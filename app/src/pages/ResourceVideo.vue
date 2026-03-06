<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Video</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">Watch and track your progress.</p>
        </div>
      </div>
    </section>

    <div v-if="loading">
      <Card :hoverable="false" padded>
        <div class="text-sm text-muted-foreground">Loading…</div>
      </Card>
    </div>

    <div v-else-if="error">
      <Card :hoverable="false" padded>
        <div class="text-sm text-destructive">{{ error }}</div>
      </Card>
    </div>

    <template v-else>
      <div class="space-y-6">
        <Card :hoverable="false" className="bg-black overflow-hidden" >
            <div class="relative w-full aspect-video">
              <div
                v-if="isYouTubeUrl(resource.source_url) && !playerFailed"
                ref="playerEl"
                class="absolute inset-0 h-full w-full"
              />
              <iframe
                v-else-if="embedUrl"
                :src="embedUrl"
                class="absolute inset-0 h-full w-full"
                title="Video preview"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                allowfullscreen
              />
              <div v-else class="absolute inset-0 flex items-center justify-center text-white/80">
                Video preview is unavailable
              </div>
            </div>
        </Card>

        <div class="space-y-3">
          <h2 class="text-xl sm:text-2xl font-semibold text-foreground">{{ resource.title }}</h2>

          <div v-if="pathItemId != null" class="rounded-md border border-border bg-muted/30 p-4">
            <div class="flex items-center justify-between text-sm mb-2">
              <span class="text-muted-foreground">Learning Progress</span>
              <div class="flex items-center gap-2">
                <input
                  type="number"
                  v-model.number="manualProgress"
                  min="0"
                  max="100"
                  class="w-16 h-8 px-2 text-sm border border-border rounded bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-ring"
                  @keyup.enter="updateManualProgress"
                />
                <span class="font-semibold text-foreground">%</span>
                <Button
                  type="button"
                  size="sm"
                  variant="outline"
                  class="h-8 px-3"
                  :disabled="progressUpdating || manualProgress === trackedProgress"
                  @click="updateManualProgress"
                >
                  Update
                </Button>
              </div>
            </div>
            <div class="relative">
              <input
                type="range"
                v-model.number="manualProgress"
                min="0"
                max="100"
                class="w-full h-2 bg-muted rounded-lg appearance-none cursor-pointer"
                style="accent-color: hsl(var(--foreground))"
              />
              <div class="mt-1 flex justify-between text-xs text-muted-foreground">
                <span>0%</span>
                <span class="text-foreground font-medium">{{ trackedProgress }}% saved</span>
                <span>100%</span>
              </div>
            </div>
          </div>

          <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
            <div class="flex flex-wrap items-center gap-2 text-sm text-muted-foreground">
              <span class="inline-flex items-center gap-2 rounded-md border border-border bg-muted/30 px-3 py-1">
                <UserRound class="h-4 w-4" />
                {{ resource.video?.channel || 'Unknown author' }}
              </span>
              <span v-if="publishedText" class="inline-flex items-center gap-2 rounded-md border border-border bg-muted/30 px-3 py-1">
                <Calendar class="h-4 w-4" />
                {{ publishedText }}
              </span>
              <span v-if="addedText" class="inline-flex items-center gap-2 rounded-md border border-border bg-muted/30 px-3 py-1">
                <Clock class="h-4 w-4" />
                Added {{ addedText }}
              </span>
            </div>

            <div class="flex items-center gap-2">
              <Button type="button" variant="outline" size="sm" class="rounded-md" @click="goSaveToPath">
                Save to path
              </Button>
              <Button
                v-if="openOnYouTubeUrl"
                type="button"
                variant="outline"
                size="sm"
                class="rounded-md"
                @click="openOnYouTube"
              >
                Open on YouTube
              </Button>
              <Button
                v-if="pathItemId != null"
                type="button"
                size="sm"
                class="rounded-md"
                :disabled="progressUpdating"
                @click="markComplete"
              >
                Mark as complete
              </Button>
              <Button type="button" variant="outline" size="icon" class="rounded-md" :aria-label="'Open source URL'" @click="openSource">
                <Download class="w-4 h-4" />
              </Button>
            </div>
          </div>
        </div>

        <div class="grid gap-6 lg:grid-cols-3">
          <div class="lg:col-span-2 space-y-6">
            <Card :hoverable="false" padded>
              <h3 class="text-lg font-semibold text-foreground">Description</h3>
              <p class="mt-2 text-sm text-muted-foreground whitespace-pre-wrap leading-relaxed">{{ resource.summary || '—' }}</p>
            </Card>
          </div>

          <div class="space-y-4">
            <Card :hoverable="false" padded>
              <h3 class="font-semibold text-foreground">Source</h3>
              <div class="mt-2 space-y-2 text-sm text-muted-foreground">
                <div class="flex items-center gap-2">
                  <LinkIcon class="w-4 h-4 text-muted-foreground" />
                  <a v-if="resource.source_url" :href="resource.source_url" target="_blank" class="text-foreground underline underline-offset-4 break-all">{{ resource.source_url }}</a>
                  <span v-else>—</span>
                </div>
              </div>
            </Card>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
// --- YouTube iframe 强制播放工具函数 ---
function isYouTubeUrl(url: string | undefined | null): boolean {
  if (!url) return false;
  return /youtube\.com\/watch\?v=|youtu\.be\//.test(url) || /youtube\.com\/shorts\//.test(url) || /youtube-nocookie\.com\/embed\//.test(url);
}

function toYouTubeEmbed(url: string | undefined | null): string {
  if (!url) return '';
  const match = url.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/shorts\/)([\w-]+)/);
  return match ? `https://www.youtube.com/embed/${match[1]}` : url;
}
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Calendar, Clock, Download, Link as LinkIcon, Play, UserRound } from 'lucide-vue-next'
import { getMyResourceDetail, getResourceDetail, type DbResourceDetail } from '../api/resource'
import { getMyProgressForItem, upsertMyProgress } from '../api/progress'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'

const route = useRoute()
const router = useRouter()

const loading = ref(false)
const error = ref('')

const resource = ref<DbResourceDetail>({} as DbResourceDetail)

const startSeconds = ref(0)

const pathItemId = computed(() => {
  const raw = String((route.query as any)?.path_item_id || '').trim()
  if (!raw) return null
  if (!/^\d+$/.test(raw)) return null
  const n = Number(raw)
  return Number.isFinite(n) ? n : null
})

const trackedProgress = ref(0)
const manualProgress = ref(0)
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

async function seedProgressFromServer() {
  if (pathItemId.value == null) return
  try {
    const row = await getMyProgressForItem(pathItemId.value)
    trackedProgress.value = Number(row?.progress_percentage) || 0
    manualProgress.value = trackedProgress.value
  } catch {
    trackedProgress.value = 0
    manualProgress.value = 0
  }
  lastSentProgress.value = trackedProgress.value

  // If we are in iframe fallback mode, try to compute a start time so playback resumes near progress.
  if (!ytPlayer && isYouTubeUrl(resource.value.source_url)) {
    maybeSetStartFromProgressForIframe()
  }
}

function maybeSetStartFromProgressForIframe() {
  if (pathItemId.value == null) return
  if (!isYouTubeUrl(resource.value.source_url)) return

  const pct = Math.min(99, Math.max(0, Math.round(Number(trackedProgress.value) || 0)))
  if (!pct) return

  const duration = Number(resource.value.video?.duration)
  if (!Number.isFinite(duration) || duration <= 0) return

  // For iframe mode, we can't seek after load reliably, so we set startSeconds before embedUrl is used.
  startSeconds.value = Math.max(0, Math.floor((duration * pct) / 100))
}

function maybeSeekFromProgress() {
  if (pathItemId.value == null) return
  if (!ytPlayer) return

  const pct = Math.min(99, Math.max(0, Math.round(Number(trackedProgress.value) || 0)))
  if (!pct) return

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

  const target = Math.max(0, Math.floor((duration * pct) / 100))
  seekTo(target)
}

async function startProgressTimer() {
  stopProgressTimer()
  if (pathItemId.value == null) return

  // Seed once per entry (and allow auto-seek when player is ready)
  await seedProgressFromServer()

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
      manualProgress.value = pct
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
      // /shorts/<id>
      if (parts[0] === 'shorts' && parts[1]) return parts[1]
    }
    if (host === 'youtube-nocookie.com') {
      const parts = u.pathname.split('/').filter(Boolean)
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
  const rawUrl = String(resource.value.source_url || '').trim()
  const start = Math.max(0, Number(startSeconds.value || 0))

  const origin = (() => {
    try {
      return typeof window !== 'undefined' ? window.location.origin : ''
    } catch {
      return ''
    }
  })()

  // Prefer a proper YouTube embed URL (even if videoId parsing fails).
  if (isYouTubeUrl(rawUrl)) {
    const vid = String(videoId.value || '').trim()
    if (vid) {
      const qs = new URLSearchParams()
      qs.set('rel', '0')
      if (start) qs.set('start', String(start))
      if (origin) qs.set('origin', origin)
      return `https://www.youtube.com/embed/${encodeURIComponent(vid)}?${qs.toString()}`
    }
    const base = toYouTubeEmbed(rawUrl)
    if (!base) return ''
    const qs = new URLSearchParams()
    if (start) qs.set('start', String(start))
    if (origin) qs.set('origin', origin)
    return qs.toString() ? `${base}${base.includes('?') ? '&' : '?'}${qs.toString()}` : base
  }

  return rawUrl || ''
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
  if (!playerEl.value) {
    playerFailed.value = true
    return
  }
  if (!videoId.value) {
    // No usable videoId: fallback to iframe (embedUrl still works).
    playerFailed.value = true
    return
  }
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
        onReady: async () => {
          await seedProgressFromServer()
          maybeSeekFromProgress()
          void startProgressTimer()
        },
      },
    })
  } catch {
    playerFailed.value = true
  }

  // If player still isn't created, fallback.
  if (!ytPlayer) {
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
    // Reset so the YT mount element can render; initPlayer will set it back to true on failure.
    if (isYouTubeUrl(resource.value.source_url)) {
      playerFailed.value = false
    }
    // Ensure the player mount element exists before initializing the YT player.
    await nextTick()
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

const openOnYouTubeUrl = computed(() => {
  const vid = String(videoId.value || '').trim()
  if (!vid) return ''
  return `https://www.youtube.com/watch?v=${encodeURIComponent(vid)}`
})

function openOnYouTube() {
  const url = String(openOnYouTubeUrl.value || '').trim()
  if (!url) return
  window.open(url, '_blank', 'noopener,noreferrer')
}

async function updateManualProgress() {
  const pid = pathItemId.value
  if (pid == null) return
  if (progressUpdating.value) return
  
  // Validate and clamp progress value
  let pct = Math.round(Number(manualProgress.value) || 0)
  pct = Math.max(0, Math.min(100, pct))
  manualProgress.value = pct
  
  if (pct === trackedProgress.value) return
  
  progressUpdating.value = true
  try {
    trackedProgress.value = pct
    lastSentProgress.value = pct
    await upsertMyProgress({ path_item_id: pid, progress_percentage: pct })
  } catch (e) {
    console.error('Failed to update progress:', e)
    // Revert on error
    manualProgress.value = trackedProgress.value
  } finally {
    progressUpdating.value = false
  }
}

async function markComplete() {
  const pid = pathItemId.value
  if (pid == null) return
  if (progressUpdating.value) return
  progressUpdating.value = true
  try {
    trackedProgress.value = 100
    manualProgress.value = 100
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
})

watch(pathItemId, () => {
  void seedProgressFromServer()
  maybeSeekFromProgress()
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
