# Deck & Card UI Skill

This skill provides a structured workflow for creating collectible card deck UI components with poker-style stacking, hover animations, and expand/collapse interactions.

## When to Use This Skill

Use this skill when asked to:
- Create a card collection display page
- Build a deck-style card stacking UI
- Implement Pokemon/TCG-style card layouts
- Design hover-to-expand card interactions

## Core Concepts

### Data Structure

```typescript
interface Card {
  id: number
  title: string
  description: string
  category: string
  weight?: 'soil' | 'iron' | 'bronze' | 'silver' | 'gold'
  color: string        // Category color (hex)
  source: string       // Origin/platform
  duration: string     // Time estimate
  image?: string       // Optional cover image URL
}

interface Deck {
  name: string
  cards: Card[]
}
```

### Layout Structure

```
Page Layout:
├── Header (title + expand/collapse button)
├── Decks Container (vertical flex, gap-12)
│   └── Deck (for each deck)
│       ├── Deck Title
│       ├── Cards Stack (horizontal, inline-flex)
│       │   └── Card (for each card, absolute positioning via margin)
│       └── Deck Count
└── Hint Text
```

## Card Design (Pokemon-style)

Each card follows this vertical layout:

```
┌─────────────────────────┐
│ [Category]      #001    │  ← Header: category badge + card number
├─────────────────────────┤
│                         │
│      [Image/Icon]       │  ← Image area: bg-white, px-2
│                         │
├─────────────────────────┤
│ Card Title              │  ← Title: bg-white, font-bold
├─────────────────────────┤
│ Description text here   │  ← Description: bg-muted/30, line-clamp-2
│ continues on second...  │
├─────────────────────────┤
│ Source          Duration│  ← Footer: source + duration
└─────────────────────────┘
```

### Card Dimensions
- Width: `w-56` (224px)
- Height: `h-72` (288px)
- Border: `border border-border`
- Background: `bg-card`
- Border radius: `rounded-md`

## Weight Variants (Border + Background)

Use `card.weight` to switch card border/background style (importance level).

### Variant Mapping

| weight | Meaning | Border | Background |
|--------|---------|--------|------------|
| soil | lowest | `border-stone-200` | `bg-stone-50` |
| iron | low-mid | `border-slate-300` | `bg-slate-50` |
| bronze | mid | `border-amber-300` | `bg-amber-50` |
| silver | high | `border-zinc-200` | `bg-zinc-50` |
| gold | highest | `border-yellow-300` | `bg-yellow-50` |

### Usage Snippet (Vue)

```ts
type Weight = '' | 'soil' | 'iron' | 'bronze' | 'silver' | 'gold'

function getWeightCardClass(weight?: Weight) {
  if (weight === 'soil') return 'border-stone-200 bg-stone-50'
  if (weight === 'iron') return 'border-slate-300 bg-slate-50'
  if (weight === 'bronze') return 'border-amber-300 bg-amber-50'
  if (weight === 'silver') return 'border-zinc-200 bg-zinc-50'
  if (weight === 'gold') return 'border-yellow-300 bg-yellow-50'
  return 'border-border bg-card'
}
```

Bind it on the card container:

```html
<div
  :class="[
    'shrink-0 w-56 h-72 rounded-md border shadow-sm transition-all duration-300 cursor-pointer hover:shadow-xl card-hover',
    getWeightCardClass(card.weight),
  ]"
>
  <!-- card content -->
</div>
```

## Stacking Behavior

### Collapsed State (Default)
Cards overlap horizontally with slight rotation:

```typescript
function getDeckCardStyle(deckIndex: number, cardIndex: number) {
  const isHovered = hoveredDeck.value === deckIndex
  const isExpanded = expandAll.value || isHovered
  const totalCards = decks.value[deckIndex].cards.length

  if (isExpanded) {
    return {
      marginLeft: cardIndex === 0 ? '0' : '16px',
      zIndex: cardIndex,
    }
  } else {
    const reverseIndex = totalCards - 1 - cardIndex
    return {
      marginLeft: cardIndex === 0 ? '0' : '-210px',  // Tight overlap
      zIndex: cardIndex,
      transform: `rotate(${reverseIndex * 0.3}deg)`,  // Slight rotation
    }
  }
}
```

### Expanded State (on Hover or Toggle)
Cards spread out with 16px gap between them.

## Hover Animation

Card hover effect: tilt left, then straighten while scaling up.

```css
.card-hover:hover {
  animation: card-tilt-up 0.4s ease forwards;
}

@keyframes card-tilt-up {
  0% {
    transform: rotate(0deg) scale(1);
  }
  30% {
    transform: rotate(-6deg) scale(1.08);
  }
  100% {
    transform: rotate(0deg) scale(1.25);
  }
}
```

### Hover Z-Index
Hovered card must appear above others:
```html
class="... hover:!z-[100] card-hover"
```

## State Management

```typescript
const hoveredDeck = ref<number | null>(null)
const activeCard = ref<Card | null>(null)
const expandAll = ref(false)

const totalCards = computed(() => {
  return decks.value.reduce((sum, deck) => sum + deck.cards.length, 0)
})
```

## Interaction Events

### Deck Hover (triggers expand)
Place events on the inner container wrapping cards, NOT the outer container:

```html
<div class="relative h-72 overflow-visible">
  <div
    class="inline-flex items-center h-full"
    @mouseenter="hoveredDeck = deckIndex"
    @mouseleave="hoveredDeck = null"
  >
    <!-- cards here -->
  </div>
</div>
```

### Card Click (opens detail modal)
```html
@click="openCard(card)"
```

## Expand/Collapse Toggle Button

```html
<button
  class="px-4 py-2 text-sm font-medium rounded-md border border-border bg-card hover:bg-muted transition"
  @click="expandAll = !expandAll"
>
  {{ expandAll ? '收起全部' : '展开全部' }}
</button>
```

## Detail Modal

When a card is clicked, show a modal with:
- Large image/icon
- Category badge + card number
- Full title
- Full description
- Source + duration
- Action buttons (Start Learning, Add to Path)

## CSS Classes Summary

### Card Container
```
shrink-0 w-56 h-72 rounded-md border border-border bg-card shadow-sm 
transition-all duration-300 ease-out cursor-pointer 
hover:shadow-xl hover:!z-[100] card-hover
```

### Card Sections
- **Header**: `px-3 py-2 border-b border-border`
- **Image**: `relative h-28 bg-white overflow-hidden px-2`
- **Title**: `px-3 py-2 border-b border-border bg-white`
- **Description**: `px-3 py-2 flex-1 bg-muted/30`
- **Footer**: `px-3 py-2 border-t border-border`

### Category Badge
```html
<span
  class="px-2 py-0.5 text-xs font-medium rounded"
  :style="{ backgroundColor: card.color + '20', color: card.color }"
>
  {{ card.category }}
</span>
```

## Transition Animations

```css
/* Stack transitions */
.stack-move,
.stack-enter-active,
.stack-leave-active {
  transition: all 0.5s ease;
}

.stack-enter-from,
.stack-leave-to {
  opacity: 0;
  transform: translateY(-30px) scale(0.9);
}

/* Modal transitions */
.modal-enter-active,
.modal-leave-active {
  transition: all 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}
```

## Reference Implementation

See `/frontend/app/src/pages/stackUI/Stack.vue` for the complete working implementation.

## Customization Points

| Aspect | Default | How to Customize |
|--------|---------|------------------|
| Card size | 224×288px | Change `w-56 h-72` |
| Overlap amount | -210px | Change `marginLeft` in collapsed state |
| Rotation | 0.3deg per card | Change multiplier in `rotate()` |
| Hover scale | 1.25 | Change final scale in keyframes |
| Expand gap | 16px | Change `marginLeft` in expanded state |
| Animation duration | 0.4s | Change in `.card-hover:hover` |

## Quality Checklist

Before finishing:
- [ ] Cards stack correctly in collapsed state
- [ ] Hover on deck expands cards horizontally
- [ ] Individual card hover shows tilt + scale animation
- [ ] Hovered card appears above others (z-index)
- [ ] Expand/collapse toggle works
- [ ] Card click opens detail modal
- [ ] Modal displays all card information
- [ ] Hover only triggers on card area, not empty space
