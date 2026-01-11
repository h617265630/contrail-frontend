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
        'flex h-10 w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm outline-none transition focus-visible:ring-2 focus-visible:ring-blue-500 focus-visible:border-blue-500 disabled:opacity-50 disabled:cursor-not-allowed',
        'placeholder:text-gray-400',
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
