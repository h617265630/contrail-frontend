<template>
  <!-- ============================================
       LANDING PAGE - UI-UX-PRO-MAX STYLE
       Premium, Rich Design with Glassmorphism
       ============================================ -->
  <div class="min-h-screen bg-[#0a0a0f]">
    <!-- Animated Background -->
    <div class="fixed inset-0 overflow-hidden">
      <div class="absolute -left-40 -top-40 h-96 w-96 rounded-full bg-violet-600/20 blur-[128px]"></div>
      <div class="absolute -bottom-40 -right-40 h-96 w-96 rounded-full bg-cyan-500/20 blur-[128px]"></div>
      <div class="absolute left-1/2 top-1/2 h-64 w-64 -translate-x-1/2 -translate-y-1/2 rounded-full bg-blue-600/10 blur-[96px]"></div>
    </div>

    <!-- Navigation -->
    <nav class="relative z-10 border-b border-white/10 backdrop-blur-xl">
      <div class="mx-auto flex h-20 max-w-7xl items-center justify-between px-6">
        <span class="text-2xl font-bold text-white">
          <span class="text-transparent bg-clip-text bg-gradient-to-r from-violet-400 to-cyan-400">Learn</span>pathly
        </span>
        <div class="hidden items-center gap-8 md:flex">
          <a href="#features" class="text-sm text-gray-400 hover:text-white transition-colors">Features</a>
          <a href="#showcase" class="text-sm text-gray-400 hover:text-white transition-colors">Showcase</a>
          <a href="#pricing" class="text-sm text-gray-400 hover:text-white transition-colors">Pricing</a>
        </div>
        <div class="flex items-center gap-4">
          <a href="/login" class="text-sm font-medium text-gray-300 hover:text-white transition-colors">Log in</a>
          <a href="/register" class="relative overflow-hidden rounded-full bg-gradient-to-r from-violet-600 to-cyan-600 px-6 py-2.5 text-sm font-semibold text-white transition-all hover:scale-105 hover:shadow-lg hover:shadow-violet-500/25">
            Get Started
          </a>
        </div>
      </div>
    </nav>

    <!-- Hero Section -->
    <section class="relative z-10 pt-32 pb-24">
      <div class="mx-auto max-w-7xl px-6">
        <div class="grid gap-16 lg:grid-cols-2 lg:items-center">
          <div class="space-y-8">
            <div class="inline-flex items-center gap-2 rounded-full border border-white/10 bg-white/5 px-4 py-1.5">
              <span class="flex h-2 w-2 animate-pulse rounded-full bg-green-400"></span>
              <span class="text-sm text-gray-300">Powered by Advanced AI</span>
            </div>
            
            <h1 class="text-5xl font-bold leading-tight text-white md:text-7xl">
              Learn smarter,
              <span class="block mt-2 text-transparent bg-clip-text bg-gradient-to-r from-violet-400 via-purple-400 to-cyan-400">
                not harder
              </span>
            </h1>
            
            <p class="text-xl leading-relaxed text-gray-400">
              Transform scattered bookmarks, videos, and articles into AI-generated learning paths. 
              Track progress, stay motivated, and actually finish what you start.
            </p>

            <div class="flex flex-col gap-4 sm:flex-row">
              <div class="relative flex-1">
                <input
                  type="text"
                  placeholder="What do you want to learn?"
                  class="w-full h-14 pl-6 pr-4 rounded-2xl bg-white/5 border border-white/10 text-white placeholder:text-gray-500 focus:border-violet-500 focus:outline-none focus:ring-2 focus:ring-violet-500/20 backdrop-blur-sm"
                />
                <div class="absolute right-3 top-1/2 -translate-y-1/2">
                  <svg class="w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                  </svg>
                </div>
              </div>
              <button class="h-14 shrink-0 px-8 rounded-2xl bg-gradient-to-r from-violet-600 to-cyan-600 text-white font-semibold hover:scale-105 transition-transform hover:shadow-lg hover:shadow-violet-500/25">
                Generate Path
              </button>
            </div>

            <div class="flex items-center gap-6 pt-4">
              <div class="flex -space-x-3">
                <div class="h-10 w-10 rounded-full bg-gradient-to-br from-pink-500 to-orange-400 border-2 border-[#0a0a0f]"></div>
                <div class="h-10 w-10 rounded-full bg-gradient-to-br from-blue-500 to-purple-500 border-2 border-[#0a0a0f]"></div>
                <div class="h-10 w-10 rounded-full bg-gradient-to-br from-green-500 to-teal-400 border-2 border-[#0a0a0f]"></div>
                <div class="flex h-10 w-10 items-center justify-center rounded-full bg-white/10 border-2 border-[#0a0a0f] text-xs font-semibold text-white">+2k</div>
              </div>
              <div class="text-sm text-gray-400">
                <span class="text-white font-semibold">2,000+</span> learners joined this month
              </div>
            </div>
          </div>

          <!-- Glass Card Preview -->
          <div class="relative">
            <div class="relative rounded-3xl border border-white/10 bg-white/5 backdrop-blur-xl p-2">
              <div class="rounded-2xl bg-gradient-to-br from-white/10 to-white/5 overflow-hidden">
                <!-- Mock UI -->
                <div class="p-6">
                  <div class="flex items-center justify-between mb-6">
                    <div class="h-8 w-32 rounded-lg bg-gradient-to-r from-violet-500/50 to-cyan-500/50"></div>
                    <div class="flex gap-2">
                      <div class="h-8 w-8 rounded-lg bg-white/10"></div>
                      <div class="h-8 w-8 rounded-lg bg-white/10"></div>
                    </div>
                  </div>
                  
                  <div class="space-y-4">
                    <div class="p-4 rounded-xl bg-white/5 border border-white/10">
                      <div class="flex items-center gap-4">
                        <div class="h-12 w-12 rounded-xl bg-gradient-to-br from-violet-500 to-purple-600 flex items-center justify-center">
                          <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z" />
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                          </svg>
                        </div>
                        <div class="flex-1">
                          <div class="h-4 w-2/3 rounded bg-white/20 mb-2"></div>
                          <div class="h-3 w-1/2 rounded bg-white/10"></div>
                        </div>
                        <div class="h-6 w-6 rounded-full bg-green-500/50 flex items-center justify-center">
                          <svg class="w-4 h-4 text-green-400" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                          </svg>
                        </div>
                      </div>
                    </div>
                    
                    <div class="p-4 rounded-xl bg-white/5 border border-white/10">
                      <div class="flex items-center gap-4">
                        <div class="h-12 w-12 rounded-xl bg-gradient-to-br from-cyan-500 to-blue-600 flex items-center justify-center">
                          <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                          </svg>
                        </div>
                        <div class="flex-1">
                          <div class="h-4 w-3/4 rounded bg-white/20 mb-2"></div>
                          <div class="h-3 w-1/2 rounded bg-white/10"></div>
                        </div>
                        <div class="h-6 w-6 rounded-full bg-yellow-500/50"></div>
                      </div>
                    </div>

                    <div class="p-4 rounded-xl bg-white/5 border border-white/10">
                      <div class="flex items-center gap-4">
                        <div class="h-12 w-12 rounded-xl bg-gradient-to-br from-orange-500 to-pink-600 flex items-center justify-center">
                          <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z" />
                          </svg>
                        </div>
                        <div class="flex-1">
                          <div class="h-4 w-2/3 rounded bg-white/20 mb-2"></div>
                          <div class="h-3 w-1/2 rounded bg-white/10"></div>
                        </div>
                        <div class="h-6 w-6 rounded-full bg-blue-500/50"></div>
                      </div>
                    </div>
                  </div>

                  <!-- Progress Bar -->
                  <div class="mt-6 p-4 rounded-xl bg-white/5 border border-white/10">
                    <div class="flex items-center justify-between mb-2">
                      <span class="text-sm text-gray-400">Overall Progress</span>
                      <span class="text-sm font-semibold text-white">67%</span>
                    </div>
                    <div class="h-2 rounded-full bg-white/10 overflow-hidden">
                      <div class="h-full w-[67%] rounded-full bg-gradient-to-r from-violet-500 to-cyan-500"></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Floating Elements -->
            <div class="absolute -top-6 -right-6 rounded-2xl bg-gradient-to-br from-violet-600 to-purple-700 p-4 shadow-2xl shadow-violet-500/30">
              <div class="flex items-center gap-3">
                <div class="h-10 w-10 rounded-xl bg-white/20 flex items-center justify-center">
                  <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                  </svg>
                </div>
                <div>
                  <div class="text-sm font-semibold text-white">AI Generated</div>
                  <div class="text-xs text-gray-300">in 2.3 seconds</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="relative z-10 py-24 bg-white/5">
      <div class="mx-auto max-w-7xl px-6">
        <div class="mb-16 text-center">
          <h2 class="text-4xl font-bold text-white md:text-5xl">
            <span class="text-transparent bg-clip-text bg-gradient-to-r from-violet-400 to-cyan-400">Powerful</span> features
          </h2>
          <p class="mt-4 text-xl text-gray-400">Everything you need to transform your learning</p>
        </div>

        <div class="grid gap-6 md:grid-cols-3">
          <div class="group relative rounded-3xl border border-white/10 bg-white/5 p-8 backdrop-blur-sm transition-all hover:border-violet-500/50 hover:bg-white/10">
            <div class="absolute inset-0 rounded-3xl bg-gradient-to-br from-violet-500/20 to-transparent opacity-0 transition-opacity group-hover:opacity-100"></div>
            <div class="relative">
              <div class="mb-6 inline-flex h-14 w-14 items-center justify-center rounded-2xl bg-gradient-to-br from-violet-500 to-purple-600">
                <svg class="h-7 w-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
                </svg>
              </div>
              <h3 class="mb-3 text-xl font-semibold text-white">AI Generation</h3>
              <p class="text-gray-400">Instantly generate comprehensive learning paths with cutting-edge AI technology.</p>
            </div>
          </div>

          <div class="group relative rounded-3xl border border-white/10 bg-white/5 p-8 backdrop-blur-sm transition-all hover:border-cyan-500/50 hover:bg-white/10">
            <div class="absolute inset-0 rounded-3xl bg-gradient-to-br from-cyan-500/20 to-transparent opacity-0 transition-opacity group-hover:opacity-100"></div>
            <div class="relative">
              <div class="mb-6 inline-flex h-14 w-14 items-center justify-center rounded-2xl bg-gradient-to-br from-cyan-500 to-blue-600">
                <svg class="h-7 w-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h7" />
                </svg>
              </div>
              <h3 class="mb-3 text-xl font-semibold text-white">Manual Builder</h3>
              <p class="text-gray-400">Create custom paths with your own curated resources in any order you choose.</p>
            </div>
          </div>

          <div class="group relative rounded-3xl border border-white/10 bg-white/5 p-8 backdrop-blur-sm transition-all hover:border-green-500/50 hover:bg-white/10">
            <div class="absolute inset-0 rounded-3xl bg-gradient-to-br from-green-500/20 to-transparent opacity-0 transition-opacity group-hover:opacity-100"></div>
            <div class="relative">
              <div class="mb-6 inline-flex h-14 w-14 items-center justify-center rounded-2xl bg-gradient-to-br from-green-500 to-teal-600">
                <svg class="h-7 w-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                </svg>
              </div>
              <h3 class="mb-3 text-xl font-semibold text-white">Progress Tracking</h3>
              <p class="text-gray-400">Visual progress tracking keeps you motivated until you complete your goals.</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="relative z-10 py-24">
      <div class="mx-auto max-w-4xl px-6 text-center">
        <h2 class="text-4xl font-bold text-white md:text-5xl">Ready to transform your learning?</h2>
        <p class="mt-6 text-xl text-gray-400">Join thousands of learners who are already achieving their goals</p>
        <div class="mt-10">
          <a href="/register" class="inline-block rounded-2xl bg-gradient-to-r from-violet-600 to-cyan-600 px-10 py-4 text-lg font-semibold text-white hover:scale-105 transition-transform hover:shadow-lg hover:shadow-violet-500/25">
            Start Learning for Free
          </a>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <footer class="relative z-10 border-t border-white/10 bg-black/20 py-8">
      <div class="mx-auto max-w-7xl px-6">
        <div class="flex flex-col items-center justify-between gap-4 md:flex-row">
          <span class="text-xl font-bold text-white">
            <span class="text-transparent bg-clip-text bg-gradient-to-r from-violet-400 to-cyan-400">Learn</span>pathly
          </span>
          <p class="text-sm text-gray-500">© 2026 Learnpathly. All rights reserved.</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
// UI-UX-Pro-Max Style Landing Page
// Premium dark theme with glassmorphism and gradients
</script>
