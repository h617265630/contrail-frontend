<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const isLoading = ref(true)
const error = ref('')
const rawStored = ref<string>('')
const pathData = ref<any>(null)

type OutlineNode = { title: string; level: number; children: OutlineNode[] }

function parseJsonString(input: unknown) {
  if (input == null) return null
  if (typeof input === 'object') return input
  if (typeof input !== 'string') return null
  const raw = input.trim()
  if (!raw) return null
  const fenced = raw.match(/```(?:json)?\s*([\s\S]*?)\s*```/i)
  const candidate = (fenced?.[1] ?? raw).trim()
  try {
    return JSON.parse(candidate)
  } catch {
    return null
  }
}

function computeLineLevel(line: string) {
  const l = line.trim()
  if (!l) return null
  if (/^[一二三四五六七八九十]+、/.test(l)) return 1
  if (/^\d+\s*[\.、]/.test(l) || /^[0-9]️⃣/.test(l)) return 2
  if (/^\d+\.\d+(?:\.\d+)?/.test(l)) return 3
  const heading = l.match(/^(#{1,6})\s+/)
  if (heading) return Math.min(3, heading[1].length)
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

function normalizeOutlineTree(obj: any): OutlineNode[] {
  const stages = obj?.stages
  if (Array.isArray(stages) && stages.length > 0) {
    return stages
      .map((x: any) => String(x?.stage ?? x?.title ?? '').trim())
      .filter(Boolean)
      .map((title: string) => ({ title, level: 1, children: [] }))
  }

  const learningStages = obj?.learning_stages
  if (Array.isArray(learningStages) && learningStages.length > 0) {
    return learningStages
      .map((x: any) => String(x ?? '').trim())
      .filter(Boolean)
      .map((title: string) => ({ title, level: 1, children: [] }))
  }

  const rawText = typeof obj === 'string' ? obj : ''
  if (rawText.trim()) return parseOutlineTextToTree(rawText)

  return []
}

function getResourceInfo(resource: any) {
  if (typeof resource === 'string') {
    return { title: resource, desc: '', url: '', type: 'text' }
  }
  const title = (resource?.title || resource?.name || resource?.resource_title || '').toString()
  const desc = (resource?.description || resource?.resource_description || '').toString()
  const url = (resource?.link || resource?.url || resource?.resource_url || '').toString()

  let type = 'text'
  if (url.includes('github.com')) type = 'github'
  else if (url && url.includes('http')) type = 'link'

  return { title, desc, url, type }
}

function getTypeIcon(type: string) {
  return type === 'github' ? '💻' : type === 'link' ? '🔗' : '📖'
}

onMounted(() => {
  isLoading.value = true
  error.value = ''
  rawStored.value = ''
  pathData.value = null

  const stored = sessionStorage.getItem('generatedPath')
  rawStored.value = stored || ''
  if (!stored) {
    isLoading.value = false
    return
  }

  const parsed = parseJsonString(stored)
  if (!parsed) {
    error.value = '解析失败：sessionStorage 中不是有效 JSON'
    isLoading.value = false
    return
  }

  pathData.value = parsed
  isLoading.value = false
})

function back() {
  router.push({ name: 'generate-path' })
}

const title = computed(() => String(pathData.value?.topic || pathData.value?.title || ''))
const description = computed(() => String(pathData.value?.description || ''))
const difficulty = computed(() => String(pathData.value?.difficulty || ''))
const estimatedDuration = computed(() => String(pathData.value?.estimated_duration || pathData.value?.duration || ''))

const outline = computed(() => normalizeOutlineTree(pathData.value))

const stages = computed(() => {
  const arr = pathData.value?.stages || pathData.value?.steps || []
  return Array.isArray(arr) ? arr : []
})

const prettyJson = computed(() => {
  try {
    return JSON.stringify(pathData.value, null, 2)
  } catch {
    return rawStored.value
  }
})
</script>

<template>
  <div class="min-h-screen bg-background py-8 px-4">
    <div class="max-w-4xl mx-auto">
      <button class="mb-6 px-4 py-2 border rounded" @click="back">← 返回</button>

      <div v-if="isLoading">加载中...</div>

      <div v-else-if="error" class="border rounded-md p-4 bg-card">
        <div class="text-red-500 text-sm">{{ error }}</div>
      </div>

      <div v-else-if="!pathData" class="border rounded-md p-6 bg-card">
        <div class="text-sm text-muted-foreground">暂无数据，请先生成学习路径。</div>
      </div>

      <div v-else class="space-y-6">
        <div class="border rounded-md p-6 bg-card">
          <h1 class="text-2xl font-semibold text-foreground">{{ title || '学习路径' }}</h1>
          <p v-if="description" class="mt-2 text-sm text-muted-foreground whitespace-pre-wrap">{{ description }}</p>
          <div class="mt-4 flex flex-wrap gap-2 text-xs text-muted-foreground">
            <span v-if="difficulty" class="px-3 py-1 border rounded-md bg-background">难度：{{ difficulty }}</span>
            <span v-if="estimatedDuration" class="px-3 py-1 border rounded-md bg-background">预计时长：{{ estimatedDuration }}</span>
            <span v-if="pathData.template_id" class="px-3 py-1 border rounded-md bg-background">模板：{{ pathData.template_id }}</span>
          </div>
        </div>

        <div v-if="outline.length" class="border rounded-md p-6 bg-card">
          <h2 class="text-lg font-semibold text-foreground">文章结构 / 大纲</h2>
          <div class="mt-4">
            <ul class="space-y-2">
              <li v-for="(n, idx) in outline" :key="idx" class="space-y-2">
                <div class="flex items-start gap-3">
                  <div class="w-6 h-6 rounded-full bg-primary text-primary-foreground flex items-center justify-center text-xs shrink-0">
                    {{ idx + 1 }}
                  </div>
                  <div class="text-sm text-foreground leading-relaxed">{{ n.title }}</div>
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

        <div v-if="stages.length" class="space-y-4">
          <div class="flex items-end justify-between">
            <h2 class="text-lg font-semibold text-foreground">阶段与资源</h2>
            <div class="text-xs text-muted-foreground">共 {{ stages.length }} 个阶段</div>
          </div>

          <div v-for="(s, i) in stages" :key="i" class="border rounded-md p-5 bg-card">
            <div class="flex items-center gap-3">
              <div class="w-8 h-8 rounded-full bg-primary text-primary-foreground flex items-center justify-center text-sm shrink-0">
                {{ i + 1 }}
              </div>
              <div class="flex-1 min-w-0">
                <div class="text-base font-semibold text-foreground truncate">
                  {{ s.stage || s.title || `阶段 ${i + 1}` }}
                </div>
                <div v-if="s.duration" class="text-xs text-muted-foreground">{{ s.duration }}</div>
              </div>
            </div>

            <p v-if="s.description" class="mt-3 text-sm text-muted-foreground whitespace-pre-wrap">{{ s.description }}</p>

            <div v-if="Array.isArray(s.resources) && s.resources.length" class="mt-4">
              <div class="text-sm font-medium text-foreground mb-2">推荐资源</div>
              <div class="space-y-2">
                <div
                  v-for="(r, j) in s.resources"
                  :key="j"
                  class="border rounded-md p-3 bg-background"
                >
                  <div class="flex items-start justify-between gap-3">
                    <div class="min-w-0">
                      <div class="flex items-center gap-2 text-sm text-foreground">
                        <span>{{ getTypeIcon(getResourceInfo(r).type) }}</span>
                        <span class="font-medium break-words">{{ getResourceInfo(r).title || '未命名资源' }}</span>
                      </div>
                      <div v-if="getResourceInfo(r).desc" class="mt-1 text-xs text-muted-foreground whitespace-pre-wrap">
                        {{ getResourceInfo(r).desc }}
                      </div>
                    </div>
                    <a
                      v-if="getResourceInfo(r).url"
                      class="text-xs px-3 py-1 border rounded-md hover:bg-accent shrink-0"
                      :href="getResourceInfo(r).url"
                      target="_blank"
                      rel="noopener noreferrer"
                    >
                      打开
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <details class="border rounded-md p-4 bg-card">
          <summary class="cursor-pointer text-sm font-medium text-foreground">查看原始 JSON</summary>
          <pre class="mt-3 text-xs whitespace-pre-wrap bg-background border rounded p-3 overflow-auto">{{ prettyJson }}</pre>
        </details>
      </div>
    </div>
  </div>
</template>
