<template>
  <div class="space-y-4">
    <div class="rounded-2xl bg-white p-5 shadow-sm border border-slate-100">
      <h1 class="text-xl font-semibold text-slate-900">Plan</h1>
      <p class="text-sm text-slate-600 mt-1">Your current plan and permissions</p>
    </div>

    <div class="rounded-2xl bg-white p-6 shadow-sm border border-slate-100 space-y-5">
      <div class="flex items-center justify-between">
        <div>
          <p class="text-xs font-semibold text-slate-500 uppercase tracking-wide">Current plan</p>
          <p class="mt-1 text-xl font-semibold text-slate-900">{{ planInfo.name }}</p>
        </div>
        <span class="rounded-full bg-slate-100 px-3 py-1 text-sm font-semibold text-slate-800">{{ planInfo.name }}</span>
      </div>

      <div class="grid gap-3 sm:grid-cols-2">
        <div class="rounded-xl border border-slate-100 bg-slate-50 p-4">
          <p class="text-xs font-semibold text-slate-500">Purchased</p>
          <p class="mt-1 text-sm font-semibold text-slate-900">{{ purchasedText }}</p>
        </div>
        <div class="rounded-xl border border-slate-100 bg-slate-50 p-4">
          <p class="text-xs font-semibold text-slate-500">Started</p>
          <p class="mt-1 text-sm font-semibold text-slate-900">{{ startedText || '—' }}</p>
        </div>
        <div class="rounded-xl border border-slate-100 bg-slate-50 p-4">
          <p class="text-xs font-semibold text-slate-500">Active for</p>
          <p class="mt-1 text-sm font-semibold text-slate-900">{{ activeForText }}</p>
        </div>
        <div class="rounded-xl border border-slate-100 bg-slate-50 p-4">
          <p class="text-xs font-semibold text-slate-500">Expires</p>
          <p class="mt-1 text-sm font-semibold text-slate-900">{{ expiresText || '—' }}</p>
        </div>
      </div>

      <div>
        <p class="text-xs font-semibold text-slate-500 uppercase tracking-wide">Permissions</p>
        <ul class="mt-2 space-y-1 text-sm text-slate-700 list-disc list-inside">
          <li v-for="p in planInfo.permissions" :key="p">{{ p }}</li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { addDaysIso, daysBetween, formatIsoDate, getPlanInfo } from '../utils/plan'

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
