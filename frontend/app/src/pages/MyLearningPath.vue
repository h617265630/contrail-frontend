<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">My Paths</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">只显示你在数据库中创建/添加的 LearningPath</p>
        </div>
        <div class="md:col-span-4 md:flex md:justify-end md:items-end">
          <div class="flex gap-1 border border-border bg-background rounded-none p-1">
            <Button
              type="button"
              variant="ghost"
              size="sm"
              class="rounded-none"
              :class="viewMode === 'grid' ? 'bg-accent text-accent-foreground' : ''"
              @click="viewMode = 'grid'"
            >
              卡片
            </Button>
            <Button
              type="button"
              variant="ghost"
              size="sm"
              class="rounded-none"
              :class="viewMode === 'list' ? 'bg-accent text-accent-foreground' : ''"
              @click="viewMode = 'list'"
            >
              列表
            </Button>
          </div>
        </div>
      </div>
    </section>

    <Card v-if="loading" as="section" :hoverable="false" class="rounded-none">
      <div class="p-6">
        <p class="text-sm text-muted-foreground">Loading…</p>
      </div>
    </Card>

    <Card v-else-if="error" as="section" :hoverable="false" class="rounded-none">
      <div class="p-6">
        <p class="text-sm text-red-600 font-semibold">{{ error }}</p>
      </div>
    </Card>

    <Card v-else-if="paths.length === 0" as="section" :hoverable="false" class="rounded-none">
      <div class="p-8">
        <p class="text-sm font-semibold text-foreground">还没有创建任何 LearningPath</p>
        <p class="mt-1 text-sm text-muted-foreground">去 CreatePath 页面创建一个新的学习路径。</p>
        <Button :as="RouterLinkComp" to="/createpath" variant="outline" size="sm" class="mt-4 rounded-none">去创建</Button>
      </div>
    </Card>

    <section v-else-if="viewMode === 'grid'" class="space-y-10">
      <div v-if="linearPaths.length" class="space-y-4">
        <div>
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Linear path</h2>
          <p class="text-sm text-muted-foreground">{{ linearPaths.length }} paths</p>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
          <Card
            v-for="path in linearPaths"
            :key="path.id"
            as="article"
            :hoverable="true"
            class="rounded-none p-0 overflow-hidden cursor-pointer"
            @click="openDetail(path.id)"
          >
            <div class="overflow-hidden bg-muted aspect-video relative">
              <span
                v-if="(path as any)?.type"
                class="absolute right-2 top-2 px-2 py-1 rounded-full border border-border bg-background text-[10px] font-semibold tracking-[0.14em] uppercase text-foreground"
              >
                {{ String((path as any)?.type || '').trim() }}
              </span>
              <img
                v-if="coverFor(path.id)"
                :src="coverFor(path.id)"
                :alt="path.title"
                class="w-full h-full object-cover object-top-left"
                loading="lazy"
              />
              <div
                v-else
                class="absolute inset-0 bg-muted flex flex-col items-center justify-center"
              >
                <ImageIcon class="w-10 h-10 text-muted-foreground" />
                <div class="mt-2 text-xs font-semibold text-foreground text-center px-2">
                  {{ path.category_name || 'Learning Path' }}
                </div>
              </div>
            </div>

            <div class="p-3 min-w-0">
              <h2 class="text-sm font-semibold text-foreground line-clamp-1">{{ path.title }}</h2>
              <p class="mt-1 text-muted-foreground text-xs line-clamp-3">{{ path.description || '（无介绍）' }}</p>
            </div>

            <div class="px-3 pb-3 flex items-center gap-2" @click.stop>
              <Button
                :as="RouterLinkComp"
                :to="{ name: 'learningpath-edit', params: { id: String(path.id) } }"
                variant="outline"
                size="sm"
                class="flex-1 rounded-none text-xs"
              >
                编辑
              </Button>
              <Button
                type="button"
                variant="outline"
                size="sm"
                class="flex-1 rounded-none text-xs"
                @click="openDeleteConfirm(path.id)"
              >
                删除
              </Button>
            </div>
          </Card>
        </div>
      </div>

      <div v-if="structuredPaths.length" class="space-y-4">
        <div>
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Structured path</h2>
          <p class="text-sm text-muted-foreground">{{ structuredPaths.length }} paths</p>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
          <Card
            v-for="path in structuredPaths"
            :key="path.id"
            as="article"
            :hoverable="true"
            class="rounded-none p-0 overflow-hidden cursor-pointer"
            @click="openDetail(path.id)"
          >
            <div class="overflow-hidden bg-muted aspect-video relative">
              <span
                v-if="(path as any)?.type"
                class="absolute right-2 top-2 px-2 py-1 rounded-full border border-border bg-background text-[10px] font-semibold tracking-[0.14em] uppercase text-foreground"
              >
                {{ String((path as any)?.type || '').trim() }}
              </span>
              <img
                v-if="coverFor(path.id)"
                :src="coverFor(path.id)"
                :alt="path.title"
                class="w-full h-full object-cover object-top-left"
                loading="lazy"
              />
              <div
                v-else
                class="absolute inset-0 bg-muted flex flex-col items-center justify-center"
              >
                <ImageIcon class="w-10 h-10 text-muted-foreground" />
                <div class="mt-2 text-xs font-semibold text-foreground text-center px-2">
                  {{ path.category_name || 'Learning Path' }}
                </div>
              </div>
            </div>

            <div class="p-3 min-w-0">
              <h2 class="text-sm font-semibold text-foreground line-clamp-1">{{ path.title }}</h2>
              <p class="mt-1 text-muted-foreground text-xs line-clamp-3">{{ path.description || '（无介绍）' }}</p>
            </div>

            <div class="px-3 pb-3 flex items-center gap-2" @click.stop>
              <Button
                :as="RouterLinkComp"
                :to="{ name: 'learningpath-edit', params: { id: String(path.id) } }"
                variant="outline"
                size="sm"
                class="flex-1 rounded-none text-xs"
              >
                编辑
              </Button>
              <Button
                type="button"
                variant="outline"
                size="sm"
                class="flex-1 rounded-none text-xs"
                @click="openDeleteConfirm(path.id)"
              >
                删除
              </Button>
            </div>
          </Card>
        </div>
      </div>

      <div v-if="particalPoolPaths.length" class="space-y-4">
        <div>
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Partical pool</h2>
          <p class="text-sm text-muted-foreground">{{ particalPoolPaths.length }} paths</p>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
          <Card
            v-for="path in particalPoolPaths"
            :key="path.id"
            as="article"
            :hoverable="true"
            class="rounded-none p-0 overflow-hidden cursor-pointer"
            @click="openDetail(path.id)"
          >
            <div class="overflow-hidden bg-muted aspect-video relative">
              <span
                v-if="(path as any)?.type"
                class="absolute right-2 top-2 px-2 py-1 rounded-full border border-border bg-background text-[10px] font-semibold tracking-[0.14em] uppercase text-foreground"
              >
                {{ String((path as any)?.type || '').trim() }}
              </span>
              <img
                v-if="coverFor(path.id)"
                :src="coverFor(path.id)"
                :alt="path.title"
                class="w-full h-full object-cover object-top-left"
                loading="lazy"
              />
              <div
                v-else
                class="absolute inset-0 bg-muted flex flex-col items-center justify-center"
              >
                <ImageIcon class="w-10 h-10 text-muted-foreground" />
                <div class="mt-2 text-xs font-semibold text-foreground text-center px-2">
                  {{ path.category_name || 'Learning Path' }}
                </div>
              </div>
            </div>

            <div class="p-3 min-w-0">
              <h2 class="text-sm font-semibold text-foreground line-clamp-1">{{ path.title }}</h2>
              <p class="mt-1 text-muted-foreground text-xs line-clamp-3">{{ path.description || '（无介绍）' }}</p>
            </div>

            <div class="px-3 pb-3 flex items-center gap-2" @click.stop>
              <Button
                :as="RouterLinkComp"
                :to="{ name: 'learningpath-edit', params: { id: String(path.id) } }"
                variant="outline"
                size="sm"
                class="flex-1 rounded-none text-xs"
              >
                编辑
              </Button>
              <Button
                type="button"
                variant="outline"
                size="sm"
                class="flex-1 rounded-none text-xs"
                @click="openDeleteConfirm(path.id)"
              >
                删除
              </Button>
            </div>
          </Card>
        </div>
      </div>

      <Card v-if="allGroupedEmpty" as="section" :hoverable="false" class="rounded-none">
        <div class="p-6 text-sm text-muted-foreground">没有可展示的 learning paths。</div>
      </Card>
    </section>

    <section v-else class="space-y-10">
      <div v-if="linearPaths.length" class="space-y-3">
        <div>
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Linear path</h2>
          <p class="text-sm text-muted-foreground">{{ linearPaths.length }} paths</p>
        </div>
        <Card
          v-for="path in linearPaths"
          :key="path.id"
          as="article"
          :hoverable="true"
          class="rounded-none p-0 overflow-hidden cursor-pointer"
          @click="openDetail(path.id)"
        >
          <div class="flex">
            <div class="w-32 shrink-0 bg-muted aspect-video relative">
              <span
                v-if="(path as any)?.type"
                class="absolute right-2 top-2 px-2 py-1 rounded-full border border-border bg-background text-[10px] font-semibold tracking-[0.14em] uppercase text-foreground"
              >
                {{ String((path as any)?.type || '').trim() }}
              </span>
              <img
                v-if="coverFor(path.id)"
                :src="coverFor(path.id)"
                :alt="path.title"
                class="w-full h-full object-cover object-top-left"
                loading="lazy"
              />
              <div
                v-else
                class="absolute inset-0 bg-muted flex flex-col items-center justify-center"
              >
                <ImageIcon class="w-7 h-7 text-muted-foreground" />
              </div>
            </div>

            <div class="min-w-0 flex-1 p-4">
              <h2 class="text-base font-semibold text-foreground line-clamp-1">{{ path.title }}</h2>
              <p class="mt-1 text-muted-foreground text-sm line-clamp-2">{{ path.description || '（无介绍）' }}</p>

              <div class="mt-3 flex items-center gap-2" @click.stop>
                <Button
                  :as="RouterLinkComp"
                  :to="{ name: 'learningpath-edit', params: { id: String(path.id) } }"
                  variant="outline"
                  size="sm"
                  class="rounded-none"
                >
                  编辑
                </Button>
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  class="rounded-none"
                  @click="openDeleteConfirm(path.id)"
                >
                  删除
                </Button>
              </div>
            </div>
          </div>
        </Card>
      </div>

      <div v-if="structuredPaths.length" class="space-y-3">
        <div>
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Structured path</h2>
          <p class="text-sm text-muted-foreground">{{ structuredPaths.length }} paths</p>
        </div>
        <Card
          v-for="path in structuredPaths"
          :key="path.id"
          as="article"
          :hoverable="true"
          class="rounded-none p-0 overflow-hidden cursor-pointer"
          @click="openDetail(path.id)"
        >
          <div class="flex">
            <div class="w-32 shrink-0 bg-muted aspect-video relative">
              <span
                v-if="(path as any)?.type"
                class="absolute right-2 top-2 px-2 py-1 rounded-full border border-border bg-background text-[10px] font-semibold tracking-[0.14em] uppercase text-foreground"
              >
                {{ String((path as any)?.type || '').trim() }}
              </span>
              <img
                v-if="coverFor(path.id)"
                :src="coverFor(path.id)"
                :alt="path.title"
                class="w-full h-full object-cover object-top-left"
                loading="lazy"
              />
              <div
                v-else
                class="absolute inset-0 bg-muted flex flex-col items-center justify-center"
              >
                <ImageIcon class="w-7 h-7 text-muted-foreground" />
              </div>
            </div>

            <div class="min-w-0 flex-1 p-4">
              <h2 class="text-base font-semibold text-foreground line-clamp-1">{{ path.title }}</h2>
              <p class="mt-1 text-muted-foreground text-sm line-clamp-2">{{ path.description || '（无介绍）' }}</p>

              <div class="mt-3 flex items-center gap-2" @click.stop>
                <Button
                  :as="RouterLinkComp"
                  :to="{ name: 'learningpath-edit', params: { id: String(path.id) } }"
                  variant="outline"
                  size="sm"
                  class="rounded-none"
                >
                  编辑
                </Button>
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  class="rounded-none"
                  @click="openDeleteConfirm(path.id)"
                >
                  删除
                </Button>
              </div>
            </div>
          </div>
        </Card>
      </div>

      <div v-if="particalPoolPaths.length" class="space-y-3">
        <div>
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Partical pool</h2>
          <p class="text-sm text-muted-foreground">{{ particalPoolPaths.length }} paths</p>
        </div>
        <Card
          v-for="path in particalPoolPaths"
          :key="path.id"
          as="article"
          :hoverable="true"
          class="rounded-none p-0 overflow-hidden cursor-pointer"
          @click="openDetail(path.id)"
        >
          <div class="flex">
            <div class="w-32 shrink-0 bg-muted aspect-video relative">
              <span
                v-if="(path as any)?.type"
                class="absolute right-2 top-2 px-2 py-1 rounded-full border border-border bg-background text-[10px] font-semibold tracking-[0.14em] uppercase text-foreground"
              >
                {{ String((path as any)?.type || '').trim() }}
              </span>
              <img
                v-if="coverFor(path.id)"
                :src="coverFor(path.id)"
                :alt="path.title"
                class="w-full h-full object-cover object-top-left"
                loading="lazy"
              />
              <div
                v-else
                class="absolute inset-0 bg-muted flex flex-col items-center justify-center"
              >
                <ImageIcon class="w-7 h-7 text-muted-foreground" />
              </div>
            </div>

            <div class="min-w-0 flex-1 p-4">
              <h2 class="text-base font-semibold text-foreground line-clamp-1">{{ path.title }}</h2>
              <p class="mt-1 text-muted-foreground text-sm line-clamp-2">{{ path.description || '（无介绍）' }}</p>

              <div class="mt-3 flex items-center gap-2" @click.stop>
                <Button
                  :as="RouterLinkComp"
                  :to="{ name: 'learningpath-edit', params: { id: String(path.id) } }"
                  variant="outline"
                  size="sm"
                  class="rounded-none"
                >
                  编辑
                </Button>
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  class="rounded-none"
                  @click="openDeleteConfirm(path.id)"
                >
                  删除
                </Button>
              </div>
            </div>
          </div>
        </Card>
      </div>

      <Card v-if="allGroupedEmpty" as="section" :hoverable="false" class="rounded-none">
        <div class="p-6 text-sm text-muted-foreground">没有可展示的 learning paths。</div>
      </Card>
    </section>
  </div>


  <div v-if="showDeleteConfirm" class="fixed inset-0 bg-black/20 backdrop-blur-sm flex items-center justify-center p-4 z-50">
    <Card as="div" :hoverable="false" class="rounded-none max-w-md w-full">
      <div class="p-6 border-b border-border flex items-center justify-between">
        <h2 class="text-foreground text-sm font-medium tracking-[0.14em] uppercase">确认删除</h2>
        <Button type="button" variant="ghost" size="icon" class="rounded-none" @click="closeDeleteConfirm" aria-label="Close">
          ×
        </Button>
      </div>

      <div class="p-6 space-y-3">
        <p class="text-foreground">确定要删除这个 LearningPath 吗？</p>
        <p class="text-sm text-muted-foreground">删除后将无法恢复。</p>
      </div>

      <div class="p-6 pt-0 flex items-center justify-end gap-3">
        <Button type="button" variant="outline" size="sm" class="rounded-none" @click="closeDeleteConfirm">取消</Button>
        <Button type="button" variant="outline" size="sm" class="rounded-none bg-foreground text-background hover:bg-foreground/90 hover:text-background" @click="confirmDelete">删除</Button>
      </div>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'

import { deleteMyLearningPath, getMyLearningPathDetail, listMyLearningPaths, type MyLearningPath } from '../api/learningPath'
import { getMyResourceDetail, getResourceDetail } from '../api/resource'
import { Image as ImageIcon } from 'lucide-vue-next'

const RouterLinkComp = RouterLink

const paths = ref<MyLearningPath[]>([])
const loading = ref(false)
const error = ref('')

function normalizePathType(raw: unknown) {
  return String(raw || '').trim().toLowerCase()
}

const linearPaths = computed(() => paths.value.filter(p => normalizePathType((p as any)?.type) === 'linear path'))
const structuredPaths = computed(() => paths.value.filter(p => normalizePathType((p as any)?.type) === 'structured path'))
const particalPoolPaths = computed(() => paths.value.filter(p => normalizePathType((p as any)?.type) === 'partical pool'))

const allGroupedEmpty = computed(() => !linearPaths.value.length && !structuredPaths.value.length && !particalPoolPaths.value.length)

const viewMode = ref<'grid' | 'list'>('grid')

const coverByPathId = ref<Record<number, string>>({})

const router = useRouter()

const showDeleteConfirm = ref(false)
const deleteTargetId = ref<number | null>(null)

async function loadPaths() {
  loading.value = true
  error.value = ''
  try {
    const data = await listMyLearningPaths()
    paths.value = Array.isArray(data) ? data : []

    // Load cover images from the first resource in each path.
    await Promise.allSettled(
      paths.value.map(async (p) => {
        try {
          const explicitCover = String((p as any)?.cover_image_url || '').trim()
          if (explicitCover) {
            coverByPathId.value[p.id] = explicitCover
            return
          }

          const detail = await getMyLearningPathDetail(p.id)
          const items = Array.isArray(detail.path_items) ? detail.path_items : []

          // “第一个 resource”：优先按 order_index 最小的 path item；如果 order_index 异常则按返回顺序。
          let first = items[0] || null
          for (const it of items) {
            const a = Number((first as any)?.order_index)
            const b = Number((it as any)?.order_index)
            const aOk = Number.isFinite(a)
            const bOk = Number.isFinite(b)
            if (!first) {
              first = it
              continue
            }
            if (bOk && (!aOk || b < a)) {
              first = it
            }
          }

          let thumb = String((first as any)?.resource_data?.thumbnail || '').trim()

          // 如果学习路径详情里没带缩略图，则回退去拉一次 resource 详情（先 public，再 my）。
          if (!thumb) {
            const rid = Number((first as any)?.resource_id)
            if (Number.isFinite(rid) && rid > 0) {
              try {
                const r = await getResourceDetail(rid)
                thumb = String(r?.thumbnail || '').trim()
              } catch {
                try {
                  const r = await getMyResourceDetail(rid)
                  thumb = String(r?.thumbnail || '').trim()
                } catch {
                  // ignore
                }
              }
            }
          }

          // Rule: use first resource thumbnail if present; otherwise show placeholder.
          coverByPathId.value[p.id] = thumb
        } catch {
          coverByPathId.value[p.id] = coverByPathId.value[p.id] || ''
        }
      }),
    )
  } catch (e: any) {
    error.value = String(e?.response?.data?.detail || e?.message || 'Failed to load learning paths')
  } finally {
    loading.value = false
  }
}

onMounted(loadPaths)

function openDetail(id: number) {
  router.push({ name: 'learningpath', params: { id: String(id) }, query: { from: 'my-paths' } })
}

function coverFor(id: number) {
  return String(coverByPathId.value[id] || '').trim()
}

function openDeleteConfirm(id: number) {
  deleteTargetId.value = id
  showDeleteConfirm.value = true
}

function closeDeleteConfirm() {
  showDeleteConfirm.value = false
  deleteTargetId.value = null
}

async function confirmDelete() {
  if (deleteTargetId.value == null) return
  try {
    await deleteMyLearningPath(deleteTargetId.value)
    await loadPaths()
  } catch (e: any) {
    error.value = String(e?.response?.data?.detail || e?.message || 'Failed to delete learning path')
  } finally {
    closeDeleteConfirm()
  }
}
</script>
