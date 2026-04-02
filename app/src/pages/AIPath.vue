<template>
  <div class="min-h-screen bg-stone-50">
    <header class="border-b border-stone-200 bg-white">
      <div class="mx-auto max-w-6xl px-4 py-8 md:py-10">
        <div class="flex items-end justify-between gap-6">
          <div>
            <div class="mb-3 flex items-center gap-2">
              <span class="h-px w-8 bg-sky-500"></span>
              <span class="text-[10px] font-bold uppercase tracking-[0.25em] text-stone-400">AI Guided</span>
            </div>
            <h1 class="text-3xl font-black leading-[0.92] tracking-tight text-stone-900 md:text-5xl">
              AI Path<br/><span class="text-sky-600">Generator.</span>
            </h1>
          </div>
          <p class="hidden max-w-sm text-sm leading-relaxed text-stone-500 md:block">
            输入你的学习目标，让 AI 生成结构化学习路径，并在详情页里直接查看阶段说明、步骤和推荐资源。
          </p>
        </div>
      </div>
    </header>

    <main class="mx-auto max-w-6xl px-4 py-8">
      <div class="grid grid-cols-1 gap-6 lg:grid-cols-5">
        <section class="lg:col-span-3 rounded-md border border-stone-200 bg-white p-6 shadow-sm md:p-8">
          <div class="mb-6 flex items-center justify-between gap-4">
            <div>
              <p class="text-[10px] font-bold uppercase tracking-[0.25em] text-stone-400">Prompt</p>
              <h2 class="mt-2 text-2xl font-black tracking-tight text-stone-900">描述你想学什么</h2>
            </div>
            <RouterLink
              :to="{ name: 'ai-path-detail' }"
              class="text-xs font-semibold uppercase tracking-wider text-stone-400 transition-colors hover:text-sky-600"
            >
              查看最近结果
            </RouterLink>
          </div>

          <textarea
            v-model="query"
            rows="10"
            placeholder="例如：我想系统学习 React 全栈开发，3 个月内做出一个可上线项目，希望路径里包含基础、状态管理、路由、Node.js、数据库和部署。"
            class="w-full rounded-sm border border-stone-200 bg-stone-50 px-5 py-4 text-sm leading-7 text-stone-900 outline-none transition-colors placeholder:text-stone-400 focus:border-sky-400 focus:bg-white focus:ring-4 focus:ring-sky-50"
          />

          <div class="mt-4 flex flex-wrap gap-2">
            <button
              v-for="prompt in presets"
              :key="prompt"
              type="button"
              class="rounded-sm border border-stone-200 bg-white px-3 py-1.5 text-[11px] font-semibold text-stone-500 transition-colors hover:border-sky-200 hover:text-sky-700"
              @click="query = prompt"
            >
              {{ prompt }}
            </button>
          </div>

          <div class="mt-6 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
            <p class="text-sm text-stone-400">
              建议写清楚目标方向、时间范围、当前基础、最终成果。
            </p>
            <Button
              type="button"
              class="rounded-sm bg-sky-600 px-8 text-white hover:bg-sky-700"
              :disabled="loading || !query.trim()"
              @click="submit"
            >
              {{ loading ? 'Generating…' : 'Generate AI Path →' }}
            </Button>
          </div>

          <p v-if="error" class="mt-4 text-sm text-red-500">{{ error }}</p>
        </section>

        <aside class="lg:col-span-2 space-y-5">
          <section class="rounded-md border border-stone-200 bg-white p-6 shadow-sm">
            <p class="text-[10px] font-bold uppercase tracking-[0.25em] text-stone-400">How it works</p>
            <div class="mt-4 space-y-4">
              <div v-for="(step, idx) in steps" :key="step.title" class="flex gap-3">
                <div class="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-sky-50 text-xs font-black text-sky-600">
                  {{ idx + 1 }}
                </div>
                <div>
                  <h3 class="text-sm font-semibold text-stone-900">{{ step.title }}</h3>
                  <p class="mt-1 text-sm leading-6 text-stone-500">{{ step.text }}</p>
                </div>
              </div>
            </div>
          </section>

          <section v-if="lastResult" class="rounded-md border border-stone-200 bg-white p-6 shadow-sm">
            <div class="flex items-center justify-between gap-3">
              <div>
                <p class="text-[10px] font-bold uppercase tracking-[0.25em] text-stone-400">Latest</p>
                <h3 class="mt-2 text-lg font-black tracking-tight text-stone-900">{{ lastResult.data.title || '最近一次 AI Path' }}</h3>
              </div>
              <RouterLink
                :to="{ name: 'ai-path-detail' }"
                class="text-xs font-semibold uppercase tracking-wider text-sky-600"
              >
                Open
              </RouterLink>
            </div>
            <p class="mt-3 line-clamp-4 text-sm leading-6 text-stone-500">{{ lastResult.data.summary }}</p>
            <div class="mt-4 flex items-center gap-4 text-xs text-stone-400">
              <span>{{ lastResult.data.nodes?.length || 0 }} stages</span>
              <span v-if="lastResult.warnings?.length">{{ lastResult.warnings.length }} warnings</span>
            </div>
          </section>
        </aside>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { useRouter, RouterLink } from 'vue-router'
import { Button } from '../components/ui/button'
import { generateAiPath, type AiPathGenerateResponse } from '../api/aiPath'

const STORAGE_KEY = 'learnsmart_ai_path_result_v1'

const router = useRouter()
const loading = ref(false)
const query = ref('')
const error = ref('')

const presets = [
  '我想系统学习 React 全栈开发，并在 3 个月内做出一个可上线项目',
  '我想从零开始学习 AI Agent 开发，希望最终做出能调用工具的应用',
  '我想学习数据分析，重点掌握 Python、Pandas、可视化和项目实战',
]

const steps = [
  { title: '输入目标', text: '告诉 AI 你的学习方向、当前基础、时间投入和最终成果。' },
  { title: '生成路径', text: '调用 AIpath LangChain 项目接口，返回结构化 JSON 学习路径。' },
  { title: '查看详情', text: '进入详情页查看阶段说明、步骤拆解和资源卡片。' },
]

const lastResult = computed<AiPathGenerateResponse | null>(() => {
  try {
    const raw = window.sessionStorage.getItem(STORAGE_KEY)
    return raw ? JSON.parse(raw) as AiPathGenerateResponse : null
  } catch {
    return null
  }
})

async function submit() {
  const value = query.value.trim()
  if (!value) return
  loading.value = true
  error.value = ''
  try {
    const result = await generateAiPath(value)
    window.sessionStorage.setItem(STORAGE_KEY, JSON.stringify(result))
    router.push({ name: 'ai-path-detail' })
  } catch (e: any) {
    error.value = String(e?.response?.data?.detail || e?.message || 'AI Path generation failed')
  } finally {
    loading.value = false
  }
}
</script>
