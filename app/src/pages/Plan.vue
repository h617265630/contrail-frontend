<template>
  <div class="min-h-screen bg-stone-50">

    <!-- Masthead -->
    <header class="border-b-2 border-stone-900 bg-white">
      <div class="mx-auto max-w-7xl px-4 py-6 md:py-8">
        <div class="flex items-end justify-between">
          <div>
            <div class="flex items-center gap-2 mb-3">
              <span class="h-px w-8 bg-blue-600"></span>
              <span class="text-[10px] font-bold uppercase tracking-[0.25em] text-stone-400">Pricing</span>
            </div>
            <h1 class="text-4xl md:text-5xl font-black tracking-tight text-stone-900 leading-[0.9]">
              Simple plans,<br/><span class="text-blue-600">serious learning.</span>
            </h1>
          </div>
          <div class="hidden md:flex flex-col items-end gap-2">
            <span class="text-[10px] font-semibold uppercase tracking-widest text-stone-400">Free · Basic · Pro</span>
          </div>
        </div>
      </div>
    </header>

    <main class="mx-auto max-w-7xl px-4 py-8">

      <!-- Billing toggle -->
      <div class="flex flex-col sm:flex-row gap-4 items-start sm:items-center mb-12">
        <div class="inline-flex rounded-full border border-stone-200 bg-white p-1 shadow-sm">
          <button
            type="button"
            class="px-5 py-2 rounded-full text-xs font-bold uppercase tracking-widest transition-all"
            :class="billingCycle === 'monthly' ? 'bg-stone-900 text-white shadow-sm' : 'text-stone-500 hover:text-stone-800'"
            @click="billingCycle = 'monthly'"
          >
            Monthly
          </button>
          <button
            type="button"
            class="px-5 py-2 rounded-full text-xs font-bold uppercase tracking-widest transition-all flex items-center gap-2"
            :class="billingCycle === 'yearly' ? 'bg-stone-900 text-white shadow-sm' : 'text-stone-500 hover:text-stone-800'"
            @click="billingCycle = 'yearly'"
          >
            Yearly
            <span v-if="billingCycle === 'yearly'" class="inline-flex items-center rounded-full bg-emerald-400 text-white px-1.5 py-0.5 text-[9px] font-black">-17%</span>
            <span v-else class="text-[10px] font-semibold text-amber-600">-17%</span>
          </button>
        </div>
        <div v-if="subscription?.plan_code" class="text-xs text-stone-400">
          <span class="font-semibold text-stone-700">{{ currentPlan }}</span>
          · Renewal {{ subscription.expire_date ? new Date(subscription.expire_date).toLocaleDateString() : '—' }}
        </div>
      </div>

      <!-- Plans: numbered editorial layout -->
      <section class="grid grid-cols-12 gap-5 mb-16">

        <!-- Free — 01 -->
        <div class="col-span-12 lg:col-span-3 relative">
          <span class="absolute -top-4 -left-2 text-[100px] font-black leading-none text-stone-100 select-none pointer-events-none" aria-hidden="true">01</span>
          <div class="relative pt-12">
            <div class="flex items-center gap-2 mb-1">
              <div class="w-1 h-5 bg-stone-300 rounded-full"></div>
              <span class="text-[10px] font-bold uppercase tracking-widest text-stone-400">Free</span>
            </div>
            <div class="flex items-end gap-1 mb-1">
              <span class="text-5xl font-black tracking-tight text-stone-900">$0</span>
              <span class="text-sm text-stone-400 mb-2">/ forever</span>
            </div>
            <p class="text-xs text-stone-500 mb-6 leading-relaxed">For trying out the platform.</p>

            <div class="space-y-2 mb-8">
              <p class="text-[10px] font-bold uppercase tracking-widest text-stone-400 mb-3">What's included</p>
              <ul class="space-y-2.5">
                <li v-for="feat in freePlan.features" :key="feat.label" class="flex items-start gap-2.5">
                  <span class="mt-0.5 shrink-0 rounded-full bg-stone-100 p-0.5">
                    <svg xmlns="http://www.w3.org/2000/svg" width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="#64748b" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                  </span>
                  <span class="text-sm text-stone-600 leading-snug">{{ feat.label }}</span>
                </li>
              </ul>
            </div>

            <button
              type="button"
              class="w-full rounded-full border-2 py-2.5 text-sm font-bold transition-all"
              :class="isCurrent('free')
                ? 'border-blue-400 bg-blue-50 text-blue-600'
                : 'border-stone-200 text-stone-600 hover:border-stone-400 hover:bg-stone-50'"
              @click="onAction('free')"
            >
              {{ isCurrent('free') ? 'Current plan' : 'Continue free' }}
            </button>
          </div>
        </div>

        <!-- Pro — 02 (dominant) -->
        <div class="col-span-12 lg:col-span-6 relative">
          <span class="absolute -top-4 -left-2 text-[100px] font-black leading-none text-blue-50 select-none pointer-events-none" aria-hidden="true">02</span>
          <div class="relative pt-12 rounded-2xl border-2 border-blue-500 bg-white shadow-xl shadow-blue-500/5 overflow-hidden">
            <!-- Decorative background -->
            <div class="absolute top-0 right-0 w-48 h-48 bg-linear-to-bl from-blue-50 to-transparent rounded-bl-full opacity-60 pointer-events-none"></div>
            <div class="absolute bottom-0 left-0 w-32 h-32 bg-linear-to-tr from-amber-50 to-transparent rounded-tr-full opacity-40 pointer-events-none"></div>

            <div class="relative p-8">
              <div class="flex items-start justify-between mb-6">
                <div>
                  <div class="inline-flex items-center gap-1.5 rounded-full border border-blue-200 bg-blue-50 px-2.5 py-1 mb-3">
                    <span class="h-1.5 w-1.5 rounded-full bg-blue-500"></span>
                    <span class="text-[9px] font-bold uppercase tracking-widest text-blue-600">Recommended</span>
                  </div>
                  <div class="flex items-center gap-2">
                    <div class="w-1 h-5 bg-blue-500 rounded-full"></div>
                    <span class="text-[10px] font-bold uppercase tracking-widest text-blue-600">Pro</span>
                  </div>
                </div>
                <div v-if="isCurrent('pro')" class="rounded-full border border-blue-200 bg-blue-50 px-3 py-1 text-[10px] font-bold text-blue-600 uppercase tracking-widest">
                  Current
                </div>
              </div>

              <div class="flex items-end gap-1 mb-1">
                <span class="text-6xl font-black tracking-tight text-stone-900">
                  {{ billingCycle === 'monthly' ? '$6' : '$60' }}
                </span>
                <span class="text-sm text-stone-400 mb-2.5">
                  {{ billingCycle === 'monthly' ? '/ month' : '/ year' }}
                </span>
              </div>
              <p class="text-xs text-stone-400 mb-8">
                {{ billingCycle === 'yearly' ? 'Billed annually · Save $12/year' : 'Billed monthly · $72/year' }}
              </p>

              <div class="space-y-2 mb-8">
                <p class="text-[10px] font-bold uppercase tracking-widest text-stone-400 mb-3">Everything in Free, plus</p>
                <ul class="space-y-2.5">
                  <li v-for="feat in proPlan.features" :key="feat.label" class="flex items-start gap-2.5">
                    <span class="mt-0.5 shrink-0 rounded-full bg-blue-50 p-0.5">
                      <svg xmlns="http://www.w3.org/2000/svg" width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="#3b82f6" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                    </span>
                    <span class="text-sm font-semibold text-stone-800 leading-snug">{{ feat.label }}</span>
                  </li>
                </ul>
              </div>

              <button
                type="button"
                class="w-full rounded-full bg-blue-600 py-3.5 text-sm font-bold text-white shadow-lg shadow-blue-500/30 transition-all hover:bg-blue-700 hover:-translate-y-0.5 hover:shadow-xl active:translate-y-0"
                @click="onAction('pro')"
              >
                Subscribe to Pro →
              </button>
              <p class="text-center text-[11px] text-stone-400 mt-2">No commitment · Cancel anytime</p>
            </div>
          </div>
        </div>

        <!-- Basic — 03 -->
        <div class="col-span-12 lg:col-span-3 relative">
          <span class="absolute -top-4 -left-2 text-[100px] font-black leading-none text-stone-100 select-none pointer-events-none" aria-hidden="true">03</span>
          <div class="relative pt-12">
            <div class="flex items-center gap-2 mb-1">
              <div class="w-1 h-5 bg-amber-500 rounded-full"></div>
              <span class="text-[10px] font-bold uppercase tracking-widest text-stone-400">Basic</span>
            </div>
            <div class="flex items-end gap-1 mb-1">
              <span class="text-5xl font-black tracking-tight text-stone-900">$48</span>
              <span class="text-sm text-stone-400 mb-2">/ year</span>
            </div>
            <p class="text-xs text-stone-500 mb-6 leading-relaxed">
              {{ billingCycle === 'yearly' ? 'Billed annually · Save $12/yr' : '$4/month' }} · Pro features, simpler billing
            </p>

            <div class="space-y-2 mb-8">
              <p class="text-[10px] font-bold uppercase tracking-widest text-stone-400 mb-3">Same as Pro, different cycle</p>
              <ul class="space-y-2.5">
                <li v-for="feat in basicPlan.features" :key="feat.label" class="flex items-start gap-2.5">
                  <span class="mt-0.5 shrink-0 rounded-full bg-amber-50 p-0.5">
                    <svg xmlns="http://www.w3.org/2000/svg" width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                  </span>
                  <span class="text-sm text-stone-600 leading-snug">{{ feat.label }}</span>
                </li>
              </ul>
            </div>

            <button
              type="button"
              class="w-full rounded-full border-2 py-2.5 text-sm font-bold transition-all"
              :class="isCurrent('basic')
                ? 'border-amber-400 bg-amber-50 text-amber-700'
                : 'border-stone-200 text-stone-600 hover:border-stone-400 hover:bg-stone-50'"
              @click="onAction('basic')"
            >
              {{ isCurrent('basic') ? 'Current plan' : 'Choose Basic' }}
            </button>
          </div>
        </div>
      </section>

      <!-- Feature comparison -->
      <section class="mb-16">
        <!-- Section header -->
        <div class="flex items-center gap-4 mb-8">
          <div class="flex items-center gap-2">
            <div class="w-1 h-6 bg-stone-900 rounded-full"></div>
            <span class="text-sm font-black uppercase tracking-widest text-stone-900">Compare</span>
          </div>
          <div class="flex-1 h-px bg-stone-200"></div>
        </div>

        <div class="rounded-2xl border border-stone-100 bg-white overflow-hidden">
          <!-- Header row -->
          <div class="grid grid-cols-12 gap-0 border-b border-stone-100 bg-stone-50/50">
            <div class="col-span-5 px-6 py-4">
              <span class="text-[10px] font-bold uppercase tracking-widest text-stone-400">Feature</span>
            </div>
            <div class="col-span-2 px-4 py-4 text-center">
              <span class="text-[10px] font-bold uppercase tracking-widest text-stone-400">Free</span>
            </div>
            <div class="col-span-5 px-6 py-4 text-center">
              <span class="text-[10px] font-bold uppercase tracking-widest text-blue-600">Pro</span>
            </div>
          </div>
          <!-- Data rows -->
          <div
            v-for="(row, i) in comparisonRows"
            :key="row.feature"
            class="grid grid-cols-12 gap-0 border-b border-stone-50 transition-colors"
            :class="i % 2 === 0 ? 'bg-white' : 'bg-stone-50/30'"
          >
            <div class="col-span-5 px-6 py-4">
              <span class="text-sm text-stone-700 font-medium">{{ row.feature }}</span>
            </div>
            <div class="col-span-2 flex justify-center items-center py-4">
              <span v-if="row.free === true" class="text-blue-500">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
              </span>
              <span v-else-if="row.free === false" class="text-stone-200">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
              </span>
              <span v-else class="text-xs font-semibold text-stone-500">{{ row.free }}</span>
            </div>
            <div class="col-span-5 flex justify-center items-center py-4">
              <span v-if="row.pro === true" class="text-blue-500">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
              </span>
              <span v-else-if="row.pro === false" class="text-stone-200">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
              </span>
              <span v-else class="text-xs font-bold text-blue-600">{{ row.pro }}</span>
            </div>
          </div>
        </div>
      </section>

      <!-- Trust signals -->
      <section class="mb-16">
        <div class="flex items-center gap-4 mb-8">
          <div class="flex items-center gap-2">
            <div class="w-1 h-6 bg-emerald-500 rounded-full"></div>
            <span class="text-sm font-black uppercase tracking-widest text-stone-900">Trust</span>
          </div>
          <div class="flex-1 h-px bg-stone-200"></div>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
          <div
            v-for="signal in trustSignals"
            :key="signal.label"
            class="rounded-md border border-stone-100 bg-white p-5 text-center hover:border-stone-200 hover:shadow-sm transition-all"
          >
            <div class="text-2xl mb-2">{{ signal.icon }}</div>
            <div class="text-sm font-bold text-stone-800">{{ signal.label }}</div>
            <div class="text-xs text-stone-400 mt-0.5">{{ signal.desc }}</div>
          </div>
        </div>
      </section>

      <!-- FAQ -->
      <section class="mb-12">
        <div class="flex items-center gap-4 mb-8">
          <div class="flex items-center gap-2">
            <div class="w-1 h-6 bg-violet-500 rounded-full"></div>
            <span class="text-sm font-black uppercase tracking-widest text-stone-900">FAQ</span>
          </div>
          <div class="flex-1 h-px bg-stone-200"></div>
        </div>

        <div class="max-w-2xl space-y-0">
          <div
            v-for="(faq, i) in faqs"
            :key="faq.q"
            class="border-b border-stone-100 py-5"
            :class="i === 0 ? 'border-t border-stone-100' : ''"
          >
            <p class="text-sm font-bold text-stone-800 leading-snug">{{ faq.q }}</p>
            <p class="text-sm text-stone-500 mt-1.5 leading-relaxed">{{ faq.a }}</p>
          </div>
        </div>
      </section>

    </main>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { getMySubscription, type SubscriptionMeResponse } from '../api/subscription'

type BillingCycle = 'monthly' | 'yearly'
type Feature = { label: string }
type PlanData = { features: Feature[] }

const billingCycle = ref<BillingCycle>('yearly')
const subscription = ref<SubscriptionMeResponse | null>(null)
const loading = ref(false)

function hasToken() {
  try {
    const local = (globalThis as any).localStorage
    const session = (globalThis as any).sessionStorage
    return Boolean(local?.getItem?.('learnsmart_token') || session?.getItem?.('learnsmart_token'))
  } catch { return false }
}

onMounted(async () => {
  if (!hasToken()) return
  loading.value = true
  try { subscription.value = await getMySubscription() } catch { /* ignore */ }
  finally { loading.value = false }
})

const currentPlanId = computed(() => {
  const code = String(subscription.value?.plan_code || '').trim().toLowerCase()
  if (!code) return 'free'
  if (code.startsWith('basic_yearly') || code.startsWith('basic')) return 'basic'
  if (code.startsWith('pro_')) return 'pro'
  return 'free'
})

const currentPlan = computed(() => {
  if (currentPlanId.value === 'pro') return 'Pro'
  if (currentPlanId.value === 'basic') return 'Basic'
  return 'Free'
})

const freePlan = computed<PlanData>(() => ({
  features: [
    { label: 'Browse public resources & paths' },
    { label: 'Create up to 2 learning paths' },
    { label: 'Add up to 80 resources' },
    { label: 'Track your progress anytime' },
  ],
}))

const proPlan = computed<PlanData>(() => ({
  features: [
    { label: 'Unlimited learning paths' },
    { label: 'Unlimited resources' },
    { label: 'Up to 5 private learning paths' },
    { label: 'Advanced progress insights & history' },
    { label: 'Priority support' },
  ],
}))

const basicPlan = computed<PlanData>(() => ({
  features: [
    { label: 'Unlimited learning paths' },
    { label: 'Unlimited resources' },
    { label: 'Up to 5 private learning paths' },
    { label: 'Advanced progress insights & history' },
    { label: 'Email support' },
  ],
}))

const comparisonRows = computed(() => [
  { feature: 'Public resources & paths', free: true, pro: true },
  { feature: 'Learning paths', free: '2', pro: 'Unlimited' },
  { feature: 'Resources', free: '80', pro: 'Unlimited' },
  { feature: 'Private learning paths', free: false, pro: '5' },
  { feature: 'Progress tracking', free: true, pro: true },
  { feature: 'Advanced progress insights', free: false, pro: true },
  { feature: 'Priority support', free: false, pro: true },
])

const trustSignals = [
  { icon: '🔒', label: 'No lock-in', desc: 'Cancel anytime' },
  { icon: '💳', label: 'Secure payment', desc: 'Powered by Stripe' },
  { icon: '📦', label: 'Your data', desc: 'Export anytime' },
  { icon: '💬', label: 'Get help', desc: 'Support responds in 24h' },
]

const faqs = [
  { q: 'Can I switch plans later?', a: 'Yes — upgrade or downgrade anytime. Changes take effect immediately and we prorate the difference.' },
  { q: 'What happens to my data if I downgrade?', a: 'Nothing. Your data stays intact. You just lose access to features above your new plan limit.' },
  { q: 'Do you offer refunds?', a: 'Contact us within 7 days of payment and we\'ll issue a full refund, no questions asked.' },
]

function isCurrent(planId: string) { return currentPlanId.value === planId }

function onAction(planId: string) {
  if (isCurrent(planId) || loading.value) return
  alert('Checkout is coming soon.')
}
</script>
