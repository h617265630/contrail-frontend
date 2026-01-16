<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="max-w-5xl mx-auto space-y-8">
    <header class="space-y-2">
      <p class="text-sm uppercase tracking-wide text-blue-600 font-semibold">Plans</p>
      <h1 class="text-3xl font-bold text-gray-900">Choose the plan that fits you</h1>
      <p class="text-gray-600">Start free, upgrade anytime. Annual billing saves 20%.</p>
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

        <div class="grid gap-3 md:grid-cols-2">
          <div class="rounded-lg bg-gray-50 shadow-sm p-4">
            <p class="text-sm text-gray-600">Monthly</p>
            <div class="text-2xl font-bold text-gray-900 mt-1">{{ plan.monthly }}</div>
          </div>
          <div class="rounded-lg bg-blue-50 shadow-sm p-4">
            <p class="text-sm text-gray-700">Annual (20% off)</p>
            <div class="text-xl font-bold text-blue-700 mt-1">{{ plan.yearly }} <span class="text-sm text-blue-600">≈ {{ plan.yearlyMonthly }} /mo</span></div>
          </div>
        </div>

        <div class="space-y-2 flex-1">
          <p class="text-sm font-semibold text-gray-800">What’s included</p>
          <ul class="space-y-1 text-sm text-gray-700 list-disc list-inside">
            <li v-for="feat in plan.features" :key="feat">{{ feat }}</li>
          </ul>
        </div>

        <button
          class="w-full md:w-auto px-4 py-2 rounded-full bg-white border border-gray-200 shadow-sm text-gray-700 text-sm font-semibold hover:bg-gray-50 hover:border-gray-300 transition-colors"
          type="button"
          @click="selectPlan(plan)"
        >
          {{ isCurrent(plan) ? 'Current plan' : `Select ${plan.name}` }}
        </button>
      </article>
    </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { getPlanInfo, selectPlan, type PlanName } from '../utils/plan'

type Plan = {
  id: string
  name: string
  description: string
  monthly: string
  yearly: string
  yearlyMonthly: string
  features: string[]
  highlight?: boolean
}

const basePlans: Array<Omit<Plan, 'yearly' | 'yearlyMonthly'>> = [
  {
    id: 'free',
    name: 'Free',
    description: 'Best for getting started.',
    monthly: '$0 /mo',
    features: ['Basic learning path preview', 'Public resources access', 'Local notes editing'],
  },
  {
    id: 'basic',
    name: 'Basic',
    description: 'For consistent growth and small teams.',
    monthly: '$9 /mo',
    features: ['Full learning paths', 'Manage your resources', 'Cloud notes sync', 'Progress tracking & export'],
  },
  {
    id: 'pro',
    name: 'Pro',
    description: 'For power users and professional teams.',
    monthly: '$19 /mo',
    features: ['Team collaboration & sharing', 'Custom paths & templates', 'Advanced search & filters', 'Priority support'],
    highlight: true,
  },
]

const currentPlan = ref<string>(getPlanInfo().name)

const plans = computed<Plan[]>(() => {
  return basePlans.map((p) => {
    const monthlyNumber = Number(p.monthly.replace(/[^0-9.]/g, '')) || 0
    const yearlyNumber = monthlyNumber * 12 * 0.8
    const yearly = monthlyNumber === 0 ? '$0 /yr' : `$${yearlyNumber.toFixed(0)} /yr`
    const yearlyMonthly = monthlyNumber === 0 ? '$0' : `$${(yearlyNumber / 12).toFixed(1)}`
    return {
      ...p,
      yearly,
      yearlyMonthly,
    }
  })
})

function isCurrent(plan: Plan) {
  return currentPlan.value === plan.name
}

function selectPlan(plan: Plan) {
  const name = plan.name as PlanName
  currentPlan.value = name
  selectPlan(name)
}
</script>
