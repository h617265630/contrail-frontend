<template>
  <div>
    <div class="mb-6">
      <h1 class="text-2xl font-bold text-stone-900">Dashboard Overview</h1>
      <p class="text-sm text-stone-500 mt-1">Platform statistics and metrics</p>
    </div>

    <!-- Stats cards grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
      <Card v-for="stat in stats" :key="stat.label">
        <CardHeader>
          <CardDescription class="text-stone-500">{{ stat.label }}</CardDescription>
        </CardHeader>
        <CardContent>
          <p class="text-3xl font-bold text-stone-900">{{ stat.value.toLocaleString() }}</p>
          <p v-if="stat.trend" class="text-xs text-emerald-600 mt-1">
            +{{ stat.trend }} this week
          </p>
        </CardContent>
      </Card>
    </div>

    <!-- Quick actions -->
    <div class="flex flex-wrap gap-3">
      <RouterLink to="/admin/users">
        <Button>Manage Users</Button>
      </RouterLink>
      <RouterLink to="/admin/resources">
        <Button variant="outline">Manage Resources</Button>
      </RouterLink>
      <RouterLink to="/admin/paths">
        <Button variant="outline">Manage Paths</Button>
      </RouterLink>
      <RouterLink to="/admin/analytics">
        <Button variant="outline">View Analytics</Button>
      </RouterLink>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { RouterLink } from 'vue-router'
import { Card, CardHeader, CardTitle, CardContent, CardDescription } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { getAdminStats } from '@/api/admin'

const stats = ref([
  { label: 'Total Users', value: 0, trend: 0 },
  { label: 'Active Users', value: 0, trend: 0 },
  { label: 'Learning Paths', value: 0, trend: 0 },
  { label: 'Resources', value: 0, trend: 0 },
])

onMounted(async () => {
  try {
    const data = await getAdminStats()
    stats.value = [
      { label: 'Total Users', value: data.total_users, trend: data.users_last_7_days },
      { label: 'Active Users', value: data.active_users, trend: 0 },
      { label: 'Learning Paths', value: data.total_learning_paths, trend: data.paths_last_7_days },
      { label: 'Resources', value: data.total_resources, trend: data.resources_last_7_days },
    ]
  } catch (e) {
    console.error('Failed to load stats', e)
  }
})
</script>
