<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="max-w-5xl mx-auto space-y-8">
    <header class="space-y-2">
      <p class="text-sm uppercase tracking-wide text-blue-600 font-semibold">Plans</p>
      <h1 class="text-3xl font-bold text-gray-900">Choose the plan that fits you</h1>
      <p class="text-gray-600">Use Contrail’s core features to start learning with structure.</p>
      <div class="inline-flex items-center gap-2 rounded-full bg-white border border-gray-200 px-3 py-1 text-sm text-gray-700">
        <span class="font-semibold">Current plan:</span>
        <span class="font-bold text-gray-900">{{ currentPlan }}</span>
      </div>
    </header>

    <div class="grid gap-4 md:grid-cols-3">
      <article
        v-for="plan in plans"
        :key="plan.id"
        class="rounded-2xl bg-white shadow-lg p-6 flex flex-col gap-4 h-full"
        :class="[plan.highlight ? 'ring-1 ring-blue-200' : '', isCurrent(plan) ? 'ring-2 ring-blue-400' : '']"
      >
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-xl font-semibold text-gray-900">{{ plan.name }}</h2>
            <p class="text-gray-600 text-sm">{{ plan.description }}</p>
          </div>
          <span v-if="plan.highlight" class="px-3 py-1 rounded-full bg-blue-50 text-blue-700 text-xs font-semibold">Recommended</span>
        </div>

        <div class="space-y-2 flex-1">
          <p class="text-sm font-semibold text-gray-800">Best for:</p>
          <p class="text-sm text-gray-700">{{ plan.suitable }}</p>

          <p class="text-sm font-semibold text-gray-800 mt-2">Includes:</p>
          <ul class="space-y-1 text-sm text-gray-700 list-disc list-inside">
            <li v-for="feat in plan.features" :key="feat">{{ feat }}</li>
          </ul>

          <p v-if="plan.tagline" class="text-sm text-gray-600 mt-2">{{ plan.tagline }}</p>
        </div>

        <button
          class="w-full md:w-auto px-4 py-2 rounded-full bg-white border border-gray-200 shadow-sm text-gray-700 text-sm font-semibold hover:bg-gray-50 hover:border-gray-300 transition-colors"
          type="button"
          @click="onSelectPlan(plan)"
        >
          {{ isCurrent(plan) ? 'Current plan' : plan.cta }}
        </button>
      </article>
    </div>

    <section class="bg-white rounded-2xl shadow-lg p-6">
      <h2 class="text-lg font-semibold text-gray-900 mb-3">Notes</h2>
      <ul class="space-y-1 text-sm text-gray-700 list-disc list-inside">
        <li>All plans include progress tracking</li>
        <li>You can upgrade or downgrade anytime</li>
        <li>Your learning data always stays yours</li>
      </ul>
    </section>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { getPlanInfo, selectPlan as persistSelectPlan, type PlanName } from '../utils/plan'

type Plan = {
  id: string
  name: PlanName
  description: string
  suitable: string
  features: string[]
  tagline?: string
  cta: string
  highlight?: boolean
}

const plans = computed<Plan[]>(() => [
  {
    id: 'free',
    name: 'Free',
    description: 'For getting started with learning paths',
    suitable: 'New users building their first learning paths',
    features: ['Browse all public resources', 'Browse all public learning paths', 'Create up to 5 learning paths', 'Track your progress anytime'],
    tagline: 'Start learning with structure using Contrail’s core features.',
    cta: 'Get started',
  },
  {
    id: 'basic',
    name: 'Basic',
    description: 'More space for personal learning management',
    suitable: 'Learners with clear goals who need more room to organize',
    features: ['Create up to 10 learning paths', 'See full progress anytime', 'Create up to 5 private learning paths', 'Manage your structure more flexibly'],
    tagline: 'Balance public and private while staying focused on your plan.',
    cta: 'Upgrade for more paths',
  },
  {
    id: 'pro',
    name: 'Pro',
    description: 'For power learners and creators',
    suitable: 'Long-term learners, heavy users, and creators',
    features: ['Unlimited learning paths', 'AI-generated learning notes and summaries', 'AI analysis of chapters and structure', 'AI-based recommendations to optimize resources and paths'],
    tagline: 'Make AI your learning copilot to continuously improve outcomes.',
    cta: 'Use AI to optimize',
    highlight: true,
  },
])

const currentPlan = ref<PlanName>(getPlanInfo().name as PlanName)

function isCurrent(plan: Plan) {
  return currentPlan.value === plan.name
}

function onSelectPlan(plan: Plan) {
  const name = plan.name as PlanName
  currentPlan.value = name
  persistSelectPlan(name)
}
</script>
