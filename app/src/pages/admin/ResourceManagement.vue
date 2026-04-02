<template>
  <div>
    <div class="flex justify-between items-center mb-6">
      <div>
        <h1 class="text-2xl font-bold text-stone-900">Resource Management</h1>
        <p class="text-sm text-stone-500 mt-1">Manage platform resources</p>
      </div>
    </div>

    <!-- Resources table -->
    <div class="rounded-md border bg-white">
      <table class="w-full text-sm">
        <thead>
          <tr class="border-b bg-stone-50">
            <th class="px-4 py-3 text-left font-medium text-stone-600">Title</th>
            <th class="px-4 py-3 text-left font-medium text-stone-600">Type</th>
            <th class="px-4 py-3 text-left font-medium text-stone-600">Platform</th>
            <th class="px-4 py-3 text-left font-medium text-stone-600">Category</th>
            <th class="px-4 py-3 text-left font-medium text-stone-600">Saves</th>
            <th class="px-4 py-3 text-left font-medium text-stone-600">Trending</th>
            <th class="px-4 py-3 text-left font-medium text-stone-600">Created</th>
            <th class="px-4 py-3 text-left font-medium text-stone-600">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="resource in resources" :key="resource.id" class="border-b last:border-0 hover:bg-stone-50">
            <td class="px-4 py-3">
              <div class="font-medium text-stone-900 max-w-xs truncate">{{ resource.title }}</div>
            </td>
            <td class="px-4 py-3">
              <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-stone-100 text-stone-700">
                {{ resource.resource_type }}
              </span>
            </td>
            <td class="px-4 py-3 text-stone-600">{{ resource.platform || '-' }}</td>
            <td class="px-4 py-3 text-stone-600">{{ resource.category_name || '-' }}</td>
            <td class="px-4 py-3 text-stone-600">{{ resource.save_count.toLocaleString() }}</td>
            <td class="px-4 py-3 text-stone-600">{{ resource.trending_score.toLocaleString() }}</td>
            <td class="px-4 py-3 text-stone-500 text-xs">{{ formatDate(resource.created_at) }}</td>
            <td class="px-4 py-3">
              <Button size="sm" variant="ghost" class="text-red-600 hover:text-red-700" @click="deleteResource(resource)">
                Delete
              </Button>
            </td>
          </tr>
          <tr v-if="resources.length === 0">
            <td colspan="8" class="px-4 py-8 text-center text-stone-500">No resources found</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <div class="flex justify-between items-center mt-4">
      <p class="text-sm text-stone-500">Total: {{ total }} resources</p>
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
import { getAdminResources, deleteAdminResource, type AdminResource } from '@/api/admin'

const resources = ref<AdminResource[]>([])
const total = ref(0)
const skip = ref(0)
const limit = ref(20)

async function loadResources() {
  try {
    const data = await getAdminResources({ skip: skip.value, limit: limit.value })
    resources.value = data.resources
    total.value = data.total
  } catch (e) {
    console.error('Failed to load resources', e)
  }
}

function prevPage() {
  skip.value = Math.max(0, skip.value - limit.value)
  loadResources()
}

function nextPage() {
  skip.value += limit.value
  loadResources()
}

async function deleteResource(resource: AdminResource) {
  if (!confirm(`Delete "${resource.title}"?`)) return
  try {
    await deleteAdminResource(resource.id)
    loadResources()
  } catch (e) {
    console.error('Failed to delete resource', e)
  }
}

function formatDate(dateStr: string) {
  return new Date(dateStr).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  })
}

onMounted(loadResources)
</script>
