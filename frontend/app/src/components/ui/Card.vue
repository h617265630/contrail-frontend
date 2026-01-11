<template>
  <component
    :is="as"
    :class="[
      // base card styling (参考 learningpool 卡片)：白底、圆角、阴影、无黑色边框
      'bg-white rounded-xl shadow-lg overflow-hidden transition-shadow',
      hoverable ? 'hover:shadow-xl' : '',
      padded ? 'p-5' : '',
      className,
    ]"
  >
    <slot />
  </component>
</template>

<script setup lang="ts">
type AsTag = keyof HTMLElementTagNameMap

withDefaults(
  defineProps<{
    as?: AsTag
    hoverable?: boolean
    padded?: boolean
    className?: string
  }>(),
  {
    as: 'div',
    hoverable: true,
    padded: false,
    className: '',
  },
)
</script>
