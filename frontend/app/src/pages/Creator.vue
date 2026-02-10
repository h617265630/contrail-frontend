<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <div
      v-if="savedToastVisible"
      class="fixed left-1/2 top-6 z-50 -translate-x-1/2 rounded-none border border-border bg-background px-4 py-2 text-sm font-semibold text-foreground shadow"
    >
      Saved
    </div>

    <div v-if="showDeleteConfirm" class="fixed inset-0 z-50 flex items-center justify-center bg-black/20 p-4 backdrop-blur-sm">
      <Card class="w-full max-w-md rounded-none" :hoverable="false">
        <div class="flex items-center justify-between border-b border-border p-6">
          <h2 class="text-lg font-semibold text-foreground">Confirm delete</h2>
          <Button
            type="button"
            variant="ghost"
            size="icon"
            class="rounded-none"
            :disabled="deletingUserFileId !== null"
            @click="closeDeleteConfirm"
          >
            ×
          </Button>
        </div>

        <div class="space-y-3 p-6">
          <div class="text-sm text-foreground">Are you sure you want to delete this document?</div>
          <div v-if="deleteTargetFile" class="border border-border bg-muted/30 p-3">
            <div class="line-clamp-1 font-semibold text-foreground">{{ deleteTargetFile.title || deleteTargetFile.original_filename || 'Untitled' }}</div>
            <div class="mt-1 line-clamp-1 text-xs text-muted-foreground">ID: {{ deleteTargetFile.id }}</div>
          </div>
          <p v-if="userFilesError" class="text-sm text-destructive">{{ userFilesError }}</p>
        </div>

        <div class="flex justify-end gap-2 border-t border-border bg-muted/30 p-6">
          <Button type="button" variant="outline" class="rounded-none" :disabled="deletingUserFileId !== null" @click="closeDeleteConfirm">
            Cancel
          </Button>
          <Button
            type="button"
            class="rounded-none bg-red-50 text-red-600 hover:bg-red-100"
            :disabled="deletingUserFileId !== null"
            @click="confirmDeleteUserTextFile"
          >
            {{ deletingUserFileId !== null ? 'Deleting…' : 'Delete' }}
          </Button>
        </div>
      </Card>
    </div>
    <section>
      <div class="grid gap-6 lg:grid-cols-12">
        <aside class="lg:col-span-3">
          <Card className="rounded-none" :hoverable="false" padded>
            <p class="text-sm font-semibold text-foreground">Creator Center</p>
            <p class="text-xs text-muted-foreground mt-1">A collection of creation tools</p>

            <div class="mt-4 space-y-2">
              <Button
                type="button"
                variant="ghost"
                class="w-full justify-start rounded-none"
                :class="activeTab === 'image' ? 'bg-foreground text-background hover:bg-foreground/90 hover:text-background' : 'text-foreground hover:bg-muted/30'"
                @click="selectTab('image')"
              >
                Upload image
              </Button>
              <Button
                type="button"
                variant="ghost"
                class="w-full justify-start rounded-none"
                :class="activeTab === 'hand' ? 'bg-foreground text-background hover:bg-foreground/90 hover:text-background' : 'text-foreground hover:bg-muted/30'"
                @click="selectTab('hand')"
              >
                Hand notes
              </Button>
              <Button
                type="button"
                variant="ghost"
                class="w-full justify-start rounded-none"
                :class="activeTab === 'idea' ? 'bg-foreground text-background hover:bg-foreground/90 hover:text-background' : 'text-foreground hover:bg-muted/30'"
                @click="selectTab('idea')"
              >
                Ideas
              </Button>
              <Button
                type="button"
                variant="ghost"
                class="w-full justify-start rounded-none"
                :class="activeTab === 'markdown' ? 'bg-foreground text-background hover:bg-foreground/90 hover:text-background' : 'text-foreground hover:bg-muted/30'"
                @click="selectTab('markdown')"
              >
                Editor
              </Button>
              <Button
                type="button"
                variant="ghost"
                class="w-full justify-start rounded-none"
                :class="activeTab === 'records' ? 'bg-foreground text-background hover:bg-foreground/90 hover:text-background' : 'text-foreground hover:bg-muted/30'"
                @click="selectTab('records')"
              >
                My records
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
              <div v-if="activeTab === 'markdown'" class="shrink-0">
                <Button type="button" variant="outline" class="rounded-none" @click="createNewMarkdown">
                  New
                </Button>
              </div>
            </div>
          </Card>

          <Card className="rounded-none" :hoverable="false" padded>
            <div v-if="activeTab === 'image'" class="space-y-3">
            <input
              ref="imageInputEl"
              type="file"
              accept="image/*"
              class="hidden"
              @change="onPickImage"
            />
            <div class="flex items-center gap-3">
              <Button type="button" variant="outline" class="shrink-0 rounded-none" @click="triggerPickImage">
                Choose file
              </Button>
              <div class="text-sm text-muted-foreground truncate">
                {{ selectedImageName || 'No file selected' }}
              </div>
            </div>
            <div class="flex items-center gap-3">
              <Input v-model="imageTitle" type="text" placeholder="Title (optional)" class="rounded-none" />
              <Button type="button" class="shrink-0 rounded-none" :disabled="!pendingImageDataUrl" @click="saveImage">Save</Button>
            </div>
            <p v-if="imageError" class="text-sm text-destructive">{{ imageError }}</p>
            <div v-if="pendingImageDataUrl" class="border border-border bg-muted/30 p-3">
              <img :src="pendingImageDataUrl" alt="preview" class="max-h-56 w-full object-contain" />
            </div>

            <div class="pt-2 border-t border-border">
              <div class="flex items-end justify-between gap-3">
                <div>
                  <p class="text-sm font-semibold text-foreground">My images</p>
                  <p class="text-xs text-muted-foreground mt-1">Total {{ imageItems.length }}</p>
                </div>
              </div>

              <div v-if="imageItems.length === 0" class="mt-3 text-sm text-muted-foreground">No images yet</div>

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
                    <p class="text-sm font-semibold text-foreground truncate" :title="img.title || 'Untitled'">
                      {{ img.title || 'Untitled' }}
                    </p>
                    <p class="mt-1 text-xs text-muted-foreground">{{ formatTime(img.createdAt) }}</p>
                  </div>
                </div>
              </div>
            </div>
            </div>

            <div v-else-if="activeTab === 'hand'" class="space-y-3">
            <div class="flex items-center gap-3">
              <Input v-model="handTitle" type="text" placeholder="Title (optional)" class="rounded-none" />
              <Button type="button" variant="outline" class="shrink-0 rounded-none" @click="clearCanvas">Clear</Button>
              <Button type="button" class="shrink-0 rounded-none" @click="saveHandNote">Save</Button>
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

            <div v-else-if="activeTab === 'idea'" class="space-y-3">
            <Input v-model="ideaTitle" type="text" placeholder="Title (optional)" class="rounded-none" />
            <textarea
              v-model="ideaContent"
              rows="4"
              placeholder="Write down your idea..."
              class="w-full border border-border bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground outline-none transition focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background rounded-none"
            ></textarea>
            <Button type="button" class="rounded-none" @click="saveIdea">Save</Button>
            <p v-if="ideaError" class="text-sm text-destructive">{{ ideaError }}</p>
            </div>

            <div v-else-if="activeTab === 'markdown'" class="flex gap-4 min-h-[calc(100vh-160px)]">
              <!-- 左侧文件列表（可折叠） -->
              <div
                v-if="!mdSidebarCollapsed"
                class="w-56 shrink-0 flex flex-col gap-3 border-r border-border pr-4"
              >
                <div class="flex items-center justify-between">
                  <h3 class="text-sm font-semibold text-foreground">Documents ({{ userTextFiles.length }})</h3>
                  <button
                    type="button"
                    class="text-xs text-muted-foreground hover:text-foreground"
                    @click="mdSidebarCollapsed = true"
                  >
                    Collapse
                  </button>
                </div>

                <div v-if="userFilesLoading" class="text-sm text-muted-foreground">Loading…</div>
                <div v-else-if="userFilesError" class="text-sm text-destructive">{{ userFilesError }}</div>
                <div v-else-if="userTextFiles.length === 0" class="text-sm text-muted-foreground">No documents yet</div>
                <div v-else class="flex flex-col gap-2 overflow-y-auto flex-1">
                  <button
                    v-for="file in userTextFiles"
                    :key="file.id"
                    type="button"
                    class="text-left border border-border bg-background p-2 transition hover:bg-muted/30 rounded-none"
                    :class="selectedMdFileId === file.id ? 'ring-2 ring-ring' : ''"
                    @click="loadUserTextFile(file)"
                  >
                    <div class="flex items-start justify-between gap-2">
                      <div class="min-w-0">
                        <p class="text-sm font-semibold text-foreground truncate" :title="file.title || 'Untitled'">
                          {{ file.title || 'Untitled' }}
                        </p>
                        <p class="text-xs text-muted-foreground">{{ formatUserFileTime(file.created_at) }}</p>
                      </div>
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        class="shrink-0 rounded-none text-red-500 hover:bg-red-50 hover:text-red-600"
                        :disabled="deletingUserFileId === file.id"
                        @click.stop="openDeleteConfirm(file)"
                      >
                        <Trash2 class="h-4 w-4" />
                      </Button>
                    </div>
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
                    Show file list
                  </button>
                  <Input v-model="markdownTitle" type="text" placeholder="Document title (optional)" class="rounded-none flex-1" />
                </div>
                <div class="border border-border overflow-hidden rounded-none flex-1 min-h-0">
                  <CodeMirrorEditor v-model="markdownContent" />
                </div>
                <div class="flex items-center gap-3">
                  <Button type="button" class="rounded-none" :disabled="savingUserFile" @click="saveMarkdown">Save</Button>
                  <p v-if="markdownError" class="text-sm text-destructive">{{ markdownError }}</p>
                </div>
              </div>
            </div>

            <div v-else-if="activeTab === 'records'">
              <div class="flex items-center justify-between gap-4 mb-4">
                <p class="text-sm text-muted-foreground">Total {{ items.length }} records</p>
                <Button type="button" variant="outline" class="rounded-none" :disabled="items.length === 0" @click="clearAll">Clear all</Button>
              </div>

              <div v-if="items.length === 0" class="text-sm text-muted-foreground">No records yet</div>

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
                  {{ item.title || 'Untitled' }}
                </p>
                <p class="mt-1 text-xs text-muted-foreground">{{ formatTime(item.createdAt) }}</p>
              </div>
              <Button
                type="button"
                variant="ghost"
                size="sm"
                class="shrink-0 rounded-none text-red-500 hover:bg-red-50 hover:text-red-600"
                @click="removeItem(item.id)"
              >
                <Trash2 class="h-4 w-4" />
              </Button>
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
import { computed, nextTick, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import CodeMirrorEditor from '../components/CodeMirrorEditor.vue'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import { deleteMyUserFile, fetchUserFileText, listMyUserFiles, updateMyUserFile, uploadMyUserFile, type UserFile } from '../api/userFile'
import { Trash2 } from 'lucide-vue-next'


type CreatorTab = 'image' | 'hand' | 'idea' | 'markdown' | 'records'
type CreatorItemKind = 'image' | 'hand' | 'url' | 'idea' | 'markdown'

const activeTab = ref<CreatorTab>('image')

function normalizeCreatorTab(value: unknown): CreatorTab | null {
  const t = String(value || '').trim()
  if (!t) return null
  if (t === 'image' || t === 'hand' || t === 'idea' || t === 'markdown' || t === 'records') return t
  return null
}

function syncTabFromRoute() {
  const next = normalizeCreatorTab((route.query as any)?.tab)
  if (next && next !== activeTab.value) activeTab.value = next
}

const route = useRoute()
const router = useRouter()

const tabTitle = computed(() => {
  switch (activeTab.value) {
    case 'image': return 'Upload image'
    case 'hand': return 'Hand notes'
    case 'idea': return 'Ideas'
    case 'markdown': return 'Editor'
    case 'records': return 'My records'
    default: return 'Creator'
  }
})

const tabSubtitle = computed(() => {
  switch (activeTab.value) {
    case 'image': return 'Upload and save image files'
    case 'hand': return 'Take notes on a canvas'
    case 'idea': return 'Capture thoughts and ideas'
    case 'markdown': return 'Write documents in Markdown'
    case 'records': return `Total ${items.value.length} records`
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
const deletingUserFileId = ref<number | null>(null)

const savedToastVisible = ref(false)
let savedToastTimer: number | null = null

function showSavedToast() {
  savedToastVisible.value = true
  if (savedToastTimer) {
    clearTimeout(savedToastTimer)
    savedToastTimer = null
  }
  savedToastTimer = window.setTimeout(() => {
    savedToastVisible.value = false
    savedToastTimer = null
  }, 1200) as unknown as number
}

const showDeleteConfirm = ref(false)
const deleteTargetFile = ref<UserFile | null>(null)

function openDeleteConfirm(file: UserFile) {
  if (deletingUserFileId.value !== null) return
  markdownError.value = ''
  userFilesError.value = ''
  deleteTargetFile.value = file
  showDeleteConfirm.value = true
}

function closeDeleteConfirm() {
  if (deletingUserFileId.value !== null) return
  showDeleteConfirm.value = false
  deleteTargetFile.value = null
  userFilesError.value = ''
}

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

function createNewMarkdown() {
  markdownError.value = ''
  selectedMdFileId.value = null
  markdownTitle.value = ''
  markdownContent.value = ''
}

async function confirmDeleteUserTextFile() {
  markdownError.value = ''
  userFilesError.value = ''
  const file = deleteTargetFile.value
  if (!file) return
  if (deletingUserFileId.value !== null) return

  deletingUserFileId.value = file.id
  try {
    await deleteMyUserFile(file.id)
    if (selectedMdFileId.value === file.id) {
      createNewMarkdown()
    }
    await loadUserFiles()
    showDeleteConfirm.value = false
    deleteTargetFile.value = null
  } catch (e: any) {
    userFilesError.value = e?.response?.data?.detail || e?.message || 'Failed to delete file'
  } finally {
    deletingUserFileId.value = null
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
const imageInputEl = ref<HTMLInputElement | null>(null)
const selectedImageName = ref('')

function triggerPickImage() {
  const el = imageInputEl.value
  if (!el) return
  el.value = ''
  el.click()
}

function onPickImage(e: Event) {
  imageError.value = ''
  pendingImageDataUrl.value = ''
  selectedImageName.value = ''

  const input = e.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return

  selectedImageName.value = String(file.name || '')

  if (!file.type.startsWith('image/')) {
    imageError.value = 'Please select an image file'
    return
  }

  const reader = new FileReader()
  reader.onload = () => {
    const result = reader.result
    if (typeof result === 'string') pendingImageDataUrl.value = result
  }
  reader.onerror = () => {
    imageError.value = 'Failed to read image'
  }
  reader.readAsDataURL(file)

  input.value = ''
}

function saveImage() {
  imageError.value = ''
  if (!pendingImageDataUrl.value) {
    imageError.value = 'Please select an image first'
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

  showSavedToast()
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
    handError.value = 'Canvas is not ready'
    return
  }

  // avoid saving blank canvas
  const empty = document.createElement('canvas')
  empty.width = canvas.width
  empty.height = canvas.height
  if (canvas.toDataURL() === empty.toDataURL()) {
    handError.value = 'Please draw something before saving'
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

  showSavedToast()
}

// --- idea ---
const ideaTitle = ref('')
const ideaContent = ref('')
const ideaError = ref('')

function saveIdea() {
  ideaError.value = ''
  const content = ideaContent.value.trim()
  if (!content) {
    ideaError.value = 'Please enter idea content'
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

  showSavedToast()
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
    markdownError.value = 'Please enter Markdown content'
    return
  }

  savingUserFile.value = true
  const title = markdownTitle.value.trim() || 'Untitled'
  try {
    if (selectedMdFileId.value) {
      await updateMyUserFile(selectedMdFileId.value, { title, content })
      await loadUserFiles()
    } else {
      const blob = new Blob([content], { type: 'text/markdown' })
      const file = new File([blob], `${title}.md`, { type: 'text/markdown' })
      await uploadMyUserFile({ file, title })
      markdownTitle.value = ''
      markdownContent.value = ''
      await loadUserFiles()
    }

    showSavedToast()
  } catch (e: any) {
    markdownError.value = e?.response?.data?.detail || e?.message || 'Failed to save file'
  } finally {
    savingUserFile.value = false
  }
}

const totalCount = computed(() => items.value.length)

onMounted(async () => {
  syncTabFromRoute()
  const loaded = loadItems().filter((i) => i.kind !== 'markdown')
  items.value = loaded
  persistItems(loaded)
  await nextTick()
  ensureCanvasSize()
  window.addEventListener('resize', ensureCanvasSize)
  await loadUserFiles()
})

watch(
  () => (route.query as any)?.tab,
  () => syncTabFromRoute(),
)
</script>

<style scoped>
</style>
