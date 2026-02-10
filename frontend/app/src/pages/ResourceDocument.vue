<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Document</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">Preview or read the document and track progress.</p>
        </div>
      </div>
    </section>

    <div class="space-y-6">
      <div class="space-y-2">
        <p class="text-xs font-medium tracking-[0.14em] uppercase text-muted-foreground">Document Resource</p>
        <h2 class="text-2xl font-semibold text-foreground md:text-3xl">{{ resource.title }}</h2>
        <div class="flex flex-wrap items-center gap-2 text-sm text-muted-foreground">
          <span class="inline-flex items-center gap-2 px-3 py-1 rounded-md border border-border bg-muted/30">
            <FileText class="w-4 h-4" />
            {{ resource.resource_type }}
          </span>
          <span v-if="resource.platform" class="inline-flex items-center gap-2 px-3 py-1 rounded-md border border-border bg-muted/30">
            <Sparkles class="w-4 h-4" />
            {{ formatPlatform(resource.platform) }}
          </span>
          <span class="inline-flex items-center gap-2 px-3 py-1 rounded-md border border-border bg-muted/30">
            <Sparkles class="w-4 h-4" />
            {{ updatedText ? `Updated ${updatedText}` : '—' }}
          </span>
        </div>
      </div>

      <div class="grid gap-6 lg:grid-cols-[2fr_1fr]">
        <Card :hoverable="false" className="overflow-hidden">
          <!-- Document Viewer -->
          <div v-if="canPreview" class="w-full bg-slate-100">
            <div class="flex items-center justify-between px-4 py-3 border-b border-border bg-muted/30">
              <div class="flex items-center gap-2 text-sm text-foreground">
                <FileText class="w-4 h-4 text-foreground" />
                <span>文档预览</span>
              </div>
              <div class="flex items-center gap-2">
                <Button type="button" size="sm" class="rounded-md" @click="openSource">
                  在新标签页打开
                </Button>
                <Button
                  v-if="pathItemId != null"
                  type="button"
                  size="sm"
                  class="rounded-md"
                  :disabled="progressUpdating"
                  @click="markComplete"
                >
                  标记为已完成
                </Button>
              </div>
            </div>
            <div class="w-full" style="height: 600px;">
              <iframe 
                v-if="viewerUrl" 
                :src="viewerUrl" 
                class="w-full h-full border-0"
                title="Document viewer"
              ></iframe>
              <div v-else class="w-full h-full flex items-center justify-center text-muted-foreground">
                <div class="text-center space-y-2">
                  <FileText class="w-12 h-12 mx-auto text-muted-foreground" />
                  <p>无法预览此文档</p>
                </div>
              </div>
            </div>
          </div>

          <!-- Fallback: Thumbnail + Summary -->
          <template v-else>
            <div v-if="resource.thumbnail" class="w-full h-64 bg-slate-100 overflow-hidden mt-6">
              <img :src="resource.thumbnail" :alt="resource.title" class="w-full h-full object-cover" />
            </div>
            <div v-else class="w-full h-64 bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center mt-6">
              <FileText class="w-16 h-16 text-white/80" />
            </div>
          </template>

          <!-- Content -->
          <div class="p-6 space-y-6">
            <div v-if="pathItemId != null" class="rounded-md border border-border bg-background p-4">
              <div class="flex items-center justify-between mb-2">
                <span class="text-sm font-semibold text-foreground">学习进度</span>
                <span class="text-sm font-semibold text-foreground">{{ trackedProgress }}%</span>
              </div>
              <div class="w-full bg-muted h-2">
                <div
                  class="h-2 rounded-md transition-all duration-300 bg-foreground"
                  :style="{ width: `${trackedProgress}%` }"
                />
              </div>
              <div class="mt-2 flex items-center justify-between text-xs text-muted-foreground">
                <span>{{ trackedProgress >= 100 ? '已完成' : trackedProgress > 0 ? '学习中' : '未开始' }}</span>
                <span v-if="trackedProgress < 100">继续阅读以更新进度</span>
              </div>
            </div>

            <!-- Summary -->
            <div v-if="resource.summary" class="space-y-2">
              <h3 class="text-lg font-semibold text-foreground">摘要</h3>
              <p class="text-sm text-muted-foreground leading-relaxed whitespace-pre-wrap">{{ resource.summary }}</p>
            </div>

            <div v-if="!canPreview" class="rounded-md border border-border bg-background overflow-hidden">
              <div class="flex items-center justify-between px-4 py-3 bg-muted/30 border-b border-border">
                <div class="text-sm font-semibold text-foreground">Reader Mode</div>
                <div class="flex items-center gap-2">
                  <Button type="button" size="sm" class="rounded-md" :disabled="!resource.source_url" @click="openSource(true)">
                    Open Original
                  </Button>
                  <Button
                    v-if="pathItemId != null"
                    type="button"
                    size="sm"
                    class="rounded-md"
                    :disabled="progressUpdating"
                    @click="markComplete"
                  >
                    标记为已完成
                  </Button>
                </div>
              </div>
              <div v-if="readerLoading" class="p-6 text-muted-foreground">Loading…</div>
              <div v-else-if="readerHtml" ref="readerScrollRef" class="p-6 max-h-[70vh] overflow-y-auto prose prose-slate max-w-none">
                <div v-html="readerHtml" />
              </div>
              <div v-else class="p-6">
                <div class="bg-muted/30 border border-border rounded-md p-6 space-y-4">
                  <div class="flex items-start gap-3">
                    <BookOpen class="w-6 h-6 text-blue-600 shrink-0 mt-1" />
                    <div class="flex-1">
                      <h3 class="font-semibold text-foreground mb-2">站内阅读不可用</h3>
                      <p class="text-muted-foreground text-sm mb-4">
                        {{ readerError || '当前链接暂时无法抽取正文。你仍可以打开原文，并在返回后记录进度。' }}
                      </p>
                      <div class="flex items-center gap-3">
                        <Button type="button" class="rounded-md" :disabled="!resource.source_url" @click="openSource(true)">
                          <span>View on {{ formatPlatform(resource.platform) || 'Original site' }}</span>
                          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                          </svg>
                        </Button>
                        <Button
                          v-if="pathItemId != null"
                          type="button"
                          class="rounded-md"
                          :disabled="progressUpdating"
                          @click="markComplete"
                        >
                          标记为已完成
                        </Button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </Card>

        <div class="space-y-4">
          <Card :hoverable="false" padded>
            <h3 class="font-semibold text-foreground">Meta</h3>
            <div class="mt-2 space-y-2 text-sm text-muted-foreground">
              <div class="flex items-center gap-2">
                <LinkIcon class="w-4 h-4 text-muted-foreground" />
                <a v-if="resource.source_url" :href="resource.source_url" target="_blank" class="text-foreground underline underline-offset-4 break-all">{{ resource.source_url }}</a>
                <span v-else>—</span>
              </div>
              <div class="flex items-center gap-2">
                <GraduationCap class="w-4 h-4 text-muted-foreground" />
                <span>Platform {{ formatPlatform(resource.platform) }}</span>
              </div>
            </div>
            <div class="mt-3 grid grid-cols-2 gap-2 text-sm text-foreground">
              <div class="p-3 rounded-md bg-muted/30 border border-border flex items-center justify-between">
                <span>Created</span>
                <span class="font-semibold">{{ createdText || '—' }}</span>
              </div>
              <div class="p-3 rounded-md bg-muted/30 border border-border flex items-center justify-between">
                <span>Published</span>
                <span class="font-semibold">{{ publishedText || '—' }}</span>
              </div>
            </div>
            <div class="mt-3 flex gap-2">
              <RouterLink
                :to="{ name: 'resource-add-to-path', params: { type: 'document', id: resourceId } }"
                class="flex-1"
              >
                <Button type="button" class="w-full rounded-md">Add to path</Button>
              </RouterLink>
              <Button
                v-if="pathItemId != null"
                type="button"
                variant="outline"
                class="rounded-md"
                :disabled="progressUpdating"
                @click="markComplete"
              >
                Mark as complete
              </Button>
              <Button type="button" variant="outline" class="rounded-md" @click="openSource" :disabled="!resource.source_url">Open</Button>
            </div>
          </Card>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter, RouterLink } from 'vue-router'
import { BookOpen, Download, FileText, GraduationCap, Link as LinkIcon, Sparkles, UserRound } from 'lucide-vue-next'
import { getMyResourceDetail, getResourceDetail, type DbResourceDetail } from '../api/resource'
import { getMyProgressForItem, upsertMyProgress } from '../api/progress'
import request from '../utils/request'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'
import { formatPlatform } from '../utils/platform'

const route = useRoute()
const router = useRouter()

const loading = ref(false)
const error = ref('')

const resourceId = computed(() => String(route.params.id || '').trim())
const resourceIdNumber = computed(() => {
  const raw = resourceId.value
  if (!raw) return null
  if (!/^\d+$/.test(raw)) return null
  const n = Number(raw)
  return Number.isFinite(n) ? n : null
})

const resource = ref<DbResourceDetail>({} as DbResourceDetail)

const pathItemId = computed(() => {
  const raw = String((route.query as any)?.path_item_id || '').trim()
  if (!raw) return null
  if (!/^\d+$/.test(raw)) return null
  const n = Number(raw)
  return Number.isFinite(n) ? n : null
})

const trackedProgress = ref(0)
let progressTimer: number | null = null
const progressUpdating = ref(false)
const lastSentProgress = ref(0)
const readerLoading = ref(false)
const readerError = ref('')
const readerHtml = ref('')
const readerWordCount = ref(0)
const readerScrollRef = ref<HTMLElement | null>(null)
const readingActiveSeconds = ref(0)
let lastTickAt = 0
const externalTrackingStartAt = ref<number | null>(null)
const externalTrackingArmed = ref(false)

function stopProgressTimer() {
  if (progressTimer != null) {
    window.clearInterval(progressTimer)
    progressTimer = null
  }
}

function stopExternalTracking() {
  externalTrackingArmed.value = false
  externalTrackingStartAt.value = null
}

function estimateReadingSeconds() {
  const wc = Math.max(0, Number(readerWordCount.value) || 0)
  if (wc > 0) {
    return Math.max(60, Math.round((wc / 220) * 60))
  }
  return 8 * 60
}

function computeScrollPct() {
  const el = readerScrollRef.value
  if (!el) return 0
  const max = el.scrollHeight - el.clientHeight
  if (max <= 0) return 100
  return Math.min(100, Math.max(0, Math.round((el.scrollTop / max) * 100)))
}

async function maybeSendProgress(next: number) {
  const pid = pathItemId.value
  if (pid == null) return
  if (progressUpdating.value) return
  const n = Math.min(95, Math.max(0, Math.round(next)))
  if (n <= lastSentProgress.value) return
  progressUpdating.value = true
  try {
    trackedProgress.value = n
    lastSentProgress.value = n
    await upsertMyProgress({ path_item_id: pid, progress_percentage: n })
  } catch {
    // ignore
  } finally {
    progressUpdating.value = false
  }
}

async function startProgressTimer() {
  stopProgressTimer()
  if (pathItemId.value == null) return

  try {
    const row = await getMyProgressForItem(pathItemId.value)
    trackedProgress.value = Number(row?.progress_percentage) || 0
  } catch {
    trackedProgress.value = 0
  }

  lastSentProgress.value = trackedProgress.value

  readingActiveSeconds.value = 0
  lastTickAt = Date.now()
  progressTimer = window.setInterval(async () => {
    if (document.visibilityState !== 'visible') return
    if (!readerHtml.value) return
    const now = Date.now()
    const delta = Math.max(0, Math.round((now - lastTickAt) / 1000))
    lastTickAt = now
    readingActiveSeconds.value += delta
    const scrollPct = computeScrollPct()
    const timePct = Math.min(95, Math.round((readingActiveSeconds.value / estimateReadingSeconds()) * 100))
    await maybeSendProgress(Math.max(scrollPct, timePct))
  }, 5_000)
}

function formatDate(iso?: string | null) {
  if (!iso) return ''
  const d = new Date(iso)
  if (Number.isNaN(d.getTime())) return ''
  return d.toLocaleDateString()
}

const createdText = computed(() => formatDate(resource.value.created_at || null))
const publishedText = computed(() => formatDate(resource.value.article?.published_at || null))
const updatedText = computed(() => publishedText.value || createdText.value)

// 文档预览逻辑
const canPreview = computed(() => {
  const url = resource.value.source_url
  if (!url) return false
  
  // 检查是否为可预览的文档类型
  const lowerUrl = url.toLowerCase()
  
  // PDF 文件
  if (lowerUrl.endsWith('.pdf')) return true
  
  // Office 文档
  if (lowerUrl.endsWith('.doc') || lowerUrl.endsWith('.docx') ||
      lowerUrl.endsWith('.xls') || lowerUrl.endsWith('.xlsx') ||
      lowerUrl.endsWith('.ppt') || lowerUrl.endsWith('.pptx')) {
    return true
  }
  
  return false
})

const viewerUrl = computed(() => {
  const url = resource.value.source_url
  if (!url) return ''
  
  const lowerUrl = url.toLowerCase()
  
  // PDF 文件 - 使用 PDF.js
  if (lowerUrl.endsWith('.pdf')) {
    // 使用 Mozilla 的 PDF.js viewer
    return `https://mozilla.github.io/pdf.js/web/viewer.html?file=${encodeURIComponent(url)}`
  }
  
  // Office 文档 - 使用 Microsoft Office Online Viewer
  if (lowerUrl.endsWith('.doc') || lowerUrl.endsWith('.docx') ||
      lowerUrl.endsWith('.xls') || lowerUrl.endsWith('.xlsx') ||
      lowerUrl.endsWith('.ppt') || lowerUrl.endsWith('.pptx')) {
    return `https://view.officeapps.live.com/op/embed.aspx?src=${encodeURIComponent(url)}`
  }
  
  return ''
})

function openSource(arg?: boolean | Event) {
  const track = typeof arg === 'boolean' ? arg : false
  const url = String(resource.value.source_url || '').trim()
  if (!url) return
  if (track) {
    externalTrackingStartAt.value = Date.now()
    externalTrackingArmed.value = true
  }
  window.open(url, '_blank', 'noopener,noreferrer')
}

function onVisibilityChange() {
  if (document.visibilityState !== 'visible') return
  if (!externalTrackingArmed.value) return
  const startAt = externalTrackingStartAt.value
  stopExternalTracking()
  if (!startAt) return
  const minutes = Math.round((Date.now() - startAt) / 60_000)
  if (minutes <= 0) return
  if (pathItemId.value == null) return
  const ok = window.confirm(`是否记录你在外部阅读的 ${minutes} 分钟到学习进度？`)
  if (!ok) return
  const inc = Math.min(30, minutes * 5)
  void maybeSendProgress(Math.min(95, trackedProgress.value + inc))
}

async function loadReader() {
  readerError.value = ''
  readerHtml.value = ''
  readerWordCount.value = 0
  if (canPreview.value) return
  const url = String(resource.value.source_url || '').trim()
  if (!url) return
  readerLoading.value = true
  try {
    const data = await request.post<any, any>('/reader/extract', { url })
    const html = String(data?.content_html || '').trim()
    readerHtml.value = html
    readerWordCount.value = Number(data?.word_count) || 0
    if (html && pathItemId.value != null) {
      await startProgressTimer()
    }
  } catch (e: any) {
    readerError.value = String(e?.response?.data?.detail || e?.message || 'Reader extract failed')
  } finally {
    readerLoading.value = false
  }
}

async function markComplete() {
  const pid = pathItemId.value
  if (pid == null) return
  if (progressUpdating.value) return
  progressUpdating.value = true
  try {
    trackedProgress.value = 100
    lastSentProgress.value = 100
    await upsertMyProgress({ path_item_id: pid, progress_percentage: 100 })
  } catch {
    // ignore
  } finally {
    progressUpdating.value = false
  }
}

async function load() {
  error.value = ''
  loading.value = true
  try {
    const dbId = resourceIdNumber.value
    if (dbId == null) throw new Error('Invalid resource id')
    const isMy = String(route.path || '').startsWith('/my-resources')
    const data = isMy ? await getMyResourceDetail(dbId) : await getResourceDetail(dbId)
    resource.value = { ...data }
    await loadReader()
  } catch (e: any) {
    error.value = String(e?.response?.data?.detail || e?.message || 'Failed to load resource')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  void load()
  void startProgressTimer()
  document.addEventListener('visibilitychange', onVisibilityChange)
})

watch(pathItemId, () => {
  void startProgressTimer()
})

onBeforeUnmount(() => {
  stopProgressTimer()
  document.removeEventListener('visibilitychange', onVisibilityChange)
})
</script>
