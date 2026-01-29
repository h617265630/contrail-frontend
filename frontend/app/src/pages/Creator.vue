<template>
  <div class="min-h-screen bg-slate-50">
    <div class="max-w-7xl mx-auto p-6">
      <div class="grid gap-6 lg:grid-cols-12">
        <aside class="lg:col-span-3">
          <div class="rounded-2xl bg-white p-4 shadow-sm border border-slate-100">
            <p class="text-sm font-semibold text-slate-900">Creator Center</p>
            <p class="text-xs text-slate-500 mt-1">创作工具集合</p>

            <div class="mt-4 space-y-2">
              <button
                type="button"
                class="w-full text-left rounded-xl px-3 py-2 text-sm font-semibold"
                :class="activeTab === 'image' ? 'bg-blue-600 text-white' : 'text-slate-700 hover:bg-slate-50'"
                @click="selectTab('image')"
              >
                上传图片
              </button>
              <button
                type="button"
                class="w-full text-left rounded-xl px-3 py-2 text-sm font-semibold"
                :class="activeTab === 'hand' ? 'bg-blue-600 text-white' : 'text-slate-700 hover:bg-slate-50'"
                @click="selectTab('hand')"
              >
                手写笔记
              </button>
              <button
                type="button"
                class="w-full text-left rounded-xl px-3 py-2 text-sm font-semibold"
                :class="activeTab === 'url' ? 'bg-blue-600 text-white' : 'text-slate-700 hover:bg-slate-50'"
                @click="selectTab('url')"
              >
                记录 URL
              </button>
              <button
                type="button"
                class="w-full text-left rounded-xl px-3 py-2 text-sm font-semibold"
                :class="activeTab === 'idea' ? 'bg-blue-600 text-white' : 'text-slate-700 hover:bg-slate-50'"
                @click="selectTab('idea')"
              >
                记录 Idea
              </button>
              <button
                type="button"
                class="w-full text-left rounded-xl px-3 py-2 text-sm font-semibold"
                :class="activeTab === 'markdown' ? 'bg-blue-600 text-white' : 'text-slate-700 hover:bg-slate-50'"
                @click="selectTab('markdown')"
              >
                Markdown 编辑器
              </button>
              <button
                type="button"
                class="w-full text-left rounded-xl px-3 py-2 text-sm font-semibold"
                :class="activeTab === 'records' ? 'bg-blue-600 text-white' : 'text-slate-700 hover:bg-slate-50'"
                @click="selectTab('records')"
              >
                我的记录
              </button>
            </div>
          </div>
        </aside>

        <main class="lg:col-span-9">
          <div class="rounded-2xl bg-white p-5 shadow-sm border border-slate-100">
            <div class="flex items-center justify-between gap-3">
              <div>
                <h1 class="text-xl font-semibold text-slate-900">{{ tabTitle }}</h1>
                <p class="text-sm text-slate-600 mt-1">{{ tabSubtitle }}</p>
              </div>
            </div>
          </div>

          <div class="mt-4 rounded-2xl bg-white p-6 shadow-sm border border-slate-100">
            <div v-if="activeTab === 'image'" class="space-y-3">
            <input
              type="file"
              accept="image/*"
              class="block w-full text-sm text-slate-700 file:mr-4 file:rounded-lg file:border-0 file:bg-slate-100 file:px-4 file:py-2 file:text-sm file:font-semibold file:text-slate-700 hover:file:bg-slate-200"
              @change="onPickImage"
            />
            <div class="flex items-center gap-3">
              <input
                v-model="imageTitle"
                type="text"
                placeholder="标题（可选）"
                class="w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              <button
                type="button"
                class="shrink-0 rounded-lg bg-blue-600 px-4 py-2 text-sm font-semibold text-white hover:bg-blue-700 disabled:opacity-50"
                :disabled="!pendingImageDataUrl"
                @click="saveImage"
              >
                保存
              </button>
            </div>
            <p v-if="imageError" class="text-sm text-red-600">{{ imageError }}</p>
            <div v-if="pendingImageDataUrl" class="rounded-xl border border-slate-200 bg-slate-50 p-3">
              <img :src="pendingImageDataUrl" alt="preview" class="max-h-56 w-full rounded-lg object-contain" />
            </div>
            </div>

            <div v-else-if="activeTab === 'hand'" class="space-y-3">
            <div class="flex items-center gap-3">
              <input
                v-model="handTitle"
                type="text"
                placeholder="标题（可选）"
                class="w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              <button
                type="button"
                class="shrink-0 rounded-lg bg-slate-100 px-4 py-2 text-sm font-semibold text-slate-700 hover:bg-slate-200"
                @click="clearCanvas"
              >
                清空
              </button>
              <button
                type="button"
                class="shrink-0 rounded-lg bg-blue-600 px-4 py-2 text-sm font-semibold text-white hover:bg-blue-700"
                @click="saveHandNote"
              >
                保存
              </button>
            </div>

            <div class="rounded-xl border border-slate-200 bg-white p-2">
              <canvas
                ref="canvasRef"
                class="h-56 w-full rounded-lg bg-slate-50"
                @pointerdown="onPointerDown"
                @pointermove="onPointerMove"
                @pointerup="onPointerUp"
                @pointercancel="onPointerUp"
                @pointerleave="onPointerUp"
              ></canvas>
            </div>
            <p v-if="handError" class="text-sm text-red-600">{{ handError }}</p>
            </div>

            <div v-else-if="activeTab === 'url'" class="space-y-3">
            <input
              v-model="urlTitle"
              type="text"
              placeholder="标题（可选）"
              class="w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
            <div class="flex items-center gap-3">
              <input
                v-model="urlValue"
                type="url"
                placeholder="https://..."
                class="w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              <button
                type="button"
                class="shrink-0 rounded-lg bg-blue-600 px-4 py-2 text-sm font-semibold text-white hover:bg-blue-700"
                @click="saveUrl"
              >
                保存
              </button>
            </div>
            <p v-if="urlError" class="text-sm text-red-600">{{ urlError }}</p>
            </div>

            <div v-else-if="activeTab === 'idea'" class="space-y-3">
            <input
              v-model="ideaTitle"
              type="text"
              placeholder="标题（可选）"
              class="w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
            <textarea
              v-model="ideaContent"
              rows="4"
              placeholder="写下你的想法..."
              class="w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
            ></textarea>
            <button
              type="button"
              class="rounded-lg bg-blue-600 px-4 py-2 text-sm font-semibold text-white hover:bg-blue-700"
              @click="saveIdea"
            >
              保存
            </button>
            <p v-if="ideaError" class="text-sm text-red-600">{{ ideaError }}</p>
            </div>

            <div v-else-if="activeTab === 'markdown'" class="space-y-4">
              <!-- 已保存的 Markdown 文件列表 -->
              <div v-if="markdownFiles.length > 0" class="space-y-3">
                <div class="flex items-center justify-between">
                  <h3 class="text-sm font-semibold text-slate-900">已保存的文档 ({{ markdownFiles.length }})</h3>
                </div>
                <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-3">
                  <button
                    v-for="file in markdownFiles"
                    :key="file.id"
                    type="button"
                    class="text-left rounded-lg border border-slate-200 bg-white p-3 hover:border-blue-500 hover:shadow-md transition-all"
                    @click="loadMarkdownFile(file)"
                  >
                    <div class="space-y-1">
                      <p class="text-sm font-semibold text-slate-900 truncate" :title="file.title || '无标题'">
                        {{ file.title || '无标题' }}
                      </p>
                      <p class="text-xs text-slate-500">{{ formatTime(file.createdAt) }}</p>
                      <p class="text-xs text-slate-400 truncate">{{ (file.content || '').substring(0, 50) }}...</p>
                    </div>
                  </button>
                </div>
              </div>

              <div v-if="markdownExtractedLinks.length > 0" class="space-y-3">
                <div class="flex items-center justify-between">
                  <h3 class="text-sm font-semibold text-slate-900">从当前 Markdown 提取的链接 ({{ markdownExtractedLinks.length }})</h3>
                </div>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
                  <div
                    v-for="link in markdownExtractedLinks"
                    :key="link.url"
                    class="rounded-lg border border-slate-200 bg-white p-3"
                  >
                    <div class="flex items-start justify-between gap-3">
                      <div class="min-w-0">
                        <p class="text-xs font-semibold text-slate-500">{{ link.kind }}</p>
                        <a
                          :href="link.url"
                          target="_blank"
                          rel="noreferrer"
                          class="mt-1 block text-sm font-semibold text-blue-600 hover:underline break-all"
                        >
                          {{ link.url }}
                        </a>
                      </div>
                      <button
                        type="button"
                        class="shrink-0 rounded-lg bg-blue-600 px-3 py-2 text-xs font-semibold text-white hover:bg-blue-700"
                        @click="goAddResource(link.url)"
                      >
                        添加为资源
                      </button>
                    </div>
                  </div>
                </div>
              </div>

              <!-- 编辑器区域 -->
              <div class="space-y-3">
                <input
                  v-model="markdownTitle"
                  type="text"
                  placeholder="文档标题（可选）"
                  class="w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              <div class="border border-slate-200 rounded-lg overflow-hidden" style="height: 600px;">
                <Editor
                  :value="markdownContent"
                  :plugins="bytemdPlugins"
                  @change="(v: string) => markdownContent = v"
                />
              </div>
                <button
                  type="button"
                  class="rounded-lg bg-blue-600 px-4 py-2 text-sm font-semibold text-white hover:bg-blue-700"
                  @click="saveMarkdown"
                >
                  保存
                </button>
                <p v-if="markdownError" class="text-sm text-red-600">{{ markdownError }}</p>
              </div>
            </div>

            <div v-else-if="activeTab === 'records'">
              <div class="flex items-center justify-between gap-4 mb-4">
                <p class="text-sm text-slate-600">共 {{ items.length }} 条记录</p>
                <button
                  type="button"
                  class="rounded-lg bg-slate-100 px-4 py-2 text-sm font-semibold text-slate-700 hover:bg-slate-200"
                  :disabled="items.length === 0"
                  @click="clearAll"
                >
                  清空全部
                </button>
              </div>

              <div v-if="items.length === 0" class="text-sm text-slate-500">暂无记录</div>

              <div v-else class="space-y-3">
          <div
            v-for="item in items"
            :key="item.id"
            class="rounded-xl border border-slate-200 p-4"
          >
            <div class="flex items-start justify-between gap-3">
              <div class="min-w-0">
                <p class="text-sm font-semibold text-slate-900 truncate">
                  <span class="mr-2 rounded-md bg-slate-100 px-2 py-0.5 text-xs font-semibold text-slate-700">{{ item.kind }}</span>
                  {{ item.title || '无标题' }}
                </p>
                <p class="mt-1 text-xs text-slate-500">{{ formatTime(item.createdAt) }}</p>
              </div>
              <button
                type="button"
                class="shrink-0 rounded-lg bg-red-50 px-3 py-1.5 text-sm font-semibold text-red-600 hover:bg-red-100"
                @click="removeItem(item.id)"
              >
                删除
              </button>
            </div>

            <div class="mt-3">
              <div v-if="item.kind === 'image' && item.dataUrl" class="rounded-lg bg-slate-50 p-2 border border-slate-200">
                <img :src="item.dataUrl" alt="image" class="max-h-64 w-full rounded-md object-contain" />
              </div>

              <div v-else-if="item.kind === 'hand' && item.dataUrl" class="rounded-lg bg-slate-50 p-2 border border-slate-200">
                <img :src="item.dataUrl" alt="hand note" class="max-h-64 w-full rounded-md object-contain" />
              </div>

              <div v-else-if="item.kind === 'url' && item.url" class="text-sm">
                <a
                  :href="item.url"
                  target="_blank"
                  rel="noreferrer"
                  class="font-semibold text-blue-600 hover:underline break-all"
                >
                  {{ item.url }}
                </a>
              </div>

              <div v-else-if="item.kind === 'idea' && item.content" class="text-sm text-slate-800 whitespace-pre-wrap">
                {{ item.content }}
              </div>

              <div v-else-if="item.kind === 'markdown' && item.content" class="rounded-lg bg-slate-50 p-3 border border-slate-200">
                <pre class="text-sm text-slate-800 whitespace-pre-wrap font-mono">{{ item.content }}</pre>
              </div>
            </div>
          </div>
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, nextTick, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { Editor } from '@bytemd/vue-next'
import gfm from '@bytemd/plugin-gfm'
import highlight from '@bytemd/plugin-highlight'
import math from '@bytemd/plugin-math'
import 'bytemd/dist/index.css'
import 'highlight.js/styles/vs.css'
import 'katex/dist/katex.css'

const bytemdPlugins = [
  gfm(),
  highlight(),
  math(),
]

type CreatorTab = 'image' | 'hand' | 'url' | 'idea' | 'markdown' | 'records'
type CreatorItemKind = 'image' | 'hand' | 'url' | 'idea' | 'markdown'

const activeTab = ref<CreatorTab>('image')

const router = useRouter()

const tabTitle = computed(() => {
  switch (activeTab.value) {
    case 'image': return '上传图片'
    case 'hand': return '手写笔记'
    case 'url': return '记录 URL'
    case 'idea': return '记录 Idea'
    case 'markdown': return 'Markdown 编辑器'
    case 'records': return '我的记录'
    default: return 'Creator'
  }
})

function extractUrls(text: string) {
  const input = String(text || '')
  const matches = input.match(/https?:\/\/[^\s)\]>]+/g) || []
  const cleaned = matches
    .map((u) => u.replace(/[),.;\]]+$/g, ''))
    .map((u) => u.trim())
    .filter(Boolean)
  return Array.from(new Set(cleaned))
}

function guessUrlKind(url: string) {
  const u = String(url || '').toLowerCase()
  if (u.includes('youtube.com') || u.includes('youtu.be') || u.includes('bilibili.com') || u.includes('vimeo.com')) return 'video'
  if (u.endsWith('.pdf') || u.endsWith('.doc') || u.endsWith('.docx') || u.endsWith('.ppt') || u.endsWith('.pptx') || u.endsWith('.xls') || u.endsWith('.xlsx')) return 'document'
  if (u.includes('github.com') || u.includes('medium.com')) return 'document'
  return 'link'
}

const markdownExtractedLinks = computed(() => {
  return extractUrls(markdownContent.value).map((url) => ({
    url,
    kind: guessUrlKind(url),
  }))
})

function goAddResource(url: string) {
  router.push({ name: 'add-resource', query: { url } })
}

const tabSubtitle = computed(() => {
  switch (activeTab.value) {
    case 'image': return '上传并保存图片文件'
    case 'hand': return '使用画布手写笔记'
    case 'url': return '保存有用的链接'
    case 'idea': return '记录灵感和想法'
    case 'markdown': return '使用 Markdown 编写文档'
    case 'records': return `共 ${items.value.length} 条记录`
    default: return ''
  }
})

function selectTab(tab: CreatorTab) {
  activeTab.value = tab
}

type CreatorItem = {
  id: string
  kind: CreatorItemKind
  title?: string
  createdAt: number
  dataUrl?: string
  url?: string
  content?: string
}

const STORAGE_KEY = 'creator.items.v1'

const items = ref<CreatorItem[]>([])

function loadItems(): CreatorItem[] {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (!raw) return []
    const parsed = JSON.parse(raw)
    return Array.isArray(parsed) ? (parsed as CreatorItem[]) : []
  } catch {
    return []
  }
}

function persistItems(nextItems: CreatorItem[]) {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(nextItems))
}

function createId(prefix: string) {
  return `${prefix}_${Date.now()}_${Math.random().toString(16).slice(2)}`
}

function formatTime(ts: number) {
  return new Date(ts).toLocaleString()
}

function removeItem(id: string) {
  const updated = items.value.filter(i => i.id !== id)
  items.value = updated
  persistItems(updated)
}

function clearAll() {
  items.value = []
  persistItems([])
}

// --- image upload ---
const pendingImageDataUrl = ref<string>('')
const imageTitle = ref('')
const imageError = ref('')

function onPickImage(e: Event) {
  imageError.value = ''
  pendingImageDataUrl.value = ''

  const input = e.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return

  if (!file.type.startsWith('image/')) {
    imageError.value = '请选择图片文件'
    return
  }

  const reader = new FileReader()
  reader.onload = () => {
    const result = reader.result
    if (typeof result === 'string') pendingImageDataUrl.value = result
  }
  reader.onerror = () => {
    imageError.value = '读取图片失败'
  }
  reader.readAsDataURL(file)

  input.value = ''
}

function saveImage() {
  imageError.value = ''
  if (!pendingImageDataUrl.value) {
    imageError.value = '请先选择图片'
    return
  }

  const nextItem: CreatorItem = {
    id: createId('img'),
    kind: 'image',
    title: imageTitle.value.trim() || undefined,
    createdAt: Date.now(),
    dataUrl: pendingImageDataUrl.value,
  }

  const updated = [nextItem, ...items.value]
  items.value = updated
  persistItems(updated)

  pendingImageDataUrl.value = ''
  imageTitle.value = ''
}

// --- hand note (canvas) ---
const canvasRef = ref<HTMLCanvasElement | null>(null)
const handTitle = ref('')
const handError = ref('')

const drawing = ref(false)
const lastPoint = ref<{ x: number; y: number } | null>(null)

function ensureCanvasSize() {
  const canvas = canvasRef.value
  if (!canvas) return

  const rect = canvas.getBoundingClientRect()
  const dpr = window.devicePixelRatio || 1
  const width = Math.max(1, Math.floor(rect.width * dpr))
  const height = Math.max(1, Math.floor(rect.height * dpr))

  if (canvas.width !== width || canvas.height !== height) {
    const ctx = canvas.getContext('2d')
    const previous = ctx ? canvas.toDataURL('image/png') : ''

    canvas.width = width
    canvas.height = height

    const nextCtx = canvas.getContext('2d')
    if (nextCtx) {
      nextCtx.lineWidth = 2 * dpr
      nextCtx.lineCap = 'round'
      nextCtx.strokeStyle = '#0f172a'

      if (previous) {
        const img = new Image()
        img.onload = () => {
          nextCtx.drawImage(img, 0, 0)
        }
        img.src = previous
      }
    }
  }
}

function pointFromEvent(ev: PointerEvent) {
  const canvas = canvasRef.value
  if (!canvas) return { x: 0, y: 0 }
  const rect = canvas.getBoundingClientRect()
  const dpr = window.devicePixelRatio || 1
  return {
    x: (ev.clientX - rect.left) * dpr,
    y: (ev.clientY - rect.top) * dpr,
  }
}

function onPointerDown(ev: PointerEvent) {
  handError.value = ''
  ensureCanvasSize()
  drawing.value = true
  lastPoint.value = pointFromEvent(ev)
  ;(ev.target as HTMLCanvasElement).setPointerCapture?.(ev.pointerId)
}

function onPointerMove(ev: PointerEvent) {
  if (!drawing.value) return
  const canvas = canvasRef.value
  if (!canvas) return

  const ctx = canvas.getContext('2d')
  if (!ctx) return

  const p = pointFromEvent(ev)
  const prev = lastPoint.value
  if (prev) {
    ctx.beginPath()
    ctx.moveTo(prev.x, prev.y)
    ctx.lineTo(p.x, p.y)
    ctx.stroke()
  }
  lastPoint.value = p
}

function onPointerUp() {
  drawing.value = false
  lastPoint.value = null
}

function clearCanvas() {
  const canvas = canvasRef.value
  if (!canvas) return
  const ctx = canvas.getContext('2d')
  if (!ctx) return
  ctx.clearRect(0, 0, canvas.width, canvas.height)
}

function saveHandNote() {
  handError.value = ''
  const canvas = canvasRef.value
  if (!canvas) {
    handError.value = '画布未就绪'
    return
  }

  // avoid saving blank canvas
  const empty = document.createElement('canvas')
  empty.width = canvas.width
  empty.height = canvas.height
  if (canvas.toDataURL() === empty.toDataURL()) {
    handError.value = '请先写点内容再保存'
    return
  }

  const nextItem: CreatorItem = {
    id: createId('hand'),
    kind: 'hand',
    title: handTitle.value.trim() || undefined,
    createdAt: Date.now(),
    dataUrl: canvas.toDataURL('image/png'),
  }

  const updated = [nextItem, ...items.value]
  items.value = updated
  persistItems(updated)

  handTitle.value = ''
  clearCanvas()
}

// --- url ---
const urlTitle = ref('')
const urlValue = ref('')
const urlError = ref('')

function saveUrl() {
  urlError.value = ''
  const url = urlValue.value.trim()
  if (!url) {
    urlError.value = '请输入 URL'
    return
  }

  try {
    // eslint-disable-next-line no-new
    new URL(url)
  } catch {
    urlError.value = 'URL 格式不正确'
    return
  }

  const nextItem: CreatorItem = {
    id: createId('url'),
    kind: 'url',
    title: urlTitle.value.trim() || undefined,
    createdAt: Date.now(),
    url,
  }

  const updated = [nextItem, ...items.value]
  items.value = updated
  persistItems(updated)

  urlTitle.value = ''
  urlValue.value = ''
}

// --- idea ---
const ideaTitle = ref('')
const ideaContent = ref('')
const ideaError = ref('')

function saveIdea() {
  ideaError.value = ''
  const content = ideaContent.value.trim()
  if (!content) {
    ideaError.value = '请输入 idea 内容'
    return
  }

  const nextItem: CreatorItem = {
    id: createId('idea'),
    kind: 'idea',
    title: ideaTitle.value.trim() || undefined,
    createdAt: Date.now(),
    content,
  }

  const updated = [nextItem, ...items.value]
  items.value = updated
  persistItems(updated)

  ideaTitle.value = ''
  ideaContent.value = ''
}

// --- markdown ---
const markdownTitle = ref('')
const markdownContent = ref('')
const markdownError = ref('')

// 筛选出所有 markdown 类型的记录
const markdownFiles = computed(() => {
  return items.value.filter(item => item.kind === 'markdown')
})

// 加载 markdown 文件内容到编辑器
function loadMarkdownFile(item: CreatorItem) {
  markdownTitle.value = item.title || ''
  markdownContent.value = item.content || ''
}

function saveMarkdown() {
  markdownError.value = ''
  const content = markdownContent.value.trim()
  if (!content) {
    markdownError.value = '请输入 Markdown 内容'
    return
  }

  const nextItem: CreatorItem = {
    id: createId('md'),
    kind: 'markdown',
    title: markdownTitle.value.trim() || undefined,
    createdAt: Date.now(),
    content,
  }

  const updated = [nextItem, ...items.value]
  items.value = updated
  persistItems(updated)

  markdownTitle.value = ''
  markdownContent.value = ''
}

const totalCount = computed(() => items.value.length)

onMounted(async () => {
  items.value = loadItems()
  await nextTick()
  ensureCanvasSize()
  window.addEventListener('resize', ensureCanvasSize)
})
</script>
