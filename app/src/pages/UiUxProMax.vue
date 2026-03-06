<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">UI/UX Pro Max</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">
            A searchable design intelligence playbook. Browse sections like a blog, then open one to read.
          </p>
        </div>
        <div class="md:col-span-4 md:flex md:justify-end">
          <div class="w-full md:max-w-xs">
            <Input v-model="query" type="search" placeholder="Search sections..." class="rounded-md" />
          </div>
        </div>
      </div>
    </section>

    <section>
      <div class="grid gap-6 lg:grid-cols-12">
        <aside class="lg:col-span-4">
          <Card className="rounded-md" :hoverable="false" padded>
            <div class="flex items-baseline justify-between gap-3">
              <p class="text-sm font-semibold text-foreground">Sections</p>
              <p class="text-xs text-muted-foreground">{{ filteredSections.length }}</p>
            </div>

            <div class="mt-4 space-y-1">
              <button
                v-for="s in filteredSections"
                :key="s.key"
                type="button"
                class="w-full rounded-md border border-transparent px-3 py-2 text-left transition-colors"
                :class="selectedKey === s.key ? 'bg-foreground text-background' : 'text-foreground hover:bg-muted/30'"
                @click="selectedKey = s.key"
              >
                <p class="text-sm font-semibold line-clamp-1">{{ s.title }}</p>
                <p class="mt-1 text-xs leading-relaxed opacity-80 line-clamp-2">{{ s.excerpt }}</p>
              </button>
            </div>
          </Card>
        </aside>

        <main class="lg:col-span-8 space-y-4">
          <Card className="rounded-md" :hoverable="false" padded>
            <div class="flex items-start justify-between gap-4">
              <div class="min-w-0">
                <h2 class="text-xl font-semibold tracking-tight text-foreground line-clamp-2">{{ activeSection?.title || 'Select a section' }}</h2>
                <p class="mt-2 text-sm text-muted-foreground line-clamp-2">{{ activeSection?.excerpt || 'Pick a section on the left to read.' }}</p>
              </div>
              <Button
                v-if="activeSection"
                type="button"
                variant="outline"
                size="sm"
                class="shrink-0 rounded-md"
                @click="copyLink"
              >
                Copy link
              </Button>
            </div>
          </Card>

          <Card className="rounded-md" :hoverable="false" padded>
            <div v-if="activeSection" class="space-y-4">
              <div class="rounded-md border border-border bg-muted/30 p-4">
                <pre class="whitespace-pre-wrap text-sm leading-relaxed text-foreground">{{ activeSection.content }}</pre>
              </div>
            </div>
            <div v-else class="text-sm text-muted-foreground">No section selected.</div>
          </Card>
        </main>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'

// Load the skill markdown as a raw string (no extra markdown renderer dependency)
import skillRaw from '../../../../skills/ui-ux-pro-max/SKILL.md?raw'

type SkillSection = {
  key: string
  title: string
  content: string
  excerpt: string
}

function stripFrontmatter(md: string) {
  const raw = String(md || '')
  if (!raw.startsWith('---')) return raw
  const end = raw.indexOf('\n---', 3)
  if (end === -1) return raw
  return raw.slice(end + '\n---'.length)
}

function normalizeWhitespace(input: string) {
  return String(input || '')
    .replace(/\r\n/g, '\n')
    .replace(/\t/g, '  ')
    .trim()
}

function excerptOf(input: string, maxLen = 140) {
  const text = normalizeWhitespace(input)
    .replace(/^#+\s+/gm, '')
    .replace(/```[\s\S]*?```/g, '')
    .replace(/`([^`]+)`/g, '$1')
    .replace(/\n+/g, ' ')
    .trim()

  if (text.length <= maxLen) return text
  return text.slice(0, maxLen).trim() + '…'
}

const allSections = computed<SkillSection[]>(() => {
  const md = normalizeWhitespace(stripFrontmatter(skillRaw))
  const parts = md.split(/^##\s+/m)

  const out: SkillSection[] = []

  // Title/intro sits in parts[0]
  const intro = parts[0]?.trim()
  if (intro) {
    out.push({
      key: 'intro',
      title: 'Overview',
      content: intro,
      excerpt: excerptOf(intro),
    })
  }

  for (let i = 1; i < parts.length; i++) {
    const block = parts[i]
    if (!block) continue
    const lines = block.split('\n')
    const title = (lines[0] || '').trim()
    const content = block.trim()
    if (!title) continue

    out.push({
      key: title.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, ''),
      title,
      content: '## ' + content,
      excerpt: excerptOf(content),
    })
  }

  return out
})

const query = ref('')

const filteredSections = computed(() => {
  const q = query.value.trim().toLowerCase()
  if (!q) return allSections.value

  return allSections.value.filter((s) => {
    return (
      s.title.toLowerCase().includes(q) ||
      s.content.toLowerCase().includes(q)
    )
  })
})

const selectedKey = ref<string>('intro')

const activeSection = computed(() => {
  return allSections.value.find((s) => s.key === selectedKey.value) || filteredSections.value[0] || null
})

watch(
  () => filteredSections.value,
  (next) => {
    if (next.length === 0) return
    const stillExists = next.some((s) => s.key === selectedKey.value)
    if (!stillExists) selectedKey.value = next[0].key
  },
  { immediate: true },
)

function keyFromHash() {
  const raw = String(location.hash || '').replace(/^#/, '')
  try {
    return decodeURIComponent(raw)
  } catch {
    return raw
  }
}

function syncFromHash() {
  const key = keyFromHash()
  if (!key) return
  const exists = allSections.value.some((s) => s.key === key)
  if (exists) selectedKey.value = key
}

onMounted(() => {
  syncFromHash()
  window.addEventListener('hashchange', syncFromHash)
})

async function copyLink() {
  const key = activeSection.value?.key
  if (!key) return

  const url = `${location.origin}/ui-ux-pro-max#${encodeURIComponent(key)}`
  try {
    await navigator.clipboard.writeText(url)
  } catch {
    // ignore
  }
}
</script>
