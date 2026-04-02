<template>
  <div>
    <div class="flex justify-between items-center mb-6">
      <div>
        <h1 class="text-2xl font-bold text-stone-900">Learning Path Management</h1>
        <p class="text-sm text-stone-500 mt-1">Manage platform learning paths</p>
      </div>
    </div>

    <!-- Learning Paths table -->
    <div class="rounded-md border bg-white">
      <table class="w-full text-sm">
        <thead>
          <tr class="border-b bg-stone-50">
            <th class="px-4 py-3 text-left font-medium text-stone-600">Title</th>
            <th class="px-4 py-3 text-left font-medium text-stone-600">Category</th>
            <th class="px-4 py-3 text-left font-medium text-stone-600">Visibility</th>
            <th class="px-4 py-3 text-left font-medium text-stone-600">Status</th>
            <th class="px-4 py-3 text-left font-medium text-stone-600">Users</th>
            <th class="px-4 py-3 text-left font-medium text-stone-600">Created</th>
            <th class="px-4 py-3 text-left font-medium text-stone-600">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="path in paths" :key="path.id" class="border-b last:border-0 hover:bg-stone-50">
            <td class="px-4 py-3">
              <div class="font-medium text-stone-900 max-w-xs truncate">{{ path.title }}</div>
            </td>
            <td class="px-4 py-3 text-stone-600">{{ path.category_name || '-' }}</td>
            <td class="px-4 py-3">
              <span
                class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium"
                :class="path.is_public ? 'bg-emerald-100 text-emerald-700' : 'bg-stone-100 text-stone-700'"
              >
                {{ path.is_public ? 'Public' : 'Private' }}
              </span>
            </td>
            <td class="px-4 py-3">
              <span
                class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium"
                :class="path.is_active ? 'bg-emerald-100 text-emerald-700' : 'bg-red-100 text-red-700'"
              >
                {{ path.is_active ? 'Active' : 'Inactive' }}
              </span>
            </td>
            <td class="px-4 py-3 text-stone-600">{{ path.user_count.toLocaleString() }}</td>
            <td class="px-4 py-3 text-stone-500 text-xs">{{ formatDate(path.created_at) }}</td>
            <td class="px-4 py-3">
              <Button size="sm" variant="ghost" class="text-red-600 hover:text-red-700" @click="deletePath(path)">
                Delete
              </Button>
            </td>
          </tr>
          <tr v-if="paths.length === 0">
            <td colspan="7" class="px-4 py-8 text-center text-stone-500">No learning paths found</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <div class="flex justify-between items-center mt-4">
      <p class="text-sm text-stone-500">Total: {{ total }} paths</p>
      <div class="flex gap-2">
        <Button variant="outline" size="sm" :disabled="skip === 0" @click="prevPage">Previous</Button>
        <Button variant="outline" size="sm" :disabled="skip + limit >= total" @click="nextPage">Next</Button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { Button } from '@/components/ui/button'
import { getAdminLearningPaths, deleteAdminLearningPath, type AdminLearningPath } from '@/api/admin'

const paths = ref<AdminLearningPath[]>([])
const total = ref(0)
const skip = ref(0)
const limit = ref(20)

async function loadPaths() {
  try {
    const data = await getAdminLearningPaths({ skip: skip.value, limit: limit.value })
    paths.value = data.paths
    total.value = data.total
  } catch (e) {
    console.error('Failed to load paths', e)
  }
}

function prevPage() {
  skip.value = Math.max(0, skip.value - limit.value)
  loadPaths()
}

function nextPage() {
  skip.value += limit.value
  loadPaths()
}

async function deletePath(path: AdminLearningPath) {
  if (!confirm(`Delete "${path.title}"?`)) return
  try {
    await deleteAdminLearningPath(path.id)
    loadPaths()
  } catch (e) {
    console.error('Failed to delete path', e)
  }
}

function formatDate(dateStr: string) {
  return new Date(dateStr).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  })
}

onMounted(loadPaths)
</script>
