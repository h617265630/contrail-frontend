<template>
  <!-- ============================================
       LANDING PAGE - UI-UX-PRO-MAX-PLUS STYLE
       Rich, Colorful, Premium SaaS Style
       ============================================ -->
  <div class="min-h-screen bg-[#f8fafc]">
    <!-- Navigation -->
    <nav class="sticky top-0 z-50 border-b border-slate-200 bg-white/90 backdrop-blur-md">
      <div class="mx-auto flex h-18 items-center justify-between px-6 py-4 max-w-7xl">
        <div class="flex items-center gap-2">
          <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-gradient-to-br from-indigo-500 to-violet-600">
            <span class="text-lg font-bold text-white">L</span>
          </div>
          <span class="text-xl font-bold text-slate-900">Learnpathly</span>
        </div>
        
        <div class="hidden items-center gap-8 md:flex">
          <a href="#features" class="text-sm font-medium text-slate-600 hover:text-slate-900 transition-colors">Features</a>
          <a href="#how-it-works" class="text-sm font-medium text-slate-600 hover:text-slate-900 transition-colors">How it Works</a>
          <a href="#testimonials" class="text-sm font-medium text-slate-600 hover:text-slate-900 transition-colors">Testimonials</a>
        </div>

        <div class="flex items-center gap-3">
          <a href="/login" class="text-sm font-semibold text-slate-700 hover:text-slate-900">Log in</a>
          <a href="/register" class="rounded-xl bg-slate-900 px-5 py-2.5 text-sm font-semibold text-white hover:bg-slate-800 transition-colors shadow-lg shadow-slate-900/20">
            Get Started Free
          </a>
        </div>
      </div>
    </nav>

    <!-- Hero Section -->
    <section class="relative overflow-hidden pt-20 pb-24">
      <!-- Background Pattern -->
      <div class="absolute inset-0 opacity-50">
        <div class="absolute right-0 top-20 h-[500px] w-[500px] rounded-full bg-gradient-to-br from-indigo-100 to-purple-100 blur-3xl"></div>
        <div class="absolute -left-20 bottom-0 h-[400px] w-[400px] rounded-full bg-gradient-to-br from-cyan-100 to-blue-100 blur-3xl"></div>
      </div>

      <div class="relative mx-auto max-w-7xl px-6">
        <div class="grid gap-12 lg:grid-cols-12 lg:items-center">
          <!-- Left Content -->
          <div class="lg:col-span-7">
            <div class="inline-flex items-center gap-2 rounded-full border border-indigo-200 bg-indigo-50 px-4 py-1.5">
              <span class="relative flex h-2 w-2">
                <span class="absolute inline-flex h-full w-full animate-ping rounded-full bg-indigo-500 opacity-75"></span>
                <span class="relative inline-flex h-2 w-2 rounded-full bg-indigo-500"></span>
              </span>
              <span class="text-sm font-medium text-indigo-700">AI-Powered Platform</span>
            </div>

            <h1 class="mt-6 text-5xl font-bold leading-tight text-slate-900 md:text-6xl lg:text-7xl">
              Build learning paths that
              <span class="relative">
                <span class="relative z-10 text-indigo-600">actually work</span>
                <span class="absolute bottom-2 left-0 h-3 w-full bg-indigo-300/50 -z-0"></span>
              </span>
            </h1>

            <p class="mt-6 text-xl leading-relaxed text-slate-600 max-w-xl">
              Stop collecting bookmarks. Start building structured learning paths with AI or manually. 
              Track progress, stay accountable, and complete your learning goals.
            </p>

            <div class="mt-8 flex flex-col gap-4 sm:flex-row">
              <div class="relative flex-1">
                <input
                  type="text"
                  placeholder="What do you want to learn?"
                  class="h-14 w-full rounded-2xl border-2 border-slate-200 bg-white pl-6 pr-14 text-slate-900 placeholder:text-slate-400 focus:border-indigo-500 focus:outline-none transition-colors"
                />
                <button class="absolute right-2 top-1/2 -translate-y-1/2 p-2">
                  <svg class="h-6 w-6 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                  </svg>
                </button>
              </div>
              <button class="h-14 shrink-0 rounded-2xl bg-indigo-600 px-8 font-semibold text-white hover:bg-indigo-700 transition-colors shadow-xl shadow-indigo-600/20">
                Generate
              </button>
            </div>

            <div class="mt-8 flex items-center gap-4">
              <div class="flex -space-x-2">
                <img src="https://i.pravatar.cc/100?img=1" alt="" class="h-10 w-10 rounded-full border-2 border-white" />
                <img src="https://i.pravatar.cc/100?img=2" alt="" class="h-10 w-10 rounded-full border-2 border-white" />
                <img src="https://i.pravatar.cc/100?img=3" alt="" class="h-10 w-10 rounded-full border-2 border-white" />
                <img src="https://i.pravatar.cc/100?img=4" alt="" class="h-10 w-10 rounded-full border-2 border-white" />
              </div>
              <div class="text-sm text-slate-600">
                <span class="font-semibold text-slate-900">2,500+</span> happy learners
              </div>
            </div>
          </div>

          <!-- Right Visual -->
          <div class="lg:col-span-5">
            <div class="relative">
              <!-- Main Card -->
              <div class="rounded-3xl bg-white p-6 shadow-2xl shadow-slate-200/50">
                <div class="rounded-2xl bg-gradient-to-br from-slate-50 to-slate-100 p-5">
                  <!-- Header -->
                  <div class="mb-5 flex items-center justify-between">
                    <div class="flex items-center gap-3">
                      <div class="h-10 w-10 rounded-xl bg-gradient-to-br from-indigo-500 to-violet-600 flex items-center justify-center">
                        <svg class="h-5 w-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                        </svg>
                      </div>
                      <div>
                        <div class="font-semibold text-slate-900">Python for Data Science</div>
                        <div class="text-xs text-slate-500">12 resources • 3 hours</div>
                      </div>
                    </div>
                    <button class="rounded-lg p-2 hover:bg-slate-100">
                      <svg class="h-5 w-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z" />
                      </svg>
                    </button>
                  </div>

                  <!-- Progress -->
                  <div class="mb-5 rounded-xl bg-slate-100 p-4">
                    <div class="flex items-center justify-between mb-2">
                      <span class="text-sm font-medium text-slate-700">Progress</span>
                      <span class="text-sm font-bold text-indigo-600">65%</span>
                    </div>
                    <div class="h-2.5 rounded-full bg-slate-200 overflow-hidden">
                      <div class="h-full w-[65%] rounded-full bg-gradient-to-r from-indigo-500 to-violet-500"></div>
                    </div>
                  </div>

                  <!-- Steps -->
                  <div class="space-y-3">
                    <div class="flex items-center gap-3 rounded-xl bg-green-50 p-3">
                      <div class="flex h-7 w-7 items-center justify-center rounded-full bg-green-500">
                        <svg class="h-4 w-4 text-white" fill="currentColor" viewBox="0 0 20 20">
                          <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                        </svg>
                      </div>
                      <span class="flex-1 text-sm font-medium text-slate-700">Python Basics</span>
                      <span class="text-xs text-green-600 font-medium">Done</span>
                    </div>

                    <div class="flex items-center gap-3 rounded-xl bg-white border-2 border-indigo-500 p-3">
                      <div class="flex h-7 w-7 items-center justify-center rounded-full bg-indigo-500 text-white text-sm font-bold">3</div>
                      <span class="flex-1 text-sm font-semibold text-slate-900">Data Analysis with Pandas</span>
                      <span class="text-xs text-indigo-600 font-medium">In Progress</span>
                    </div>

                    <div class="flex items-center gap-3 rounded-xl bg-slate-50 p-3">
                      <div class="flex h-7 w-7 items-center justify-center rounded-full bg-slate-200 text-sm font-medium text-slate-500">4</div>
                      <span class="flex-1 text-sm font-medium text-slate-600">Machine Learning Intro</span>
                    </div>

                    <div class="flex items-center gap-3 rounded-xl bg-slate-50 p-3">
                      <div class="flex h-7 w-7 items-center justify-center rounded-full bg-slate-200 text-sm font-medium text-slate-500">5</div>
                      <span class="flex-1 text-sm font-medium text-slate-600">Build Your First Project</span>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Floating Cards -->
              <div class="absolute -right-4 top-4 rounded-2xl bg-white p-4 shadow-xl">
                <div class="flex items-center gap-3">
                  <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-amber-100">
                    <svg class="h-5 w-5 text-amber-600" fill="currentColor" viewBox="0 0 20 20">
                      <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                    </svg>
                  </div>
                  <div>
                    <div class="text-sm font-bold text-slate-900">Streak: 7 days</div>
                    <div class="text-xs text-slate-500">Keep it up!</div>
                  </div>
                </div>
              </div>

              <div class="absolute -bottom-4 -left-4 rounded-2xl bg-white p-4 shadow-xl">
                <div class="flex items-center gap-3">
                  <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-emerald-100">
                    <svg class="h-5 w-5 text-emerald-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
                    </svg>
                  </div>
                  <div>
                    <div class="text-sm font-bold text-slate-900">+150 XP</div>
                    <div class="text-xs text-slate-500">Level up!</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="bg-white py-24">
      <div class="mx-auto max-w-7xl px-6">
        <div class="text-center">
          <h2 class="text-4xl font-bold text-slate-900">Everything you need to learn</h2>
          <p class="mt-4 text-xl text-slate-600">Powerful features designed for modern learners</p>
        </div>

        <div class="mt-16 grid gap-8 md:grid-cols-3">
          <!-- Feature 1 -->
          <div class="group rounded-3xl border-2 border-slate-100 bg-white p-8 transition-all hover:border-indigo-500 hover:shadow-xl">
            <div class="mb-6 inline-flex h-14 w-14 items-center justify-center rounded-2xl bg-indigo-100 group-hover:bg-indigo-500 transition-colors">
              <svg class="h-7 w-7 text-indigo-600 group-hover:text-white transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
              </svg>
            </div>
            <h3 class="text-xl font-bold text-slate-900">AI Generation</h3>
            <p class="mt-3 text-slate-600 leading-relaxed">
              Generate comprehensive learning paths in seconds with our advanced AI. Just enter your topic and get a structured roadmap.
            </p>
          </div>

          <!-- Feature 2 -->
          <div class="group rounded-3xl border-2 border-slate-100 bg-white p-8 transition-all hover:border-violet-500 hover:shadow-xl">
            <div class="mb-6 inline-flex h-14 w-14 items-center justify-center rounded-2xl bg-violet-100 group-hover:bg-violet-500 transition-colors">
              <svg class="h-7 w-7 text-violet-600 group-hover:text-white transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h7" />
              </svg>
            </div>
            <h3 class="text-xl font-bold text-slate-900">Manual Builder</h3>
            <p class="mt-3 text-slate-600 leading-relaxed">
              Build custom paths with your own curated resources. Add videos, articles, and documents in any order you prefer.
            </p>
          </div>

          <!-- Feature 3 -->
          <div class="group rounded-3xl border-2 border-slate-100 bg-white p-8 transition-all hover:border-emerald-500 hover:shadow-xl">
            <div class="mb-6 inline-flex h-14 w-14 items-center justify-center rounded-2xl bg-emerald-100 group-hover:bg-emerald-500 transition-colors">
              <svg class="h-7 w-7 text-emerald-600 group-hover:text-white transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
              </svg>
            </div>
            <h3 class="text-xl font-bold text-slate-900">Progress Tracking</h3>
            <p class="mt-3 text-slate-600 leading-relaxed">
              Track your progress with visual dashboards. Stay motivated with streaks, XP, and completion milestones.
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- Stats Section -->
    <section class="bg-slate-900 py-16">
      <div class="mx-auto max-w-7xl px-6">
        <div class="grid gap-8 text-center md:grid-cols-3">
          <div>
            <div class="text-4xl font-bold text-white md:text-5xl">10K+</div>
            <div class="mt-2 text-lg text-slate-400">Active Learners</div>
          </div>
          <div>
            <div class="text-4xl font-bold text-white md:text-5xl">5K+</div>
            <div class="mt-2 text-lg text-slate-400">Learning Paths Created</div>
          </div>
          <div>
            <div class="text-4xl font-bold text-white md:text-5xl">95%</div>
            <div class="mt-2 text-lg text-slate-400">Completion Rate</div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="bg-gradient-to-br from-indigo-600 to-violet-700 py-24">
      <div class="mx-auto max-w-3xl px-6 text-center">
        <h2 class="text-4xl font-bold text-white">Start your learning journey today</h2>
        <p class="mt-6 text-xl text-indigo-100">
          Join thousands of learners who are already achieving their goals with Learnpathly
        </p>
        <div class="mt-10">
          <a href="/register" class="inline-block rounded-2xl bg-white px-10 py-4 text-lg font-bold text-indigo-600 hover:bg-indigo-50 transition-colors shadow-xl">
            Get Started for Free
          </a>
        </div>
        <p class="mt-4 text-sm text-indigo-200">No credit card required</p>
      </div>
    </section>

    <!-- Footer -->
    <footer class="bg-white border-t border-slate-200 py-12">
      <div class="mx-auto max-w-7xl px-6">
        <div class="flex flex-col items-center justify-between gap-4 md:flex-row">
          <div class="flex items-center gap-2">
            <div class="flex h-8 w-8 items-center justify-center rounded-xl bg-gradient-to-br from-indigo-500 to-violet-600">
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
// UI-UX-Pro-Max-Plus Style Landing Page
// Rich, colorful premium SaaS style with modern gradients
</script>
