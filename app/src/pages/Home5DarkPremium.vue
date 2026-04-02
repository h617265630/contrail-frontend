<template>
  <!-- ============================================
       LANDING PAGE 5 - UI-UX-PRO-MAX STYLE
       Dark Premium Alternative
       ============================================ -->
  <div class="min-h-screen bg-[#0f0f12]">
    <!-- Ambient Background -->
    <div class="fixed inset-0">
      <div class="absolute top-0 left-1/4 w-[600px] h-[600px] bg-blue-600/10 rounded-full blur-[150px]"></div>
      <div class="absolute bottom-0 right-1/4 w-[500px] h-[500px] bg-purple-600/10 rounded-full blur-[150px]"></div>
    </div>

    <!-- Nav -->
    <nav class="relative z-10 border-b border-white/5">
      <div class="mx-auto flex h-20 max-w-7xl items-center justify-between px-6">
        <div class="flex items-center gap-3">
          <div class="h-10 w-10 rounded-xl bg-gradient-to-br from-blue-500 to-purple-600 flex items-center justify-center">
            <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
            </svg>
          </div>
          <span class="text-xl font-bold text-white">Learnpathly</span>
        </div>

        <div class="hidden md:flex items-center gap-8">
          <a href="#features" class="text-sm text-gray-400 hover:text-white transition-colors">Features</a>
          <a href="#showcase" class="text-sm text-gray-400 hover:text-white transition-colors">Showcase</a>
          <a href="#pricing" class="text-sm text-gray-400 hover:text-white transition-colors">Pricing</a>
        </div>

        <div class="flex items-center gap-4">
          <a href="/login" class="text-sm font-medium text-gray-300 hover:text-white transition-colors">Sign In</a>
          <a href="/register" class="rounded-xl bg-white/10 backdrop-blur-sm border border-white/10 px-5 py-2.5 text-sm font-semibold text-white hover:bg-white/20 transition-all">
            Start Free
          </a>
        </div>
      </div>
    </nav>

    <!-- Hero -->
    <section class="relative z-10 pt-28 pb-24">
      <div class="mx-auto max-w-7xl px-6">
        <div class="grid lg:grid-cols-2 gap-16 items-center">
          <div class="space-y-8">
            <div class="inline-flex items-center gap-2 rounded-full border border-white/10 bg-white/5 px-4 py-1.5">
              <span class="relative flex h-2 w-2">
                <span class="absolute inline-flex h-full w-full animate-ping rounded-full bg-emerald-400 opacity-75"></span>
                <span class="relative inline-flex h-2 w-2 rounded-full bg-emerald-400"></span>
              </span>
              <span class="text-sm text-gray-300">Now with GPT-5 integration</span>
            </div>

            <h1 class="text-5xl md:text-6xl font-bold text-white leading-tight">
              Your learning journey,
              <span class="block mt-2 bg-gradient-to-r from-blue-400 via-purple-400 to-pink-400 bg-clip-text text-transparent">
                reimagined
              </span>
            </h1>

            <p class="text-lg text-gray-400 leading-relaxed">
              Transform how you learn with AI-generated roadmaps. Build, customize, and track your progress 
              all in one beautiful platform.
            </p>

            <div class="flex flex-col sm:flex-row gap-4">
              <div class="relative flex-1">
                <input
                  type="text"
                  placeholder="What do you want to master?"
                  class="w-full h-14 pl-6 pr-14 rounded-2xl bg-white/5 border border-white/10 text-white placeholder:text-gray-500 focus:border-purple-500 focus:outline-none focus:ring-2 focus:ring-purple-500/20 backdrop-blur-sm"
                />
                <button class="absolute right-4 top-1/2 -translate-y-1/2">
                  <svg class="w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                  </svg>
                </button>
              </div>
              <button class="h-14 px-8 rounded-2xl bg-gradient-to-r from-blue-600 to-purple-600 text-white font-semibold hover:opacity-90 transition-opacity">
                Generate
              </button>
            </div>

            <div class="flex items-center gap-8 pt-4">
              <div class="flex -space-x-3">
                <div class="h-10 w-10 rounded-full bg-gradient-to-br from-pink-500 to-rose-500 border-2 border-[#0f0f12]"></div>
                <div class="h-10 w-10 rounded-full bg-gradient-to-br from-blue-500 to-cyan-500 border-2 border-[#0f0f12]"></div>
                <div class="h-10 w-10 rounded-full bg-gradient-to-br from-emerald-500 to-teal-500 border-2 border-[#0f0f12]"></div>
                <div class="h-10 w-10 rounded-full bg-gradient-to-br from-amber-500 to-orange-500 border-2 border-[#0f0f12]"></div>
              </div>
              <div class="text-sm text-gray-400">
                <span class="text-white font-semibold">5,000+</span> learners
              </div>
            </div>
          </div>

          <!-- Preview Card -->
          <div class="relative">
            <div class="rounded-3xl border border-white/10 bg-white/5 backdrop-blur-xl p-1">
              <div class="rounded-2xl bg-gradient-to-br from-white/5 to-white/0 overflow-hidden">
                <div class="p-6">
                  <!-- Header -->
                  <div class="flex items-center justify-between mb-6">
                    <div class="flex items-center gap-3">
                      <div class="h-12 w-12 rounded-xl bg-gradient-to-br from-blue-500 to-purple-600 flex items-center justify-center">
                        <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" />
                        </svg>
                      </div>
                      <div>
                        <div class="font-semibold text-white">Machine Learning A-Z</div>
                        <div class="text-xs text-gray-400">15 resources • 6 hours</div>
                      </div>
                    </div>
                  </div>

                  <!-- Progress Steps -->
                  <div class="space-y-3">
                    <div class="flex items-center gap-3 p-3 rounded-xl bg-green-500/10 border border-green-500/20">
                      <div class="h-6 w-6 rounded-full bg-green-500 flex items-center justify-center">
                        <svg class="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 20 20">
                          <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                        </svg>
                      </div>
                      <span class="flex-1 text-sm font-medium text-green-400">Python Basics</span>
                    </div>

                    <div class="flex items-center gap-3 p-3 rounded-xl bg-blue-500/10 border border-blue-500/20">
                      <div class="h-6 w-6 rounded-full bg-blue-500 flex items-center justify-center text-white text-xs font-bold">2</div>
                      <span class="flex-1 text-sm font-semibold text-white">Data Science Fundamentals</span>
                    </div>

                    <div class="flex items-center gap-3 p-3 rounded-xl bg-white/5">
                      <div class="h-6 w-6 rounded-full bg-white/10 flex items-center justify-center text-gray-400 text-xs">3</div>
                      <span class="flex-1 text-sm font-medium text-gray-400">ML Algorithms</span>
                    </div>

                    <div class="flex items-center gap-3 p-3 rounded-xl bg-white/5">
                      <div class="h-6 w-6 rounded-full bg-white/10 flex items-center justify-center text-gray-400 text-xs">4</div>
                      <span class="flex-1 text-sm font-medium text-gray-400">Deep Learning</span>
                    </div>
                  </div>

                  <!-- Stats -->
                  <div class="mt-6 flex gap-4">
                    <div class="flex-1 p-4 rounded-xl bg-white/5">
                      <div class="text-2xl font-bold text-white">12</div>
                      <div class="text-xs text-gray-400">Days Streak</div>
                    </div>
                    <div class="flex-1 p-4 rounded-xl bg-white/5">
                      <div class="text-2xl font-bold text-white">68%</div>
                      <div class="text-xs text-gray-400">Completed</div>
                    </div>
                    <div class="flex-1 p-4 rounded-xl bg-white/5">
                      <div class="text-2xl font-bold text-white">850</div>
                      <div class="text-xs text-gray-400">XP Earned</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Features -->
    <section id="features" class="relative z-10 py-24 bg-white/5">
      <div class="mx-auto max-w-7xl px-6">
        <div class="text-center mb-16">
          <h2 class="text-4xl font-bold text-white">
            <span class="bg-gradient-to-r from-blue-400 to-purple-400 bg-clip-text text-transparent">Powerful</span> features
          </h2>
          <p class="mt-4 text-gray-400">Everything you need to learn effectively</p>
        </div>

        <div class="grid md:grid-cols-3 gap-6">
          <div class="group p-8 rounded-3xl bg-white/5 border border-white/10 hover:border-purple-500/50 transition-all">
            <div class="h-14 w-14 rounded-2xl bg-gradient-to-br from-blue-500 to-purple-600 flex items-center justify-center mb-6">
              <svg class="h-7 w-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
              </svg>
            </div>
            <h3 class="text-xl font-semibold text-white mb-3">AI Generation</h3>
            <p class="text-gray-400">Generate complete learning paths in seconds with advanced AI.</p>
          </div>

          <div class="group p-8 rounded-3xl bg-white/5 border border-white/10 hover:border-cyan-500/50 transition-all">
            <div class="h-14 w-14 rounded-2xl bg-gradient-to-br from-cyan-500 to-blue-600 flex items-center justify-center mb-6">
              <svg class="h-7 w-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h7" />
              </svg>
            </div>
            <h3 class="text-xl font-semibold text-white mb-3">Manual Builder</h3>
            <p class="text-gray-400">Create custom paths with your own curated resources.</p>
          </div>

          <div class="group p-8 rounded-3xl bg-white/5 border border-white/10 hover:border-green-500/50 transition-all">
            <div class="h-14 w-14 rounded-2xl bg-gradient-to-br from-green-500 to-emerald-600 flex items-center justify-center mb-6">
              <svg class="h-7 w-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
              </svg>
            </div>
            <h3 class="text-xl font-semibold text-white mb-3">Progress Tracking</h3>
            <p class="text-gray-400">Visual progress with streaks and achievements.</p>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="relative z-10 py-24">
      <div class="mx-auto max-w-3xl px-6 text-center">
        <h2 class="text-4xl font-bold text-white">Start your journey today</h2>
        <p class="mt-4 text-gray-400">Join thousands of learners achieving their goals</p>
        <div class="mt-10">
          <a href="/register" class="inline-block rounded-2xl bg-gradient-to-r from-blue-600 to-purple-600 px-10 py-4 text-lg font-semibold text-white hover:opacity-90 transition-opacity">
            Get Started Free
          </a>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <footer class="relative z-10 border-t border-white/5 bg-black/20 py-8">
      <div class="mx-auto max-w-7xl px-6">
        <div class="flex flex-col md:flex-row items-center justify-between gap-4">
          <div class="flex items-center gap-2">
            <div class="h-8 w-8 rounded-lg bg-gradient-to-br from-blue-500 to-purple-600 flex items-center justify-center">
              <span class="text-sm font-bold text-white">L</span>
            </div>
            <span class="text-lg font-bold text-white">Learnpathly</span>
          </div>
          <p class="text-sm text-gray-500">© 2026 Learnpathly. All rights reserved.</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
// Home5 - UI-UX-Pro-Max Dark Alternative
</script>
