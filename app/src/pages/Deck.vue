<template>
  <div class="min-h-screen bg-background">
    <section class="container mx-auto px-4 py-8">
      <header class="mb-8 flex items-center justify-between">
        <div>
          <h1 class="text-2xl font-bold text-foreground">My Collection</h1>
          <p class="text-muted-foreground mt-1">{{ totalCards }} learning resources in {{ decks.length }} decks</p>
        </div>
        <button
          class="px-4 py-2 text-sm font-medium rounded-md border border-border bg-card hover:bg-muted transition"
          @click="expandAll = !expandAll"
        >
          {{ expandAll ? '收起全部' : '展开全部' }}
        </button>
      </header>

      <!-- Decks List (Vertical) -->
      <main class="flex flex-col gap-12">
        <div
          v-for="(deck, deckIndex) in decks"
          :key="deck.name"
          class="flex flex-col"
        >
          <!-- Deck Title -->
          <h2 class="text-lg font-semibold text-foreground mb-4">{{ deck.name }}</h2>

          <!-- Cards Stack (Horizontal) -->
          <div class="relative h-72 overflow-visible">
            <div
              class="inline-flex items-center h-full"
              :style="{ paddingLeft: '20px' }"
              @mouseenter="hoveredDeck = deckIndex"
              @mouseleave="hoveredDeck = null"
            >
              <div
                v-for="(card, cardIndex) in deck.cards"
                :key="card.id"
                class="shrink-0 w-56 h-72 rounded-md border border-border bg-card shadow-sm transition-all duration-300 ease-out cursor-pointer hover:shadow-xl hover:!z-[100] card-hover"
                :style="getDeckCardStyle(deckIndex, cardIndex)"
                @click="openCard(card)"
              >
                <!-- Pokemon-style Card Layout -->
                <div class="h-full flex flex-col overflow-hidden rounded-md">
                  <!-- Card Header with Category -->
                  <div class="px-3 py-2 border-b border-border flex items-center justify-between">
                    <span
                      class="px-2 py-0.5 text-xs font-medium rounded"
                      :style="{ backgroundColor: card.color + '20', color: card.color }"
                    >
                      {{ card.category }}
                    </span>
                    <span class="text-xs text-muted-foreground">#{{ String(card.id).padStart(3, '0') }}</span>
                  </div>

                  <!-- Card Image -->
                  <div class="relative h-28 bg-white overflow-hidden px-2">
                    <img
                      v-if="card.image"
                      :src="card.image"
                      :alt="card.title"
                      class="w-full h-full object-cover"
                    />
                    <div v-else class="w-full h-full flex items-center justify-center">
                      <div
                        class="w-12 h-12 rounded-full flex items-center justify-center text-xl font-bold text-white"
                        :style="{ backgroundColor: card.color }"
                      >
                        {{ card.title.charAt(0) }}
                      </div>
                    </div>
                  </div>

                  <!-- Card Title -->
                  <div class="px-3 py-2 border-b border-border bg-white">
                    <h3 class="text-sm font-bold text-foreground line-clamp-1">
                      {{ card.title }}
                    </h3>
                  </div>

                  <!-- Card Description -->
                  <div class="px-3 py-2 flex-1 bg-muted/30">
                    <p class="text-xs text-muted-foreground line-clamp-2">
                      {{ card.description }}
                    </p>
                  </div>

                  <!-- Card Footer -->
                  <div class="px-3 py-2 border-t border-border flex items-center justify-between">
                    <span class="text-xs text-muted-foreground">{{ card.source }}</span>
                    <span class="text-xs font-medium text-foreground">{{ card.duration }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Deck Count -->
          <p class="text-sm text-muted-foreground mt-4">{{ deck.cards.length }} cards</p>
        </div>
      </main>

      <!-- Hint -->
      <p class="text-center text-muted-foreground text-sm mt-12">
        Hover deck to fan out • Click card to view details
      </p>
    </section>

    <!-- Detail Modal -->
    <Teleport to="body">
      <Transition name="modal">
        <div
          v-if="activeCard"
          class="fixed inset-0 z-50 flex items-center justify-center p-4"
          @click.self="activeCard = null"
        >
          <div class="absolute inset-0 bg-black/50"></div>
          <div class="relative w-full max-w-md rounded-md overflow-hidden bg-card border border-border shadow-xl">
            <!-- Modal Image -->
            <div class="relative h-48 bg-muted overflow-hidden">
              <img
                v-if="activeCard.image"
                :src="activeCard.image"
                :alt="activeCard.title"
                class="w-full h-full object-cover"
              />
              <div v-else class="w-full h-full flex items-center justify-center">
                <div
                  class="w-24 h-24 rounded-full flex items-center justify-center text-4xl font-bold text-white"
                  :style="{ backgroundColor: activeCard.color }"
                >
                  {{ activeCard.title.charAt(0) }}
                </div>
              </div>
              <button
                class="absolute top-3 right-3 w-8 h-8 rounded-full bg-background/80 flex items-center justify-center text-foreground hover:bg-background transition"
                @click="activeCard = null"
              >
                ✕
              </button>
            </div>

            <!-- Modal Header -->
            <div class="p-4 border-b border-border">
              <div class="flex items-center gap-2 mb-2">
                <span
                  class="px-2 py-0.5 text-xs font-medium rounded"
                  :style="{ backgroundColor: activeCard.color + '20', color: activeCard.color }"
                >
                  {{ activeCard.category }}
                </span>
                <span class="text-xs text-muted-foreground">#{{ String(activeCard.id).padStart(3, '0') }}</span>
              </div>
              <h2 class="text-xl font-bold text-foreground">{{ activeCard.title }}</h2>
            </div>

            <!-- Modal Body -->
            <div class="p-4">
              <p class="text-sm text-muted-foreground mb-4">{{ activeCard.description }}</p>
              <div class="flex items-center gap-4 text-sm text-muted-foreground">
                <span>{{ activeCard.source }}</span>
                <span>•</span>
                <span>{{ activeCard.duration }}</span>
              </div>
            </div>

            <!-- Modal Footer -->
            <div class="p-4 border-t border-border flex gap-3">
              <button class="flex-1 px-4 py-2 rounded-md bg-foreground text-background font-medium hover:bg-foreground/90 transition">
                Start Learning
              </button>
              <button class="px-4 py-2 rounded-md border border-border text-foreground font-medium hover:bg-muted transition">
                Add to Path
              </button>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

interface Card {
  id: number
  title: string
  description: string
  category: string
  color: string
  source: string
  duration: string
  image?: string
}

interface Deck {
  name: string
  cards: Card[]
}

const hoveredDeck = ref<number | null>(null)
const activeCard = ref<Card | null>(null)
const expandAll = ref(false)

const decks = ref<Deck[]>([
  {
    name: 'AI & Machine Learning',
    cards: [
      {
        id: 1,
        title: 'Introduction to Machine Learning',
        description: 'Learn the fundamentals of machine learning algorithms and their applications.',
        category: 'AI & ML',
        color: '#8b5cf6',
        source: 'Coursera',
        duration: '4 weeks',
        image: 'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=400&h=300&fit=crop',
      },
      {
        id: 2,
        title: 'Deep Learning Specialization',
        description: 'Master neural networks, CNNs, RNNs, and transformers.',
        category: 'AI & ML',
        color: '#8b5cf6',
        source: 'Coursera',
        duration: '3 months',
        image: 'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?w=400&h=300&fit=crop',
      },
      {
        id: 3,
        title: 'Natural Language Processing',
        description: 'Build NLP applications with modern transformer models.',
        category: 'AI & ML',
        color: '#8b5cf6',
        source: 'Hugging Face',
        duration: '6 weeks',
        image: 'https://images.unsplash.com/photo-1655720828018-edd2daec9349?w=400&h=300&fit=crop',
      },
      {
        id: 4,
        title: 'Computer Vision Fundamentals',
        description: 'Image classification, object detection, and segmentation.',
        category: 'AI & ML',
        color: '#8b5cf6',
        source: 'Fast.ai',
        duration: '8 weeks',
        image: 'https://images.unsplash.com/photo-1561736778-92e52a7769ef?w=400&h=300&fit=crop',
      },
      {
        id: 5,
        title: 'MLOps & Model Deployment',
        description: 'Deploy and monitor ML models in production environments.',
        category: 'AI & ML',
        color: '#8b5cf6',
        source: 'Google Cloud',
        duration: '4 weeks',
        image: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&h=300&fit=crop',
      },
    ],
  },
  {
    name: 'Frontend Development',
    cards: [
      {
        id: 6,
        title: 'Advanced TypeScript Patterns',
        description: 'Master generics, conditional types, and mapped types.',
        category: 'Frontend',
        color: '#3b82f6',
        source: 'Frontend Masters',
        duration: '6 hours',
        image: 'https://images.unsplash.com/photo-1516116216624-53e697fedbea?w=400&h=300&fit=crop',
      },
      {
        id: 7,
        title: 'React Performance Optimization',
        description: 'Deep dive into React rendering and memoization.',
        category: 'Frontend',
        color: '#3b82f6',
        source: 'Egghead',
        duration: '3 hours',
        image: 'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=400&h=300&fit=crop',
      },
      {
        id: 8,
        title: 'Vue 3 Composition API',
        description: 'Build scalable apps with Vue 3 and TypeScript.',
        category: 'Frontend',
        color: '#3b82f6',
        source: 'Vue Mastery',
        duration: '5 hours',
        image: 'https://images.unsplash.com/photo-1627398242454-45a1465c2479?w=400&h=300&fit=crop',
      },
      {
        id: 9,
        title: 'CSS Grid & Flexbox Mastery',
        description: 'Modern layout techniques for responsive design.',
        category: 'Frontend',
        color: '#3b82f6',
        source: 'CSS Tricks',
        duration: '4 hours',
        image: 'https://images.unsplash.com/photo-1507721999472-8ed4421c4af2?w=400&h=300&fit=crop',
      },
      {
        id: 10,
        title: 'Web Accessibility (a11y)',
        description: 'Build inclusive web experiences for all users.',
        category: 'Frontend',
        color: '#3b82f6',
        source: 'Deque',
        duration: '6 hours',
        image: 'https://images.unsplash.com/photo-1573164713988-8665fc963095?w=400&h=300&fit=crop',
      },
    ],
  },
  {
    name: 'Backend & Infrastructure',
    cards: [
      {
        id: 11,
        title: 'System Design Fundamentals',
        description: 'Distributed systems, scalability, and architecture.',
        category: 'Backend',
        color: '#10b981',
        source: 'YouTube',
        duration: '2 hours',
        image: 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=400&h=300&fit=crop',
      },
      {
        id: 12,
        title: 'Database Design Principles',
        description: 'Normalization, indexing, and query optimization.',
        category: 'Backend',
        color: '#10b981',
        source: 'Udemy',
        duration: '8 hours',
        image: 'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=400&h=300&fit=crop',
      },
      {
        id: 13,
        title: 'Docker & Kubernetes',
        description: 'Container orchestration for modern applications.',
        category: 'Backend',
        color: '#10b981',
        source: 'Linux Foundation',
        duration: '12 hours',
        image: 'https://images.unsplash.com/photo-1605745341112-85968b19335b?w=400&h=300&fit=crop',
      },
      {
        id: 14,
        title: 'API Design Best Practices',
        description: 'RESTful APIs, GraphQL, and gRPC patterns.',
        category: 'Backend',
        color: '#10b981',
        source: 'Postman',
        duration: '5 hours',
        image: 'https://images.unsplash.com/photo-1623282033815-40b05d96c903?w=400&h=300&fit=crop',
      },
      {
        id: 15,
        title: 'Cloud Architecture (AWS)',
        description: 'Design scalable cloud solutions on AWS.',
        category: 'Backend',
        color: '#10b981',
        source: 'AWS',
        duration: '10 hours',
        image: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=400&h=300&fit=crop',
      },
    ],
  },
])

const totalCards = computed(() => {
  return decks.value.reduce((sum, deck) => sum + deck.cards.length, 0)
})

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
      marginLeft: cardIndex === 0 ? '0' : '-210px',
      zIndex: cardIndex,
      transform: `rotate(${reverseIndex * 0.3}deg)`,
    }
  }
}

function openCard(card: Card) {
  hoveredDeck.value = null
  activeCard.value = card
}
</script>

<style scoped>
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

.modal-enter-active,
.modal-leave-active {
  transition: all 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.modal-enter-from > div:last-child,
.modal-leave-to > div:last-child {
  transform: scale(0.95) translateY(20px);
}

.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

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
</style>
