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
            <p class="mt-2 text-xl font-semibold text-foreground">{{ planInfo.name }}</p>
          </div>
          <span class="rounded-md border border-border bg-muted/30 px-3 py-1 text-sm font-semibold text-foreground">{{ planInfo.name }}</span>
        </div>

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
            <li v-for="p in planInfo.permissions" :key="p">{{ p }}</li>
          </ul>
        </div>
      </div>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { addDaysIso, daysBetween, formatIsoDate, getPlanInfo } from '../utils/plan'
import Card from '../components/ui/Card.vue'

const planInfo = computed(() => getPlanInfo())

const purchasedText = computed(() => {
  const days = planInfo.value.duration_days
  if (!days || days <= 0) return '—'
  return `${days} days`
})

const startedText = computed(() => formatIsoDate(planInfo.value.purchased_at))

const activeForText = computed(() => {
  if (!planInfo.value.purchased_at) return '—'
  const nowIso = new Date().toISOString()
  const n = daysBetween(planInfo.value.purchased_at, nowIso)
  return `${n} days`
})

const expiresText = computed(() => {
  if (!planInfo.value.purchased_at) return ''
  const days = planInfo.value.duration_days
  if (!days || days <= 0) return ''
  const expiresIso = addDaysIso(planInfo.value.purchased_at, days)
  return formatIsoDate(expiresIso)
})
</script>
