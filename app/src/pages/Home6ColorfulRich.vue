<template>
  <!-- ============================================
       LANDING PAGE 6 - UI-UX-PRO-MAX-PLUS STYLE
       Colorful Premium Alternative
       ============================================ -->
  <div class="min-h-screen bg-gradient-to-br from-slate-50 via-white to-blue-50">
    <!-- Header -->
    <header class="sticky top-0 z-50 bg-white/80 backdrop-blur-lg border-b border-slate-200/50">
      <div class="mx-auto flex h-18 items-center justify-between px-6 py-4 max-w-7xl">
        <div class="flex items-center gap-3">
          <div class="flex h-10 w-10 items-center justify-center rounded-2xl bg-gradient-to-br from-orange-500 via-pink-500 to-purple-600 shadow-lg shadow-purple-500/25">
            <span class="text-lg font-bold text-white">L</span>
          </div>
          <span class="text-2xl font-bold bg-gradient-to-r from-slate-900 to-slate-700 bg-clip-text text-transparent">Learnpathly</span>
        </div>

        <div class="hidden md:flex items-center gap-8">
          <a href="#features" class="text-sm font-medium text-slate-600 hover:text-slate-900 transition-colors">Features</a>
          <a href="#how-it-works" class="text-sm font-medium text-slate-600 hover:text-slate-900 transition-colors">How It Works</a>
          <a href="#testimonials" class="text-sm font-medium text-slate-600 hover:text-slate-900 transition-colors">Testimonials</a>
        </div>

        <div class="flex items-center gap-4">
          <a href="/login" class="text-sm font-semibold text-slate-700 hover:text-slate-900">Log in</a>
          <a href="/register" class="rounded-2xl bg-gradient-to-r from-orange-500 via-pink-500 to-purple-600 px-6 py-2.5 text-sm font-bold text-white shadow-lg shadow-purple-500/25 hover:shadow-xl hover:scale-105 transition-all">
            Try Free
          </a>
        </div>
      </div>
    </header>

    <!-- Hero -->
    <section class="pt-24 pb-20 overflow-hidden">
      <!-- Decorative elements -->
      <div class="absolute top-20 right-10 w-72 h-72 bg-gradient-to-br from-purple-200 to-pink-200 rounded-full blur-3xl opacity-50"></div>
      <div class="absolute bottom-10 left-10 w-96 h-96 bg-gradient-to-br from-blue-200 to-cyan-200 rounded-full blur-3xl opacity-50"></div>

      <div class="relative mx-auto max-w-7xl px-6">
        <div class="grid lg:grid-cols-12 gap-12 items-center">
          <!-- Left Content -->
          <div class="lg:col-span-6">
            <div class="inline-flex items-center gap-2 rounded-full border border-orange-200 bg-orange-50 px-4 py-1.5 mb-6">
              <span class="relative flex h-2 w-2">
                <span class="absolute inline-flex h-full w-full animate-ping rounded-full bg-orange-500 opacity-75"></span>
                <span class="relative inline-flex h-2 w-2 rounded-full bg-orange-500"></span>
              </span>
              <span class="text-sm font-semibold text-orange-700">New: GPT-5 Integration</span>
            </div>

            <h1 class="text-5xl md:text-6xl lg:text-7xl font-bold text-slate-900 leading-[1.1]">
              Learn smarter,
              <span class="block mt-2 bg-gradient-to-r from-orange-500 via-pink-500 to-purple-600 bg-clip-text text-transparent">
                achieve more
              </span>
            </h1>

            <p class="mt-6 text-xl text-slate-600 leading-relaxed max-w-lg">
              Turn any topic into a structured learning path. AI generates your roadmap, you focus on learning. 
              Track progress, stay motivated, and reach your goals.
            </p>

            <div class="mt-8 flex flex-col sm:flex-row items-start gap-4">
              <div class="relative flex-1 w-full">
                <input
                  type="text"
                  placeholder="What do you want to learn?"
                  class="w-full h-14 pl-6 pr-14 rounded-2xl border-2 border-slate-200 bg-white text-slate-900 placeholder:text-slate-400 focus:border-purple-500 focus:outline-none transition-colors shadow-sm"
                />
                <button class="absolute right-4 top-1/2 -translate-y-1/2 p-1">
                  <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                  </svg>
                </button>
              </div>
              <button class="h-14 px-8 rounded-2xl bg-gradient-to-r from-orange-500 via-pink-500 to-purple-600 text-white font-bold hover:shadow-xl hover:scale-105 transition-all shadow-lg shadow-purple-500/25">
                Generate
              </button>
            </div>

            <div class="mt-8 flex items-center gap-4">
              <div class="flex -space-x-2">
                <img src="https://i.pravatar.cc/100?img=5" alt="" class="h-10 w-10 rounded-full border-3 border-white" />
                <img src="https://i.pravatar.cc/100?img=6" alt="" class="h-10 w-10 rounded-full border-3 border-white" />
                <img src="https://i.pravatar.cc/100?img=7" alt="" class="h-10 w-10 rounded-full border-3 border-white" />
                <img src="https://i.pravatar.cc/100?img=8" alt="" class="h-10 w-10 rounded-full border-3 border-white" />
              </div>
              <div class="text-sm text-slate-600">
                <span class="font-bold text-slate-900">8,000+</span> happy learners
              </div>
            </div>
          </div>

          <!-- Right Visual -->
          <div class="lg:col-span-6">
            <div class="relative">
              <!-- Main Card -->
              <div class="relative rounded-[2.5rem] bg-white shadow-2xl shadow-slate-200/50 p-2">
                <div class="rounded-[2rem] bg-gradient-to-br from-slate-50 to-white overflow-hidden">
                  <!-- Mock App Header -->
                  <div class="p-6 border-b border-slate-100">
                    <div class="flex items-center justify-between">
                      <div class="flex items-center gap-3">
                        <div class="h-12 w-12 rounded-2xl bg-gradient-to-br from-orange-500 to-pink-600 flex items-center justify-center shadow-lg">
                          <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                          </svg>
                        </div>
                        <div>
                          <div class="font-bold text-slate-900">UI/UX Design Masterclass</div>
                          <div class="text-xs text-slate-500">20 resources • 8 hours</div>
                        </div>
                      </div>
                      <div class="flex gap-2">
                        <div class="h-8 w-8 rounded-xl bg-slate-100"></div>
                        <div class="h-8 w-8 rounded-xl bg-slate-100"></div>
                      </div>
                    </div>
                  </div>

                  <!-- Content -->
                  <div class="p-6 space-y-4">
                    <!-- Progress -->
                    <div class="rounded-2xl bg-gradient-to-r from-orange-50 to-pink-50 p-4 border border-orange-100">
                      <div class="flex items-center justify-between mb-2">
                        <span class="text-sm font-semibold text-slate-700">Weekly Progress</span>
                        <span class="text-sm font-bold text-orange-600">75%</span>
                      </div>
                      <div class="h-3 bg-white rounded-full overflow-hidden">
                        <div class="h-full w-[75%] rounded-full bg-gradient-to-r from-orange-500 to-pink-500"></div>
                      </div>
                      <div class="mt-2 flex items-center justify-between text-xs text-slate-500">
                        <span>5/7 days completed</span>
                        <span class="font-semibold text-green-600">🔥 5 day streak!</span>
                      </div>
                    </div>

                    <!-- Steps -->
                    <div class="space-y-3">
                      <div class="flex items-center gap-3 p-4 rounded-2xl bg-green-50 border-2 border-green-500">
                        <div class="h-8 w-8 rounded-full bg-green-500 flex items-center justify-center">
                          <svg class="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                          </svg>
                        </div>
                        <div class="flex-1">
                          <div class="font-semibold text-slate-900">Design Principles</div>
                          <div class="text-xs text-slate-500">Completed • +100 XP</div>
                        </div>
                      </div>

                      <div class="flex items-center gap-3 p-4 rounded-2xl bg-gradient-to-r from-orange-50 to-pink-50 border-2 border-orange-400">
                        <div class="h-8 w-8 rounded-full bg-gradient-to-r from-orange-500 to-pink-500 flex items-center justify-center text-white font-bold text-sm">2</div>
                        <div class="flex-1">
                          <div class="font-semibold text-slate-900">User Research Methods</div>
                          <div class="text-xs text-orange-600 font-medium">In Progress • +150 XP</div>
                        </div>
                      </div>

                      <div class="flex items-center gap-3 p-4 rounded-2xl bg-slate-50">
                        <div class="h-8 w-8 rounded-full bg-slate-200 flex items-center justify-center text-slate-500 font-bold text-sm">3</div>
                        <div class="flex-1">
                          <div class="font-medium text-slate-400">Wireframing & Prototyping</div>
                        </div>
                      </div>
                    </div>

                    <!-- Achievement Badge -->
                    <div class="rounded-2xl bg-gradient-to-r from-amber-100 to-orange-100 p-4 border border-amber-200">
                      <div class="flex items-center gap-3">
                        <div class="h-12 w-12 rounded-xl bg-gradient-to-br from-amber-400 to-orange-500 flex items-center justify-center shadow-lg">
                          <svg class="w-6 h-6 text-white" fill="currentColor" viewBox="0 0 20 20">
                            <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                          </svg>
                        </div>
                        <div>
                          <div class="font-bold text-slate-900">Achievement Unlocked!</div>
                          <div class="text-sm text-slate-600">Week Warrior - 7 day streak</div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Floating Badge -->
              <div class="absolute -right-4 top-10 rounded-2xl bg-white p-4 shadow-xl">
                <div class="flex items-center gap-3">
                  <div class="h-10 w-10 rounded-xl bg-gradient-to-br from-green-400 to-emerald-500 flex items-center justify-center">
                    <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
                    </svg>
                  </div>
                  <div>
                    <div class="text-sm font-bold text-slate-900">+250 XP</div>
                    <div class="text-xs text-slate-500">Level up!</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Features -->
    <section id="features" class="py-24 bg-white">
      <div class="mx-auto max-w-7xl px-6">
        <div class="text-center mb-16">
          <h2 class="text-4xl md:text-5xl font-bold text-slate-900">Why learners love us</h2>
          <p class="mt-4 text-xl text-slate-600">Powerful features, beautiful design</p>
        </div>

        <div class="grid md:grid-cols-3 gap-8">
          <div class="group rounded-3xl bg-gradient-to-br from-orange-50 to-pink-50 p-8 border border-orange-100 hover:shadow-xl transition-all">
            <div class="h-14 w-14 rounded-2xl bg-gradient-to-br from-orange-500 to-pink-500 flex items-center justify-center mb-6 shadow-lg">
              <svg class="h-7 w-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
              </svg>
            </div>
            <h3 class="text-xl font-bold text-slate-900 mb-3">Lightning Fast AI</h3>
            <p class="text-slate-600">Generate comprehensive learning paths in seconds with our advanced AI.</p>
          </div>

          <div class="group rounded-3xl bg-gradient-to-br from-purple-50 to-blue-50 p-8 border border-purple-100 hover:shadow-xl transition-all">
            <div class="h-14 w-14 rounded-2xl bg-gradient-to-br from-purple-500 to-blue-500 flex items-center justify-center mb-6 shadow-lg">
              <svg class="h-7 w-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h7" />
              </svg>
            </div>
            <h3 class="text-xl font-bold text-slate-900 mb-3">Full Customization</h3>
            <p class="text-slate-600">Build custom paths with your own resources in any order you prefer.</p>
          </div>

          <div class="group rounded-3xl bg-gradient-to-br from-green-50 to-teal-50 p-8 border border-green-100 hover:shadow-xl transition-all">
            <div class="h-14 w-14 rounded-2xl bg-gradient-to-br from-green-500 to-teal-500 flex items-center justify-center mb-6 shadow-lg">
              <svg class="h-7 w-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
              </svg>
            </div>
            <h3 class="text-xl font-bold text-slate-900 mb-3">Gamified Progress</h3>
            <p class="text-slate-600">Earn XP, unlock achievements, and maintain streaks to stay motivated.</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Stats -->
    <section class="py-16 bg-gradient-to-r from-slate-900 via-purple-900 to-slate-900">
      <div class="mx-auto max-w-7xl px-6">
        <div class="grid md:grid-cols-4 gap-8 text-center">
          <div>
            <div class="text-4xl md:text-5xl font-bold text-white">10K+</div>
            <div class="mt-2 text-purple-300">Active Learners</div>
          </div>
          <div>
            <div class="text-4xl md:text-5xl font-bold text-white">8K+</div>
            <div class="mt-2 text-purple-300">Paths Created</div>
          </div>
          <div>
            <div class="text-4xl md:text-5xl font-bold text-white">95%</div>
            <div class="mt-2 text-purple-300">Completion Rate</div>
          </div>
          <div>
            <div class="text-4xl md:text-5xl font-bold text-white">4.9</div>
            <div class="mt-2 text-purple-300">User Rating</div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="py-24 bg-white">
      <div class="mx-auto max-w-3xl px-6 text-center">
        <h2 class="text-4xl md:text-5xl font-bold text-slate-900">Ready to start learning?</h2>
        <p class="mt-6 text-xl text-slate-600">Join thousands of learners who are achieving their goals</p>
        <div class="mt-10">
          <a href="/register" class="inline-block rounded-2xl bg-gradient-to-r from-orange-500 via-pink-500 to-purple-600 px-10 py-5 text-xl font-bold text-white shadow-xl shadow-purple-500/25 hover:shadow-2xl hover:scale-105 transition-all">
            Get Started for Free
          </a>
        </div>
        <p class="mt-4 text-sm text-slate-500">No credit card required • 2-minute setup</p>
      </div>
    </section>

    <!-- Footer -->
    <footer class="bg-slate-50 py-12 border-t border-slate-200">
      <div class="mx-auto max-w-7xl px-6">
        <div class="flex flex-col md:flex-row items-center justify-between gap-4">
          <div class="flex items-center gap-2">
            <div class="h-8 w-8 rounded-xl bg-gradient-to-br from-orange-500 to-pink-600 flex items-center justify-center">
              <span class="text-sm font-bold text-white">L</span>
            </div>
            <span class="text-lg font-bold text-slate-900">Learnpathly</span>
          </div>
          <p class="text-sm text-slate-500">© 2026 Learnpathly. All rights reserved.</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
// Home6 - UI-UX-Pro-Max-Plus Colorful Alternative
</script>
