<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Creator Center</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">创作工具集合。</p>
        </div>
      </div>
    </section>

    <section>
      <div class="grid gap-6 lg:grid-cols-12">
        <aside class="lg:col-span-3">
          <Card className="rounded-none" :hoverable="false" padded>
            <p class="text-sm font-semibold text-foreground">Creator Center</p>
            <p class="text-xs text-muted-foreground mt-1">创作工具集合</p>

            <div class="mt-4 space-y-2">
              <Button
                type="button"
                variant="ghost"
                class="w-full justify-start rounded-none"
                :class="activeTab === 'image' ? 'bg-foreground text-background hover:bg-foreground/90 hover:text-background' : 'text-foreground hover:bg-muted/30'"
                @click="selectTab('image')"
              >
                上传图片
              </Button>
              <Button
                type="button"
                variant="ghost"
                class="w-full justify-start rounded-none"
                :class="activeTab === 'hand' ? 'bg-foreground text-background hover:bg-foreground/90 hover:text-background' : 'text-foreground hover:bg-muted/30'"
                @click="selectTab('hand')"
              >
                手写笔记
              </Button>
              <Button
                type="button"
                variant="ghost"
                class="w-full justify-start rounded-none"
                :class="activeTab === 'url' ? 'bg-foreground text-background hover:bg-foreground/90 hover:text-background' : 'text-foreground hover:bg-muted/30'"
                @click="selectTab('url')"
              >
                记录 URL
              </Button>
              <Button
                type="button"
                variant="ghost"
                class="w-full justify-start rounded-none"
                :class="activeTab === 'idea' ? 'bg-foreground text-background hover:bg-foreground/90 hover:text-background' : 'text-foreground hover:bg-muted/30'"
                @click="selectTab('idea')"
              >
                记录 Idea
              </Button>
              <Button
                type="button"
                variant="ghost"
                class="w-full justify-start rounded-none"
                :class="activeTab === 'markdown' ? 'bg-foreground text-background hover:bg-foreground/90 hover:text-background' : 'text-foreground hover:bg-muted/30'"
                @click="selectTab('markdown')"
              >
                Markdown 编辑器
              </Button>
              <Button
                type="button"
                variant="ghost"
                class="w-full justify-start rounded-none"
                :class="activeTab === 'records' ? 'bg-foreground text-background hover:bg-foreground/90 hover:text-background' : 'text-foreground hover:bg-muted/30'"
                @click="selectTab('records')"
              >
                我的记录
              </Button>
            </div>
          </Card>
        </aside>

        <main class="lg:col-span-9 space-y-4">
          <Card className="rounded-none" :hoverable="false" padded>
            <div class="flex items-center justify-between gap-3">
              <div>
                <h2 class="text-xl font-semibold text-foreground">{{ tabTitle }}</h2>
                <p class="text-sm text-muted-foreground mt-1">{{ tabSubtitle }}</p>
              </div>
            </div>
          </Card>

          <Card className="rounded-none" :hoverable="false" padded>
            <div v-if="activeTab === 'image'" class="space-y-3">
            <input
              type="file"
              accept="image/*"
              class="block w-full text-sm text-foreground file:mr-4 file:rounded-none file:border file:border-border file:bg-background file:px-4 file:py-2 file:text-sm file:font-semibold file:text-foreground hover:file:bg-muted/30"
              @change="onPickImage"
            />
            <div class="flex items-center gap-3">
              <Input v-model="imageTitle" type="text" placeholder="标题（可选）" class="rounded-none" />
              <Button type="button" class="shrink-0 rounded-none" :disabled="!pendingImageDataUrl" @click="saveImage">保存</Button>
            </div>
            <p v-if="imageError" class="text-sm text-destructive">{{ imageError }}</p>
            <div v-if="pendingImageDataUrl" class="border border-border bg-muted/30 p-3">
              <img :src="pendingImageDataUrl" alt="preview" class="max-h-56 w-full object-contain" />
            </div>

            <div class="pt-2 border-t border-border">
              <div class="flex items-end justify-between gap-3">
                <div>
                  <p class="text-sm font-semibold text-foreground">我的图片</p>
                  <p class="text-xs text-muted-foreground mt-1">共 {{ imageItems.length }} 张</p>
                </div>
              </div>

              <div v-if="imageItems.length === 0" class="mt-3 text-sm text-muted-foreground">暂无图片</div>

              <div v-else class="mt-3 grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-3">
                <div
                  v-for="img in imageItems"
                  :key="img.id"
                  class="border border-border bg-background overflow-hidden rounded-none"
                >
                  <div class="aspect-video bg-muted/30">
                    <img :src="img.dataUrl" :alt="img.title || 'image'" class="h-full w-full object-cover" />
                  </div>
                  <div class="p-3">
                    <p class="text-sm font-semibold text-foreground truncate" :title="img.title || '无标题'">
                      {{ img.title || '无标题' }}
                    </p>
                    <p class="mt-1 text-xs text-muted-foreground">{{ formatTime(img.createdAt) }}</p>
                  </div>
                </div>
              </div>
            </div>
            </div>

            <div v-else-if="activeTab === 'hand'" class="space-y-3">
            <div class="flex items-center gap-3">
              <Input v-model="handTitle" type="text" placeholder="标题（可选）" class="rounded-none" />
              <Button type="button" variant="outline" class="shrink-0 rounded-none" @click="clearCanvas">清空</Button>
              <Button type="button" class="shrink-0 rounded-none" @click="saveHandNote">保存</Button>
            </div>

            <div class="border border-border bg-background p-2">
              <canvas
                ref="canvasRef"
                class="h-56 w-full bg-muted/30"
                @pointerdown="onPointerDown"
                @pointermove="onPointerMove"
                @pointerup="onPointerUp"
                @pointercancel="onPointerUp"
                @pointerleave="onPointerUp"
              ></canvas>
            </div>
            <p v-if="handError" class="text-sm text-destructive">{{ handError }}</p>
            </div>

            <div v-else-if="activeTab === 'url'" class="space-y-3">
            <Input v-model="urlTitle" type="text" placeholder="标题（可选）" class="rounded-none" />
            <div class="flex items-center gap-3">
              <Input v-model="urlValue" type="url" placeholder="https://..." class="rounded-none" />
              <Button type="button" class="shrink-0 rounded-none" @click="saveUrl">保存</Button>
            </div>
            <p v-if="urlError" class="text-sm text-destructive">{{ urlError }}</p>
            </div>

            <div v-else-if="activeTab === 'idea'" class="space-y-3">
            <Input v-model="ideaTitle" type="text" placeholder="标题（可选）" class="rounded-none" />
            <textarea
              v-model="ideaContent"
              rows="4"
              placeholder="写下你的想法..."
              class="w-full border border-border bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground outline-none transition focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background rounded-none"
            ></textarea>
            <Button type="button" class="rounded-none" @click="saveIdea">保存</Button>
            <p v-if="ideaError" class="text-sm text-destructive">{{ ideaError }}</p>
            </div>

            <div v-else-if="activeTab === 'markdown'" class="flex gap-4 min-h-[calc(100vh-160px)]">
              <!-- 左侧文件列表（可折叠） -->
              <div
                v-if="!mdSidebarCollapsed"
                class="w-56 shrink-0 flex flex-col gap-3 border-r border-border pr-4"
              >
                <div class="flex items-center justify-between">
                  <h3 class="text-sm font-semibold text-foreground">文档 ({{ userTextFiles.length }})</h3>
                  <button
                    type="button"
                    class="text-xs text-muted-foreground hover:text-foreground"
                    @click="mdSidebarCollapsed = true"
                  >
                    收起
                  </button>
                </div>

                <div v-if="userFilesLoading" class="text-sm text-muted-foreground">Loading…</div>
                <div v-else-if="userFilesError" class="text-sm text-destructive">{{ userFilesError }}</div>
                <div v-else-if="userTextFiles.length === 0" class="text-sm text-muted-foreground">暂无文档</div>
                <div v-else class="flex flex-col gap-2 overflow-y-auto flex-1">
                  <button
                    v-for="file in userTextFiles"
                    :key="file.id"
                    type="button"
                    class="text-left border border-border bg-background p-2 transition hover:bg-muted/30 rounded-none"
                    :class="selectedMdFileId === file.id ? 'ring-2 ring-ring' : ''"
                    @click="loadUserTextFile(file)"
                  >
                    <p class="text-sm font-semibold text-foreground truncate" :title="file.title || '无标题'">
                      {{ file.title || '无标题' }}
                    </p>
                    <p class="text-xs text-muted-foreground">{{ formatUserFileTime(file.created_at) }}</p>
                  </button>
                </div>
              </div>

              <!-- 右侧编辑器区域 -->
              <div class="flex flex-col gap-3 flex-1 min-h-0">
                <div class="flex items-center gap-3">
                  <button
                    v-if="mdSidebarCollapsed"
                    type="button"
                    class="text-xs text-muted-foreground hover:text-foreground border border-border px-2 py-1"
                    @click="mdSidebarCollapsed = false"
                  >
                    展开文件列表
                  </button>
                  <Input v-model="markdownTitle" type="text" placeholder="文档标题（可选）" class="rounded-none flex-1" />
                </div>
                <div class="border border-border overflow-hidden rounded-none flex-1 min-h-0">
                  <CodeMirrorEditor v-model="markdownContent" />
                </div>
                <div class="flex items-center gap-3">
                  <Button type="button" class="rounded-none" :disabled="savingUserFile" @click="saveMarkdown">保存</Button>
                  <p v-if="markdownError" class="text-sm text-destructive">{{ markdownError }}</p>
                </div>
              </div>
            </div>

            <div v-else-if="activeTab === 'records'">
              <div class="flex items-center justify-between gap-4 mb-4">
                <p class="text-sm text-muted-foreground">共 {{ items.length }} 条记录</p>
                <Button type="button" variant="outline" class="rounded-none" :disabled="items.length === 0" @click="clearAll">清空全部</Button>
              </div>

              <div v-if="items.length === 0" class="text-sm text-muted-foreground">暂无记录</div>

              <div v-else class="space-y-3">
          <div
            v-for="item in items"
            :key="item.id"
            class="border border-border p-4"
          >
            <div class="flex items-start justify-between gap-3">
              <div class="min-w-0">
                <p class="text-sm font-semibold text-foreground truncate">
                  <span class="mr-2 border border-border bg-muted/30 px-2 py-0.5 text-xs font-semibold text-muted-foreground">{{ item.kind }}</span>
                  {{ item.title || '无标题' }}
                </p>
                <p class="mt-1 text-xs text-muted-foreground">{{ formatTime(item.createdAt) }}</p>
              </div>
              <Button type="button" variant="destructive" size="sm" class="shrink-0 rounded-none" @click="removeItem(item.id)">删除</Button>
            </div>

            <div class="mt-3">
              <div v-if="item.kind === 'image' && item.dataUrl" class="bg-muted/30 p-2 border border-border">
                <img :src="item.dataUrl" alt="image" class="max-h-64 w-full object-contain" />
              </div>

              <div v-else-if="item.kind === 'hand' && item.dataUrl" class="bg-muted/30 p-2 border border-border">
                <img :src="item.dataUrl" alt="hand note" class="max-h-64 w-full object-contain" />
              </div>

              <div v-else-if="item.kind === 'url' && item.url" class="text-sm">
                <a
                  :href="item.url"
                  target="_blank"
                  rel="noreferrer"
                  class="font-semibold text-foreground underline underline-offset-4 break-all"
                >
                  {{ item.url }}
                </a>
              </div>

              <div v-else-if="item.kind === 'idea' && item.content" class="text-sm text-foreground whitespace-pre-wrap">
                {{ item.content }}
              </div>
            </div>
          </div>
              </div>
            </div>
          </Card>
        </main>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed, nextTick, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import CodeMirrorEditor from '../components/CodeMirrorEditor.vue'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import { fetchUserFileText, listMyUserFiles, uploadMyUserFile, type UserFile } from '../api/userFile'


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

const userFilesLoading = ref(false)
const userFilesError = ref('')
const userFiles = ref<UserFile[]>([])
const savingUserFile = ref(false)
const mdSidebarCollapsed = ref(false)
const selectedMdFileId = ref<number | null>(null)

const userTextFiles = computed(() => {
  return userFiles.value.filter((f) => f.file_type === 'md' || f.file_type === 'txt')
})

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

function formatUserFileTime(ts: string) {
  const d = new Date(ts)
  if (Number.isNaN(d.getTime())) return String(ts || '')
  return d.toLocaleString()
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

const imageItems = computed(() => {
  return items.value.filter((item) => item.kind === 'image' && !!item.dataUrl)
})

// 筛选出所有 markdown 类型的记录
async function loadUserFiles() {
  userFilesError.value = ''
  userFilesLoading.value = true
  try {
    userFiles.value = await listMyUserFiles()
  } catch (e: any) {
    userFilesError.value = e?.response?.data?.detail || e?.message || 'Failed to load files'
    userFiles.value = []
  } finally {
    userFilesLoading.value = false
  }
}

// 加载用户文件内容到编辑器
async function loadUserTextFile(file: UserFile) {
  markdownError.value = ''
  selectedMdFileId.value = file.id
  try {
    const text = typeof file.content === 'string' ? file.content : await fetchUserFileText(file.file_url)
    markdownTitle.value = String(file.title || file.original_filename || '')
    markdownContent.value = String(text || '')
  } catch (e: any) {
    markdownError.value = e?.response?.data?.detail || e?.message || 'Failed to load file content'
  }
}

async function saveMarkdown() {
  markdownError.value = ''
  const content = markdownContent.value.trim()
  if (!content) {
    markdownError.value = '请输入 Markdown 内容'
    return
  }

  savingUserFile.value = true
  const title = markdownTitle.value.trim() || 'Untitled'
  const blob = new Blob([content], { type: 'text/markdown' })
  const file = new File([blob], `${title}.md`, { type: 'text/markdown' })

  try {
    await uploadMyUserFile({ file, title })
    markdownTitle.value = ''
    markdownContent.value = ''
    await loadUserFiles()
  } catch (e: any) {
    markdownError.value = e?.response?.data?.detail || e?.message || 'Failed to save file'
  } finally {
    savingUserFile.value = false
  }
}

const totalCount = computed(() => items.value.length)

onMounted(async () => {
  const loaded = loadItems().filter((i) => i.kind !== 'markdown')
  items.value = loaded
  persistItems(loaded)
  await nextTick()
  ensureCanvasSize()
  window.addEventListener('resize', ensureCanvasSize)
  await loadUserFiles()
})
</script>

<style scoped>
</style>
