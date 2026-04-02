<template>
  <article
    v-if="variant === 'hero'"
    class="group relative flex gap-0 rounded-md overflow-hidden bg-white border border-stone-100 shadow-sm hover:border-stone-200 hover:shadow-2xl transition-all duration-300 cursor-pointer"
    @click="$emit('open')"
  >
    <div class="shrink-0 bg-stone-100 relative" style="width: 256px; flex-shrink: 0;">
      <img
        :src="thumbnail"
        :alt="title"
        loading="lazy"
        class="block w-full h-full object-cover"
      />
    </div>

    <div class="flex-1 p-6 flex flex-col justify-between">
      <div>
        <div class="flex items-center gap-2 mb-2">
          <span
            class="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded"
            :style="{ backgroundColor: categoryColor + '18', color: categoryColor }"
          >
            {{ categoryLabel }}
          </span>
          <span class="text-[10px] text-stone-400">#{{ idLabel }}</span>
        </div>
        <h3 class="text-lg font-bold text-stone-900 leading-snug group-hover:text-amber-700 transition-colors">
          {{ title }}
        </h3>
        <p class="text-sm text-stone-500 mt-2 line-clamp-2">{{ summary || '' }}</p>
      </div>

      <div class="flex items-center justify-between mt-4">
        <span class="text-xs text-stone-400">{{ platformLabel }} · {{ typeLabel }}</span>
        <button
          v-if="showAdd && !saved"
          class="text-[11px] font-semibold uppercase tracking-wider text-stone-400 hover:text-amber-600 transition-colors"
          @click.stop="$emit('add')"
        >
          {{ saving ? savingLabel : addLabel }}
        </button>
        <span v-else-if="saved" class="text-[11px] font-semibold uppercase tracking-wider text-emerald-500">{{ savedLabel }}</span>
      </div>
    </div>
  </article>

  <article
    v-else
    class="h-full rounded-md overflow-hidden bg-white border border-stone-100 shadow-sm hover:border-stone-200 hover:shadow-2xl transition-all duration-200 cursor-pointer flex flex-col"
    @click="$emit('open')"
  >
    <div class="flex items-center justify-between gap-2 px-3.5 py-2">
      <span
        class="text-[10px] font-semibold uppercase tracking-wider"
        :style="{ color: categoryColor }"
      >
        {{ categoryLabel }}
      </span>
      <span class="inline-flex items-center rounded-full bg-stone-100 px-2 py-0.5 text-[9px] font-bold uppercase tracking-wider text-stone-500">
        {{ typeLabel }}
      </span>
    </div>

    <div
      class="card-image bg-stone-100 border-y border-stone-200"
    >
      <img
        :src="thumbnail"
        :alt="title"
        loading="lazy"
        class="block w-full h-full"
      />
    </div>

    <div class="flex-1 p-3.5 flex flex-col">
      <h3
        class="text-sm font-semibold text-stone-800 leading-snug line-clamp-2 group-hover:text-amber-700 transition-colors"
        :title="title"
      >
        {{ title }}
      </h3>
      <p class="text-xs text-stone-400 mt-1 line-clamp-2 flex-1">{{ summary || '' }}</p>
      <div class="flex items-center justify-between mt-3 pt-2 border-t border-stone-50">
        <span class="text-[10px] text-stone-400">{{ platformLabel }}</span>
        <button
          v-if="showAdd && !saved"
          class="text-[10px] font-semibold text-stone-400 hover:text-amber-600 transition-colors"
          @click.stop="$emit('add')"
        >
          {{ saving ? savingLabel : addLabel }}
        </button>
        <span v-else-if="saved" class="text-[10px] font-semibold text-emerald-500">{{ savedLabel }}</span>
      </div>
    </div>
  </article>
</template>

<script setup lang="ts">
const props = defineProps<{
  variant?: 'standard' | 'hero'
  thumbnail: string
  title: string
  summary?: string
  categoryLabel: string
  categoryColor: string
  platformLabel: string
  typeLabel: string
  idLabel?: string
  showAdd?: boolean
  addLabel?: string
  saving?: boolean
  savingLabel?: string
  saved?: boolean
  savedLabel?: string
}>()

defineEmits<{
  open: []
  add: []
}>()

const variant = props.variant ?? 'standard'
const showAdd = props.showAdd ?? true
const addLabel = props.addLabel ?? '+ Save'
const idLabel = props.idLabel ?? ''
const saving = props.saving ?? false
const savingLabel = props.savingLabel ?? 'Saving…'
const saved = props.saved ?? false
const savedLabel = props.savedLabel ?? 'Saved'
</script>

<style scoped>
.card-image {
  width: 100%;
  aspect-ratio: 16 / 9;
  overflow: hidden;
}

.card-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
</style>
