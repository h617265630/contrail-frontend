<template>
  <div class="mx-auto max-w-7xl px-4 py-8">
    <!-- Header -->
    <div class="mb-8 pb-6 border-b border-stone-200">
      <div class="flex items-end justify-between">
        <div>
          <p class="text-[10px] font-bold uppercase tracking-[0.3em] text-amber-500 mb-2">Admin</p>
          <h1 class="text-3xl md:text-4xl font-black tracking-tight text-stone-900 font-serif leading-tight">Dashboard.</h1>
        </div>
        <RouterLink to="/home" class="hidden md:flex items-center gap-1.5 text-xs text-stone-400 hover:text-stone-600 transition-colors">
          <span>← Back</span>
        </RouterLink>
      </div>
    </div>

    <!-- Stats Grid -->
    <div class="grid grid-cols-2 md:grid-cols-5 gap-4 mb-8">
      <div v-for="stat in statCards" :key="stat.label" class="p-4 bg-stone-900 rounded-md">
        <p class="text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400 mb-2">{{ stat.label }}</p>
        <p class="text-2xl font-black text-white">{{ stat.value }}</p>
      </div>
    </div>

    <!-- Tabs -->
    <div class="flex gap-1 mb-6 bg-stone-100 p-1 rounded-lg w-fit">
      <button
        v-for="tab in tabs"
        :key="tab.key"
        @click="activeTab = tab.key"
        class="px-4 py-2 text-xs font-semibold rounded-sm transition-all"
        :class="activeTab === tab.key ? 'bg-white text-stone-900 shadow-sm' : 'text-stone-500 hover:text-stone-700'"
      >
        {{ tab.label }}
      </button>
    </div>

    <!-- Tab Content -->
    <div v-if="loading" class="text-center py-12 text-stone-400">Loading...</div>
    <div v-else-if="error" class="text-center py-12 text-red-400">{{ error }}</div>
    <div v-else>

      <!-- Users Tab -->
      <div v-if="activeTab === 'users'" class="bg-white rounded-md border border-stone-200 overflow-hidden">
        <table class="w-full text-sm">
          <thead>
            <tr class="bg-stone-50 border-b border-stone-200">
              <th class="text-left px-4 py-3 font-semibold text-stone-600">User</th>
              <th class="text-left px-4 py-3 font-semibold text-stone-600">Email</th>
              <th class="text-left px-4 py-3 font-semibold text-stone-600">Role</th>
              <th class="text-left px-4 py-3 font-semibold text-stone-600">Status</th>
              <th class="text-left px-4 py-3 font-semibold text-stone-600">Joined</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="user in users" :key="user.id" class="border-b border-stone-100 hover:bg-stone-50">
              <td class="px-4 py-3">
                <div class="flex items-center gap-2">
                  <div class="w-7 h-7 rounded-none bg-amber-100 flex items-center justify-center text-amber-700 text-xs font-bold">
                    {{ user.display_name?.[0] || user.username[0] }}
                  </div>
                  <span class="font-medium text-stone-900">{{ user.display_name || user.username }}</span>
                </div>
              </td>
              <td class="px-4 py-3 text-stone-500">{{ user.email }}</td>
              <td class="px-4 py-3">
                <span v-if="user.is_superuser" class="text-[10px] font-bold uppercase tracking-wider text-amber-600 bg-amber-50 px-2 py-0.5 rounded">Admin</span>
                <span v-else class="text-[10px] font-bold uppercase tracking-wider text-stone-400 bg-stone-100 px-2 py-0.5 rounded">User</span>
              </td>
              <td class="px-4 py-3">
                <span :class="user.is_active ? 'text-green-600' : 'text-red-500'" class="text-xs font-medium">
                  {{ user.is_active ? 'Active' : 'Inactive' }}
                </span>
              </td>
              <td class="px-4 py-3 text-stone-400 text-xs">{{ formatDate(user.created_at) }}</td>
            </tr>
          </tbody>
        </table>
        <div v-if="users.length === 0" class="text-center py-8 text-stone-400">No users found</div>
      </div>

      <!-- Learning Paths Tab -->
      <div v-if="activeTab === 'paths'" class="bg-white rounded-md border border-stone-200 overflow-hidden">
        <table class="w-full text-sm">
          <thead>
            <tr class="bg-stone-50 border-b border-stone-200">
              <th class="text-left px-4 py-3 font-semibold text-stone-600">Title</th>
              <th class="text-left px-4 py-3 font-semibold text-stone-600">Visibility</th>
              <th class="text-left px-4 py-3 font-semibold text-stone-600">Created</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="path in learningPaths" :key="path.id" class="border-b border-stone-100 hover:bg-stone-50">
              <td class="px-4 py-3 font-medium text-stone-900">{{ path.title }}</td>
              <td class="px-4 py-3">
                <span :class="path.is_public ? 'bg-green-50 text-green-600' : 'bg-stone-100 text-stone-500'" class="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded">
                  {{ path.is_public ? 'Public' : 'Private' }}
                </span>
              </td>
              <td class="px-4 py-3 text-stone-400 text-xs">{{ formatDate(path.created_at) }}</td>
            </tr>
          </tbody>
        </table>
        <div v-if="learningPaths.length === 0" class="text-center py-8 text-stone-400">No learning paths found</div>
      </div>

      <!-- Resources Tab -->
      <div v-if="activeTab === 'resources'" class="bg-white rounded-md border border-stone-200 overflow-hidden">
        <table class="w-full text-sm">
          <thead>
            <tr class="bg-stone-50 border-b border-stone-200">
              <th class="text-left px-4 py-3 font-semibold text-stone-600">Title</th>
              <th class="text-left px-4 py-3 font-semibold text-stone-600">Type</th>
              <th class="text-left px-4 py-3 font-semibold text-stone-600">Platform</th>
              <th class="text-left px-4 py-3 font-semibold text-stone-600">Difficulty</th>
              <th class="text-left px-4 py-3 font-semibold text-stone-600">Created</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="resource in resources" :key="resource.id" class="border-b border-stone-100 hover:bg-stone-50">
              <td class="px-4 py-3 font-medium text-stone-900 truncate max-w-xs">{{ resource.title }}</td>
              <td class="px-4 py-3">
                <span class="text-[10px] font-bold uppercase tracking-wider text-stone-500 bg-stone-100 px-2 py-0.5 rounded">
                  {{ resource.resource_type }}
                </span>
              </td>
              <td class="px-4 py-3 text-stone-500 text-xs">{{ resource.platform || '—' }}</td>
              <td class="px-4 py-3 text-stone-500 text-xs">{{ resource.difficulty || '—' }}</td>
              <td class="px-4 py-3 text-stone-400 text-xs">{{ formatDate(resource.created_at) }}</td>
            </tr>
          </tbody>
        </table>
        <div v-if="resources.length === 0" class="text-center py-8 text-stone-400">No resources found</div>
      </div>

    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { adminApi } from '../api/admin'
import type { AdminStats, UserItem, LearningPathItem, ResourceItem } from '../api/admin'

const activeTab = ref<'users' | 'paths' | 'resources'>('users')
const loading = ref(false)
const error = ref('')

const stats = ref<AdminStats | null>(null)
const users = ref<UserItem[]>([])
const learningPaths = ref<LearningPathItem[]>([])
const resources = ref<ResourceItem[]>([])

const tabs = [
  { key: 'users' as const, label: 'Users' },
  { key: 'paths' as const, label: 'Learning Paths' },
  { key: 'resources' as const, label: 'Resources' },
]

const statCards = [
  { label: 'Total Users', value: '' },
  { label: 'Learning Paths', value: '' },
  { label: 'Resources', value: '' },
  { label: 'Enrollments', value: '' },
  { label: 'Active (7d)', value: '' },
]

function updateStatValues() {
  if (!stats.value) return
  statCards[0].value = String(stats.value.total_users)
  statCards[1].value = String(stats.value.total_learning_paths)
  statCards[2].value = String(stats.value.total_resources)
  statCards[3].value = String(stats.value.total_user_learning_paths)
  statCards[4].value = String(stats.value.active_users_7d)
}

function formatDate(dateStr: string): string {
  if (!dateStr) return '—'
  return new Date(dateStr).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
}

async function loadStats() {
  try {
    const { data } = await adminApi.getStats()
    stats.value = data
    updateStatValues()
  } catch (e: any) {
    if (e?.response?.status === 403 || e?.response?.status === 401) {
      error.value = 'Access denied. Admin only.'
    } else {
      error.value = 'Failed to load stats.'
    }
  }
}

async function loadUsers() {
  loading.value = true
  error.value = ''
  try {
    const { data } = await adminApi.getUsers()
    users.value = data
  } catch (e: any) {
    error.value = e?.response?.status === 403 ? 'Admin only.' : 'Failed to load users.'
  } finally {
    loading.value = false
  }
}

async function loadPaths() {
  loading.value = true
  error.value = ''
  try {
    const { data } = await adminApi.getLearningPaths()
    learningPaths.value = data
  } catch (e: any) {
    error.value = e?.response?.status === 403 ? 'Admin only.' : 'Failed to load paths.'
  } finally {
    loading.value = false
  }
}

async function loadResources() {
  loading.value = true
  error.value = ''
  try {
    const { data } = await adminApi.getResources()
    resources.value = data
  } catch (e: any) {
    error.value = e?.response?.status === 403 ? 'Admin only.' : 'Failed to load resources.'
  } finally {
    loading.value = false
  }
}

onMounted(async () => {
  await loadStats()
  await loadUsers()
})
</script>
