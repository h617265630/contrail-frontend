<template>
  <div class="min-h-screen bg-stone-50">

    <!-- Masthead -->
    <header class="border-b border-stone-200 bg-white">
      <div class="mx-auto max-w-7xl px-4 py-6 md:py-8">
        <div class="flex items-end justify-between gap-6">
          <div>
            <div class="flex items-center gap-2 mb-3">
              <span class="h-px w-8 bg-cyan-600"></span>
              <span class="text-[10px] font-bold uppercase tracking-[0.25em] text-stone-400">Personal</span>
            </div>
            <h1 class="text-3xl md:text-4xl font-black tracking-tight text-stone-900 leading-[0.92]">
              My<br/><span class="text-cyan-600">Paths.</span>
            </h1>
          </div>
          <div class="hidden md:flex flex-col items-end gap-1">
            <span class="text-xs text-stone-400">
              <span class="font-semibold text-stone-700">{{ paths.length }}</span> learning paths
            </span>
          </div>
        </div>

        <!-- Toolbar -->
        <div class="mt-6 flex items-center justify-between gap-4">
          <!-- View toggle -->
          <div class="flex h-9 items-center rounded-none border border-stone-200 bg-white p-0.5">
            <button
              v-for="mode in viewModes"
              :key="mode.value"
              type="button"
              class="h-full px-4 text-[11px] font-semibold uppercase tracking-wider transition-all"
              :class="viewMode === mode.value
                ? 'bg-stone-900 text-white'
                : 'text-stone-500 hover:text-stone-900'"
              @click="viewMode = mode.value"
            >
              {{ mode.label }}
            </button>
          </div>

          <Button
            :as="RouterLinkComp"
            to="/createpath"
            size="sm"
            class="rounded-none bg-cyan-600 text-white hover:bg-cyan-700 font-semibold text-xs uppercase tracking-wider px-5"
          >
            + New path
          </Button>
        </div>
      </div>
    </header>

    <!-- Main content -->
    <main class="mx-auto max-w-7xl px-4 py-8">

      <!-- Loading -->
      <div v-if="loading" class="py-20 text-center">
        <div class="inline-flex items-center gap-3">
          <div class="h-2 w-2 rounded-full bg-cyan-500 animate-pulse"></div>
          <span class="text-sm text-stone-400">Loading your paths…</span>
        </div>
      </div>

      <!-- Error -->
      <div v-else-if="error" class="py-12 rounded-md border border-red-100 bg-red-50/50 p-6 text-center">
        <p class="text-sm text-red-600 font-semibold">{{ error }}</p>
      </div>

      <!-- Empty -->
      <div v-else-if="paths.length === 0" class="py-20 text-center">
        <div class="text-5xl mb-4">🛤️</div>
        <h3 class="text-base font-semibold text-stone-700 mb-1">No learning paths yet</h3>
        <p class="text-sm text-stone-400 mb-5">Create your first learning path and start building.</p>
        <Button
          :as="RouterLinkComp"
          to="/createpath"
          class="rounded-none bg-cyan-600 text-white hover:bg-cyan-700 font-semibold text-sm"
        >
          Create your first path →
        </Button>
      </div>

      <!-- GRID VIEW -->
      <template v-else-if="viewMode === 'grid'">
        <!-- Linear paths -->
        <section v-if="linearPaths.length" class="mb-12">
          <div class="flex items-center gap-4 mb-5">
            <div class="flex items-center gap-2">
              <div class="w-1 h-5 bg-cyan-500 rounded-full"></div>
              <h2 class="text-sm font-bold text-stone-900 uppercase tracking-widest">Linear</h2>
            </div>
            <span class="text-xs text-stone-400 font-medium">{{ linearPaths.length }} paths</span>
          </div>
          <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
            <article
              v-for="path in linearPaths"
              :key="path.id"
              class="group rounded-md overflow-hidden bg-white border border-stone-100 hover:border-stone-200 hover:shadow-lg transition-all duration-200 cursor-pointer"
              @click="openDetail(path.id)"
            >
              <!-- Cover -->
              <div
                class="relative aspect-video bg-stone-100 overflow-hidden transition-transform duration-500 group-hover:scale-105"
                :style="coverFor(path.id) ? { backgroundImage: `url(${coverFor(path.id)})` } : {}"
              >
                <img
                  v-if="coverFor(path.id)"
                  :src="coverFor(path.id)"
                  alt=""
                  aria-hidden="true"
                  class="absolute inset-0 w-full h-full object-cover scale-110 blur-xl opacity-30"
                  style="width: 100%; height: 100%; object-fit: cover;"
                />
                <img
                  v-if="coverFor(path.id)"
                  :src="coverFor(path.id)"
                  :alt="path.title"
                  class="block w-full h-full object-contain"
                  style="width: 100%; height: 100%; object-fit: contain; background-color: #f7f7f7;"
                />
                <div v-else class="absolute inset-0 flex flex-col items-center justify-center bg-stone-100">
                  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="text-stone-300"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
                  <span class="text-[10px] font-semibold text-stone-400 mt-2 uppercase tracking-wider">{{ path.category_name || 'Path' }}</span>
                </div>
                <!-- Type badge -->
                <div class="absolute top-2 right-2">
                  <span class="text-[9px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-full bg-white/90 backdrop-blur-sm text-stone-600 border border-white/20">
                    {{ String((path as any)?.type || '').trim() }}
                  </span>
                </div>
              </div>
              <!-- Info -->
              <div class="p-3.5">
                <h3 class="text-sm font-bold text-stone-900 line-clamp-1 group-hover:text-cyan-700 transition-colors">{{ path.title }}</h3>
                <p class="text-xs text-stone-400 mt-1 line-clamp-2 leading-relaxed">{{ path.description || 'No description.' }}</p>
              </div>
              <!-- Actions -->
              <div class="px-3 pb-3 flex gap-2" @click.stop>
                <Button
                  :as="RouterLinkComp"
                  :to="{ name: 'learningpath-edit', params: { id: String(path.id) } }"
                  size="sm"
                  class="flex-1 rounded-none h-7 text-[10px] font-semibold uppercase tracking-wider border-stone-200 text-stone-600 hover:border-stone-400 hover:text-stone-900"
                >
                  Edit
                </Button>
                <button
                  type="button"
                  class="h-7 px-2.5 rounded-none border border-stone-200 text-[10px] font-semibold text-red-400 hover:bg-red-50 hover:border-red-200 hover:text-red-500 transition-all"
                  @click="openDeleteConfirm(path.id)"
                >
                  Delete
                </button>
              </div>
            </article>
          </div>
        </section>

        <!-- Structured paths -->
        <section v-if="structuredPaths.length" class="mb-12">
          <div class="flex items-center gap-4 mb-5">
            <div class="flex items-center gap-2">
              <div class="w-1 h-5 bg-violet-500 rounded-full"></div>
              <h2 class="text-sm font-bold text-stone-900 uppercase tracking-widest">Structured</h2>
            </div>
            <span class="text-xs text-stone-400 font-medium">{{ structuredPaths.length }} paths</span>
          </div>
          <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
            <article
              v-for="path in structuredPaths"
              :key="path.id"
              class="group rounded-md overflow-hidden bg-white border border-stone-100 hover:border-stone-200 hover:shadow-lg transition-all duration-200 cursor-pointer"
              @click="openDetail(path.id)"
            >
              <div
                class="relative aspect-video bg-stone-100 overflow-hidden transition-transform duration-500 group-hover:scale-105"
                :style="coverFor(path.id) ? { backgroundImage: `url(${coverFor(path.id)})` } : {}"
              >
                <img
                  v-if="coverFor(path.id)"
                  :src="coverFor(path.id)"
                  alt=""
                  aria-hidden="true"
                  class="absolute inset-0 w-full h-full object-cover scale-110 blur-xl opacity-30"
                  style="width: 100%; height: 100%; object-fit: cover;"
                />
                <img
                  v-if="coverFor(path.id)"
                  :src="coverFor(path.id)"
                  :alt="path.title"
                  class="block w-full h-full object-contain"
                  style="width: 100%; height: 100%; object-fit: contain; background-color: #f7f7f7;"
                />
                <div v-else class="absolute inset-0 flex flex-col items-center justify-center bg-stone-100">
                  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="text-stone-300"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
                  <span class="text-[10px] font-semibold text-stone-400 mt-2 uppercase tracking-wider">{{ path.category_name || 'Path' }}</span>
                </div>
                <div class="absolute top-2 right-2">
                  <span class="text-[9px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-full bg-white/90 backdrop-blur-sm text-stone-600 border border-white/20">
                    {{ String((path as any)?.type || '').trim() }}
                  </span>
                </div>
              </div>
              <div class="p-3.5">
                <h3 class="text-sm font-bold text-stone-900 line-clamp-1 group-hover:text-violet-700 transition-colors">{{ path.title }}</h3>
                <p class="text-xs text-stone-400 mt-1 line-clamp-2 leading-relaxed">{{ path.description || 'No description.' }}</p>
              </div>
              <div class="px-3 pb-3 flex gap-2" @click.stop>
                <Button
                  :as="RouterLinkComp"
                  :to="{ name: 'learningpath-edit', params: { id: String(path.id) } }"
                  size="sm"
                  class="flex-1 rounded-none h-7 text-[10px] font-semibold uppercase tracking-wider border-stone-200 text-stone-600 hover:border-stone-400 hover:text-stone-900"
                >
                  Edit
                </Button>
                <button
                  type="button"
                  class="h-7 px-2.5 rounded-none border border-stone-200 text-[10px] font-semibold text-red-400 hover:bg-red-50 hover:border-red-200 hover:text-red-500 transition-all"
                  @click="openDeleteConfirm(path.id)"
                >
                  Delete
                </button>
              </div>
            </article>
          </div>
        </section>

        <!-- Pool paths -->
        <section v-if="particalPoolPaths.length" class="mb-12">
          <div class="flex items-center gap-4 mb-5">
            <div class="flex items-center gap-2">
              <div class="w-1 h-5 bg-amber-500 rounded-full"></div>
              <h2 class="text-sm font-bold text-stone-900 uppercase tracking-widest">Pool</h2>
            </div>
            <span class="text-xs text-stone-400 font-medium">{{ particalPoolPaths.length }} paths</span>
          </div>
          <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
            <article
              v-for="path in particalPoolPaths"
              :key="path.id"
              class="group rounded-md overflow-hidden bg-white border border-stone-100 hover:border-stone-200 hover:shadow-lg transition-all duration-200 cursor-pointer"
              @click="openDetail(path.id)"
            >
              <div
                class="relative aspect-video bg-stone-100 overflow-hidden transition-transform duration-500 group-hover:scale-105"
                :style="coverFor(path.id) ? { backgroundImage: `url(${coverFor(path.id)})` } : {}"
              >
                <img
                  v-if="coverFor(path.id)"
                  :src="coverFor(path.id)"
                  alt=""
                  aria-hidden="true"
                  class="absolute inset-0 w-full h-full object-cover scale-110 blur-xl opacity-30"
                  style="width: 100%; height: 100%; object-fit: cover;"
                />
                <img
                  v-if="coverFor(path.id)"
                  :src="coverFor(path.id)"
                  :alt="path.title"
                  class="block w-full h-full object-contain"
                  style="width: 100%; height: 100%; object-fit: contain; background-color: #f7f7f7;"
                />
                <div v-else class="absolute inset-0 flex flex-col items-center justify-center bg-stone-100">
                  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="text-stone-300"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
                  <span class="text-[10px] font-semibold text-stone-400 mt-2 uppercase tracking-wider">{{ path.category_name || 'Path' }}</span>
                </div>
                <div class="absolute top-2 right-2">
                  <span class="text-[9px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-full bg-white/90 backdrop-blur-sm text-stone-600 border border-white/20">
                    {{ String((path as any)?.type || '').trim() }}
                  </span>
                </div>
              </div>
              <div class="p-3.5">
                <h3 class="text-sm font-bold text-stone-900 line-clamp-1 group-hover:text-amber-700 transition-colors">{{ path.title }}</h3>
                <p class="text-xs text-stone-400 mt-1 line-clamp-2 leading-relaxed">{{ path.description || 'No description.' }}</p>
              </div>
              <div class="px-3 pb-3 flex gap-2" @click.stop>
                <Button
                  :as="RouterLinkComp"
                  :to="{ name: 'learningpath-edit', params: { id: String(path.id) } }"
                  size="sm"
                  class="flex-1 rounded-none h-7 text-[10px] font-semibold uppercase tracking-wider border-stone-200 text-stone-600 hover:border-stone-400 hover:text-stone-900"
                >
                  Edit
                </Button>
                <button
                  type="button"
                  class="h-7 px-2.5 rounded-none border border-stone-200 text-[10px] font-semibold text-red-400 hover:bg-red-50 hover:border-red-200 hover:text-red-500 transition-all"
                  @click="openDeleteConfirm(path.id)"
                >
                  Delete
                </button>
              </div>
            </article>
          </div>
        </section>
      </template>

      <!-- LIST VIEW -->
      <template v-else>
        <section v-if="linearPaths.length" class="mb-10">
          <div class="flex items-center gap-3 mb-4">
            <div class="w-1 h-4 bg-cyan-500 rounded-full"></div>
            <h2 class="text-xs font-bold uppercase tracking-widest text-stone-500">Linear</h2>
            <span class="text-xs text-stone-400">{{ linearPaths.length }}</span>
          </div>
          <div class="space-y-2">
            <article
              v-for="path in linearPaths"
              :key="path.id"
              class="group flex items-center gap-4 rounded-md bg-white border border-stone-100 hover:border-stone-200 hover:shadow-sm transition-all cursor-pointer p-3"
              @click="openDetail(path.id)"
            >
              <div class="w-24 h-14 shrink-0 rounded-none overflow-hidden bg-stone-100 relative">
                <img
                  v-if="coverFor(path.id)"
                  :src="coverFor(path.id)"
                  :alt="path.title"
                  class="w-full h-full object-contain"
                  style="object-fit: contain; background-color: #f7f7f7;"
                  loading="lazy"
                />
                <div v-else class="absolute inset-0 flex items-center justify-center">
                  <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="text-stone-300"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
                </div>
              </div>
              <div class="flex-1 min-w-0">
                <h3 class="text-sm font-bold text-stone-900 line-clamp-1 group-hover:text-cyan-700 transition-colors">{{ path.title }}</h3>
                <p class="text-xs text-stone-400 mt-0.5 line-clamp-1">{{ path.description || 'No description.' }}</p>
              </div>
              <div class="shrink-0 flex items-center gap-2" @click.stop>
                <Button
                  :as="RouterLinkComp"
                  :to="{ name: 'learningpath-edit', params: { id: String(path.id) } }"
                  size="sm"
                  class="rounded-none h-7 text-[10px] font-semibold uppercase tracking-wider border-stone-200 text-stone-600 hover:border-stone-400"
                >
                  Edit
                </Button>
                <button
                  type="button"
                  class="h-7 px-2.5 rounded-none border border-stone-200 text-[10px] font-semibold text-red-400 hover:bg-red-50 transition-all"
                  @click="openDeleteConfirm(path.id)"
                >
                  Delete
                </button>
              </div>
            </article>
          </div>
        </section>

        <section v-if="structuredPaths.length" class="mb-10">
          <div class="flex items-center gap-3 mb-4">
            <div class="w-1 h-4 bg-violet-500 rounded-full"></div>
            <h2 class="text-xs font-bold uppercase tracking-widest text-stone-500">Structured</h2>
            <span class="text-xs text-stone-400">{{ structuredPaths.length }}</span>
          </div>
          <div class="space-y-2">
            <article
              v-for="path in structuredPaths"
              :key="path.id"
              class="group flex items-center gap-4 rounded-md bg-white border border-stone-100 hover:border-stone-200 hover:shadow-sm transition-all cursor-pointer p-3"
              @click="openDetail(path.id)"
            >
              <div class="w-24 h-14 shrink-0 rounded-none overflow-hidden bg-stone-100 relative">
                <img
                  v-if="coverFor(path.id)"
                  :src="coverFor(path.id)"
                  :alt="path.title"
                  class="w-full h-full object-contain"
                  style="object-fit: contain; background-color: #f7f7f7;"
                  loading="lazy"
                />
                <div v-else class="absolute inset-0 flex items-center justify-center">
                  <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="text-stone-300"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
                </div>
              </div>
              <div class="flex-1 min-w-0">
                <h3 class="text-sm font-bold text-stone-900 line-clamp-1 group-hover:text-violet-700 transition-colors">{{ path.title }}</h3>
                <p class="text-xs text-stone-400 mt-0.5 line-clamp-1">{{ path.description || 'No description.' }}</p>
              </div>
              <div class="shrink-0 flex items-center gap-2" @click.stop>
                <Button
                  :as="RouterLinkComp"
                  :to="{ name: 'learningpath-edit', params: { id: String(path.id) } }"
                  size="sm"
                  class="rounded-none h-7 text-[10px] font-semibold uppercase tracking-wider border-stone-200 text-stone-600 hover:border-stone-400"
                >
                  Edit
                </Button>
                <button
                  type="button"
                  class="h-7 px-2.5 rounded-none border border-stone-200 text-[10px] font-semibold text-red-400 hover:bg-red-50 transition-all"
                  @click="openDeleteConfirm(path.id)"
                >
                  Delete
                </button>
              </div>
            </article>
          </div>
        </section>

        <section v-if="particalPoolPaths.length" class="mb-10">
          <div class="flex items-center gap-3 mb-4">
            <div class="w-1 h-4 bg-amber-500 rounded-full"></div>
            <h2 class="text-xs font-bold uppercase tracking-widest text-stone-500">Pool</h2>
            <span class="text-xs text-stone-400">{{ particalPoolPaths.length }}</span>
          </div>
          <div class="space-y-2">
            <article
              v-for="path in particalPoolPaths"
              :key="path.id"
              class="group flex items-center gap-4 rounded-md bg-white border border-stone-100 hover:border-stone-200 hover:shadow-sm transition-all cursor-pointer p-3"
              @click="openDetail(path.id)"
            >
              <div class="w-24 h-14 shrink-0 rounded-none overflow-hidden bg-stone-100 relative">
                <img
                  v-if="coverFor(path.id)"
                  :src="coverFor(path.id)"
                  :alt="path.title"
                  class="w-full h-full object-contain"
                  style="object-fit: contain; background-color: #f7f7f7;"
                  loading="lazy"
                />
                <div v-else class="absolute inset-0 flex items-center justify-center">
                  <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="text-stone-300"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
                </div>
              </div>
              <div class="flex-1 min-w-0">
                <h3 class="text-sm font-bold text-stone-900 line-clamp-1 group-hover:text-amber-700 transition-colors">{{ path.title }}</h3>
                <p class="text-xs text-stone-400 mt-0.5 line-clamp-1">{{ path.description || 'No description.' }}</p>
              </div>
              <div class="shrink-0 flex items-center gap-2" @click.stop>
                <Button
                  :as="RouterLinkComp"
                  :to="{ name: 'learningpath-edit', params: { id: String(path.id) } }"
                  size="sm"
                  class="rounded-none h-7 text-[10px] font-semibold uppercase tracking-wider border-stone-200 text-stone-600 hover:border-stone-400"
                >
                  Edit
                </Button>
                <button
                  type="button"
                  class="h-7 px-2.5 rounded-none border border-stone-200 text-[10px] font-semibold text-red-400 hover:bg-red-50 transition-all"
                  @click="openDeleteConfirm(path.id)"
                >
                  Delete
                </button>
              </div>
            </article>
          </div>
        </section>
      </template>
    </main>

    <!-- Delete confirm dialog -->
    <Teleport to="body">
      <Transition name="modal">
        <div
          v-if="showDeleteConfirm"
          class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-stone-900/40 backdrop-blur-sm"
        >
          <div class="w-full max-w-sm rounded-md bg-white shadow-2xl border border-stone-100 overflow-hidden">
            <div class="px-6 py-5 border-b border-stone-100 flex items-center justify-between">
              <h2 class="text-base font-bold text-stone-900">Delete learning path?</h2>
              <button
                class="w-7 h-7 rounded-full bg-stone-100 flex items-center justify-center text-stone-400 hover:text-stone-600 transition"
                @click="closeDeleteConfirm"
              >
                ×
              </button>
            </div>
            <div class="p-6 space-y-3">
              <p class="text-sm text-stone-600">This will permanently delete the path. This action cannot be undone.</p>
              <p v-if="deleteError" class="text-sm text-red-500">{{ deleteError }}</p>
            </div>
            <div class="px-6 py-4 border-t border-stone-100 flex justify-end gap-2">
              <Button type="button" variant="outline" size="sm" class="rounded-none h-8 text-xs" @click="closeDeleteConfirm" :disabled="deleteConfirming">Cancel</Button>
              <Button
                type="button"
                size="sm"
                class="rounded-none h-8 text-xs bg-red-500 text-white hover:bg-red-600 border-0"
                @click="confirmDelete"
                :disabled="deleteConfirming"
              >
                {{ deleteConfirming ? 'Deleting…' : 'Delete' }}
              </Button>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>

  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'
import { deleteMyLearningPath, getMyLearningPathDetail, listMyLearningPaths, type MyLearningPath } from '../api/learningPath'
import { getMyResourceDetail, getResourceDetail } from '../api/resource'

const RouterLinkComp = RouterLink

const paths = ref<MyLearningPath[]>([])
const loading = ref(false)
const error = ref('')

function normalizePathType(raw: unknown) {
  return String(raw || '').trim().toLowerCase()
}

const linearPaths = computed(() => paths.value.filter(p => normalizePathType((p as any)?.type) === 'linear path'))
const structuredPaths = computed(() => paths.value.filter(p => normalizePathType((p as any)?.type) === 'structured path'))
const particalPoolPaths = computed(() => paths.value.filter(p => normalizePathType((p as any)?.type) === 'partical pool'))

const viewMode = ref<string>('grid')
const viewModes = [
  { label: 'Grid', value: 'grid' },
  { label: 'List', value: 'list' },
]

const coverByPathId = ref<Record<number, string>>({})
const router = useRouter()

const showDeleteConfirm = ref(false)
const deleteTargetId = ref<number | null>(null)
const deleteConfirming = ref(false)
const deleteError = ref('')

async function loadPaths() {
  loading.value = true
  error.value = ''
  try {
    const data = await listMyLearningPaths()
    paths.value = Array.isArray(data) ? data : []

    await Promise.allSettled(
      paths.value.map(async (p) => {
        try {
          const explicitCover = String((p as any)?.cover_image_url || '').trim()
          if (explicitCover) {
            coverByPathId.value[p.id] = explicitCover
            return
          }
          const detail = await getMyLearningPathDetail(p.id)
          const items = Array.isArray(detail.path_items) ? detail.path_items : []
          let first = items[0] || null
          for (const it of items) {
            const a = Number((first as any)?.order_index)
            const b = Number((it as any)?.order_index)
            const aOk = Number.isFinite(a)
            const bOk = Number.isFinite(b)
            if (!first) { first = it; continue }
            if (bOk && (!aOk || b < a)) first = it
          }
          let thumb = String((first as any)?.resource_data?.thumbnail || '').trim()
          if (!thumb) {
            const rid = Number((first as any)?.resource_id)
            if (Number.isFinite(rid) && rid > 0) {
              try {
                const r = await getResourceDetail(rid)
                thumb = String(r?.thumbnail || '').trim()
              } catch {
                try {
                  const r = await getMyResourceDetail(rid)
                  thumb = String(r?.thumbnail || '').trim()
                } catch { /* ignore */ }
              }
            }
          }
          coverByPathId.value[p.id] = thumb
        } catch {
          coverByPathId.value[p.id] = coverByPathId.value[p.id] || ''
        }
      }),
    )
  } catch (e: any) {
    error.value = String(e?.response?.data?.detail || e?.message || 'Failed to load paths')
  } finally {
    loading.value = false
  }
}

onMounted(loadPaths)

function openDetail(id: number) {
  router.push({ name: 'learningpath', params: { id: String(id) }, query: { from: 'my-paths' } })
}

function coverFor(id: number) {
  return String(coverByPathId.value[id] || '').trim()
}

function openDeleteConfirm(id: number) {
  deleteTargetId.value = id
  showDeleteConfirm.value = true
  deleteError.value = ''
}

function closeDeleteConfirm() {
  if (deleteConfirming.value) return
  showDeleteConfirm.value = false
  deleteTargetId.value = null
}

async function confirmDelete() {
  if (deleteTargetId.value == null) return
  deleteConfirming.value = true
  deleteError.value = ''
  try {
    await deleteMyLearningPath(deleteTargetId.value)
    await loadPaths()
    closeDeleteConfirm()
  } catch (e: any) {
    deleteError.value = String(e?.response?.data?.detail || e?.message || 'Failed to delete')
  } finally {
    deleteConfirming.value = false
  }
}
</script>

<style scoped>
.modal-enter-active, .modal-leave-active { transition: opacity 250ms ease; }
.modal-enter-from, .modal-leave-to { opacity: 0; }
</style>
