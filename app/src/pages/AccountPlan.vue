<template>
  <div>
    <!-- Plan card -->
    <div class="mb-5 p-6 bg-white rounded-md border border-stone-100 shadow-sm">
      <div class="flex items-start justify-between mb-6">
        <div>
          <p class="text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400 mb-2">Current plan</p>
          <p class="text-3xl font-black text-stone-900 font-serif tracking-tight">{{ effectivePlan }}</p>
        </div>
        <span class="inline-flex items-center px-3 py-1.5 rounded-sm border border-stone-200 bg-stone-50 text-xs font-bold text-stone-600 uppercase tracking-wider">
          {{ effectivePlan }}
        </span>
      </div>

      <p v-if="loadError" class="text-xs text-red-500 py-2 px-3 border border-red-100 bg-red-50 rounded-lg">{{ loadError }}</p>

      <!-- Stats grid -->
      <div class="grid grid-cols-2 gap-3 mb-8">
        <div class="px-4 py-3 bg-stone-50 rounded-lg border border-stone-100">
          <p class="text-[10px] font-bold uppercase tracking-[0.15em] text-stone-400 mb-1">Plan</p>
          <p class="text-sm font-semibold text-stone-900">{{ purchasedText }}</p>
        </div>
        <div class="px-4 py-3 bg-stone-50 rounded-lg border border-stone-100">
          <p class="text-[10px] font-bold uppercase tracking-[0.15em] text-stone-400 mb-1">Expires</p>
          <p class="text-sm font-semibold text-stone-900">{{ expiresText || '—' }}</p>
        </div>
      </div>

      <!-- Permissions -->
      <div>
        <p class="text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400 mb-3">Permissions</p>
        <ul class="space-y-2">
          <li
            v-for="p in permissions"
            :key="p.label"
            class="flex items-center gap-2.5 text-sm"
          >
            <div class="w-4 h-4 shrink-0 rounded-full flex items-center justify-center" :class="p.included ? 'bg-emerald-100' : 'bg-stone-100'">
              <svg v-if="p.included" xmlns="http://www.w3.org/2000/svg" width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="oklch(55% 0.2 145)" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
              <svg v-else xmlns="http://www.w3.org/2000/svg" width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="oklch(55% 0.02 250)" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
            </div>
            <span :class="p.included ? 'text-stone-700' : 'text-stone-400'">{{ p.label }}</span>
          </li>
        </ul>
      </div>
    </div>

    <!-- Upgrade prompt -->
    <div v-if="effectivePlan === 'Free'" class="p-5 bg-amber-50 border border-amber-200 rounded-md">
      <p class="text-xs font-bold uppercase tracking-[0.15em] text-amber-600 mb-1">Upgrade available</p>
      <p class="text-sm text-stone-700 mb-3">Unlock team collaboration, custom paths, and priority support.</p>
      <button
        class="inline-flex items-center gap-2 px-4 py-2 bg-amber-500 text-white text-xs font-bold hover:bg-amber-600 transition-all rounded-sm"
        @click="router.push('/plan')"
      >
        View Plans →
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { getMySubscription, type SubscriptionMeResponse } from '../api/subscription'

const router = useRouter()
const subscription = ref<SubscriptionMeResponse | null>(null)
const loadError = ref('')

function hasToken() {
  try {
    const storage = (globalThis as any).localStorage
    return Boolean(String(storage?.getItem?.('learnsmart_token') || '').trim())
  } catch { return false }
}

onMounted(async () => {
  if (!hasToken()) return
  loadError.value = ''
  try {
    subscription.value = await getMySubscription()
  } catch {
    loadError.value = 'Failed to load your current plan.'
  }
})

const effectivePlan = computed(() => (subscription.value?.effective_plan || 'Free'))
const planCode = computed(() => String(subscription.value?.plan_code || ''))
const purchasedText = computed(() => planCode.value || '—')
const expiresText = computed(() => {
  const iso = subscription.value?.current_period_end
  if (!iso) return ''
  const d = new Date(String(iso))
  return Number.isNaN(d.getTime()) ? '' : d.toLocaleDateString()
})

const allPermissions = [
  { label: 'View public resources', plans: ['Free', 'Basic', 'Pro'] },
  { label: 'Preview learning paths', plans: ['Free', 'Basic', 'Pro'] },
  { label: 'Local notes', plans: ['Free', 'Basic', 'Pro'] },
  { label: 'All learning paths', plans: ['Basic', 'Pro'] },
  { label: 'Manage resources', plans: ['Basic', 'Pro'] },
  { label: 'Cloud notes sync', plans: ['Basic', 'Pro'] },
  { label: 'Progress tracking & export', plans: ['Basic', 'Pro'] },
  { label: 'Team collaboration & sharing', plans: ['Pro'] },
  { label: 'Custom paths & templates', plans: ['Pro'] },
  { label: 'Advanced search & filters', plans: ['Pro'] },
  { label: 'Priority support', plans: ['Pro'] },
]

const permissions = computed(() =>
  allPermissions.map(p => ({ ...p, included: p.plans.includes(effectivePlan.value as any) }))
)
</script>
