<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8 -mt-4 md:-mt-6">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Subscribe now</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">Use linktopath’s core features to start learning with structure.</p>
        </div>
        <div class="md:col-span-4 md:flex md:justify-end">
          <div class="inline-flex items-center gap-2 border border-border bg-background px-3 py-2 text-xs text-muted-foreground">
            <span class="font-semibold text-foreground">Current plan:</span>
            <span class="font-semibold text-foreground">{{ currentPlan }}</span>
          </div>
        </div>
      </div>

      <div class="mt-6 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <div v-if="loadError" class="text-sm text-destructive">{{ loadError }}</div>
        <div class="inline-flex items-center gap-2 border border-border bg-background p-1">
          <button
            type="button"
            class="px-3 py-1 text-xs font-semibold uppercase tracking-[0.14em] transition"
            :class="billingCycle === 'monthly' ? 'bg-foreground text-background' : 'text-muted-foreground hover:text-foreground'"
            @click="billingCycle = 'monthly'"
          >
            Monthly
          </button>
          <button
            type="button"
            class="px-3 py-1 text-xs font-semibold uppercase tracking-[0.14em] transition"
            :class="billingCycle === 'yearly' ? 'bg-foreground text-background' : 'text-muted-foreground hover:text-foreground'"
            @click="billingCycle = 'yearly'"
          >
            Yearly
          </button>
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
            <div class="text-3xl font-semibold text-foreground">
              <span v-if="plan.priceText" class="align-baseline">{{ plan.priceText }}</span>
              <span v-if="plan.priceSuffix" class="ml-1 text-sm font-semibold text-muted-foreground">{{ plan.priceSuffix }}</span>
            </div>

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
            @click="onAction(plan)"
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
import { computed, onMounted, ref } from 'vue'
import { getMySubscription, type SubscriptionMeResponse } from '../api/subscription'
import { Button } from '../components/ui/button'
import Card from '../components/ui/Card.vue'

type BillingCycle = 'monthly' | 'yearly'

type Plan = {
  id: string
  name: string
  description: string
  suitable: string
  features: string[]
  tagline?: string
  cta: string
  highlight?: boolean
  priceText?: string
  priceSuffix?: string
}

const billingCycle = ref<BillingCycle>('monthly')

const subscription = ref<SubscriptionMeResponse | null>(null)
const loading = ref(false)
const loadError = ref('')

function hasToken() {
  try {
    const local = (globalThis as any).localStorage
    const session = (globalThis as any).sessionStorage
    const token = String(local?.getItem?.('learnsmart_token') || session?.getItem?.('learnsmart_token') || '').trim()
    return Boolean(token)
  } catch {
    return false
  }
}

onMounted(async () => {
  if (!hasToken()) return
  loading.value = true
  loadError.value = ''
  try {
    subscription.value = await getMySubscription()
  } catch (e: any) {
    loadError.value = 'Failed to load your current plan.'
  } finally {
    loading.value = false
  }
})

const currentPlanId = computed(() => {
  const code = String(subscription.value?.plan_code || '').trim().toLowerCase()
  if (!code) return 'free'
  if (code.startsWith('basic_yearly')) return 'basic'
  if (code.startsWith('basic_')) return 'pro'
  if (code.startsWith('pro_')) return 'pro'
  return 'free'
})

const currentPlan = computed(() => {
  if (currentPlanId.value === 'pro') return 'Pro'
  if (currentPlanId.value === 'basic') return 'Basic'
  return 'Free'
})

function planCta(id: Plan['id']) {
  if (id === 'free') return 'Continue with Free'
  if (id === 'pro') return 'Subscribe to Pro (coming soon)'
  return 'Subscribe to Basic (coming soon)'
}

function planPriceText(id: Plan['id']) {
  if (id === 'free') return '$0'
  if (id === 'pro') return billingCycle.value === 'monthly' ? '$6' : '$60'
  return '$48'
}

function planPriceSuffix(id: Plan['id']) {
  if (id === 'free') return ''
  if (id === 'pro') return billingCycle.value === 'monthly' ? '/mo' : '/yr'
  return '/yr'
}

const plans = computed<Plan[]>(() => [
  {
    id: 'free',
    name: 'Free',
    description: 'For getting started with learning paths',
    suitable: 'New users building their first learning paths',
    features: ['Browse all public resources', 'Browse all public learning paths', 'Create up to 2 learning paths', 'Add up to 80 resources', 'Track your progress anytime'],
    tagline: 'Start learning with structure using linktopath’s core features.',
    cta: planCta('free'),
    priceText: planPriceText('free'),
    priceSuffix: planPriceSuffix('free'),
  },
  {
    id: 'pro',
    name: 'Pro',
    description: 'More space for personal learning management',
    suitable: 'Learners with clear goals who need more room to organize',
    features: ['Create up to 10 learning paths', 'See full progress anytime', 'Create up to 5 private learning paths', 'Manage your structure more flexibly'],
    tagline: 'Balance public and private while staying focused on your plan.',
    cta: planCta('pro'),
    priceText: planPriceText('pro'),
    priceSuffix: planPriceSuffix('pro'),
  },
  {
    id: 'basic',
    name: 'Basic',
    description: 'Yearly billing with 20% off',
    suitable: 'Learners who prefer yearly billing and better value',
    features: ['Create up to 10 learning paths', 'See full progress anytime', 'Create up to 5 private learning paths', 'Manage your structure more flexibly'],
    tagline: 'Pay yearly and save 20% compared to monthly.',
    cta: planCta('basic'),
    highlight: true,
    priceText: planPriceText('basic'),
    priceSuffix: planPriceSuffix('basic'),
  },
])

function isCurrent(plan: Plan) {
  return currentPlanId.value === plan.id
}

function onAction(plan: Plan) {
  if (isCurrent(plan)) return
  if (loading.value) return
  try {
    alert('Checkout is coming soon.')
  } catch {
    // ignore
  }
}
</script>
