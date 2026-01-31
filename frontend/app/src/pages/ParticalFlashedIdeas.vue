<template>
  <div class="min-h-[60vh] space-y-6">
    <div>
      <h3 class="text-lg font-semibold text-foreground">Flashed Ideas</h3>
      <p class="mt-2 text-sm text-muted-foreground">记录你的素材：手动获取的 URL / 分享链接、笔记、文档链接、文字片段</p>
    </div>

    <!-- Add item -->
    <section class="rounded-md border border-border bg-background p-6">
      <div class="flex items-start justify-between gap-4">
        <div>
          <h2 class="text-lg font-semibold text-foreground">新增记录</h2>
          <p class="text-sm text-muted-foreground mt-1">支持：链接 / 文档链接 / 笔记 / 文字片段</p>
        </div>
        <Button type="button" class="rounded-md" :disabled="!canSave" @click="saveItem">保存</Button>
      </div>

      <div class="mt-5 grid grid-cols-1 lg:grid-cols-2 gap-4">
        <div>
          <label class="block text-sm font-semibold text-foreground mb-2">类型</label>
          <select
            v-model="draft.kind"
            class="w-full px-3 py-2 border border-border rounded-md bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-ring"
          >
            <option value="link">分享链接 / URL</option>
            <option value="document">文档链接</option>
            <option value="note">笔记</option>
            <option value="snippet">文字片段</option>
          </select>
        </div>

        <div>
          <label class="block text-sm font-semibold text-foreground mb-2">标题 *</label>
          <Input v-model="draft.title" type="text" placeholder="给它起个名字，方便以后搜索" class="rounded-md" />
        </div>

        <div v-if="draft.kind === 'link' || draft.kind === 'document'" class="lg:col-span-2">
          <label class="block text-sm font-semibold text-foreground mb-2">链接 *</label>
          <Input v-model="draft.url" type="url" placeholder="https://..." class="rounded-md" />
        </div>

        <div v-else class="lg:col-span-2">
          <label class="block text-sm font-semibold text-foreground mb-2">内容 *</label>
          <textarea
            v-model="draft.content"
            rows="5"
            placeholder="把笔记或文字片段贴在这里"
            class="w-full px-3 py-2 border border-border rounded-md bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-ring"
          ></textarea>
        </div>

        <div class="lg:col-span-2">
          <label class="block text-sm font-semibold text-foreground mb-2">备注（可选）</label>
          <textarea
            v-model="draft.note"
            rows="2"
            placeholder="为什么收藏 / 下一步怎么用"
            class="w-full px-3 py-2 border border-border rounded-md bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-ring"
          ></textarea>
        </div>
      </div>
    </section>

    <!-- Documents -->
    <section class="space-y-4">
      <div class="flex items-center justify-between">
        <h2 class="text-lg font-semibold text-foreground">文档</h2>
        <span class="text-sm text-muted-foreground">{{ documents.length }} items</span>
      </div>
      <div v-if="documents.length === 0" class="rounded-md border border-border bg-muted/30 p-6 text-sm text-muted-foreground">暂无文档链接</div>
      <div v-else class="space-y-3">
        <article
          v-for="d in documents"
          :key="d.id"
          class="bg-background rounded-md border border-border p-5 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3"
        >
          <div class="min-w-0">
            <h3 class="text-foreground font-semibold line-clamp-1" :title="d.title">{{ d.title }}</h3>
            <a :href="d.url" target="_blank" class="text-foreground underline underline-offset-4 break-all text-sm">{{ d.url }}</a>
            <p v-if="d.note" class="text-muted-foreground text-sm mt-1 line-clamp-2" :title="d.note">{{ d.note }}</p>
            <p class="text-xs text-muted-foreground mt-1">{{ formatDate(d.createdAt) }}</p>
          </div>
          <div class="flex items-center gap-2">
            <span class="px-2 py-1 rounded-md border border-border bg-muted/30 text-xs font-semibold text-foreground">Document</span>
            <Button type="button" size="sm" class="rounded-md" asChild>
              <a :href="d.url" target="_blank">打开</a>
            </Button>
            <Button type="button" variant="destructive" size="sm" class="rounded-md" @click="removeItem(d.id)">删除</Button>
          </div>
        </article>
      </div>
    </section>

    <!-- Text snippets -->
    <section class="space-y-4">
      <div class="flex items-center justify-between">
        <h2 class="text-lg font-semibold text-foreground">文字片段</h2>
        <span class="text-sm text-muted-foreground">{{ snippets.length }} items</span>
      </div>
      <div v-if="snippets.length === 0" class="rounded-md border border-border bg-muted/30 p-6 text-sm text-muted-foreground">暂无文字片段</div>
      <div v-else class="grid grid-cols-1 lg:grid-cols-2 gap-4">
        <article v-for="t in snippets" :key="t.id" class="bg-background rounded-md border border-border p-5">
          <div class="flex items-start justify-between gap-3">
            <div class="min-w-0">
              <h3 class="text-foreground font-semibold line-clamp-1" :title="t.title">{{ t.title }}</h3>
              <p class="text-xs text-muted-foreground mt-1">{{ formatDate(t.createdAt) }}</p>
            </div>
            <span class="px-2 py-1 rounded-md border border-border bg-muted/30 text-xs font-semibold text-foreground">Text</span>
          </div>
          <p class="mt-3 text-muted-foreground text-sm leading-relaxed whitespace-pre-wrap line-clamp-6">{{ t.content }}</p>
          <p v-if="t.note" class="mt-3 text-muted-foreground text-sm line-clamp-2" :title="t.note">{{ t.note }}</p>
          <div class="mt-4 flex items-center justify-between gap-3">
            <div class="text-xs text-muted-foreground">{{ t.kind === 'snippet' ? 'Snippet' : 'Text' }}</div>
            <Button type="button" variant="destructive" size="sm" class="rounded-md" @click="removeItem(t.id)">删除</Button>
          </div>
        </article>
      </div>
    </section>

    <!-- Notes -->
    <section class="space-y-4">
      <div class="flex items-center justify-between">
        <h2 class="text-lg font-semibold text-foreground">笔记</h2>
        <span class="text-sm text-muted-foreground">{{ notes.length }} items</span>
      </div>
      <div v-if="notes.length === 0" class="rounded-md border border-border bg-muted/30 p-6 text-sm text-muted-foreground">暂无笔记</div>
      <div v-else class="grid grid-cols-1 lg:grid-cols-2 gap-4">
        <article v-for="n in notes" :key="n.id" class="bg-background rounded-md border border-border p-5">
          <div class="flex items-start justify-between gap-3">
            <div class="min-w-0">
              <h3 class="text-foreground font-semibold line-clamp-1" :title="n.title">{{ n.title }}</h3>
              <p class="text-xs text-muted-foreground mt-1">{{ formatDate(n.createdAt) }}</p>
            </div>
            <span class="px-2 py-1 rounded-md border border-border bg-muted/30 text-xs font-semibold text-foreground">Note</span>
          </div>
          <p class="mt-3 text-muted-foreground text-sm leading-relaxed whitespace-pre-wrap line-clamp-8">{{ n.content }}</p>
          <p v-if="n.note" class="mt-3 text-muted-foreground text-sm line-clamp-2" :title="n.note">{{ n.note }}</p>
          <div class="mt-4 flex items-center justify-end">
            <Button type="button" variant="destructive" size="sm" class="rounded-md" @click="removeItem(n.id)">删除</Button>
          </div>
        </article>
      </div>
    </section>

    <!-- Shared links -->
    <section class="space-y-4">
      <div class="flex items-center justify-between">
        <h2 class="text-lg font-semibold text-foreground">分享链接</h2>
        <span class="text-sm text-muted-foreground">{{ links.length }} items</span>
      </div>
      <div v-if="links.length === 0" class="rounded-md border border-border bg-muted/30 p-6 text-sm text-muted-foreground">暂无分享链接</div>
      <div v-else class="space-y-3">
        <article v-for="l in links" :key="l.id" class="bg-background rounded-md border border-border p-5 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
          <div class="min-w-0">
            <h3 class="text-foreground font-semibold line-clamp-1" :title="l.title">{{ l.title }}</h3>
            <a :href="l.url" target="_blank" class="text-foreground underline underline-offset-4 break-all text-sm">{{ l.url }}</a>
            <p v-if="l.note" class="text-muted-foreground text-sm mt-1 line-clamp-2" :title="l.note">{{ l.note }}</p>
            <p class="text-xs text-muted-foreground mt-1">{{ formatDate(l.createdAt) }}</p>
          </div>
          <div class="flex items-center gap-2">
            <span class="px-2 py-1 rounded-md border border-border bg-muted/30 text-xs font-semibold text-foreground">Link</span>
            <Button type="button" size="sm" class="rounded-md" asChild>
              <a :href="l.url" target="_blank">打开</a>
            </Button>
            <Button type="button" variant="destructive" size="sm" class="rounded-md" @click="removeItem(l.id)">删除</Button>
          </div>
        </article>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'

type ItemKind = 'link' | 'document' | 'note' | 'snippet'

type ParticalItem = {
  id: string
  kind: ItemKind
  title: string
  url?: string
  content?: string
  note?: string
  createdAt: string
}

const STORAGE_KEY = 'partical.items.v1'

function safeJsonParse<T>(raw: string | null): T | null {
  if (!raw) return null
  try {
    return JSON.parse(raw) as T
  } catch {
    return null
  }
}

function loadItems(): ParticalItem[] {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const storage = (globalThis as any).localStorage
  const raw = storage?.getItem?.(STORAGE_KEY) ?? null
  const parsed = safeJsonParse<ParticalItem[]>(raw)
  if (!parsed) return []
  return parsed.filter(i => typeof i?.id === 'string' && typeof i?.kind === 'string' && typeof i?.title === 'string')
}

function persistItems(next: ParticalItem[]) {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const storage = (globalThis as any).localStorage
  storage?.setItem?.(STORAGE_KEY, JSON.stringify(next))
}

function makeId() {
  return `${Date.now()}-${Math.random().toString(16).slice(2)}`
}

function formatDate(iso: string) {
  if (!iso) return ''
  return iso.slice(0, 10)
}

const items = ref<ParticalItem[]>([])

const draft = ref<{ kind: ItemKind; title: string; url: string; content: string; note: string }>({
  kind: 'link',
  title: '',
  url: '',
  content: '',
  note: '',
})

const canSave = computed(() => {
  const titleOk = draft.value.title.trim().length > 0
  if (!titleOk) return false
  if (draft.value.kind === 'link' || draft.value.kind === 'document') {
    return draft.value.url.trim().length > 0
  }
  return draft.value.content.trim().length > 0
})

function saveItem() {
  if (!canSave.value) return
  const now = new Date().toISOString()
  const next: ParticalItem = {
    id: makeId(),
    kind: draft.value.kind,
    title: draft.value.title.trim(),
    url: draft.value.url.trim() || undefined,
    content: draft.value.content.trim() || undefined,
    note: draft.value.note.trim() || undefined,
    createdAt: now,
  }
  const updated = [next, ...items.value]
  items.value = updated
  persistItems(updated)

  draft.value = {
    kind: draft.value.kind,
    title: '',
    url: '',
    content: '',
    note: '',
  }
}

function removeItem(id: string) {
  const next = items.value.filter(i => i.id !== id)
  items.value = next
  persistItems(next)
}

const documents = computed(() => items.value.filter(i => i.kind === 'document' && i.url))
const snippets = computed(() => items.value.filter(i => i.kind === 'snippet' && i.content))
const notes = computed(() => items.value.filter(i => i.kind === 'note' && i.content))
const links = computed(() => items.value.filter(i => i.kind === 'link' && i.url))

onMounted(() => {
  items.value = loadItems()
})
</script>
