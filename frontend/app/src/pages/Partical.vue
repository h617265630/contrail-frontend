<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Partical</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">素材收集与灵感记录。</p>
        </div>
      </div>
    </section>

    <section>
      <div class="grid gap-6 lg:grid-cols-12">
        <aside class="lg:col-span-3">
          <Card className="rounded-none" :hoverable="false" padded>
            <div class="space-y-1">
              <p class="text-sm font-semibold text-foreground">Partical</p>
              <p class="text-xs text-muted-foreground">素材收集与灵感记录</p>
            </div>

            <div class="mt-4 space-y-2">
              <RouterLink to="/partical/image" class="block">
                <Button
                  type="button"
                  variant="ghost"
                  class="w-full justify-start rounded-none"
                  :class="isActive('/partical/image') ? 'bg-foreground text-background hover:bg-foreground/90 hover:text-background' : 'text-foreground hover:bg-muted/30'"
                >
                  Image
                </Button>
              </RouterLink>
              <RouterLink to="/partical/flashed-ideas" class="block">
                <Button
                  type="button"
                  variant="ghost"
                  class="w-full justify-start rounded-none"
                  :class="isActive('/partical/flashed-ideas') ? 'bg-foreground text-background hover:bg-foreground/90 hover:text-background' : 'text-foreground hover:bg-muted/30'"
                >
                  Flashed Ideas
                </Button>
              </RouterLink>
            </div>
          </Card>
        </aside>

        <main class="lg:col-span-9 space-y-4">
          <Card className="rounded-none" :hoverable="false" padded>
            <div>
              <h2 class="text-xl font-semibold text-foreground">{{ tabTitle }}</h2>
              <p class="text-sm text-muted-foreground mt-1">{{ tabSubtitle }}</p>
            </div>
          </Card>

          <Card className="rounded-none" :hoverable="false" padded>
            <RouterView />
          </Card>
        </main>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { RouterLink, RouterView, useRoute } from 'vue-router'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'

const route = useRoute()

function isActive(prefix: string) {
  return route.path.startsWith(prefix)
}

const tabTitle = computed(() => {
  if (isActive('/partical/flashed-ideas')) return 'Flashed Ideas'
  return 'Image'
})

const tabSubtitle = computed(() => {
  if (isActive('/partical/flashed-ideas')) return '记录灵感片段，快速归档。'
  return '收集图片素材，沉淀灵感来源。'
})
</script>
