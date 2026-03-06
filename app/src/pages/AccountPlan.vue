<template>
  <div class="space-y-6">
    <div>
      <h3 class="text-lg font-semibold text-foreground">Plan</h3>
      <p class="mt-2 text-sm text-muted-foreground">Your current plan and permissions</p>
    </div>

    <Card as="section" :hoverable="false" class="rounded-md">
      <div class="space-y-5 p-6">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-xs font-semibold text-muted-foreground uppercase tracking-[0.14em]">Current plan</p>
            <p class="mt-2 text-xl font-semibold text-foreground">{{ effectivePlan }}</p>
          </div>
          <span class="rounded-md border border-border bg-muted/30 px-3 py-1 text-sm font-semibold text-foreground">{{ effectivePlan }}</span>
        </div>

        <p v-if="loadError" class="text-sm text-destructive">{{ loadError }}</p>

        <div class="grid gap-3 sm:grid-cols-2">
          <div class="rounded-md border border-border bg-muted/30 p-4">
            <p class="text-xs font-semibold text-muted-foreground">Purchased</p>
            <p class="mt-1 text-sm font-semibold text-foreground">{{ purchasedText }}</p>
          </div>
          <div class="rounded-md border border-border bg-muted/30 p-4">
            <p class="text-xs font-semibold text-muted-foreground">Started</p>
            <p class="mt-1 text-sm font-semibold text-foreground">{{ startedText || '—' }}</p>
          </div>
          <div class="rounded-md border border-border bg-muted/30 p-4">
            <p class="text-xs font-semibold text-muted-foreground">Active for</p>
            <p class="mt-1 text-sm font-semibold text-foreground">{{ activeForText }}</p>
          </div>
          <div class="rounded-md border border-border bg-muted/30 p-4">
            <p class="text-xs font-semibold text-muted-foreground">Expires</p>
            <p class="mt-1 text-sm font-semibold text-foreground">{{ expiresText || '—' }}</p>
          </div>
        </div>

        <div>
          <p class="text-xs font-semibold text-muted-foreground uppercase tracking-[0.14em]">Permissions</p>
          <ul class="mt-2 space-y-1 text-sm text-muted-foreground list-disc list-inside">
            <li v-for="p in permissions" :key="p">{{ p }}</li>
          </ul>
        </div>
      </div>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { getMySubscription, type SubscriptionMeResponse } from '../api/subscription'
import Card from '../components/ui/Card.vue'

const subscription = ref<SubscriptionMeResponse | null>(null)
const loadError = ref('')

function hasToken() {
  try {
    const storage = (globalThis as any).localStorage
    return Boolean(String(storage?.getItem?.('learnsmart_token') || '').trim())
  } catch {
    return false
  }
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

const planCode = computed(() => {
  const code = subscription.value?.plan_code
  return code ? String(code) : ''
})

const purchasedText = computed(() => {
  if (!planCode.value) return '—'
  return planCode.value
})

const startedText = computed(() => '')

const activeForText = computed(() => {
  return '—'
})

const expiresText = computed(() => {
  const iso = subscription.value?.current_period_end
  if (!iso) return ''
  const d = new Date(String(iso))
  if (Number.isNaN(d.getTime())) return ''
  return d.toLocaleDateString()
})

const permissions = computed(() => {
  const name = effectivePlan.value
  if (name === 'Pro') {
    return ['Team collaboration & sharing', 'Custom paths & templates', 'Advanced search & filters', 'Priority support']
  }
  if (name === 'Basic') {
    return ['All learning paths', 'Manage resources', 'Cloud notes sync', 'Progress tracking & export']
  }
  return ['View public resources', 'Preview learning paths', 'Local notes']
})
</script>
