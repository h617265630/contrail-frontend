<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { generateLearningPathWorkflow } from '@/api/aiPath'

const router = useRouter()
const topic = ref('')
const isLoading = ref(false)
const error = ref('')
const structureStages = ref<string[]>([])
const generatedPayload = ref<any>(null)
type OutlineNode = { title: string; level: number; children: OutlineNode[] }
const outlineTree = ref<OutlineNode[]>([])

function parseJsonString(input: unknown) {
  if (input == null) return null
  if (typeof input === 'object') return input
  if (typeof input !== 'string') return null
  const raw = input.trim()
  if (!raw) return null

  // Strip fenced code blocks if the backend returns ```json ...```
  const fenced = raw.match(/```(?:json)?\s*([\s\S]*?)\s*```/i)
  const candidate = (fenced?.[1] ?? raw).trim()
  try {
    return JSON.parse(candidate)
  } catch {
    return null
  }
}

function normalizeStructureStages(payload: any): string[] {
  // Prefer template planner output: stages.planner (JSON string)
  const plannerObj = parseJsonString(payload?.stages?.planner)
  const fromPlanner = Array.isArray(plannerObj?.learning_stages)
    ? plannerObj.learning_stages
    : null
  if (fromPlanner && fromPlanner.length > 0) {
    return fromPlanner.map((s: any) => String(s ?? '').trim()).filter(Boolean)
  }

  // Fallback: data.raw (JSON string) -> stages[{ stage }]
  const rawObj = parseJsonString(payload?.data?.raw)
  const stages = rawObj?.stages
  if (Array.isArray(stages) && stages.length > 0) {
    return stages
      .map((x: any) => String(x?.stage ?? x?.title ?? '').trim())
      .filter(Boolean)
  }

  // Last fallback: already-parsed stages array
  const directStages = payload?.data?.stages
  if (Array.isArray(directStages) && directStages.length > 0) {
    return directStages
      .map((x: any) => String(x?.stage ?? x?.title ?? '').trim())
      .filter(Boolean)
  }

  return []
}

function computeLineLevel(line: string) {
  const l = line.trim()
  if (!l) return null

  // Primary sections: 一、 二、 三、
  if (/^[一二三四五六七八九十]+、/.test(l)) return 1
  // Secondary sections: 1. / 1、 / 1️⃣ / 1️⃣xxxx
  if (/^\d+\s*[\.、]/.test(l) || /^[0-9]️⃣/.test(l)) return 2
  // Tertiary: 3.1 / 3.2.1
  if (/^\d+\.\d+(?:\.\d+)?/.test(l)) return 3
  // Markdown headings: # / ## / ###
  const heading = l.match(/^(#{1,6})\s+/)
  if (heading) return Math.min(3, heading[1].length)
  // Bullet list items
  if (/^[-*•]\s+/.test(l)) return 4
  return 5
}

function stripLinePrefix(line: string) {
  return line
    .trim()
    .replace(/^#{1,6}\s+/, '')
    .replace(/^[一二三四五六七八九十]+、\s*/, '')
    .replace(/^\d+\s*[\.、]\s*/, '')
    .replace(/^[0-9]️⃣\s*/, '')
    .replace(/^[-*•]\s+/, '')
    .trim()
}

function parseOutlineTextToTree(text: string): OutlineNode[] {
  const lines = text
    .replace(/\r\n/g, '\n')
    .split('\n')
    .map((x) => x.trimEnd())
    .filter((x) => x.trim().length > 0)

  const root: OutlineNode = { title: '__root__', level: 0, children: [] }
  const stack: OutlineNode[] = [root]

  for (const rawLine of lines) {
    const level = computeLineLevel(rawLine)
    if (level == null) continue
    const title = stripLinePrefix(rawLine)
    if (!title) continue

    const node: OutlineNode = { title, level, children: [] }

    while (stack.length > 1 && stack[stack.length - 1].level >= level) {
      stack.pop()
    }
    stack[stack.length - 1].children.push(node)
    stack.push(node)
  }

  return root.children
}

function normalizeOutlineTree(payload: any): OutlineNode[] {
  const plannerObj = parseJsonString(payload?.stages?.planner)
  if (Array.isArray(plannerObj?.learning_stages) && plannerObj.learning_stages.length > 0) {
    return plannerObj.learning_stages
      .map((s: any) => String(s ?? '').trim())
      .filter(Boolean)
      .map((title: string) => ({ title, level: 1, children: [] }))
  }

  const raw = payload?.data?.raw
  if (typeof raw === 'string') {
    const rawObj = parseJsonString(raw)
    if (rawObj && typeof rawObj === 'object') {
      const stages = rawObj?.stages
      if (Array.isArray(stages) && stages.length > 0) {
        return stages
          .map((x: any) => String(x?.stage ?? x?.title ?? '').trim())
          .filter(Boolean)
          .map((title: string) => ({ title, level: 1, children: [] }))
      }
    }

    // Not JSON: treat as ChatGPT outline text
    const tree = parseOutlineTextToTree(raw)
    if (tree.length > 0) return tree
  }

  const researcher = payload?.stages?.researcher
  if (typeof researcher === 'string' && researcher.trim()) {
    const tree = parseOutlineTextToTree(researcher)
    if (tree.length > 0) return tree
  }

  return []
}

// 生成 learning path
async function handleGenerate() {
  if (!topic.value.trim()) {
    error.value = '请输入学习主题'
    return
  }
  
  isLoading.value = true
  error.value = ''
  structureStages.value = []
  generatedPayload.value = null
  outlineTree.value = []
  
  try {
    const res = await generateLearningPathWorkflow(topic.value)
    console.log('API原始返回:', res)

    // axios response -> business payload
    const payload = (res as any)?.data ?? res
    generatedPayload.value = payload

    // Structure (article outline) for this page
    structureStages.value = normalizeStructureStages(payload)
    outlineTree.value = normalizeOutlineTree(payload)

    // For detail page: store a best-effort merged object
    const rawObj = parseJsonString(payload?.data?.raw)
    const mergedForDetail = rawObj && typeof rawObj === 'object' ? { ...rawObj } : { ...(payload?.data || {}) }
    if (payload?.data?.based_on_template_id != null) {
      mergedForDetail.template_id = payload.data.based_on_template_id
    }

    console.log('结构数据(learning_stages):', structureStages.value)
    console.log('详情页数据(merged):', mergedForDetail)

    if (structureStages.value.length > 0) {
      sessionStorage.setItem('generatedPath', JSON.stringify(mergedForDetail))
      // 自动跳转到详情页
      router.push({ name: 'generated-path-detail' })
    } else if (outlineTree.value.length > 0) {
      sessionStorage.setItem('generatedPath', JSON.stringify(mergedForDetail))
      // 自动跳转到详情页
      router.push({ name: 'generated-path-detail' })
    } else {
      error.value = '生成失败：未解析到文章结构数据'
      return
    }
  } catch (e: any) {
    console.error('生成失败:', e)
    error.value = e.message || '生成失败，请重试'
  } finally {
    isLoading.value = false
  }
}
</script>

<template>
  <div class="min-h-screen bg-background py-12 px-4">
    <div class="max-w-2xl mx-auto">
      <!-- 标题 -->
      <div class="text-center mb-8">
        <h1 class="text-3xl font-bold text-foreground mb-2">
          AI 生成学习路径
        </h1>
        <p class="text-muted-foreground">
          输入你想学习的主题，AI 将为你生成个性化的学习路径
        </p>
      </div>
      
      <!-- 输入卡片 -->
      <div class="border rounded-md p-6 mb-6 bg-card">
        <h2 class="text-xl font-semibold mb-2">输入学习主题</h2>
        <p class="text-sm text-muted-foreground mb-4">
          例如：Python 编程、机器学习入门、React 开发等
        </p>
        
        <textarea
          v-model="topic"
          placeholder="请输入你想学习的内容...&#10;&#10;例如：Python 编程、机器学习入门、React 开发等"
          class="w-full h-32 px-5 py-4 text-lg border-2 border-gray-200 rounded-sm bg-background disabled:opacity-50 resize-none focus:border-blue-500 focus:ring-2 focus:ring-blue-200 focus:outline-none transition-all duration-200"
          :disabled="isLoading"
          @keydown.enter.ctrl="handleGenerate"
        />
        
        <div v-if="error" class="text-red-500 text-sm mt-2">
          {{ error }}
        </div>
        
        <button 
          @click="handleGenerate" 
          :disabled="isLoading"
          class="w-full mt-4 py-4 text-lg bg-primary text-primary-foreground rounded-md hover:bg-primary/90 disabled:opacity-50"
        >
          <span v-if="isLoading">🤖 AI 工作中...</span>
          <span v-else>🚀 生成学习路径</span>
        </button>

        <div v-if="outlineTree.length" class="mt-6 border rounded-md p-4 bg-background">
          <div class="flex items-center justify-between gap-3">
            <h3 class="text-base font-semibold">文章结构（学习阶段）</h3>
            <button
              class="text-sm px-3 py-1 border rounded-md hover:bg-accent"
              @click="router.push({ name: 'generated-path-detail' })"
            >
              查看详情
            </button>
          </div>
          <div class="mt-3">
            <ul class="space-y-2">
              <li v-for="(n, idx) in outlineTree" :key="idx" class="space-y-2">
                <div class="flex items-start gap-3">
                  <div class="w-6 h-6 rounded-full bg-primary text-primary-foreground flex items-center justify-center text-xs shrink-0">
                    {{ idx + 1 }}
                  </div>
                  <div class="text-sm text-foreground leading-relaxed">
                    {{ n.title }}
                  </div>
                </div>
                <ul v-if="n.children?.length" class="ml-9 space-y-2">
                  <li v-for="(c1, j) in n.children" :key="j" class="space-y-2">
                    <div class="text-sm text-foreground leading-relaxed">- {{ c1.title }}</div>
                    <ul v-if="c1.children?.length" class="ml-4 space-y-2">
                      <li v-for="(c2, k) in c1.children" :key="k" class="text-sm text-foreground leading-relaxed">
                        - {{ c2.title }}
                      </li>
                    </ul>
                  </li>
                </ul>
              </li>
            </ul>
          </div>
        </div>

        <div v-else-if="structureStages.length" class="mt-6 border rounded-md p-4 bg-background">
          <div class="flex items-center justify-between gap-3">
            <h3 class="text-base font-semibold">文章结构（学习阶段）</h3>
            <button
              class="text-sm px-3 py-1 border rounded-md hover:bg-accent"
              @click="router.push({ name: 'generated-path-detail' })"
            >
              查看详情
            </button>
          </div>
          <div class="mt-3 space-y-2">
            <div
              v-for="(s, idx) in structureStages"
              :key="idx"
              class="flex items-start gap-3"
            >
              <div class="w-6 h-6 rounded-full bg-primary text-primary-foreground flex items-center justify-center text-xs shrink-0">
                {{ idx + 1 }}
              </div>
              <div class="text-sm text-foreground leading-relaxed">
                {{ s }}
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 示例提示 -->
      <div class="text-center text-sm text-muted-foreground mt-4">
        <p>试试这些主题：</p>
        <div class="flex flex-wrap justify-center gap-2 mt-2">
          <button @click="topic = 'Python 基础入门'" class="px-3 py-1 text-sm border rounded-md hover:bg-accent">
            Python 基础入门
          </button>
          <button @click="topic = 'React 全栈开发'" class="px-3 py-1 text-sm border rounded-md hover:bg-accent">
            React 全栈开发
          </button>
          <button @click="topic = '数据结构与算法'" class="px-3 py-1 text-sm border rounded-md hover:bg-accent">
            数据结构与算法
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
