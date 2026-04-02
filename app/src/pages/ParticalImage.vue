<template>
  <div class="space-y-6">
    <div v-if="loading" class="rounded-md border border-border bg-muted/30 p-6 text-sm text-muted-foreground">
      Loading…
    </div>

    <div v-else-if="error" class="rounded-md border border-border bg-muted/30 p-6">
      <p class="text-sm font-semibold text-foreground">加载失败</p>
      <p class="mt-1 text-sm text-muted-foreground">{{ error }}</p>
      <Button type="button" variant="outline" size="sm" class="mt-4 rounded-md" @click="load">Retry</Button>
    </div>

    <div v-else-if="images.length === 0" class="rounded-md border border-border bg-muted/30 p-6">
      <p class="text-sm font-semibold text-foreground">暂无图片</p>
      <p class="mt-1 text-sm text-muted-foreground">你在 Creator 里上传的图片会显示在这里。</p>
    </div>

    <div v-else class="space-y-4">
      <div class="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4">
        <div
          v-for="img in images"
          :key="img.id"
          class="overflow-hidden rounded-md border border-border bg-background"
        >
          <div class="aspect-video bg-muted/30">
            <img
              :src="img.image_url"
              :alt="img.title || 'image'"
              class="h-full w-full object-contain"
              style="object-fit: contain; background-color: #f7f7f7;"
              loading="lazy"
            />
          </div>
          <div class="p-3">
            <p class="text-sm font-semibold text-foreground truncate" :title="img.title || '无标题'">
              {{ img.title || '无标题' }}
            </p>
            <p class="mt-1 text-xs text-muted-foreground">{{ formatTime(img.created_at) }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { Button } from '../components/ui/button'
import { listMyUserImages, type UserImage } from '../api/userImage'

const loading = ref(false)
const error = ref('')
const images = ref<UserImage[]>([])

function formatTime(v: string) {
  try {
    const d = new Date(v)
    return Number.isNaN(d.getTime()) ? v : d.toLocaleString()
  } catch {
    return v
  }
}

async function load() {
  loading.value = true
  error.value = ''
  try {
    const data = await listMyUserImages()
    images.value = data || []
  } catch (e: any) {
    error.value = String(e?.response?.data?.detail || e?.message || 'Failed to load')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  load()
})
</script>
