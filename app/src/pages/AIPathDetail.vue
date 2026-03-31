<template>
  <div class="min-h-screen bg-stone-50">
    <header class="border-b border-stone-200 bg-white">
      <div class="mx-auto max-w-7xl px-4 py-8 md:py-10">
        <div class="flex flex-col gap-6 md:flex-row md:items-end md:justify-between">
          <div>
            <div class="mb-3 flex items-center gap-2">
              <span class="h-px w-8 bg-sky-500"></span>
              <span class="text-[10px] font-bold uppercase tracking-[0.25em] text-stone-400">AI Result</span>
            </div>
            <h1 class="text-3xl font-black leading-[0.92] tracking-tight text-stone-900 md:text-5xl">
              {{ result?.data.title || 'AI Path Detail' }}
            </h1>
            <p v-if="result?.data.summary" class="mt-4 max-w-3xl text-sm leading-7 text-stone-500 md:text-base">
              {{ result.data.summary }}
            </p>
          </div>
          <div class="flex flex-wrap items-center gap-3">
            <RouterLink
              :to="{ name: 'ai-path' }"
              class="inline-flex h-10 items-center justify-center rounded-full border border-stone-200 bg-white px-5 text-sm font-semibold text-stone-600 transition-colors hover:border-stone-400 hover:text-stone-900"
            >
              Back to AI Path
            </RouterLink>
            <Button
              type="button"
              class="rounded-full bg-sky-600 px-6 text-white hover:bg-sky-700"
              @click="copySummary"
              :disabled="!result"
            >
              Copy summary
            </Button>
          </div>
        </div>
      </div>
    </header>

    <main class="mx-auto max-w-7xl px-4 py-8">
      <div v-if="!result" class="rounded-3xl border border-dashed border-stone-300 bg-white px-6 py-20 text-center">
        <div class="mx-auto max-w-xl">
          <h2 class="text-2xl font-black tracking-tight text-stone-900">还没有 AI Path 结果</h2>
          <p class="mt-3 text-sm leading-7 text-stone-500">
            先去 AI Path 页面输入你的学习目标，生成结果后会自动跳转到这里。
          </p>
          <RouterLink
            :to="{ name: 'ai-path' }"
            class="mt-6 inline-flex h-11 items-center justify-center rounded-full bg-sky-600 px-6 text-sm font-semibold text-white transition-colors hover:bg-sky-700"
          >
            Go generate
          </RouterLink>
        </div>
      </div>

      <template v-else>
        <section v-if="result.warnings?.length" class="mb-6 rounded-2xl border border-amber-200 bg-amber-50 p-5">
          <p class="text-[10px] font-bold uppercase tracking-[0.25em] text-amber-600">Warnings</p>
          <ul class="mt-3 space-y-2">
            <li v-for="warning in result.warnings" :key="warning" class="text-sm leading-6 text-amber-800">
              {{ warning }}
            </li>
          </ul>
        </section>

        <section class="mb-8 grid grid-cols-1 gap-4 md:grid-cols-3">
          <article class="rounded-2xl border border-stone-200 bg-white p-5 shadow-sm">
            <p class="text-[10px] font-bold uppercase tracking-[0.25em] text-stone-400">Stages</p>
            <p class="mt-3 text-3xl font-black tracking-tight text-stone-900">{{ result.data.nodes.length }}</p>
          </article>
          <article class="rounded-2xl border border-stone-200 bg-white p-5 shadow-sm">
            <p class="text-[10px] font-bold uppercase tracking-[0.25em] text-stone-400">Resources</p>
            <p class="mt-3 text-3xl font-black tracking-tight text-stone-900">{{ totalResources }}</p>
          </article>
          <article class="rounded-2xl border border-stone-200 bg-white p-5 shadow-sm">
            <p class="text-[10px] font-bold uppercase tracking-[0.25em] text-stone-400">Sub topics</p>
            <p class="mt-3 text-3xl font-black tracking-tight text-stone-900">{{ totalSubNodes }}</p>
          </article>
        </section>

        <section class="space-y-8">
          <article
            v-for="(node, idx) in result.data.nodes"
            :key="`${idx}-${node.title}`"
            class="overflow-hidden rounded-3xl border border-stone-200 bg-white shadow-sm"
          >
            <div class="border-b border-stone-100 bg-stone-50 px-6 py-5 md:px-8">
              <div class="flex flex-col gap-4 md:flex-row md:items-start md:justify-between">
                <div class="max-w-3xl">
                  <div class="flex items-center gap-3">
                    <span class="inline-flex h-8 min-w-8 items-center justify-center rounded-full bg-sky-100 px-3 text-xs font-black text-sky-700">
                      {{ idx + 1 }}
                    </span>
                    <span class="text-[10px] font-bold uppercase tracking-[0.25em] text-stone-400">Stage</span>
                  </div>
                  <h2 class="mt-3 text-2xl font-black tracking-tight text-stone-900">{{ node.title }}</h2>
                  <p class="mt-3 text-sm leading-7 text-stone-600">{{ node.description }}</p>
                </div>
                <div class="rounded-2xl border border-stone-200 bg-white px-4 py-3 text-xs text-stone-400">
                  {{ collectNodeResources(node).length }} resources
                </div>
              </div>
            </div>

            <div class="px-6 py-6 md:px-8">
              <div class="grid grid-cols-1 gap-6 lg:grid-cols-12">
                <div class="lg:col-span-7 space-y-6">
                  <section v-if="node.explanation" class="rounded-2xl border border-stone-200 bg-stone-50 p-5">
                    <p class="text-[10px] font-bold uppercase tracking-[0.25em] text-stone-400">Explanation</p>
                    <p class="mt-3 text-sm leading-7 text-stone-600">{{ node.explanation }}</p>
                  </section>

                  <section v-if="node.tutorial?.length" class="rounded-2xl border border-stone-200 bg-white p-5">
                    <p class="text-[10px] font-bold uppercase tracking-[0.25em] text-stone-400">Tutorial</p>
                    <ol class="mt-3 space-y-3">
                      <li v-for="(step, stepIdx) in node.tutorial" :key="`${node.title}-${stepIdx}`" class="flex gap-3 text-sm leading-7 text-stone-600">
                        <span class="mt-1 inline-flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-stone-900 text-[10px] font-black text-white">{{ stepIdx + 1 }}</span>
                        <span>{{ step }}</span>
                      </li>
                    </ol>
                  </section>

                  <section v-if="node.sub_nodes?.length" class="rounded-2xl border border-stone-200 bg-white p-5">
                    <p class="text-[10px] font-bold uppercase tracking-[0.25em] text-stone-400">Sub Topics</p>
                    <div class="mt-4 space-y-4">
                      <div
                        v-for="(subNode, subIdx) in node.sub_nodes"
                        :key="`${node.title}-${subIdx}-${subNode.title}`"
                        class="rounded-2xl border border-stone-100 bg-stone-50 p-4"
                      >
                        <div class="flex items-start justify-between gap-3">
                          <h3 class="text-base font-bold text-stone-900">{{ subNode.title }}</h3>
                          <span class="text-[10px] font-semibold uppercase tracking-wider text-stone-400">{{ (subNode.resources || []).length }} links</span>
                        </div>
                        <p class="mt-2 text-sm leading-7 text-stone-600">{{ subNode.description }}</p>
                        <div v-if="subNode.resources?.length" class="mt-4 grid grid-cols-1 gap-3 xl:grid-cols-2">
                          <a
                            v-for="resource in subNode.resources"
                            :key="`${subNode.title}-${resource.url}`"
                            :href="resource.url"
                            target="_blank"
                            rel="noreferrer"
                            class="group block h-full overflow-hidden rounded-xl border border-stone-100 bg-white transition-all duration-200 hover:border-stone-200 hover:shadow-md"
                          >
                            <div class="relative h-36 bg-stone-100 bg-cover bg-center transition-transform duration-500 group-hover:scale-105" :style="{ backgroundImage: `url(${resourceThumbnail(resource.url)})` }">
                              <div class="absolute left-2 top-2">
                                <span class="inline-flex items-center rounded-full bg-white/90 px-2 py-0.5 text-[9px] font-bold uppercase tracking-wider text-stone-600">
                                  {{ resourceTypeLabel(resource.url) }}
                                </span>
                              </div>
                            </div>
                            <div class="flex h-[calc(100%-9rem)] flex-col p-3.5">
                              <span class="mb-1.5 text-[10px] font-semibold uppercase tracking-wider" :style="{ color: getCategoryColor(resourceHost(resource.url)) }">
                                {{ resourceHost(resource.url) }}
                              </span>
                              <h4 class="line-clamp-2 text-sm font-semibold leading-snug text-stone-800 transition-colors group-hover:text-amber-700">
                                {{ resourceTitle(resource.url) }}
                              </h4>
                              <p class="mt-1 line-clamp-2 flex-1 text-xs text-stone-400">{{ resource.url }}</p>
                              <div class="mt-3 border-t border-stone-50 pt-2 text-[10px] text-stone-400">Open resource</div>
                            </div>
                          </a>
                        </div>
                      </div>
                    </div>
                  </section>
                </div>

                <div class="lg:col-span-5 space-y-4">
                  <section v-if="collectNodeResources(node).length" class="rounded-2xl border border-stone-200 bg-white p-5">
                    <p class="text-[10px] font-bold uppercase tracking-[0.25em] text-stone-400">Recommended Resources</p>
                    <div class="mt-4 grid grid-cols-1 gap-4">
                      <a
                        v-for="resource in collectNodeResources(node)"
                        :key="`${node.title}-${resource.url}`"
                        :href="resource.url"
                        target="_blank"
                        rel="noreferrer"
                        class="group block h-full overflow-hidden rounded-xl border border-stone-100 bg-white transition-all duration-200 hover:border-stone-200 hover:shadow-md"
                      >
                        <div class="relative h-48 bg-stone-100 bg-cover bg-center transition-transform duration-500 group-hover:scale-105" :style="{ backgroundImage: `url(${resourceThumbnail(resource.url)})` }">
                          <div class="absolute left-2 top-2">
                            <span class="inline-flex items-center rounded-full bg-white/90 px-2 py-0.5 text-[9px] font-bold uppercase tracking-wider text-stone-600">
                              {{ resourceTypeLabel(resource.url) }}
                            </span>
                          </div>
                        </div>
                        <div class="flex flex-col p-3.5">
                          <span class="mb-1.5 text-[10px] font-semibold uppercase tracking-wider" :style="{ color: getCategoryColor(resourceHost(resource.url)) }">
                            {{ resourceHost(resource.url) }}
                          </span>
                          <h3 class="line-clamp-2 text-sm font-semibold leading-snug text-stone-800 transition-colors group-hover:text-amber-700">
                            {{ resourceTitle(resource.url) }}
                          </h3>
                          <p class="mt-1 line-clamp-2 text-xs text-stone-400">{{ resource.url }}</p>
                        </div>
                      </a>
                    </div>
                  </section>
                </div>
              </div>
            </div>
          </article>
        </section>
      </template>
    </main>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { RouterLink } from 'vue-router'
import { Button } from '../components/ui/button'
import type { AiPathGenerateResponse, AiPathNode, AiPathResourceLink } from '../api/aiPath'

const STORAGE_KEY = 'learnsmart_ai_path_result_v1'
const fallbackThumb = 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&h=400&fit=crop'

const result = ref<AiPathGenerateResponse | null>(readResult())

const totalSubNodes = computed(() => result.value?.data.nodes.reduce((sum, node) => sum + (node.sub_nodes?.length || 0), 0) || 0)
const totalResources = computed(() => result.value?.data.nodes.reduce((sum, node) => sum + collectNodeResources(node).length + (node.sub_nodes || []).reduce((subSum, subNode) => subSum + (subNode.resources?.length || 0), 0), 0) || 0)

function readResult(): AiPathGenerateResponse | null {
  try {
    const raw = window.sessionStorage.getItem(STORAGE_KEY)
    return raw ? JSON.parse(raw) as AiPathGenerateResponse : null
  } catch {
    return null
  }
}

function collectNodeResources(node: AiPathNode): AiPathResourceLink[] {
  const seen = new Set<string>()
  const links: AiPathResourceLink[] = []
  for (const item of node.resources || []) {
    const url = String(item?.url || '').trim()
    if (!url || seen.has(url)) continue
    seen.add(url)
    links.push({ url })
  }
  return links
}

function resourceHost(url: string) {
  try {
    const host = new URL(url).hostname.replace(/^www\./, '')
    return host || 'resource'
  } catch {
    return 'resource'
  }
}

function resourceTitle(url: string) {
  try {
    const parsed = new URL(url)
    const last = parsed.pathname.split('/').filter(Boolean).pop() || parsed.hostname
    return decodeURIComponent(last).replace(/[-_]/g, ' ') || parsed.hostname
  } catch {
    return url
  }
}

function resourceTypeLabel(url: string) {
  const lower = url.toLowerCase()
  if (lower.includes('youtube.com') || lower.includes('youtu.be') || lower.includes('bilibili.com')) return 'video'
  if (lower.includes('docs.') || lower.includes('/docs') || lower.endsWith('.pdf')) return 'document'
  if (lower.includes('github.com')) return 'repo'
  return 'article'
}

function resourceThumbnail(url: string) {
  const host = resourceHost(url)
  return `https://www.google.com/s2/favicons?domain=${encodeURIComponent(host)}&sz=256`
}

function getCategoryColor(category?: string) {
  const key = String(category || '').trim().toLowerCase() || 'other'
  const palette = ['#3b82f6', '#22c55e', '#f59e0b', '#8b5cf6', '#ef4444', '#06b6d4', '#f97316', '#84cc16']
  let hash = 0
  for (let i = 0; i < key.length; i += 1) hash = (hash * 31 + key.charCodeAt(i)) >>> 0
  return palette[hash % palette.length]
}

async function copySummary() {
  if (!result.value) return
  const text = `${result.value.data.title}\n\n${result.value.data.summary}`
  try {
    await navigator.clipboard.writeText(text)
  } catch {
    window.prompt('Copy summary', text)
  }
}
</script>
