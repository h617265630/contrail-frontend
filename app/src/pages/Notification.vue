<template>
  <div class="min-h-screen bg-stone-50">

    <!-- Masthead -->
    <header class="border-b-2 border-stone-900 bg-white">
      <div class="mx-auto max-w-7xl px-4 py-6 md:py-8">
        <div class="flex items-end justify-between">
          <div>
            <div class="flex items-center gap-2 mb-3">
              <span class="h-px w-8 bg-rose-500"></span>
              <span class="text-[10px] font-bold uppercase tracking-[0.25em] text-stone-400">Updates</span>
            </div>
            <h1 class="text-4xl md:text-5xl font-black tracking-tight text-stone-900 leading-[0.9]">
              What's<br/><span class="text-rose-600">New.</span>
            </h1>
          </div>
          <div class="hidden md:flex flex-col items-end gap-2">
            <span class="text-[10px] font-semibold uppercase tracking-widest text-stone-400">Platform · Rules · Status</span>
          </div>
        </div>
      </div>
    </header>

    <main class="mx-auto max-w-7xl px-4 py-8">

      <!-- Platform Updates -->
      <section class="mb-14">
        <!-- Section header -->
        <div class="flex items-center gap-4 mb-8">
          <div class="flex items-center gap-2">
            <div class="w-2 h-8 bg-blue-600 rounded-full"></div>
            <span class="text-sm font-black uppercase tracking-widest text-stone-900">Platform</span>
          </div>
          <div class="flex-1 h-px bg-stone-200"></div>
        </div>

        <!-- Numbered editorial cards -->
        <div class="space-y-3">
          <article
            v-for="(n, idx) in platformUpdates"
            :key="n.id"
            class="group relative pl-14 py-6 border-b border-stone-100 hover:border-stone-200 transition-colors"
          >
            <!-- Large index number -->
            <span class="absolute left-0 top-4 text-[72px] font-black leading-none text-stone-100 select-none pointer-events-none group-hover:text-stone-200 transition-colors" aria-hidden="true">
              {{ String(idx + 1).padStart(2, '0') }}
            </span>

            <div class="relative">
              <div class="flex items-center gap-3 mb-2">
                <time class="text-xs text-stone-400 font-medium">{{ n.date }}</time>
                <span class="inline-flex items-center gap-1 rounded-sm border border-blue-100 bg-blue-50 px-2 py-0.5 text-[9px] font-bold uppercase tracking-wider text-blue-600">
                  New
                </span>
              </div>
              <h3 class="text-base font-bold text-stone-900 leading-snug">{{ n.title }}</h3>
              <p class="text-sm text-stone-500 mt-2 leading-relaxed max-w-2xl">{{ n.body }}</p>
            </div>
          </article>
        </div>
      </section>

      <!-- Rules & Policies -->
      <section class="mb-14">
        <div class="flex items-center gap-4 mb-8">
          <div class="flex items-center gap-2">
            <div class="w-2 h-8 bg-amber-600 rounded-full"></div>
            <span class="text-sm font-black uppercase tracking-widest text-stone-900">Rules & Policy</span>
          </div>
          <div class="flex-1 h-px bg-stone-200"></div>
        </div>

        <div class="space-y-3">
          <article
            v-for="(n, idx) in ruleChanges"
            :key="n.id"
            class="group relative pl-14 py-6 border-b border-stone-100 hover:border-stone-200 transition-colors"
          >
            <span class="absolute left-0 top-4 text-[72px] font-black leading-none text-stone-100 select-none pointer-events-none group-hover:text-stone-200 transition-colors" aria-hidden="true">
              {{ String(idx + 1).padStart(2, '0') }}
            </span>

            <div class="relative">
              <div class="flex items-center gap-3 mb-2">
                <time class="text-xs text-stone-400 font-medium">{{ n.date }}</time>
                <span class="inline-flex items-center gap-1 rounded-sm border border-amber-100 bg-amber-50 px-2 py-0.5 text-[9px] font-bold uppercase tracking-wider text-amber-600">
                  Policy
                </span>
              </div>
              <h3 class="text-base font-bold text-stone-900 leading-snug">{{ n.title }}</h3>
              <p class="text-sm text-stone-500 mt-2 leading-relaxed max-w-2xl">{{ n.body }}</p>
            </div>
          </article>
        </div>
      </section>

      <!-- Service Status -->
      <section class="mb-14">
        <div class="flex items-center gap-4 mb-8">
          <div class="flex items-center gap-2">
            <div class="w-2 h-8 bg-emerald-600 rounded-full"></div>
            <span class="text-sm font-black uppercase tracking-widest text-stone-900">Service Status</span>
          </div>
          <div class="flex-1 h-px bg-stone-200"></div>
          <!-- Always-on status indicator -->
          <div class="flex items-center gap-2">
            <div class="h-2 w-2 rounded-full bg-emerald-500 animate-pulse"></div>
            <span class="text-[10px] font-semibold uppercase tracking-wider text-emerald-600">All operational</span>
          </div>
        </div>

        <div class="space-y-3">
          <article
            v-for="(s, idx) in serviceStatus"
            :key="s.id"
            class="group relative pl-14 py-6 border-b border-stone-100 hover:border-stone-200 transition-colors"
          >
            <span class="absolute left-0 top-4 text-[72px] font-black leading-none text-stone-100 select-none pointer-events-none group-hover:text-stone-200 transition-colors" aria-hidden="true">
              {{ String(idx + 1).padStart(2, '0') }}
            </span>

            <div class="relative">
              <div class="flex items-center gap-3 mb-2">
                <time class="text-xs text-stone-400 font-medium">{{ s.date }}</time>
                <span
                  class="inline-flex items-center gap-1.5 rounded-sm px-2.5 py-0.5 text-[9px] font-bold uppercase tracking-wider"
                  :class="statusClasses(s.status)"
                >
                  <span class="h-1.5 w-1.5 rounded-full" :class="statusDotClass(s.status)"></span>
                  {{ s.status }}
                </span>
              </div>
              <h3 class="text-base font-bold text-stone-900 leading-snug">{{ s.title }}</h3>
              <p class="text-sm text-stone-500 mt-2 leading-relaxed max-w-2xl">{{ s.body }}</p>
            </div>
          </article>
        </div>
      </section>

      <!-- Divider -->
      <div class="border-t-2 border-stone-900 mb-14"></div>

      <!-- Personal Notifications (auth-gated) -->
      <section v-if="!isAuthed">
        <!-- Auth gate -->
        <div class="py-16 text-center">
          <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-stone-100 mb-6">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="text-stone-400"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
          </div>
          <h3 class="text-lg font-bold text-stone-700 mb-2">Sign in to see your notifications</h3>
          <p class="text-sm text-stone-400 mb-6 max-w-sm mx-auto">Social activity, progress milestones, and path updates will appear here once you're signed in.</p>
          <Button
            :as="RouterLinkComp"
            to="/login"
            class="rounded-sm bg-stone-900 text-white hover:bg-stone-800 font-semibold text-sm px-8 py-2.5 transition-all hover:-translate-y-px"
          >
            Sign in
          </Button>
        </div>
      </section>

      <template v-else>
        <!-- Social -->
        <section class="mb-14">
          <div class="flex items-center gap-4 mb-8">
            <div class="flex items-center gap-2">
              <div class="w-2 h-8 bg-violet-600 rounded-full"></div>
              <span class="text-sm font-black uppercase tracking-widest text-stone-900">Social</span>
            </div>
            <div class="flex-1 h-px bg-stone-200"></div>
          </div>
          <div class="rounded-md border border-dashed border-stone-200 bg-stone-50/50 py-12 text-center">
            <p class="text-sm text-stone-400">Social and collaboration features coming soon.</p>
          </div>
        </section>

        <!-- Progress -->
        <section class="mb-14">
          <div class="flex items-center gap-4 mb-8">
            <div class="flex items-center gap-2">
              <div class="w-2 h-8 bg-cyan-600 rounded-full"></div>
              <span class="text-sm font-black uppercase tracking-widest text-stone-900">Progress</span>
            </div>
            <div class="flex-1 h-px bg-stone-200"></div>
          </div>
          <div class="rounded-md border border-dashed border-stone-200 bg-stone-50/50 py-12 text-center">
            <p class="text-sm text-stone-400">Progress tracking and milestone notifications coming soon.</p>
          </div>
        </section>
      </template>

    </main>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { RouterLink } from 'vue-router'
import { Button } from '../components/ui/button'
import { useAuthStore } from '../stores/auth'

const RouterLinkComp = RouterLink
const auth = useAuthStore()
const isAuthed = computed(() => auth.isAuthed)

type TextNotice = { id: string; date: string; title: string; body: string }
type ServiceNotice = TextNotice & { status: 'operational' | 'degraded' | 'incident' }

const platformUpdates: TextNotice[] = [
  {
    id: 'pu1',
    date: '2026-01-31',
    title: 'Learning path types are live',
    body: 'LearningPool now groups paths by type (linear / structured / partical pool). You can pick a type when creating a path.',
  },
  {
    id: 'pu2',
    date: '2026-01-31',
    title: 'Refined UI consistency',
    body: 'We improved typography and UI consistency across key pages for a cleaner experience.',
  },
]

const ruleChanges: TextNotice[] = [
  {
    id: 'rc1',
    date: '2026-01-31',
    title: 'Public content guidelines updated',
    body: 'Public paths/resources should avoid sensitive content and include a clear title/description for discoverability.',
  },
]

const serviceStatus: ServiceNotice[] = [
  {
    id: 'ss1',
    date: '2026-01-31',
    title: 'Video metadata extraction',
    body: 'Operational. Some platforms may have rate limits depending on availability.',
    status: 'operational',
  },
]

function statusClasses(status: ServiceNotice['status']) {
  if (status === 'operational') return 'border-emerald-100 bg-emerald-50 text-emerald-700'
  if (status === 'degraded') return 'border-amber-100 bg-amber-50 text-amber-700'
  return 'border-red-100 bg-red-50 text-red-700'
}

function statusDotClass(status: ServiceNotice['status']) {
  if (status === 'operational') return 'bg-emerald-500'
  if (status === 'degraded') return 'bg-amber-500'
  return 'bg-red-500'
}
</script>
