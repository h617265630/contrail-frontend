<template>
  <div class="min-h-screen bg-linear-to-br from-blue-50 to-indigo-100 p-6">
    <div class="max-w-7xl mx-auto space-y-10">

      <!-- Hero -->
      <section class="rounded-2xl bg-white shadow-lg p-8 md:p-12 flex flex-col gap-6">
        <div class="space-y-3 max-w-3xl">
          <p class="text-sm uppercase tracking-wide text-blue-600 font-semibold">About</p>
          <h1 class="text-3xl md:text-4xl font-bold text-gray-900 leading-tight">What is Contrail?</h1>
          <p class="text-gray-700 text-base leading-relaxed">
            Contrail is a Learning Path Platform built with Vue + Tailwind. It includes a home page, learning path listings,
            path detail views, a resource library, and auth pages. You can browse steps in a horizontally scrollable layout,
            view progress and notes in cards, and navigate through a consistent global header and footer.
          </p>
        </div>
        <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          <div class="rounded-xl bg-blue-50/50 shadow-sm p-4">
            <h3 class="font-semibold text-gray-900">Tech Stack</h3>
            <p class="text-sm text-gray-700 mt-1">Vue 3 + Vite + TypeScript, styled with TailwindCSS, icons via lucide-vue-next.</p>
          </div>
          <div class="rounded-xl bg-purple-50/40 shadow-sm p-4">
            <h3 class="font-semibold text-gray-900">Pages & Routes</h3>
            <p class="text-sm text-gray-700 mt-1">Home (hero + featured paths), LearningPool, path details, Resources, Login/Register, About, and a shared NavBar/Footer layout.</p>
          </div>
          <div class="rounded-xl bg-green-50/40 shadow-sm p-4">
            <h3 class="font-semibold text-gray-900">Path Experience</h3>
            <p class="text-sm text-gray-700 mt-1">Featured paths in a 5-card row; multiple paths in lists; steps scroll horizontally; long text is clamped for readability.</p>
          </div>
        </div>
      </section>

      <!-- Sections -->
      <section class="grid gap-6 md:grid-cols-2">
        <div class="rounded-2xl bg-white shadow-lg p-6 space-y-3">
          <h2 class="text-xl font-semibold text-gray-900">Core Features</h2>
          <ul class="space-y-2 text-gray-700 text-sm leading-relaxed list-disc list-inside">
            <li>Learning path lists: horizontally scrollable step cards for quick browsing.</li>
            <li>Path details: timeline, progress, and note editing.</li>
            <li>Resource library: grid/list view, search, add/remove resources.</li>
            <li>Login/Register: client-side validation and password visibility toggle.</li>
            <li>Unified layout: global navigation and consistent footer.</li>
          </ul>
        </div>
        <div class="rounded-2xl bg-white shadow-lg p-6 space-y-3">
          <h2 class="text-xl font-semibold text-gray-900">Highlights</h2>
          <ul class="space-y-2 text-gray-700 text-sm leading-relaxed list-disc list-inside">
            <li>Card-based UI with a bold hero section to spotlight featured paths.</li>
            <li>Line-clamp for long text to keep layouts clean.</li>
            <li>Tailwind layout primitives: centered max width, soft shadows, and rounded corners.</li>
            <li>Extensible: connect a real backend API to replace mock data.</li>
          </ul>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
</script>
