<template>
  <div class="min-h-screen bg-stone-50">

    <!-- Masthead -->
    <header class="border-b-2 border-stone-900 bg-white">
      <div class="mx-auto max-w-7xl px-4 py-6 md:py-8">
        <div class="flex items-end justify-between">
          <div>
            <div class="flex items-center gap-2 mb-3">
              <span class="h-px w-8 bg-violet-500"></span>
              <span class="text-[10px] font-bold uppercase tracking-[0.25em] text-stone-400">Add</span>
            </div>
            <h1 class="text-4xl md:text-5xl font-black tracking-tight text-stone-900 leading-[0.9]">
              New<br/><span class="text-violet-600">Resource.</span>
            </h1>
          </div>
          <div class="hidden md:flex flex-col items-end gap-1">
            <span class="text-[10px] font-semibold uppercase tracking-widest text-stone-400">URL · File</span>
          </div>
        </div>
      </div>
    </header>

    <main class="mx-auto max-w-7xl px-4 py-8">

      <!-- Mode tabs -->
      <div class="flex gap-1 mb-8 border-b border-stone-200">
        <button
          type="button"
          class="relative px-5 py-3 text-xs font-bold uppercase tracking-widest transition-colors"
          :class="mode === 'url' ? 'text-stone-900' : 'text-stone-400 hover:text-stone-600'"
          @click="setMode('url')"
        >
          From URL
          <span v-if="mode === 'url'" class="absolute bottom-0 left-0 right-0 h-0.5 bg-violet-600"></span>
        </button>
        <button
          type="button"
          class="relative px-5 py-3 text-xs font-bold uppercase tracking-widest transition-colors"
          :class="mode === 'md' ? 'text-stone-900' : 'text-stone-400 hover:text-stone-600'"
          @click="setMode('md')"
        >
          From File
          <span v-if="mode === 'md'" class="absolute bottom-0 left-0 right-0 h-0.5 bg-violet-600"></span>
        </button>
      </div>

      <!-- URL MODE -->
      <div v-if="mode === 'url'" class="grid grid-cols-12 gap-8">

        <!-- Left: form -->
        <div class="col-span-12 lg:col-span-7 space-y-6">
          <!-- Platform + URL input -->
          <div class="bg-white rounded-md border border-stone-100 p-5 space-y-4">
            <div class="flex items-center gap-2 mb-1">
              <div class="w-1 h-5 bg-violet-600 rounded-full"></div>
              <h2 class="text-sm font-bold uppercase tracking-widest text-stone-700">Source</h2>
            </div>

            <!-- Platform selector -->
            <div>
              <label class="block text-[11px] font-bold uppercase tracking-widest text-stone-400 mb-2">Platform</label>
              <div class="grid grid-cols-4 gap-2">
                <button
                  v-for="p in supportedPlatforms"
                  :key="p.key"
                  type="button"
                  class="py-2 px-3 rounded-sm border text-[11px] font-semibold uppercase tracking-wider transition-all"
                  :class="selectedPlatform === p.key
                    ? 'border-violet-600 bg-violet-50 text-violet-700'
                    : 'border-stone-200 bg-white text-stone-500 hover:border-stone-300'"
                  @click="selectedPlatform = p.key"
                >
                  {{ p.label }}
                </button>
              </div>
            </div>

            <!-- URL input -->
            <div>
              <label class="block text-[11px] font-bold uppercase tracking-widest text-stone-400 mb-2">Resource URL</label>
              <div class="relative">
                <input
                  v-model="urlInput"
                  type="url"
                  :placeholder="selectedPlatformPlaceholder"
                  class="w-full h-11 px-4 border border-stone-200 rounded-sm bg-white text-sm text-stone-900 placeholder:text-stone-400 outline-none focus:border-violet-400 focus:ring-2 focus:ring-violet-100 transition-colors"
                />
                <div v-if="extracting" class="absolute right-3 top-1/2 -translate-y-1/2 flex items-center gap-2">
                  <div class="h-3 w-3 rounded-full bg-violet-500 animate-pulse"></div>
                  <span class="text-xs text-stone-400">Parsing…</span>
                </div>
              </div>
              <p v-if="extractError" class="mt-2 text-xs text-red-500">{{ extractError }}</p>
            </div>
          </div>

          <!-- Metadata preview -->
          <div v-if="extractedMeta" class="bg-white rounded-md border border-stone-100 p-5 space-y-4">
            <div class="flex items-center gap-2 mb-1">
              <div class="w-1 h-5 bg-emerald-500 rounded-full"></div>
              <h2 class="text-sm font-bold uppercase tracking-widest text-stone-700">Metadata</h2>
            </div>

            <!-- Thumbnail -->
            <div>
              <label class="block text-[11px] font-bold uppercase tracking-widest text-stone-400 mb-2">Thumbnail</label>
              <div class="relative aspect-video w-full max-w-sm rounded-none overflow-hidden bg-stone-100">
                <img
                  v-if="extractedMeta.thumbnail_url"
                  :src="extractedMeta.thumbnail_url"
                  :alt="extractedMeta.title || 'thumbnail'"
                  class="w-full h-full object-contain"
                  style="object-fit: contain; background-color: #f7f7f7;"
                />
                <div v-else class="absolute inset-0 flex items-center justify-center">
                  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="text-stone-300"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
                </div>
              </div>
            </div>

            <!-- Title -->
            <div>
              <label class="block text-[11px] font-bold uppercase tracking-widest text-stone-400 mb-2">Title</label>
              <p class="text-sm font-semibold text-stone-900">{{ extractedMeta.title || '—' }}</p>
            </div>

            <!-- Author + Date -->
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-[11px] font-bold uppercase tracking-widest text-stone-400 mb-1">Author</label>
                <p class="text-sm text-stone-700">{{ extractedMeta.author || '—' }}</p>
              </div>
              <div>
                <label class="block text-[11px] font-bold uppercase tracking-widest text-stone-400 mb-1">Date</label>
                <p class="text-sm text-stone-700">{{ formatExtractDate(extractedMeta.publish_date) || '—' }}</p>
              </div>
            </div>

            <!-- Description -->
            <div v-if="extractedMeta.description">
              <label class="block text-[11px] font-bold uppercase tracking-widest text-stone-400 mb-2">Description</label>
              <p class="text-sm text-stone-600 leading-relaxed line-clamp-3">{{ extractedMeta.description }}</p>
            </div>
          </div>

          <!-- Options -->
          <div class="bg-white rounded-md border border-stone-100 p-5 space-y-4">
            <div class="flex items-center gap-2 mb-1">
              <div class="w-1 h-5 bg-stone-300 rounded-full"></div>
              <h2 class="text-sm font-bold uppercase tracking-widest text-stone-700">Options</h2>
            </div>

            <div class="grid grid-cols-2 gap-4">
              <!-- Category -->
              <div>
                <label class="block text-[11px] font-bold uppercase tracking-widest text-stone-400 mb-2">Category</label>
                <select
                  v-model="categoryId"
                  class="w-full h-10 px-3 border border-stone-200 rounded-sm bg-white text-sm text-stone-700 outline-none focus:border-violet-400 focus:ring-2 focus:ring-violet-100 cursor-pointer"
                >
                  <option value="">Select category</option>
                  <option v-for="c in dbCategories" :key="c.id" :value="String(c.id)">{{ c.name }}</option>
                </select>
              </div>

              <!-- Visibility -->
              <div>
                <label class="block text-[11px] font-bold uppercase tracking-widest text-stone-400 mb-2">Visibility</label>
                <div class="flex h-10 items-center gap-4">
                  <label class="flex items-center gap-2 cursor-pointer">
                    <input type="radio" v-model="isPublic" :value="true" class="accent-violet-600" />
                    <span class="text-sm text-stone-600">Public</span>
                  </label>
                  <label class="flex items-center gap-2 cursor-pointer">
                    <input type="radio" v-model="isPublic" :value="false" class="accent-violet-600" />
                    <span class="text-sm text-stone-600">Private</span>
                  </label>
                </div>
              </div>
            </div>

            <!-- Weight -->
            <div>
              <label class="block text-[11px] font-bold uppercase tracking-widest text-stone-400 mb-2">Weight</label>
              <div class="flex gap-3 items-center">
                <div class="flex gap-2 flex-wrap">
                  <button
                    v-for="w in weightOptions"
                    :key="w.value"
                    type="button"
                    class="h-8 px-3 rounded-full border text-[11px] font-bold uppercase tracking-wider transition-all"
                    :class="selectedWeight === w.value
                      ? 'border-stone-900 bg-stone-900 text-white'
                      : 'border-stone-200 bg-white text-stone-500 hover:border-stone-400'"
                    @click="selectedWeight = w.value"
                  >
                    {{ w.label }}
                  </button>
                </div>
                <div
                  v-if="selectedWeight"
                  class="ml-auto w-16 h-16 rounded-sm border-2 flex items-center justify-center text-[10px] font-black tracking-widest"
                  :class="weightPreviewClass"
                >
                  <span :class="weightTextClass">{{ selectedWeight.toUpperCase() }}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Submit -->
          <div class="flex justify-end">
            <Button
              type="button"
              class="rounded-full bg-violet-600 text-white hover:bg-violet-700 font-semibold text-sm px-8 py-2.5 transition-all hover:-translate-y-px disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none"
              :disabled="!urlInput || extracting || !extractedMeta?.title || submitting"
              @click="confirmAdd"
            >
              {{ submitting ? 'Saving…' : 'Add resource →' }}
            </Button>
          </div>
          <p v-if="submitError" class="text-sm text-red-500 text-right">{{ submitError }}</p>
        </div>

        <!-- Right: live card preview -->
        <div class="col-span-12 lg:col-span-5">
          <div class="sticky top-24">
            <div class="flex items-center gap-2 mb-3">
              <span class="text-[10px] font-bold uppercase tracking-widest text-stone-400">Live preview</span>
            </div>
            <div
              :class="['w-full rounded-md border-2 overflow-hidden transition-all duration-300', weightPreviewClass]"
            >
              <div class="h-full flex flex-col">
                <!-- Header -->
                <div class="px-4 py-3 border-b flex items-center justify-between bg-stone-50/50">
                  <span
                    class="text-[10px] font-bold uppercase tracking-wider"
                    :style="{ color: '#8b5cf6' }"
                  >
                    {{ selectedPlatformLabel || 'video' }}
                  </span>
                  <span class="text-[10px] text-stone-400 font-mono">#{{ extractedMeta?.video_id?.slice(0, 6) || '------' }}</span>
                </div>
                <!-- Thumbnail -->
                <div class="relative aspect-video bg-stone-100">
                  <img
                    v-if="extractedMeta?.thumbnail_url"
                    :src="extractedMeta.thumbnail_url"
                    :alt="extractedMeta?.title || 'thumbnail'"
                    class="w-full h-full object-contain"
                    style="object-fit: contain; background-color: #f7f7f7;"
                  />
                  <div v-else class="absolute inset-0 flex items-center justify-center">
                    <div class="w-12 h-12 rounded-full flex items-center justify-center text-lg font-black text-white" :style="{ backgroundColor: '#8b5cf6' }">
                      {{ (extractedMeta?.title || 'R').charAt(0) }}
                    </div>
                  </div>
                </div>
                <!-- Title -->
                <div class="px-4 py-3 border-b bg-white">
                  <h3 class="text-sm font-bold text-stone-900 line-clamp-1">{{ extractedMeta?.title || 'Untitled' }}</h3>
                </div>
                <!-- Summary -->
                <div class="px-4 py-3 flex-1 bg-stone-50/30">
                  <p class="text-xs text-stone-500 line-clamp-2">{{ extractedMeta?.description || 'No description' }}</p>
                </div>
                <!-- Footer -->
                <div class="px-4 py-3 border-t bg-stone-50/50 flex items-center justify-between">
                  <span class="text-[11px] text-stone-400">{{ extractedMeta?.author || '—' }}</span>
                  <span class="text-[10px] font-semibold text-stone-500 uppercase tracking-wider">{{ formatExtractDate(extractedMeta?.publish_date) || '—' }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- MD MODE -->
      <div v-else class="space-y-6">
        <div class="bg-white rounded-md border border-stone-100 p-5">
          <div class="flex items-center justify-between mb-4">
            <div class="flex items-center gap-2">
              <div class="w-1 h-5 bg-violet-600 rounded-full"></div>
              <h2 class="text-sm font-bold uppercase tracking-widest text-stone-700">Markdown / Text Files</h2>
            </div>
            <div class="flex items-center gap-2">
              <input
                ref="uploadInputEl"
                type="file"
                class="hidden"
                accept=".md,.txt,text/markdown,text/plain"
                @change="onUploadSelected"
              />
              <button
                type="button"
                class="h-9 px-4 rounded-full border border-stone-200 bg-white text-xs font-semibold text-stone-600 hover:border-stone-400 transition-all"
                :disabled="uploading"
                @click="triggerUpload"
              >
                {{ uploading ? 'Uploading…' : 'Upload file' }}
              </button>
              <Button
                type="button"
                class="rounded-full bg-stone-900 text-white hover:bg-stone-800 font-semibold text-xs px-5"
                @click="goToCreator"
              >
                Editor →
              </Button>
            </div>
          </div>

          <p v-if="uploadError" class="text-sm text-red-500 mb-3">{{ uploadError }}</p>

          <div class="grid grid-cols-12 gap-5">
            <!-- File list -->
            <div class="col-span-12 md:col-span-3">
              <label class="block text-[11px] font-bold uppercase tracking-widest text-stone-400 mb-2">Files</label>
              <div v-if="mdFilesLoading" class="text-xs text-stone-400 py-4">Loading…</div>
              <div v-else-if="mdFiles.length === 0" class="text-xs text-stone-400 py-4">No files yet.</div>
              <div v-else class="space-y-1.5 max-h-64 overflow-y-auto">
                <button
                  v-for="f in mdFiles"
                  :key="f.id"
                  type="button"
                  class="w-full text-left px-3 py-2.5 rounded-sm border transition-all text-xs"
                  :class="selectedMdFile?.id === f.id
                    ? 'border-violet-300 bg-violet-50 border-l-2 border-l-violet-600'
                    : 'border-stone-100 bg-white hover:border-stone-200'"
                  @click="selectMdFile(f)"
                >
                  <p class="font-semibold text-stone-800 truncate">{{ f.title || f.original_filename || 'Untitled' }}</p>
                  <p class="text-[10px] text-stone-400 mt-0.5">{{ f.file_type }}</p>
                </button>
              </div>
            </div>

            <!-- Content preview + URLs -->
            <div class="col-span-12 md:col-span-9">
              <label class="block text-[11px] font-bold uppercase tracking-widest text-stone-400 mb-2">
                Content — {{ mdExtractedUrls.length }} URL(s) found
              </label>
              <div class="rounded-md border border-stone-100 bg-stone-50/50 p-4 max-h-48 overflow-auto mb-4">
                <pre class="text-xs text-stone-600 whitespace-pre-wrap leading-relaxed">{{ mdContentPreview }}</pre>
              </div>
              <p v-if="mdBulkAddSummary" class="text-sm mb-3" :class="mdBulkAddSummary.failed ? 'text-amber-600' : 'text-emerald-600'">
                Added {{ mdBulkAddSummary.success }} of {{ mdBulkAddSummary.total }} URLs.
                <span v-if="mdBulkAddSummary.failed" class="text-red-500">({{ mdBulkAddSummary.failed }} failed)</span>
              </p>
              <p v-if="mdBulkAddError" class="text-sm text-red-500 mb-3">{{ mdBulkAddError }}</p>
              <p v-if="mdExtractedUrls.length > 0" class="text-xs text-stone-400 mb-3">Hover a card to load preview, click "Use" to open in URL mode.</p>
            </div>
          </div>
        </div>

        <!-- URL cards from markdown -->
        <div v-if="mdExtractedUrls.length > 0" class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-3">
          <div
            v-for="u in mdExtractedUrls"
            :key="u"
            class="rounded-md border border-stone-100 bg-white overflow-hidden hover:shadow-md transition-all cursor-pointer group"
            @mouseenter="ensureMdUrlMeta(u)"
            @click="useMdUrl(u)"
          >
            <div class="relative aspect-video bg-stone-100 overflow-hidden">
              <img
                v-if="mdUrlMetaState[u]?.meta?.thumbnail_url"
                :src="mdUrlMetaState[u].meta.thumbnail_url"
                :alt="mdUrlMetaState[u]?.meta?.title || 'thumbnail'"
                class="w-full h-full object-contain transition-transform duration-300 group-hover:scale-105"
                style="object-fit: contain; background-color: #f7f7f7;"
                loading="lazy"
              />
              <div v-else class="absolute inset-0 flex items-center justify-center">
                <span class="text-xs text-stone-400">{{ mdUrlMetaState[u]?.loading ? '…' : 'No preview' }}</span>
              </div>
              <div class="absolute top-2 left-2">
                <span class="text-[9px] font-bold uppercase tracking-wider px-1.5 py-0.5 rounded bg-white/90 backdrop-blur-sm text-stone-600">
                  {{ platformLabelFromUrl(u) }}
                </span>
              </div>
            </div>
            <div class="p-3">
              <p class="text-xs font-semibold text-stone-800 line-clamp-2 leading-snug">{{ mdUrlMetaState[u]?.meta?.title || u }}</p>
              <button
                type="button"
                class="mt-2 text-[10px] font-semibold uppercase tracking-wider text-violet-600 hover:text-violet-700 transition-colors"
                @click.stop="useMdUrl(u)"
              >
                Use URL →
              </button>
            </div>
          </div>
        </div>

        <!-- Bulk add footer -->
        <div class="flex items-center justify-between pt-2">
          <p class="text-xs text-stone-400">
            {{ mdExtractedUrls.length }} URL(s) detected · Select category above before bulk adding
          </p>
          <Button
            type="button"
            class="rounded-full bg-stone-900 text-white hover:bg-stone-800 font-semibold text-xs px-6 py-2.5 transition-all hover:-translate-y-px disabled:opacity-50"
            :disabled="mdExtractedUrls.length === 0 || mdBulkAdding"
            @click="bulkAddMdUrls"
          >
            {{ mdBulkAdding ? 'Adding…' : `Add all ${mdExtractedUrls.length} URLs` }}
          </Button>
        </div>
      </div>

    </main>

    <!-- Success toast -->
    <Transition name="toast">
      <div
        v-if="mdSuccessToastVisible"
        class="fixed bottom-6 left-1/2 -translate-x-1/2 z-100 rounded-full bg-stone-900 text-white px-6 py-3 shadow-2xl flex items-center gap-3"
      >
        <div class="h-5 w-5 rounded-full bg-emerald-500 flex items-center justify-center">
          <svg xmlns="http://www.w3.org/2000/svg" width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
        </div>
        <span class="text-sm font-semibold">{{ mdSuccessToastText }}</span>
        <button class="text-stone-400 hover:text-white ml-1" @click="mdSuccessToastVisible = false">
          <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
        </button>
      </div>
    </Transition>

  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { createMyResourceFromUrl, extractVideoMetadata, type UrlExtractResponse } from '../api/resource'
import { listCategories, type Category } from '../api/category'
import { Button } from '../components/ui/button'
import { listMyUserFiles, uploadMyUserFile, type UserFile } from '../api/userFile'

const route = useRoute()
const router = useRouter()

const mode = computed(() => ((route.query as any)?.mode === 'md' ? 'md' : 'url'))
function setMode(next: 'url' | 'md') {
  const current = (route.query as any) || {}
  router.replace({ query: { ...current, mode: next } })
}

const supportedPlatforms = [
  { key: 'youtube', label: 'YouTube' },
  { key: 'x', label: 'X' },
  { key: 'instagram', label: 'Instagram' },
  { key: 'github', label: 'GitHub' },
  { key: 'medium', label: 'Medium' },
  { key: 'substack', label: 'Substack' },
  { key: 'devto', label: 'Dev.to' },
  { key: 'other', label: 'Other' },
]

const selectedPlatform = ref('youtube')
const selectedPlatformLabel = computed(() => supportedPlatforms.find(p => p.key === selectedPlatform.value)?.label || '')
const selectedPlatformPlaceholder = computed(() => {
  const map: Record<string, string> = {
    youtube: 'https://www.youtube.com/watch?v=...',
    x: 'https://x.com/user/status/id',
    instagram: 'https://www.instagram.com/p/...',
    github: 'https://github.com/...',
    medium: 'https://medium.com/.../...',
    substack: 'https://xxx.substack.com/p/...',
    devto: 'https://dev.to/.../...',
    other: 'Paste a URL',
  }
  return map[selectedPlatform.value] || 'Paste a URL'
})

const urlInput = ref('')
const extracting = ref(false)
const extractError = ref('')
const extractedMeta = ref<UrlExtractResponse | null>(null)
const submitting = ref(false)
const submitError = ref('')
const isPublic = ref(true)

const dbCategories = ref<Category[]>([])
const categoryId = ref('')
const selectedWeight = ref('')

const weightOptions = [
  { value: 'soil', label: 'Soil' },
  { value: 'iron', label: 'Iron' },
  { value: 'bronze', label: 'Bronze' },
  { value: 'silver', label: 'Silver' },
  { value: 'gold', label: 'Gold' },
]

const weightPreviewClass = computed(() => {
  const w = selectedWeight.value
  if (w === 'soil') return 'border-stone-200 bg-stone-50'
  if (w === 'iron') return 'border-slate-300 bg-slate-50'
  if (w === 'bronze') return 'border-amber-300 bg-amber-50'
  if (w === 'silver') return 'border-zinc-200 bg-zinc-50'
  if (w === 'gold') return 'border-yellow-300 bg-yellow-50'
  return 'border-stone-200 bg-white'
})

const weightTextClass = computed(() => {
  const w = selectedWeight.value
  if (w === 'gold') return 'text-amber-600'
  if (w === 'silver') return 'text-zinc-500'
  if (w === 'bronze') return 'text-amber-700'
  if (w === 'iron') return 'text-slate-500'
  return 'text-stone-500'
})

function toManualWeight(w: string): number {
  if (w === 'gold') return 5
  if (w === 'silver') return 4
  if (w === 'bronze') return 3
  if (w === 'iron') return 2
  return 1
}

function getErrorMessage(e: any, fallback: string) {
  const detail = e?.response?.data?.detail
  if (typeof detail === 'string' && detail.trim()) return detail
  if (Array.isArray(detail) && detail.length > 0) {
    const first = detail[0]
    return (first && (first.msg || first.message)) ? String(first.msg || first.message) : ''
  }
  return e?.message || fallback
}

function formatExtractDate(iso?: string | null) {
  if (!iso) return ''
  const d = new Date(iso)
  if (Number.isNaN(d.getTime())) return ''
  return d.toLocaleDateString()
}

function detectPlatformFromUrl(url: string) {
  const u = String(url || '').toLowerCase()
  if (u.includes('youtube.com') || u.includes('youtu.be')) return 'youtube'
  if (u.includes('instagram.com')) return 'instagram'
  if (u.includes('x.com') || u.includes('twitter.com')) return 'x'
  if (u.includes('github.com')) return 'github'
  if (u.includes('medium.com')) return 'medium'
  if (u.includes('substack.com')) return 'substack'
  if (u.includes('dev.to')) return 'devto'
  return ''
}

async function loadCategories() {
  try {
    dbCategories.value = await listCategories()
    const other = dbCategories.value.find(c => String(c.code).toLowerCase() === 'other')
    if (other && !categoryId.value) categoryId.value = String(other.id)
  } catch { dbCategories.value = [] }
}

async function confirmAdd() {
  if (!urlInput.value || !extractedMeta.value?.title) return
  submitError.value = ''
  submitting.value = true
  try {
    const catId = categoryId.value ? Number(categoryId.value) : NaN
    if (!Number.isFinite(catId)) throw new Error('请选择分类')
    const manualWeight = toManualWeight(selectedWeight.value)
    await createMyResourceFromUrl(urlInput.value, { category_id: catId, is_public: isPublic.value, manual_weight: manualWeight })
    router.push({ name: 'my-resources' })
  } catch (e: any) {
    submitError.value = getErrorMessage(e, 'Failed to add resource')
  } finally {
    submitting.value = false
  }
}

let extractTimer: ReturnType<typeof setTimeout> | null = null
watch(urlInput, (nextUrl) => {
  extractError.value = ''
  extractedMeta.value = null
  if (extractTimer) { clearTimeout(extractTimer); extractTimer = null }
  const raw = String(nextUrl || '').trim()
  if (!raw) { extracting.value = false; return }
  extracting.value = true
  extractTimer = setTimeout(() => {
    extractVideoMetadata(raw)
      .then((res) => { extractedMeta.value = res; extracting.value = false })
      .catch((err) => {
        extractError.value = selectedPlatform.value === 'other' ? 'Not supported yet.' : getErrorMessage(err, '解析失败')
        extracting.value = false
      })
  }, 1200)
}, { immediate: false })

// Markdown mode
const mdFilesLoading = ref(false)
const mdFilesError = ref('')
const mdFiles = ref<UserFile[]>([])
const selectedMdFile = ref<UserFile | null>(null)
const mdSelectedContent = ref('')
type MdUrlMetaState = { loading: boolean; error: string; meta: UrlExtractResponse | null }
const mdUrlMetaState = ref<Record<string, MdUrlMetaState>>({})
const mdBulkAdding = ref(false)
const mdBulkAddError = ref('')
const mdBulkAddSummary = ref<{ total: number; success: number; failed: number } | null>(null)
const mdSuccessToastVisible = ref(false)
const mdSuccessToastText = ref('')
let mdSuccessToastTimer: ReturnType<typeof setTimeout> | null = null
const uploadInputEl = ref<HTMLInputElement | null>(null)
const uploading = ref(false)
const uploadError = ref('')

function showMdSuccessToast(text: string) {
  mdSuccessToastText.value = text
  mdSuccessToastVisible.value = true
  if (mdSuccessToastTimer) clearTimeout(mdSuccessToastTimer)
  mdSuccessToastTimer = setTimeout(() => { mdSuccessToastVisible.value = false }, 2200)
}

function extractUrls(text: string) {
  const matches = String(text || '').match(/https?:\/\/[^\s)\]>]+/g) || []
  return Array.from(new Set(matches.map(u => u.replace(/[),.;\]]+$/, '').trim()).filter(Boolean)))
}

function guessUrlKind(url: string) {
  const u = String(url || '').toLowerCase()
  if (u.includes('youtube.com') || u.includes('youtu.be') || u.includes('bilibili.com')) return 'video'
  if (u.endsWith('.pdf') || u.includes('github.com')) return 'document'
  return 'link'
}

function platformLabelFromUrl(url: string) {
  const key = detectPlatformFromUrl(url) || 'other'
  return supportedPlatforms.find(p => p.key === key)?.label || key
}

function ensureMdUrlMeta(url: string) {
  const current = mdUrlMetaState.value[url]
  if (current?.loading || current?.meta) return
  mdUrlMetaState.value = { ...mdUrlMetaState.value, [url]: { loading: true, error: '', meta: null } }
  extractVideoMetadata(url)
    .then((res) => { mdUrlMetaState.value = { ...mdUrlMetaState.value, [url]: { loading: false, error: '', meta: res } } })
    .catch((err) => { mdUrlMetaState.value = { ...mdUrlMetaState.value, [url]: { loading: false, error: getErrorMessage(err, '解析失败'), meta: null } } })
}

const mdExtractedUrls = computed(() => extractUrls(mdSelectedContent.value))
const mdContentPreview = computed(() => {
  if (!selectedMdFile.value) return 'Select a file to preview content and extract URLs.'
  const raw = String(mdSelectedContent.value || '')
  if (mdExtractedUrls.value.length === 0) return raw || 'No valid URLs found.'
  return raw || 'Select a file.'
})

async function loadMdFiles() {
  mdFilesError.value = ''
  mdFilesLoading.value = true
  try {
    const files = await listMyUserFiles()
    mdFiles.value = files.filter((f) => {
      const ft = String((f as any)?.file_type || '').toLowerCase()
      if (ft === 'md' || ft === 'txt' || ft === 'markdown' || ft === 'text') return true
      const ct = String((f as any)?.content_type || '').toLowerCase()
      if (ct === 'text/markdown' || ct === 'text/x-markdown' || ct === 'text/plain') return true
      const name = String((f as any)?.original_filename || (f as any)?.title || '').toLowerCase()
      return name.endsWith('.md') || name.endsWith('.txt')
    })
  } catch (e: any) { mdFilesError.value = e?.message || 'Failed to load'; mdFiles.value = [] }
  finally { mdFilesLoading.value = false }
}

function selectMdFile(file: UserFile) {
  selectedMdFile.value = file
  mdSelectedContent.value = String(file.content || '')
}

function triggerUpload() {
  uploadError.value = ''
  const el = uploadInputEl.value
  if (!el) return
  el.value = ''
  el.click()
}

async function onUploadSelected(e: Event) {
  uploadError.value = ''
  const input = e.target as HTMLInputElement | null
  const file = input?.files?.[0]
  if (!file) return
  const name = String(file.name || '').toLowerCase()
  if (!(name.endsWith('.md') || name.endsWith('.txt'))) { uploadError.value = 'Only .md and .txt supported'; return }
  uploading.value = true
  try {
    const created = await uploadMyUserFile({ file })
    await loadMdFiles()
    const found = mdFiles.value.find((f) => f.id === created.id)
    if (found) selectMdFile(found)
  } catch (err: any) { uploadError.value = getErrorMessage(err, 'Upload failed') }
  finally { uploading.value = false }
}

function useMdUrl(url: string) {
  urlInput.value = url
  const detected = detectPlatformFromUrl(url)
  if (detected) selectedPlatform.value = detected
  setMode('url')
}

function normalizeUrlForDedupe(url: string) {
  const raw = String(url || '').trim()
  if (!raw) return ''
  try {
    const u = new URL(raw)
    u.hash = ''
    if (u.pathname !== '/' && u.pathname.endsWith('/')) u.pathname = u.pathname.replace(/\/+$/, '')
    u.hostname = u.hostname.toLowerCase()
    return u.toString()
  } catch { return raw }
}

async function bulkAddMdUrls() {
  mdBulkAddError.value = ''
  mdBulkAddSummary.value = null
  const urls = Array.from(new Set(mdExtractedUrls.value.map(normalizeUrlForDedupe))).filter(Boolean)
  if (urls.length === 0) return
  const catId = categoryId.value ? Number(categoryId.value) : NaN
  if (!Number.isFinite(catId)) { mdBulkAddError.value = '请选择分类'; return }
  mdBulkAdding.value = true
  let success = 0, failed = 0
  for (const u of urls) {
    try {
      await createMyResourceFromUrl(u, { category_id: catId, is_public: isPublic.value, manual_weight: toManualWeight(selectedWeight.value) })
      success += 1
    } catch { failed += 1 }
  }
  mdBulkAddSummary.value = { total: urls.length, success, failed }
  if (success > 0) showMdSuccessToast(failed === 0 ? `Added ${success} resources.` : `Added ${success}/${urls.length} resources.`)
  mdBulkAdding.value = false
}

function goToCreator() { router.push({ name: 'creator' }) }

function applyPrefillFromRoute() {
  const q = (route.query as any)?.url
  const next = Array.isArray(q) ? String(q[0] || '').trim() : String(q || '').trim()
  if (!next) return
  urlInput.value = next
  const detected = detectPlatformFromUrl(next)
  if (detected) selectedPlatform.value = detected
}

onMounted(() => {
  void loadCategories()
  applyPrefillFromRoute()
  if (mode.value === 'md') void loadMdFiles()
})

watch(() => mode.value, (nextMode) => { if (nextMode === 'md') void loadMdFiles() })
</script>

<style scoped>
.toast-enter-active, .toast-leave-active { transition: opacity 300ms ease, transform 300ms ease; }
.toast-enter-from, .toast-leave-to { opacity: 0; transform: translate(-50%, 12px); }
</style>
