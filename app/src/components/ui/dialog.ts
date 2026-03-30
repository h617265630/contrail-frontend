import { Teleport, defineComponent, h, inject, provide, ref, type PropType, watch, onBeforeUnmount } from 'vue'
import { cn } from './cn'

const DialogSymbol = Symbol('DialogContext')
let dialogTitleSeed = 0

interface DialogContext {
  open: ReturnType<typeof ref<boolean>>
  setOpen: (val: boolean) => void
  titleId: string
}

function useDialogContext() {
  const ctx = inject<DialogContext | null>(DialogSymbol, null)
  if (!ctx) throw new Error('Dialog components must be used inside <Dialog>')
  return ctx
}

export const Dialog = defineComponent({
  name: 'UiDialog',
  props: {
    modelValue: { type: Boolean, default: undefined },
    defaultOpen: { type: Boolean, default: false },
  },
  emits: ['update:modelValue', 'open', 'close'],
  setup(props, { emit, slots }) {
    const internalOpen = ref(props.modelValue ?? props.defaultOpen)
    const titleId = `ui-dialog-title-${++dialogTitleSeed}`

    const setOpen = (val: boolean) => {
      internalOpen.value = val
      emit('update:modelValue', val)
      emit(val ? 'open' : 'close')
    }

    provide(DialogSymbol, { open: internalOpen, setOpen, titleId })

    return () => slots.default?.({ open: internalOpen.value, setOpen })
  },
})

export const DialogTrigger = defineComponent({
  name: 'UiDialogTrigger',
  setup(_, { slots }) {
    const { setOpen } = useDialogContext()
    return () =>
      h('button', { type: 'button', onClick: () => setOpen(true), class: 'outline-none' }, slots.default?.())
  },
})

export const DialogPortal = defineComponent({
  name: 'UiDialogPortal',
  setup(_, { slots }) {
    const { open } = useDialogContext()
    return () => (open.value ? h(Teleport as any, { to: 'body' }, slots.default?.()) : null)
  },
})

export const DialogOverlay = defineComponent({
  name: 'UiDialogOverlay',
  props: { class: { type: [String, Array, Object] as PropType<any>, default: '' } },
  setup(props) {
    const { open } = useDialogContext()
    const base = 'fixed inset-0 z-50 bg-foreground/50 transition-opacity'
    return () => (open.value ? h('div', { class: cn(base, props.class) }) : null)
  },
})

export const DialogContent = defineComponent({
  name: 'UiDialogContent',
  props: { class: { type: [String, Array, Object] as PropType<any>, default: '' } },
  setup(props, { slots, attrs }) {
    const ctx = useDialogContext()
    const onKeydown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') ctx.setOpen(false)
    }

    watch(
      () => ctx.open.value,
      (isOpen) => {
        if (isOpen) window.addEventListener('keydown', onKeydown)
        else window.removeEventListener('keydown', onKeydown)
      },
      { immediate: true },
    )

    onBeforeUnmount(() => window.removeEventListener('keydown', onKeydown))

    const content = () =>
      h('div', { class: cn('fixed left-1/2 top-1/2 z-50 w-full max-w-lg -translate-x-1/2 -translate-y-1/2 rounded-lg border bg-background text-foreground p-6 shadow-lg', props.class), role: 'dialog', 'aria-modal': 'true', 'aria-labelledby': ctx.titleId, ...attrs }, [
        slots.default?.(),
        h(DialogClose, { class: 'absolute right-4 top-4 text-muted-foreground hover:text-foreground', 'aria-label': 'Close dialog' }, { default: () => '×' }),
      ])

    return () =>
      h(DialogPortal, null, {
        default: () => [h(DialogOverlay), content()],
      })
  },
})

export const DialogClose = defineComponent({
  name: 'UiDialogClose',
  props: { class: { type: [String, Array, Object] as PropType<any>, default: '' } },
  setup(props, { slots, attrs }) {
    const { setOpen } = useDialogContext()
    return () =>
      h(
        'button',
        { type: 'button', class: cn('inline-flex items-center justify-center', props.class), onClick: () => setOpen(false), ...attrs },
        slots.default?.() ?? 'Close',
      )
  },
})

export const DialogHeader = defineComponent({
  name: 'UiDialogHeader',
  props: { class: { type: [String, Array, Object] as PropType<any>, default: '' } },
  setup(props, { slots }) {
    return () => h('div', { class: cn('flex flex-col gap-2 text-left', props.class) }, slots.default?.())
  },
})

export const DialogFooter = defineComponent({
  name: 'UiDialogFooter',
  props: { class: { type: [String, Array, Object] as PropType<any>, default: '' } },
  setup(props, { slots }) {
    return () => h('div', { class: cn('flex flex-col gap-2 sm:flex-row sm:justify-end', props.class) }, slots.default?.())
  },
})

export const DialogTitle = defineComponent({
  name: 'UiDialogTitle',
  props: { class: { type: [String, Array, Object] as PropType<any>, default: '' } },
  setup(props, { slots }) {
    const ctx = useDialogContext()
    return () => h('h3', { id: ctx.titleId, class: cn('text-lg font-semibold leading-none', props.class) }, slots.default?.())
  },
})

export const DialogDescription = defineComponent({
  name: 'UiDialogDescription',
  props: { class: { type: [String, Array, Object] as PropType<any>, default: '' } },
  setup(props, { slots }) {
    return () => h('p', { class: cn('text-sm text-muted-foreground', props.class) }, slots.default?.())
  },
})
