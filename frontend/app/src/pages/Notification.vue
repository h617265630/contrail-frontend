<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Notifications</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">Platform updates, important changes, and your activity</p>
        </div>
      </div>
    </section>

    <section class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <Card as="section" :hoverable="false" class="rounded-none">
        <div class="p-6 space-y-4">
          <div>
            <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Platform updates</h2>
            <p class="text-sm text-muted-foreground">New features</p>
          </div>
          <div class="space-y-3">
            <article v-for="n in platformUpdates" :key="n.id" class="border border-border bg-background p-4">
              <div class="flex items-start justify-between gap-3">
                <div class="min-w-0">
                  <p class="text-xs text-muted-foreground">{{ n.date }}</p>
                  <h3 class="text-foreground font-semibold mt-1 line-clamp-1" :title="n.title">{{ n.title }}</h3>
                </div>
                <span class="shrink-0 px-2 py-1 border border-border bg-background text-xs font-semibold text-foreground">New</span>
              </div>
              <p class="text-muted-foreground text-sm mt-2 line-clamp-3" :title="n.body">{{ n.body }}</p>
            </article>
          </div>
        </div>
      </Card>

      <Card as="section" :hoverable="false" class="rounded-none">
        <div class="p-6 space-y-4">
          <div>
            <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Important changes</h2>
            <p class="text-sm text-muted-foreground">Rules & policies</p>
          </div>
          <div class="space-y-3">
            <article v-for="n in ruleChanges" :key="n.id" class="border border-border bg-background p-4">
              <div class="flex items-start justify-between gap-3">
                <div class="min-w-0">
                  <p class="text-xs text-muted-foreground">{{ n.date }}</p>
                  <h3 class="text-foreground font-semibold mt-1 line-clamp-1" :title="n.title">{{ n.title }}</h3>
                </div>
                <span class="shrink-0 px-2 py-1 border border-border bg-background text-xs font-semibold text-foreground">Rule</span>
              </div>
              <p class="text-muted-foreground text-sm mt-2 line-clamp-3" :title="n.body">{{ n.body }}</p>
            </article>
          </div>
        </div>
      </Card>

      <Card as="section" :hoverable="false" class="rounded-none">
        <div class="p-6 space-y-4">
          <div>
            <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Service status</h2>
            <p class="text-sm text-muted-foreground">Availability & incidents</p>
          </div>
          <div class="space-y-3">
            <article v-for="s in serviceStatus" :key="s.id" class="border border-border bg-background p-4">
              <div class="flex items-start justify-between gap-3">
                <div class="min-w-0">
                  <p class="text-xs text-muted-foreground">{{ s.date }}</p>
                  <h3 class="text-foreground font-semibold mt-1 line-clamp-1" :title="s.title">{{ s.title }}</h3>
                </div>
                <span class="shrink-0 px-2 py-1 border border-border bg-background text-xs font-semibold" :class="statusBadgeClass(s.status)">
                  {{ s.status }}
                </span>
              </div>
              <p class="text-muted-foreground text-sm mt-2 line-clamp-3" :title="s.body">{{ s.body }}</p>
            </article>
          </div>
        </div>
      </Card>
    </section>

    <Card v-if="!isAuthed" as="section" :hoverable="false" class="rounded-none">
      <div class="p-6">
        <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Personal notifications</h2>
        <p class="mt-2 text-sm text-muted-foreground">Sign in to see social, progress, and path update notifications.</p>
        <div class="mt-4">
          <Button :as="RouterLinkComp" to="/login" variant="outline" size="sm" class="rounded-none">Sign in</Button>
        </div>
      </div>
    </Card>

    <section v-else class="space-y-10">
      <section class="grid gap-6 md:grid-cols-2">
        <Card as="section" :hoverable="false" class="rounded-none">
          <div class="p-6 space-y-4">
            <div>
              <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Social & collaboration</h2>
              <p class="text-sm text-muted-foreground">Interactions around your content</p>
            </div>
            <div class="space-y-3">
              <article v-for="n in socialNotifications" :key="n.id" class="border border-border bg-background p-4">
                <div class="flex items-start justify-between gap-3">
                  <div class="min-w-0">
                    <p class="text-xs text-muted-foreground">{{ n.date }}</p>
                    <h3 class="text-foreground font-semibold mt-1 line-clamp-1" :title="n.title">{{ n.title }}</h3>
                  </div>
                  <span class="shrink-0 px-2 py-1 border border-border bg-background text-xs font-semibold text-foreground">{{ n.kind }}</span>
                </div>
                <p class="text-muted-foreground text-sm mt-2 line-clamp-3" :title="n.body">{{ n.body }}</p>
              </article>
            </div>
          </div>
        </Card>

        <Card as="section" :hoverable="false" class="rounded-none">
          <div class="p-6 space-y-4">
            <div>
              <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Progress</h2>
              <p class="text-sm text-muted-foreground">Learning signals & milestones</p>
            </div>
            <div class="space-y-3">
              <article v-for="n in progressNotifications" :key="n.id" class="border border-border bg-background p-4">
                <div class="flex items-start justify-between gap-3">
                  <div class="min-w-0">
                    <p class="text-xs text-muted-foreground">{{ n.date }}</p>
                    <h3 class="text-foreground font-semibold mt-1 line-clamp-1" :title="n.title">{{ n.title }}</h3>
                  </div>
                  <span class="shrink-0 px-2 py-1 border border-border bg-background text-xs font-semibold text-foreground">{{ n.kind }}</span>
                </div>
                <p class="text-muted-foreground text-sm mt-2 line-clamp-3" :title="n.body">{{ n.body }}</p>
              </article>
            </div>
          </div>
        </Card>
      </section>

      <Card as="section" :hoverable="false" class="rounded-none">
        <div class="p-6 space-y-4">
          <div>
            <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Path updates</h2>
            <p class="text-sm text-muted-foreground">Changes and activity around paths</p>
          </div>
          <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <article v-for="n in pathUpdateNotifications" :key="n.id" class="border border-border bg-background p-4">
              <div class="flex items-start justify-between gap-3">
                <div class="min-w-0">
                  <p class="text-xs text-muted-foreground">{{ n.date }}</p>
                  <h3 class="text-foreground font-semibold mt-1 line-clamp-1" :title="n.title">{{ n.title }}</h3>
                </div>
                <span class="shrink-0 px-2 py-1 border border-border bg-background text-xs font-semibold text-foreground">{{ n.kind }}</span>
              </div>
              <p class="text-muted-foreground text-sm mt-2 line-clamp-3" :title="n.body">{{ n.body }}</p>
            </article>
          </div>
        </div>
      </Card>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { RouterLink } from 'vue-router'
import { Button } from '../components/ui/button'
import Card from '../components/ui/Card.vue'
import { useAuthStore } from '../stores/auth'

const RouterLinkComp = RouterLink

const auth = useAuthStore()
const isAuthed = computed(() => auth.isAuthed)

type TextNotice = { id: string; date: string; title: string; body: string }
type ServiceNotice = TextNotice & { status: 'operational' | 'degraded' | 'incident' }
type TypedNotice = TextNotice & { kind: string }

const platformUpdates: TextNotice[] = [
  {
    id: 'pu1',
    date: '2026-01-31',
    title: 'Learning path types are live',
    body: 'LearningPool now groups paths by type (linear / structured / partical pool). You can pick a type when creating a path.',
  },
  {
    id: 'pu2',
    date: '2026-01-31',
    title: 'Refined UI consistency',
    body: 'We improved typography and UI consistency across key pages for a cleaner experience.',
  },
]

const ruleChanges: TextNotice[] = [
  {
    id: 'rc1',
    date: '2026-01-31',
    title: 'Public content guidelines updated',
    body: 'Public paths/resources should avoid sensitive content and include a clear title/description for discoverability.',
  },
]

const serviceStatus: ServiceNotice[] = [
  {
    id: 'ss1',
    date: '2026-01-31',
    title: 'Video metadata extraction',
    body: 'Operational. Some platforms may have rate limits depending on availability.',
    status: 'operational',
  },
]

const socialNotifications: TypedNotice[] = [
  {
    id: 'sn1',
    date: '2026-01-31',
    kind: 'Comment',
    title: '有人评论你的路径',
    body: '有人在你的 learning path 下发表了评论。打开路径即可查看。',
  },
  {
    id: 'sn2',
    date: '2026-01-31',
    kind: 'Reference',
    title: '有人引用了你的资源',
    body: '某个公开 learning path 引用了你创建/分享的资源。',
  },
  {
    id: 'sn3',
    date: '2026-01-31',
    kind: 'Follow',
    title: '有人关注了你',
    body: '你获得了一个新的关注者。社交/协作能力后续会扩展。',
  },
]

const progressNotifications: TypedNotice[] = [
  {
    id: 'pn1',
    date: '2026-01-31',
    kind: 'Step completed',
    title: '你完成了某一步',
    body: '系统已更新该步骤的学习进度。',
  },
  {
    id: 'pn2',
    date: '2026-01-31',
    kind: 'Milestone',
    title: '里程碑：完成 30%',
    body: '你在某条 learning path 上达成了 30% 完成度。',
  },
  {
    id: 'pn3',
    date: '2026-01-31',
    kind: 'Reminder',
    title: '连续学习提醒（可选）',
    body: '你可以设置每日/每周提醒，让学习保持连续。',
  },
]

const pathUpdateNotifications: TypedNotice[] = [
  {
    id: 'un1',
    date: '2026-01-31',
    kind: 'Updated',
    title: '你关注的 Path 被作者更新',
    body: '作者更新了路径内容（新增 / 删除 / 顺序调整）。',
  },
  {
    id: 'un2',
    date: '2026-01-31',
    kind: 'Forked',
    title: '你创建的 Path 被他人 fork / 收藏',
    body: '你的路径获得了新的 fork 或收藏。',
  },
]

function statusBadgeClass(status: ServiceNotice['status']) {
  if (status === 'operational') return 'text-foreground'
  if (status === 'degraded') return 'text-muted-foreground'
  return 'text-destructive'
}
</script>
