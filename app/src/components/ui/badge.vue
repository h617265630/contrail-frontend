<script setup lang="ts">
import { type HTMLAttributes } from 'vue'

interface Props {
  variant?: 'default' | 'secondary' | 'destructive' | 'outline'
  class?: HTMLAttributes['class']
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'default',
})

const variantClasses = {
  default: 'border-transparent bg-primary text-primary-foreground',
  secondary: 'border-transparent bg-secondary text-secondary-foreground',
  destructive: 'border-transparent bg-destructive text-destructive-foreground',
  outline: 'text-foreground',
}
</script>

<template>
  <span :class="['inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors', variantClasses[variant], props.class]">
    <slot />
  </span>
</template>
