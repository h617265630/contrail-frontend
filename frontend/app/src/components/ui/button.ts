import { computed, defineComponent, h, type PropType } from 'vue'
import { cn } from './cn'

type ButtonVariant = 'default' | 'destructive' | 'outline' | 'secondary' | 'ghost' | 'link'
type ButtonSize = 'default' | 'sm' | 'lg' | 'icon'

const variantClass: Record<ButtonVariant, string> = {
  default: 'bg-primary text-primary-foreground hover:bg-primary/90',
  destructive: 'bg-destructive text-destructive-foreground hover:bg-destructive/90',
  outline: 'border border-border bg-background text-foreground hover:bg-accent hover:text-accent-foreground',
  secondary: 'bg-secondary text-secondary-foreground hover:bg-secondary/80',
  ghost: 'hover:bg-accent hover:text-accent-foreground',
  link: 'text-primary underline-offset-4 hover:underline',
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
    const isNativeButton = computed(() => props.as === 'button')
    const classes = computed(() =>
      cn(
        'inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background',
        !isNativeButton.value && props.disabled ? 'pointer-events-none opacity-50' : '',
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
          disabled: isNativeButton.value ? props.disabled : undefined,
          'aria-disabled': !isNativeButton.value && props.disabled ? 'true' : undefined,
          tabindex: !isNativeButton.value && props.disabled ? -1 : (attrs as any).tabindex,
          type: attrs.type ?? (isNativeButton.value ? 'button' : undefined),
          ...attrs,
        },
        slots.default ? slots.default() : undefined,
      )
  },
})
