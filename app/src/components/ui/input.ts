import { defineComponent, h, computed, type PropType } from 'vue'
import { cn } from './cn'

export const Input = defineComponent({
  name: 'UiInput',
  props: {
    modelValue: { type: [String, Number] as PropType<string | number | null>, default: '' },
    type: { type: String, default: 'text' },
    class: { type: [String, Array, Object] as PropType<any>, default: '' },
  },
  emits: ['update:modelValue'],
  setup(props, { emit, attrs }) {
    const classes = computed(() =>
      cn(
        'flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm outline-none transition',
        'placeholder:text-muted-foreground',
        'focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background',
        'disabled:opacity-50 disabled:cursor-not-allowed',
        props.class,
      ),
    )

    return () =>
      h('input', {
        ...attrs,
        class: classes.value,
        type: props.type,
        value: props.modelValue ?? '',
        onInput: (e: Event) => emit('update:modelValue', (e.target as HTMLInputElement).value),
      })
  },
})
