<template>
  <div class="min-h-screen bg-slate-50">
    <div class="max-w-6xl mx-auto p-6 space-y-6">
      <div v-if="loading" class="rounded-2xl bg-white p-6 shadow-sm text-slate-700">Loading…</div>
      <div v-else-if="error" class="rounded-2xl bg-white p-6 shadow-sm text-red-600">{{ error }}</div>

      <template v-else>
        <div class="flex flex-col gap-2">
          <p class="text-sm uppercase tracking-wide text-emerald-600 font-semibold">Article Resource</p>
          <h1 class="text-3xl font-semibold text-slate-900">{{ resource.title }}</h1>
          <div class="flex flex-wrap items-center gap-3 text-sm text-slate-600">
            <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-slate-100 text-slate-700">
              <BookOpen class="w-4 h-4" />
              {{ resource.resource_type }}
            </span>
            <span v-if="resource.platform" class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-slate-100 text-slate-700">
              <Sparkles class="w-4 h-4" />
              {{ resource.platform }}
            </span>
            <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-slate-100 text-slate-700">
              <Sparkles class="w-4 h-4" />
              {{ updatedText ? `Updated ${updatedText}` : '—' }}
            </span>
          </div>
        </div>

        <div class="grid gap-6 lg:grid-cols-[2fr_1fr]">
          <div class="bg-white rounded-2xl shadow-sm overflow-hidden border border-slate-100">
            <!-- Thumbnail -->
            <div v-if="resource.thumbnail" class="w-full h-64 bg-slate-100 overflow-hidden">
              <img :src="resource.thumbnail" :alt="resource.title" class="w-full h-full object-cover" />
            </div>
            <div v-else class="w-full h-64 bg-gradient-to-br from-emerald-500 to-teal-600 flex items-center justify-center">
              <BookOpen class="w-16 h-16 text-white/80" />
            </div>

            <!-- Content -->
            <div class="p-6 space-y-6">
              <div v-if="pathItemId != null" class="rounded-xl border border-slate-200 bg-white p-4">
                <div class="flex items-center justify-between mb-2">
                  <span class="text-sm font-semibold text-slate-700">学习进度</span>
                  <span class="text-sm font-semibold text-emerald-600">{{ trackedProgress }}%</span>
                </div>
                <div class="w-full bg-slate-200 rounded-full h-2.5">
                  <div
                    class="h-2.5 rounded-full transition-all duration-300"
                    :class="trackedProgress >= 100 ? 'bg-green-500' : 'bg-emerald-600'"
                    :style="{ width: `${trackedProgress}%` }"
                  />
                </div>
                <div class="mt-2 flex items-center justify-between text-xs text-slate-500">
                  <span>{{ trackedProgress >= 100 ? '已完成' : trackedProgress > 0 ? '学习中' : '未开始' }}</span>
                  <span v-if="trackedProgress < 100">继续阅读以更新进度</span>
                </div>
              </div>

              <!-- Summary -->
              <div v-if="resource.summary" class="space-y-2">
                <h2 class="text-xl font-semibold text-slate-900">摘要</h2>
                <p class="text-slate-700 leading-relaxed whitespace-pre-wrap text-lg">{{ resource.summary }}</p>
              </div>

              <div class="rounded-xl border border-slate-200 bg-white overflow-hidden">
                <div class="flex items-center justify-between px-4 py-3 bg-slate-50 border-b border-slate-200">
                  <div class="text-sm font-semibold text-slate-900">Reader Mode</div>
                  <div class="flex items-center gap-2">
                    <button
                      type="button"
                      class="px-3 py-2 rounded-lg bg-slate-900 text-white text-sm font-semibold hover:bg-black disabled:opacity-50"
                      :disabled="!resource.source_url"
                      @click="openSource(true)"
                    >
                      Open Original
                    </button>
                    <button
                      v-if="pathItemId != null"
                      type="button"
                      class="px-3 py-2 rounded-lg bg-emerald-600 text-white text-sm font-semibold hover:bg-emerald-700 disabled:opacity-50"
                      :disabled="progressUpdating"
                      @click="markComplete"
                    >
                      标记为已完成
                    </button>
                  </div>
                </div>
                <div v-if="readerLoading" class="p-6 text-slate-700">Loading…</div>
                <div v-else-if="readerHtml" ref="readerScrollRef" class="p-6 max-h-[70vh] overflow-y-auto prose prose-slate max-w-none">
                  <div v-html="readerHtml" />
                </div>
                <div v-else class="p-6">
                  <div class="bg-slate-50 border border-slate-200 rounded-xl p-6 space-y-4">
                    <div class="flex items-start gap-3">
                      <BookOpen class="w-6 h-6 text-emerald-600 shrink-0 mt-1" />
                      <div class="flex-1">
                        <h3 class="font-semibold text-slate-900 mb-2">站内阅读不可用</h3>
                        <p class="text-slate-600 text-sm mb-4">
                          {{ readerError || '当前链接暂时无法抽取正文。你仍可以打开原文，并在返回后记录进度。' }}
                        </p>
                        <div class="flex items-center gap-3">
                          <button
                            type="button"
                            class="px-6 py-3 rounded-lg bg-slate-900 text-white font-semibold hover:bg-black disabled:opacity-50 transition-colors inline-flex items-center gap-2"
                            :disabled="!resource.source_url"
                            @click="openSource(true)"
                          >
                            <span>在 {{ resource.platform || '原站' }} 上阅读</span>
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                            </svg>
                          </button>
                          <button
                            v-if="pathItemId != null"
                            type="button"
                            class="px-4 py-3 rounded-lg bg-emerald-600 text-white font-semibold hover:bg-emerald-700 disabled:opacity-50 transition-colors"
                            :disabled="progressUpdating"
                            @click="markComplete"
                          >
                            标记为已完成
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

            </div>
          </div>

          <div class="space-y-4">
            <div class="p-4 rounded-2xl bg-white border border-slate-200 space-y-3">
              <h3 class="font-semibold text-slate-900">Meta</h3>
              <div class="space-y-2 text-sm text-slate-700">
                <div class="flex items-center gap-2">
                  <LinkIcon class="w-4 h-4 text-slate-500" />
                  <a v-if="resource.source_url" :href="resource.source_url" target="_blank" class="text-emerald-600 hover:underline break-all">{{ resource.source_url }}</a>
                  <span v-else>—</span>
                </div>
                <div class="flex items-center gap-2">
                  <UserRound class="w-4 h-4 text-slate-500" />
                  <span>Publisher {{ resource.article?.publisher || '—' }}</span>
                </div>
                <div class="flex items-center gap-2">
                  <GraduationCap class="w-4 h-4 text-slate-500" />
                  <span>Platform {{ resource.platform || '—' }}</span>
                </div>
              </div>
              <div class="grid grid-cols-2 gap-2 text-sm text-slate-800">
                <div class="p-3 rounded-lg bg-slate-50 border border-slate-100 flex items-center justify-between">
                  <span>Created</span>
                  <span class="font-semibold">{{ createdText || '—' }}</span>
                </div>
                <div class="p-3 rounded-lg bg-slate-50 border border-slate-100 flex items-center justify-between">
                  <span>Published</span>
                  <span class="font-semibold">{{ publishedText || '—' }}</span>
                </div>
              </div>
              <div class="flex gap-2">
                <RouterLink
                  :to="{ name: 'resource-add-to-path', params: { type: 'article', id: resourceId } }"
                  class="flex-1 px-3 py-2 rounded-lg bg-emerald-600 text-white font-semibold hover:bg-emerald-700 text-center"
                >
                  Add to path
                </RouterLink>
                <button type="button" class="px-3 py-2 rounded-lg border border-slate-200 text-slate-700 hover:bg-white" @click="openSource" :disabled="!resource.source_url">
                  Open
                </button>
              </div>
            </div>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, RouterLink } from 'vue-router'
import { BookOpen, Download, GraduationCap, Link as LinkIcon, Sparkles, UserRound } from 'lucide-vue-next'
import { getMyResourceDetail, getResourceDetail, type DbResourceDetail } from '../api/resource'
import { getMyProgressForItem, upsertMyProgress } from '../api/progress'
import request from '../utils/request'

const route = useRoute()

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
