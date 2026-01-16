<template>
  <div class="min-h-screen bg-linear-to-br from-blue-50 to-indigo-100 p-6">
    <div class="max-w-3xl mx-auto space-y-6">
      <div class="bg-white rounded-2xl shadow-xl p-6">
        <div class="flex items-start justify-between gap-4">
          <div class="min-w-0">
            <h1 class="text-gray-900 mb-1">Edit Resource</h1>
            <p class="text-gray-600 text-sm">修改 URL、名称和介绍</p>
          </div>
          <button
            type="button"
            class="px-4 py-2 rounded-lg bg-white border border-gray-200 text-gray-700 hover:bg-gray-50"
            @click="goBack"
          >
            Back
          </button>
        </div>
      </div>

      <div class="bg-white rounded-2xl shadow-xl p-6">
        <div v-if="loading" class="text-gray-600 text-sm">Loading…</div>
        <div v-else class="space-y-4">
          <div>
            <label class="block text-gray-700 mb-2">URL</label>
            <input
              v-model="form.url"
              type="url"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="https://www.youtube.com/watch?v=..."
            />
          </div>

          <div>
            <label class="block text-gray-700 mb-2">Name</label>
            <input
              v-model="form.title"
              type="text"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="Resource title"
            />
          </div>

          <div>
            <label class="block text-gray-700 mb-2">Description</label>
            <textarea
              v-model="form.description"
              rows="5"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="Resource description"
            />
          </div>

          <p v-if="error" class="text-sm text-red-600">{{ error }}</p>

          <div class="flex gap-3 justify-end">
            <button
              type="button"
              class="px-6 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50"
              @click="goBack"
            >
              Cancel
            </button>
            <button
              type="button"
              class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
              :disabled="saving || !form.url || !form.title"
              @click="save"
            >
              {{ saving ? 'Saving…' : 'Save' }}
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getMyResourceDetail, updateMyResource } from '../api/resource'

const route = useRoute()
const router = useRouter()

const resourceId = Number(route.params.id)

const loading = ref(false)
const saving = ref(false)
const error = ref('')

const form = ref({
  url: '',
  title: '',
  description: '',
})

function goBack() {
  router.push({ name: 'my-resources' })
}

onMounted(async () => {
  if (!Number.isFinite(resourceId)) {
    error.value = 'Invalid resource id'
    return
  }

  loading.value = true
  try {
    const detail = await getMyResourceDetail(resourceId)
    form.value = {
      url: String(detail.url || ''),
      title: String(detail.title || ''),
      description: String(detail.description || ''),
    }
  } catch (e: any) {
    const msg = e?.response?.data?.detail || e?.message || 'Failed to load resource'
    error.value = String(msg)
  } finally {
    loading.value = false
  }
})

async function save() {
  if (!Number.isFinite(resourceId)) return
  error.value = ''
  saving.value = true
  try {
    await updateMyResource(resourceId, {
      url: form.value.url,
      title: form.value.title,
      description: form.value.description,
    })
    router.push({ name: 'my-resources' })
  } catch (e: any) {
    const msg = e?.response?.data?.detail || e?.message || 'Failed to save'
    error.value = String(msg)
  } finally {
    saving.value = false
  }
}
</script>
