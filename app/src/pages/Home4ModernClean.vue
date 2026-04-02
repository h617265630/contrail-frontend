<template>
  <!-- ============================================
       LANDING PAGE 4 - UI-UX-DESIGN STYLE
       Alternative Modern Clean Design
       ============================================ -->
  <div class="min-h-screen bg-white">
    <!-- Header -->
    <header class="fixed top-0 left-0 right-0 z-50 bg-white/95 backdrop-blur-sm border-b border-gray-100">
      <div class="mx-auto flex h-16 max-w-6xl items-center justify-between px-4">
        <div class="flex items-center gap-2">
          <div class="h-8 w-8 rounded-lg bg-blue-600 flex items-center justify-center">
            <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
            </svg>
          </div>
          <span class="text-lg font-bold text-gray-900">Learnpathly</span>
        </div>
        
        <nav class="hidden md:flex items-center gap-6">
          <a href="#features" class="text-sm text-gray-600 hover:text-gray-900">Features</a>
          <a href="#how-it-works" class="text-sm text-gray-600 hover:text-gray-900">How It Works</a>
          <a href="#pricing" class="text-sm text-gray-600 hover:text-gray-900">Pricing</a>
        </nav>

        <div class="flex items-center gap-3">
          <a href="/login" class="text-sm font-medium text-gray-700 hover:text-gray-900">Sign In</a>
          <a href="/register" class="rounded-lg bg-gray-900 px-4 py-2 text-sm font-medium text-white hover:bg-gray-800">
            Get Started
          </a>
        </div>
      </div>
    </header>

    <!-- Hero -->
    <section class="pt-32 pb-20 px-4">
      <div class="mx-auto max-w-6xl">
        <div class="text-center max-w-3xl mx-auto">
          <div class="inline-block mb-4 px-4 py-1.5 rounded-full bg-blue-50 text-blue-700 text-sm font-medium">
            🚀 The future of learning is here
          </div>
          <h1 class="text-4xl md:text-5xl lg:text-6xl font-bold text-gray-900 leading-tight">
            Master any skill with
            <span class="text-blue-600"> AI-powered</span> learning paths
          </h1>
          <p class="mt-6 text-lg text-gray-600 leading-relaxed">
            Create structured learning paths in seconds. Whether you use AI to generate or build manually, 
            you'll have a clear roadmap to follow and track your progress.
          </p>
          
          <div class="mt-8 flex flex-col sm:flex-row items-center justify-center gap-4">
            <input
              type="text"
              placeholder="Enter a topic (e.g., Machine Learning)"
              class="w-full sm:w-80 h-12 px-5 rounded-xl border border-gray-200 focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500/10"
            />
            <button class="w-full sm:w-auto h-12 px-8 rounded-xl bg-blue-600 text-white font-semibold hover:bg-blue-700 transition-colors">
              Create Path
            </button>
          </div>

          <p class="mt-4 text-sm text-gray-500">
            <span class="font-semibold text-gray-900">Free</span> to start • No credit card
          </p>
        </div>

        <!-- Hero Image/Preview -->
        <div class="mt-16 relative">
          <div class="rounded-2xl overflow-hidden shadow-2xl border border-gray-200">
            <div class="bg-gray-50 p-8">
              <div class="bg-white rounded-xl shadow-lg p-6">
                <div class="flex items-center justify-between mb-6">
                  <div class="flex items-center gap-3">
                    <div class="h-12 w-12 rounded-xl bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center">
                      <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" />
                      </svg>
                    </div>
                    <div>
                      <div class="font-semibold text-gray-900">Web Development Bootcamp</div>
                      <div class="text-sm text-gray-500">8 modules • 24 resources</div>
                    </div>
                  </div>
                  <span class="px-3 py-1 rounded-full bg-green-100 text-green-700 text-xs font-medium">In Progress</span>
                </div>
                
                <div class="space-y-3">
                  <div class="flex items-center gap-3 p-3 rounded-lg bg-green-50">
                    <div class="h-6 w-6 rounded-full bg-green-500 flex items-center justify-center">
                      <svg class="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                      </svg>
                    </div>
                    <span class="text-sm font-medium text-gray-700">HTML & CSS Fundamentals</span>
                  </div>
                  <div class="flex items-center gap-3 p-3 rounded-lg bg-blue-50 border-2 border-blue-500">
                    <div class="h-6 w-6 rounded-full bg-blue-500 flex items-center justify-center text-white text-xs font-bold">3</div>
                    <span class="text-sm font-semibold text-gray-900">JavaScript Essentials</span>
                  </div>
                  <div class="flex items-center gap-3 p-3 rounded-lg bg-gray-50">
                    <div class="h-6 w-6 rounded-full bg-gray-200 flex items-center justify-center text-gray-500 text-xs font-medium">4</div>
                    <span class="text-sm font-medium text-gray-500">React Framework</span>
                  </div>
                </div>

                <div class="mt-6">
                  <div class="flex justify-between text-sm mb-2">
                    <span class="font-medium text-gray-700">Progress</span>
                    <span class="font-bold text-blue-600">45%</span>
                  </div>
                  <div class="h-2 bg-gray-100 rounded-full overflow-hidden">
                    <div class="h-full w-[45%] bg-gradient-to-r from-blue-500 to-indigo-500 rounded-full"></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Features Grid -->
    <section id="features" class="py-20 bg-gray-50">
      <div class="mx-auto max-w-6xl px-4">
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-gray-900">Why choose Learnpathly?</h2>
          <p class="mt-3 text-gray-600">Everything you need to learn effectively</p>
        </div>

        <div class="grid md:grid-cols-3 gap-8">
          <div class="bg-white rounded-2xl p-8 shadow-sm">
            <div class="h-12 w-12 rounded-xl bg-blue-100 flex items-center justify-center mb-5">
              <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
              </svg>
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-2">AI-Powered</h3>
            <p class="text-gray-600">Generate complete learning paths in seconds with advanced AI technology.</p>
          </div>

          <div class="bg-white rounded-2xl p-8 shadow-sm">
            <div class="h-12 w-12 rounded-xl bg-purple-100 flex items-center justify-center mb-5">
              <svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h7" />
              </svg>
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-2">Manual Control</h3>
            <p class="text-gray-600">Build custom paths with your own resources in any order you prefer.</p>
          </div>

          <div class="bg-white rounded-2xl p-8 shadow-sm">
            <div class="h-12 w-12 rounded-xl bg-green-100 flex items-center justify-center mb-5">
              <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
              </svg>
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-2">Track Progress</h3>
            <p class="text-gray-600">Visual progress tracking keeps you motivated until completion.</p>
          </div>
        </div>
      </div>
    </section>

    <!-- How It Works -->
    <section id="how-it-works" class="py-20">
      <div class="mx-auto max-w-6xl px-4">
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-gray-900">How it works</h2>
          <p class="mt-3 text-gray-600">Three simple steps</p>
        </div>

        <div class="grid md:grid-cols-3 gap-8">
          <div class="text-center">
            <div class="w-16 h-16 mx-auto mb-4 rounded-full bg-blue-600 text-white text-2xl font-bold flex items-center justify-center">1</div>
            <h3 class="font-bold text-gray-900 mb-2">Enter Topic</h3>
            <p class="text-gray-600">Type what you want to learn</p>
          </div>
          <div class="text-center">
            <div class="w-16 h-16 mx-auto mb-4 rounded-full bg-blue-600 text-white text-2xl font-bold flex items-center justify-center">2</div>
            <h3 class="font-bold text-gray-900 mb-2">Generate Path</h3>
            <p class="text-gray-600">AI creates your roadmap</p>
          </div>
          <div class="text-center">
            <div class="w-16 h-16 mx-auto mb-4 rounded-full bg-blue-600 text-white text-2xl font-bold flex items-center justify-center">3</div>
            <h3 class="font-bold text-gray-900 mb-2">Start Learning</h3>
            <p class="text-gray-600">Follow and track progress</p>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="py-20 bg-gray-900">
      <div class="mx-auto max-w-3xl px-4 text-center">
        <h2 class="text-3xl font-bold text-white">Ready to start learning?</h2>
        <p class="mt-4 text-gray-400">Join thousands of learners today</p>
        <div class="mt-8">
          <a href="/register" class="inline-block rounded-xl bg-blue-600 px-8 py-4 text-lg font-semibold text-white hover:bg-blue-700">
            Get Started Free
          </a>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <footer class="py-8 bg-white border-t border-gray-100">
      <div class="mx-auto max-w-6xl px-4 text-center">
        <p class="text-sm text-gray-500">© 2026 Learnpathly. All rights reserved.</p>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
// Home4 - UI-UX-Design Alternative Modern Clean
</script>
