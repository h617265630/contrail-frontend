<template>
  <div class="min-h-screen bg-slate-50">
    <div class="mx-auto max-w-5xl px-4 py-8">
      <div class="rounded-2xl bg-white p-6 shadow-sm border border-slate-100">
        <h1 class="text-2xl font-bold text-slate-900">Creator</h1>
        <p class="mt-1 text-sm text-slate-600">上传图片、手写笔记、记录 URL、记录 idea</p>
      </div>

      <div class="mt-6 grid gap-6 lg:grid-cols-2">
        <section class="rounded-2xl bg-white p-6 shadow-sm border border-slate-100">
          <h2 class="text-lg font-semibold text-slate-900">上传图片</h2>
          <div class="mt-4 space-y-3">
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
        </section>

        <section class="rounded-2xl bg-white p-6 shadow-sm border border-slate-100">
          <h2 class="text-lg font-semibold text-slate-900">手写笔记</h2>
          <div class="mt-4 space-y-3">
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
        </section>

        <section class="rounded-2xl bg-white p-6 shadow-sm border border-slate-100">
          <h2 class="text-lg font-semibold text-slate-900">记录 URL</h2>
          <div class="mt-4 space-y-3">
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
        </section>

        <section class="rounded-2xl bg-white p-6 shadow-sm border border-slate-100">
          <h2 class="text-lg font-semibold text-slate-900">记录 idea</h2>
          <div class="mt-4 space-y-3">
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
        </section>
      </div>

      <div class="mt-8 rounded-2xl bg-white p-6 shadow-sm border border-slate-100">
        <div class="flex items-center justify-between gap-4">
          <h2 class="text-lg font-semibold text-slate-900">我的记录</h2>
          <button
            type="button"
            class="rounded-lg bg-slate-100 px-4 py-2 text-sm font-semibold text-slate-700 hover:bg-slate-200"
            :disabled="items.length === 0"
            @click="clearAll"
          >
            清空全部
          </button>
        </div>

        <div v-if="items.length === 0" class="mt-4 text-sm text-slate-500">暂无记录</div>

        <div v-else class="mt-4 space-y-3">
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
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, nextTick, onMounted, ref } from 'vue'

type CreatorItemKind = 'image' | 'hand' | 'url' | 'idea'

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

const totalCount = computed(() => items.value.length)

onMounted(async () => {
  items.value = loadItems()
  await nextTick()
  ensureCanvasSize()
  window.addEventListener('resize', ensureCanvasSize)
})
</script>
