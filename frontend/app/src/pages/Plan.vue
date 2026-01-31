<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Choose the plan that fits you</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">Use Contrail’s core features to start learning with structure.</p>
        </div>
        <div class="md:col-span-4 md:flex md:justify-end">
          <div class="inline-flex items-center gap-2 border border-border bg-background px-3 py-2 text-xs text-muted-foreground">
            <span class="font-semibold text-foreground">Current plan:</span>
            <span class="font-semibold text-foreground">{{ currentPlan }}</span>
          </div>
        </div>
      </div>
    </section>

    <section class="grid gap-4 md:grid-cols-3">
      <Card
        v-for="plan in plans"
        :key="plan.id"
        as="article"
        :hoverable="true"
        class="rounded-none"
        :class="[plan.highlight ? 'ring-1 ring-primary/20' : '', isCurrent(plan) ? 'ring-2 ring-primary/40' : '']"
      >
        <div class="p-6 flex flex-col gap-4 h-full">
          <div class="flex items-start justify-between gap-4">
            <div class="min-w-0">
              <h2 class="text-xl font-semibold text-foreground">{{ plan.name }}</h2>
              <p class="text-muted-foreground text-sm">{{ plan.description }}</p>
            </div>
            <span v-if="plan.highlight" class="px-2 py-1 border border-border bg-background text-xs font-semibold text-foreground">Recommended</span>
          </div>

          <div class="space-y-2 flex-1">
            <p class="text-sm font-semibold text-foreground">Best for:</p>
            <p class="text-sm text-muted-foreground">{{ plan.suitable }}</p>

            <p class="text-sm font-semibold text-foreground mt-2">Includes:</p>
            <ul class="space-y-1 text-sm text-muted-foreground list-disc list-inside">
              <li v-for="feat in plan.features" :key="feat">{{ feat }}</li>
            </ul>

            <p v-if="plan.tagline" class="text-sm text-muted-foreground mt-2">{{ plan.tagline }}</p>
          </div>

          <Button
            type="button"
            variant="outline"
            size="sm"
            class="rounded-none"
            :class="isCurrent(plan) ? 'bg-foreground text-background hover:bg-foreground/90 hover:text-background' : ''"
            @click="onSelectPlan(plan)"
          >
            {{ isCurrent(plan) ? 'Current plan' : plan.cta }}
          </Button>
        </div>
      </Card>
    </section>

    <Card as="section" :hoverable="false" class="rounded-none">
      <div class="p-6">
        <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground mb-3">Notes</h2>
        <ul class="space-y-1 text-sm text-muted-foreground list-disc list-inside">
          <li>All plans include progress tracking</li>
          <li>You can upgrade or downgrade anytime</li>
          <li>Your learning data always stays yours</li>
        </ul>
      </div>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { getPlanInfo, selectPlan as persistSelectPlan, type PlanName } from '../utils/plan'
import { Button } from '../components/ui/button'
import Card from '../components/ui/Card.vue'

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
