import { computed, defineComponent, h, type PropType } from 'vue'
import { cn } from './cn'

type ButtonVariant = 'default' | 'destructive' | 'outline' | 'secondary' | 'ghost' | 'link'
type ButtonSize = 'default' | 'sm' | 'lg' | 'icon'

const variantClass: Record<ButtonVariant, string> = {
  default: 'bg-blue-600 text-white hover:bg-blue-700',
  destructive: 'bg-red-600 text-white hover:bg-red-700',
  outline: 'border bg-white text-gray-800 hover:bg-gray-50',
  secondary: 'bg-gray-100 text-gray-800 hover:bg-gray-200',
  ghost: 'hover:bg-gray-100 text-gray-800',
  link: 'text-blue-600 underline-offset-4 hover:underline',
}

const sizeClass: Record<ButtonSize, string> = {
  default: 'h-9 px-4 py-2',
  sm: 'h-8 px-3 py-1.5 text-sm',
  lg: 'h-10 px-6 py-2.5 text-base',
  icon: 'h-9 w-9',
}

export const buttonVariants = { variantClass, sizeClass }

export const Button = defineComponent({
  name: 'UiButton',
  props: {
    as: { type: [String, Object] as PropType<string | any>, default: 'button' },
    variant: { type: String as PropType<ButtonVariant>, default: 'default' },
    size: { type: String as PropType<ButtonSize>, default: 'default' },
    class: { type: [String, Array, Object] as PropType<any>, default: '' },
    disabled: { type: Boolean, default: false },
  },
  setup(props, { slots, attrs }) {
    const classes = computed(() =>
      cn(
        'inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:ring-2 focus-visible:ring-blue-400',
        variantClass[props.variant],
        sizeClass[props.size],
        props.class,
      ),
    )

    return () =>
      h(
        props.as as any,
        {
          class: classes.value,
          disabled: props.disabled,
          type: attrs.type ?? (props.as === 'button' ? 'button' : undefined),
          ...attrs,
        },
        slots.default ? slots.default() : undefined,
      )
  },
})
