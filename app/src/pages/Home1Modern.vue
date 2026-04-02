<template>
  <!-- ============================================
       LANDING PAGE - UI-UX-DESIGN STYLE
       Modern, Clean, Mobile-First Design
       ============================================ -->
  <div class="min-h-screen bg-white">
    <!-- Navigation -->
    <nav class="fixed left-0 right-0 top-0 z-50 border-b border-gray-100 bg-white/80 backdrop-blur-md">
      <div class="mx-auto flex h-16 max-w-7xl items-center justify-between px-4">
        <span class="text-xl font-bold text-gray-900">Learnpathly</span>
        <div class="hidden items-center gap-8 md:flex">
          <a href="#features" class="text-sm text-gray-600 hover:text-gray-900">Features</a>
          <a href="#how-it-works" class="text-sm text-gray-600 hover:text-gray-900">How it Works</a>
          <a href="#pricing" class="text-sm text-gray-600 hover:text-gray-900">Pricing</a>
        </div>
        <div class="flex items-center gap-3">
          <a href="/login" class="text-sm font-medium text-gray-700 hover:text-gray-900">Log in</a>
          <a href="/register" class="rounded-full bg-gray-900 px-4 py-2 text-sm font-medium text-white hover:bg-gray-800">Get Started</a>
        </div>
      </div>
    </nav>

    <!-- Hero Section -->
    <section class="pt-32 pb-20">
      <div class="mx-auto max-w-7xl px-4">
        <div class="grid gap-12 lg:grid-cols-2 lg:items-center">
          <div class="space-y-8">
            <div class="inline-flex items-center gap-2 rounded-full border border-gray-200 bg-gray-50 px-3 py-1 text-xs font-medium text-gray-700">
              <span class="flex h-2 w-2 rounded-full bg-green-500"></span>
              AI-Powered Learning
            </div>
            <h1 class="text-4xl font-bold leading-tight text-gray-900 md:text-6xl">
              Turn scattered resources into
              <span class="text-blue-600"> structured learning</span>
            </h1>
            <p class="text-lg leading-relaxed text-gray-600">
              Generate AI learning paths or build manually. Track progress and complete your goals with guided roadmaps.
            </p>
            <div class="flex flex-col gap-4 sm:flex-row">
              <input
                type="text"
                placeholder="What do you want to learn?"
                class="h-12 w-full rounded-xl border border-gray-200 px-4 text-gray-900 placeholder:text-gray-400 focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500/20"
              />
              <button class="h-12 shrink-0 rounded-xl bg-blue-600 px-8 font-semibold text-white hover:bg-blue-700">
                Generate
              </button>
            </div>
            <p class="text-sm text-gray-500">
              10,000+ learners • Free to start
            </p>
          </div>
          <div class="relative">
            <div class="aspect-[4/3] overflow-hidden rounded-2xl bg-gradient-to-br from-blue-50 to-indigo-100 p-8">
              <div class="h-full rounded-xl bg-white shadow-xl">
                <div class="border-b border-gray-100 p-4">
                  <div class="flex items-center gap-2">
                    <div class="h-3 w-3 rounded-full bg-red-400"></div>
                    <div class="h-3 w-3 rounded-full bg-yellow-400"></div>
                    <div class="h-3 w-3 rounded-full bg-green-400"></div>
                  </div>
                </div>
                <div class="p-6">
                  <div class="mb-4 h-4 w-1/3 rounded bg-gray-200"></div>
                  <div class="space-y-3">
                    <div class="h-3 w-full rounded bg-gray-100"></div>
                    <div class="h-3 w-5/6 rounded bg-gray-100"></div>
                    <div class="h-3 w-4/6 rounded bg-gray-100"></div>
                  </div>
                  <div class="mt-6 flex gap-2">
                    <div class="h-20 flex-1 rounded-lg bg-blue-100"></div>
                    <div class="h-20 flex-1 rounded-lg bg-indigo-100"></div>
                    <div class="h-20 flex-1 rounded-lg bg-purple-100"></div>
                  </div>
                </div>
              </div>
            </div>
            <!-- Floating badge -->
            <div class="absolute -bottom-4 -left-4 rounded-xl bg-white p-4 shadow-lg">
              <div class="flex items-center gap-3">
                <div class="flex h-10 w-10 items-center justify-center rounded-full bg-green-100">
                  <svg class="h-5 w-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                  </svg>
                </div>
                <div>
                  <div class="text-sm font-semibold text-gray-900">Path Generated</div>
                  <div class="text-xs text-gray-500">in 3 seconds</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="bg-gray-50 py-20">
      <div class="mx-auto max-w-7xl px-4">
        <div class="mb-12 text-center">
          <h2 class="text-3xl font-bold text-gray-900 md:text-4xl">Everything you need to learn effectively</h2>
          <p class="mt-4 text-lg text-gray-600">Powerful features designed for modern learners</p>
        </div>
        <div class="grid gap-8 md:grid-cols-3">
          <div class="rounded-2xl bg-white p-8 shadow-sm">
            <div class="mb-4 inline-flex h-12 w-12 items-center justify-center rounded-xl bg-blue-100">
              <svg class="h-6 w-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
              </svg>
            </div>
            <h3 class="mb-2 text-xl font-semibold text-gray-900">AI Generation</h3>
            <p class="text-gray-600">Generate structured learning paths in seconds with AI. Just enter your topic and get a complete roadmap.</p>
          </div>
          <div class="rounded-2xl bg-white p-8 shadow-sm">
            <div class="mb-4 inline-flex h-12 w-12 items-center justify-center rounded-xl bg-purple-100">
              <svg class="h-6 w-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h7" />
              </svg>
            </div>
            <h3 class="mb-2 text-xl font-semibold text-gray-900">Manual Builder</h3>
            <p class="text-gray-600">Build your own path with curated resources. Add videos, articles, and documents in any order.</p>
          </div>
          <div class="rounded-2xl bg-white p-8 shadow-sm">
            <div class="mb-4 inline-flex h-12 w-12 items-center justify-center rounded-xl bg-green-100">
              <svg class="h-6 w-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
              </svg>
            </div>
            <h3 class="mb-2 text-xl font-semibold text-gray-900">Progress Tracking</h3>
            <p class="text-gray-600">Track your progress visually. Mark items complete and see how far you've come.</p>
          </div>
        </div>
      </div>
    </section>

    <!-- How It Works -->
    <section id="how-it-works" class="py-20">
      <div class="mx-auto max-w-7xl px-4">
        <div class="mb-12 text-center">
          <h2 class="text-3xl font-bold text-gray-900 md:text-4xl">How it works</h2>
          <p class="mt-4 text-lg text-gray-600">Three simple steps to structured learning</p>
        </div>
        <div class="grid gap-8 md:grid-cols-3">
          <div class="text-center">
            <div class="mb-4 flex justify-center">
              <div class="flex h-16 w-16 items-center justify-center rounded-full bg-blue-600 text-2xl font-bold text-white">1</div>
            </div>
            <h3 class="mb-2 text-lg font-semibold text-gray-900">Enter a topic</h3>
            <p class="text-gray-600">Type what you want to learn, or start building manually with your own resources.</p>
          </div>
          <div class="text-center">
            <div class="mb-4 flex justify-center">
              <div class="flex h-16 w-16 items-center justify-center rounded-full bg-blue-600 text-2xl font-bold text-white">2</div>
            </div>
            <h3 class="mb-2 text-lg font-semibold text-gray-900">Generate or build</h3>
            <p class="text-gray-600">Let AI create a structured path, or manually add and organize your learning materials.</p>
          </div>
          <div class="text-center">
            <div class="mb-4 flex justify-center">
              <div class="flex h-16 w-16 items-center justify-center rounded-full bg-blue-600 text-2xl font-bold text-white">3</div>
            </div>
            <h3 class="mb-2 text-lg font-semibold text-gray-900">Track progress</h3>
            <p class="text-gray-600">Follow your path, mark items complete, and track your learning journey.</p>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="bg-gray-900 py-20">
      <div class="mx-auto max-w-4xl px-4 text-center">
        <h2 class="text-3xl font-bold text-white md:text-4xl">Start learning effectively today</h2>
        <p class="mt-4 text-lg text-gray-300">Join thousands of learners who are already using Learnpathly</p>
        <div class="mt-8">
          <a href="/register" class="inline-block rounded-full bg-blue-600 px-8 py-4 text-lg font-semibold text-white hover:bg-blue-700">
            Get Started for Free
          </a>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <footer class="border-t border-gray-100 bg-white py-12">
      <div class="mx-auto max-w-7xl px-4">
        <div class="flex flex-col items-center justify-between gap-4 md:flex-row">
          <span class="text-lg font-bold text-gray-900">Learnpathly</span>
          <p class="text-sm text-gray-500">© 2026 Learnpathly. All rights reserved.</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
// UI-UX-Design Style Landing Page
// Mobile-first, clean, modern design
</script>
