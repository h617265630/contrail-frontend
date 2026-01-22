<template>
  <div class="min-h-screen bg-slate-50">
    <div class="max-w-6xl mx-auto p-6 space-y-4">
      <div v-if="loading" class="rounded-2xl bg-white p-6 shadow-sm text-slate-700">Loading…</div>

      <div v-else-if="error" class="rounded-2xl bg-white p-6 shadow-sm text-red-600">{{ error }}</div>

      <template v-else>
        <div class="space-y-3">
          <div class="rounded-2xl bg-black overflow-hidden shadow-sm">
            <div class="relative w-full aspect-video">
              <iframe
                v-if="isYouTubeUrl(resource.source_url)"
                :src="toYouTubeEmbed(resource.source_url)"
                class="absolute inset-0 h-full w-full"
                title="YouTube Video Player"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                allowfullscreen
              />
              <div v-else-if="embedUrl"
                :src="embedUrl"
                class="absolute inset-0 h-full w-full"
                title="Video preview"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                allowfullscreen
              />
              <div v-else class="absolute inset-0 flex items-center justify-center text-white/80">
                Video preview is unavailable
              </div>
function isYouTubeUrl(url) {
  if (!url) return false;
  return /youtube\.com\/watch\?v=|youtu\.be\//.test(url);
}

function toYouTubeEmbed(url) {
  if (!url) return '';
  const match = url.match(/(?:youtube\\.com\/watch\\?v=|youtu\\.be\/)([\w-]+)/);
  return match ? `https://www.youtube.com/embed/${match[1]}` : url;
}

              <div
                v-if="playerFailed"
                class="absolute inset-0 flex flex-col items-center justify-center gap-3 bg-black/50 px-6 text-center"
              >
                <div class="text-white/90 text-sm">
                  Unable to load the embedded player. This is usually caused by network restrictions or browser extensions.
                </div>
                <button
                  type="button"
                  class="inline-flex items-center gap-2 rounded-lg bg-white/90 px-4 py-2 text-sm font-semibold text-slate-900 hover:bg-white"
                  @click="openSource"
                >
                  Open Source URL
                </button>
              </div>
            </div>
          </div>

          <h1 class="text-xl sm:text-2xl font-semibold text-slate-900">{{ resource.title }}</h1>

          <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
            <div class="flex flex-wrap items-center gap-3 text-sm text-slate-600">
              <span class="inline-flex items-center gap-2 rounded-full bg-slate-100 px-3 py-1">
                <UserRound class="h-4 w-4" />
                {{ resource.video?.channel || 'Unknown author' }}
              </span>
              <span v-if="publishedText" class="inline-flex items-center gap-2 rounded-full bg-slate-100 px-3 py-1">
                <Calendar class="h-4 w-4" />
                {{ publishedText }}
              </span>
              <span v-if="addedText" class="inline-flex items-center gap-2 rounded-full bg-slate-100 px-3 py-1">
                <Clock class="h-4 w-4" />
                Added {{ addedText }}
              </span>
            </div>

            <div class="flex items-center gap-2">
              <button
                type="button"
                class="px-3 py-2 rounded-lg bg-white text-slate-900 text-sm font-semibold shadow-sm hover:bg-slate-50"
                @click="goSaveToPath"
              >
                Save to path
              </button>
              <button
                v-if="pathItemId != null"
                type="button"
                class="px-3 py-2 rounded-lg bg-blue-600 text-white text-sm font-semibold shadow-sm hover:bg-blue-700 disabled:opacity-50"
                :disabled="progressUpdating"
                @click="markComplete"
              >
                Mark as complete
              </button>
              <button
                type="button"
                class="p-2 rounded-lg bg-white text-slate-900 shadow-sm hover:bg-slate-50"
                :aria-label="'Open source URL'"
                @click="openSource"
              >
                <Download class="w-4 h-4" />
              </button>
            </div>
          </div>
        </div>

        <div class="grid gap-6 lg:grid-cols-3">
          <div class="lg:col-span-2 space-y-6">
            <div class="rounded-2xl bg-white p-5 shadow-sm space-y-2">
              <h2 class="text-lg font-semibold text-slate-900">Description</h2>
              <p class="text-slate-700 whitespace-pre-wrap leading-relaxed">{{ resource.summary || '—' }}</p>
            </div>
          </div>

          <div class="space-y-4">
            <div class="rounded-2xl bg-white p-5 shadow-sm space-y-3">
              <h3 class="font-semibold text-slate-900">Source</h3>
              <div class="space-y-2 text-sm text-slate-700">
                <div class="flex items-center gap-2">
                  <LinkIcon class="w-4 h-4 text-slate-500" />
                  <a v-if="resource.source_url" :href="resource.source_url" target="_blank" class="text-blue-600 hover:underline break-all">{{ resource.source_url }}</a>
                  <span v-else>—</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
// --- YouTube iframe 强制播放工具函数 ---
function isYouTubeUrl(url: string | undefined | null): boolean {
  if (!url) return false;
  return /youtube\.com\/watch\?v=|youtu\.be\//.test(url);
}

function toYouTubeEmbed(url: string | undefined | null): string {
  if (!url) return '';
  const match = url.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/)([\w-]+)/);
  return match ? `https://www.youtube.com/embed/${match[1]}` : url;
}
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Calendar, Clock, Download, Link as LinkIcon, Play, UserRound } from 'lucide-vue-next'
import { getMyResourceDetail, getResourceDetail, type DbResourceDetail } from '../api/resource'
import { getMyProgressForItem, upsertMyProgress } from '../api/progress'

const route = useRoute()
const router = useRouter()

const loading = ref(false)
const error = ref('')

const resource = ref<DbResourceDetail>({ id: 0, resource_type: 'video', title: '', category_id: 0 })

const startSeconds = ref(0)

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

declare global {
  interface Window {
    YT?: any
    onYouTubeIframeAPIReady?: () => void
  }
}

const playerEl = ref<HTMLElement | null>(null)
let ytPlayer: any | null = null
const playerFailed = ref(false)

function stopProgressTimer() {
  if (progressTimer != null) {
    window.clearInterval(progressTimer)
    progressTimer = null
  }
}

async function startProgressTimer() {
  stopProgressTimer()
  if (pathItemId.value == null) return

  // Seed from server
  try {
    const row = await getMyProgressForItem(pathItemId.value)
    trackedProgress.value = Number(row?.progress_percentage) || 0
  } catch {
    trackedProgress.value = 0
  }

  lastSentProgress.value = trackedProgress.value

  progressTimer = window.setInterval(async () => {
    const pid = pathItemId.value
    if (pid == null) return
    if (!ytPlayer) return
    if (progressUpdating.value) return

    let duration = 0
    try {
      const d = Number(ytPlayer.getDuration?.())
      duration = Number.isFinite(d) ? d : 0
    } catch {
      duration = 0
    }
    if (!duration) {
      const fallback = Number(resource.value.video?.duration)
      duration = Number.isFinite(fallback) ? fallback : 0
    }
    if (!duration) return

    let current = 0
    try {
      const c = Number(ytPlayer.getCurrentTime?.())
      current = Number.isFinite(c) ? c : 0
    } catch {
      current = 0
    }

    const pct = Math.min(100, Math.max(0, Math.round((current / duration) * 100)))
    if (pct <= lastSentProgress.value) return

    progressUpdating.value = true
    try {
      trackedProgress.value = pct
      lastSentProgress.value = pct
      await upsertMyProgress({ path_item_id: pid, progress_percentage: pct })
    } catch {
      // ignore
    } finally {
      progressUpdating.value = false
    }
  }, 10_000)
}

const resourceIdRaw = computed(() => String(route.params.id || '').trim())

const resourceIdNumber = computed(() => {
  const raw = resourceIdRaw.value
  if (!raw) return null
  // Only treat as DB id when it is purely numeric.
  if (!/^\d+$/.test(raw)) return null
  const n = Number(raw)
  return Number.isFinite(n) ? n : null
})

function extractYouTubeId(url: string): string {
  const raw = String(url || '').trim()
  if (!raw) return ''
  try {
    const u = new URL(raw)
    const host = u.hostname.replace(/^www\./, '')
    if (host === 'youtu.be') {
      return u.pathname.replace(/^\//, '').split('/')[0] || ''
    }
    if (host === 'youtube.com' || host === 'm.youtube.com') {
      const v = u.searchParams.get('v')
      if (v) return v
      const parts = u.pathname.split('/').filter(Boolean)
      // /embed/<id>
      if (parts[0] === 'embed' && parts[1]) return parts[1]
    }
  } catch {
    // ignore
  }
  return ''
}

function formatDate(iso?: string | null) {
  if (!iso) return ''
  const d = new Date(iso)
  if (Number.isNaN(d.getTime())) return ''
  return d.toLocaleDateString()
}

const publishedText = computed(() => formatDate(resource.value.article?.published_at || null))
const addedText = computed(() => formatDate(resource.value.created_at || null))

const videoId = computed(() => {
  const fromDb = String(resource.value.video?.video_id || '').trim()
  if (fromDb) return fromDb
  const fromUrl = extractYouTubeId(String(resource.value.source_url || ''))
  return String(fromUrl || '').trim()
})

const embedUrl = computed(() => {
  const vid = String(videoId.value || '').trim()
  if (vid) {
    const start = Math.max(0, Number(startSeconds.value || 0))
    const qs = start ? `?start=${start}&rel=0` : '?rel=0'
    return `https://www.youtube.com/embed/${encodeURIComponent(vid)}${qs}`
  }
  const raw = String(resource.value.source_url || '').trim()
  return raw || ''
})

function ensureYouTubeApi(): Promise<void> {
  if (window.YT && window.YT.Player) return Promise.resolve()
  return new Promise((resolve, reject) => {
    const timeout = window.setTimeout(() => reject(new Error('YouTube iframe API load timeout')), 6000)
    const existing = document.querySelector('script[data-youtube-iframe-api="1"]') as HTMLScriptElement | null
    if (existing) {
      const prev = window.onYouTubeIframeAPIReady
      window.onYouTubeIframeAPIReady = () => {
        prev?.()
        window.clearTimeout(timeout)
        resolve()
      }
      return
    }

    const script = document.createElement('script')
    script.src = 'https://www.youtube.com/iframe_api'
    script.async = true
    script.setAttribute('data-youtube-iframe-api', '1')
    script.onerror = () => {
      window.clearTimeout(timeout)
      reject(new Error('YouTube iframe API load error'))
    }
    document.head.appendChild(script)
    window.onYouTubeIframeAPIReady = () => {
      window.clearTimeout(timeout)
      resolve()
    }
  })
}

async function initPlayer() {
  if (!playerEl.value) return
  if (!videoId.value) return
  playerFailed.value = false
  try {
    await ensureYouTubeApi()
  } catch {
    playerFailed.value = true
    return
  }
  if (!window.YT?.Player) {
    playerFailed.value = true
    return
  }

  try {
    ytPlayer?.destroy?.()
  } catch {
    // ignore
  }
  try {
    ytPlayer = new window.YT.Player(playerEl.value, {
      videoId: videoId.value,
      playerVars: {
        start: Math.max(0, startSeconds.value || 0),
        rel: 0,
      },
      events: {
        onReady: () => {
          void startProgressTimer()
        },
      },
    })
  } catch {
    playerFailed.value = true
  }
}

async function load() {
  error.value = ''
  loading.value = true
  try {
    const raw = resourceIdRaw.value
    if (!raw) throw new Error('Invalid resource id')

    const dbId = resourceIdNumber.value
    if (dbId == null) throw new Error('Invalid resource id')

    const isMy = String(route.path || '').startsWith('/my-resources')
    const data = isMy ? await getMyResourceDetail(dbId) : await getResourceDetail(dbId)
    resource.value = {
      ...data,
    }
    startSeconds.value = 0
    await initPlayer()
  } catch (e: any) {
    error.value = String(e?.response?.data?.detail || e?.message || 'Failed to load resource')
  } finally {
    loading.value = false
  }
}

function seekTo(seconds: number) {
  startSeconds.value = Math.max(0, Number(seconds) || 0)
  try {
    ytPlayer?.seekTo?.(startSeconds.value, true)
  } catch {
    // ignore
  }
}

function openSource() {
  const url = String(resource.value.source_url || '').trim()
  if (!url) return
  window.open(url, '_blank', 'noopener,noreferrer')
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

function goSaveToPath() {
  if (!resourceIdRaw.value) return
  router.push({ name: 'resource-add-to-path', params: { type: 'video', id: resourceIdRaw.value } })
}

watch(
  () => route.params.id,
  () => {
    load()
  }
)

onMounted(() => {
  load()
  void startProgressTimer()
})

watch(pathItemId, () => {
  void startProgressTimer()
})

onBeforeUnmount(() => {
  stopProgressTimer()
  try {
    ytPlayer?.destroy?.()
  } catch {
    // ignore
  }
  ytPlayer = null
})
</script>
