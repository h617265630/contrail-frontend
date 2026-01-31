<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Edit Resource</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">Update URL, name, and description.</p>
        </div>
        <div class="md:col-span-4 md:flex md:justify-end md:items-end">
          <Button type="button" variant="outline" size="sm" class="rounded-none" @click="goBack">Back</Button>
        </div>
      </div>
    </section>

    <Card as="section" :hoverable="false" class="rounded-none">
      <div class="p-6">
        <div v-if="loading" class="text-sm text-muted-foreground">Loading…</div>
        <div v-else class="space-y-4">
          <div>
            <label class="block text-sm font-semibold text-foreground mb-2">URL</label>
            <Input v-model="form.url" type="url" class="h-10 rounded-none" placeholder="https://..." />
          </div>

          <div>
            <label class="block text-sm font-semibold text-foreground mb-2">Name</label>
            <Input v-model="form.title" type="text" class="h-10 rounded-none" placeholder="Resource title" />
          </div>

          <div>
            <label class="block text-sm font-semibold text-foreground mb-2">Description</label>
            <textarea
              v-model="form.description"
              rows="5"
              class="w-full px-3 py-2 rounded-none border border-border bg-background text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 focus:ring-offset-background"
              placeholder="Resource description"
            />
          </div>

          <p v-if="error" class="text-sm text-red-600">{{ error }}</p>

          <div class="flex gap-3 justify-end">
            <Button type="button" variant="outline" size="sm" class="rounded-none" @click="goBack">Cancel</Button>
            <Button
              type="button"
              variant="outline"
              size="sm"
              class="rounded-none bg-[#8ecbff] text-white hover:bg-[#8ecbff]/90 hover:text-white disabled:opacity-50 disabled:cursor-not-allowed"
              :disabled="saving || !form.url || !form.title"
              @click="save"
            >
              {{ saving ? 'Saving…' : 'Save' }}
            </Button>
          </div>
        </div>
      </div>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
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
      url: String((detail as any).source_url || ''),
      title: String(detail.title || ''),
      description: String((detail as any).summary || ''),
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
      title: form.value.title,
      summary: form.value.description,
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
