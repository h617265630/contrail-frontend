import { defineComponent, h, type PropType } from 'vue'
import { cn } from './cn'

function makeDiv(name: string, base: string) {
  return defineComponent({
    name,
    props: { class: { type: [String, Array, Object] as PropType<any>, default: '' } },
    setup(props, { slots, attrs }) {
      return () => h('div', { ...attrs, class: cn(base, props.class) }, slots.default?.())
    },
  })
}

export const Card = makeDiv('UiCard', 'bg-white text-gray-900 flex flex-col gap-6 rounded-xl border')
export const CardHeader = makeDiv('UiCardHeader', 'grid auto-rows-min grid-rows-[auto_auto] items-start gap-1.5 px-6 pt-6')
export const CardTitle = makeDiv('UiCardTitle', 'text-lg font-semibold leading-none')
export const CardDescription = makeDiv('UiCardDescription', 'text-sm text-gray-600')
export const CardAction = makeDiv('UiCardAction', 'col-start-2 row-span-2 row-start-1 self-start justify-self-end')
export const CardContent = makeDiv('UiCardContent', 'px-6 pb-6')
export const CardFooter = makeDiv('UiCardFooter', 'flex items-center px-6 pb-6 pt-0')
