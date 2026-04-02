<template>
  <div>
    <div class="mb-6">
      <h1 class="text-2xl font-bold text-stone-900">Analytics</h1>
      <p class="text-sm text-stone-500 mt-1">Platform growth and trends</p>
    </div>

    <!-- Charts grid -->
    <div class="grid gap-6 lg:grid-cols-2">
      <!-- Daily Users Chart -->
      <Card>
        <CardHeader>
          <CardTitle>New Users (30 days)</CardTitle>
        </CardHeader>
        <CardContent>
          <div class="space-y-2">
            <div v-for="item in analytics.daily_users" :key="item.date" class="flex items-center gap-3">
              <span class="text-xs text-stone-500 w-20">{{ item.date }}</span>
              <div class="flex-1 h-4 bg-stone-100 rounded overflow-hidden">
                <div
                  class="h-full bg-amber-500 rounded"
                  :style="{ width: `${getBarWidth(item.count, maxUsers)}%` }"
                />
              </div>
              <span class="text-sm font-medium text-stone-700 w-8 text-right">{{ item.count }}</span>
            </div>
            <div v-if="analytics.daily_users.length === 0" class="text-sm text-stone-500 py-4 text-center">
              No data available
            </div>
          </div>
        </CardContent>
      </Card>

      <!-- Daily Learning Paths Chart -->
      <Card>
        <CardHeader>
          <CardTitle>New Learning Paths (30 days)</CardTitle>
        </CardHeader>
        <CardContent>
          <div class="space-y-2">
            <div v-for="item in analytics.daily_paths" :key="item.date" class="flex items-center gap-3">
              <span class="text-xs text-stone-500 w-20">{{ item.date }}</span>
              <div class="flex-1 h-4 bg-stone-100 rounded overflow-hidden">
                <div
                  class="h-full bg-emerald-500 rounded"
                  :style="{ width: `${getBarWidth(item.count, maxPaths)}%` }"
                />
              </div>
              <span class="text-sm font-medium text-stone-700 w-8 text-right">{{ item.count }}</span>
            </div>
            <div v-if="analytics.daily_paths.length === 0" class="text-sm text-stone-500 py-4 text-center">
              No data available
            </div>
          </div>
        </CardContent>
      </Card>

      <!-- Daily Resources Chart -->
      <Card>
        <CardHeader>
          <CardTitle>New Resources (30 days)</CardTitle>
        </CardHeader>
        <CardContent>
          <div class="space-y-2">
            <div v-for="item in analytics.daily_resources" :key="item.date" class="flex items-center gap-3">
              <span class="text-xs text-stone-500 w-20">{{ item.date }}</span>
              <div class="flex-1 h-4 bg-stone-100 rounded overflow-hidden">
                <div
                  class="h-full bg-blue-500 rounded"
                  :style="{ width: `${getBarWidth(item.count, maxResources)}%` }"
                />
              </div>
              <span class="text-sm font-medium text-stone-700 w-8 text-right">{{ item.count }}</span>
            </div>
            <div v-if="analytics.daily_resources.length === 0" class="text-sm text-stone-500 py-4 text-center">
              No data available
            </div>
          </div>
        </CardContent>
      </Card>

      <!-- Top Categories -->
      <Card>
        <CardHeader>
          <CardTitle>Top Categories</CardTitle>
        </CardHeader>
        <CardContent>
          <div class="space-y-2">
            <div v-for="cat in analytics.top_categories" :key="cat.name" class="flex items-center gap-3">
              <span class="text-sm text-stone-700 flex-1">{{ cat.name }}</span>
              <span class="text-sm font-medium text-stone-900">{{ cat.count }}</span>
            </div>
            <div v-if="analytics.top_categories.length === 0" class="text-sm text-stone-500 py-4 text-center">
              No data available
            </div>
          </div>
        </CardContent>
      </Card>
    </div>

    <!-- Top Resources -->
    <Card class="mt-6">
      <CardHeader>
        <CardTitle>Most Saved Resources</CardTitle>
      </CardHeader>
      <CardContent>
        <div class="space-y-2">
          <div v-for="(res, idx) in analytics.top_resources" :key="idx" class="flex items-center gap-3 py-2 border-b last:border-0">
            <span class="w-6 h-6 rounded-full bg-stone-900 text-white text-xs flex items-center justify-center font-medium">
              {{ idx + 1 }}
            </span>
            <span class="flex-1 text-sm text-stone-700 truncate">{{ res.title }}</span>
            <span class="text-sm font-medium text-amber-600">{{ res.save_count.toLocaleString() }} saves</span>
          </div>
          <div v-if="analytics.top_resources.length === 0" class="text-sm text-stone-500 py-4 text-center">
            No data available
          </div>
        </div>
      </CardContent>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import { getAdminAnalytics, type AdminAnalytics } from '@/api/admin'

const analytics = ref<AdminAnalytics>({
  daily_users: [],
  daily_paths: [],
  daily_resources: [],
  top_categories: [],
  top_resources: [],
})

const maxUsers = computed(() => Math.max(...analytics.value.daily_users.map(i => i.count), 1))
const maxPaths = computed(() => Math.max(...analytics.value.daily_paths.map(i => i.count), 1))
const maxResources = computed(() => Math.max(...analytics.value.daily_resources.map(i => i.count), 1))

function getBarWidth(count: number, max: number): number {
  return (count / max) * 100
}

onMounted(async () => {
  try {
    analytics.value = await getAdminAnalytics(30)
  } catch (e) {
    console.error('Failed to load analytics', e)
  }
})
</script>
