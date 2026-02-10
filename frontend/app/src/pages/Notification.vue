<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
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
        <p class="mt-2 text-sm text-muted-foreground">Sign in to see social & collaboration, progress, and path notifications.</p>
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
              <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Social & Collaboration - coming soon</h2>
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
              <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Progress - coming soon</h2>
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
            <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Path - coming soon</h2>
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
    title: 'Someone commented on your path',
    body: 'A new comment was posted under one of your learning paths. Open the path to view it.',
  },
  {
    id: 'sn2',
    date: '2026-01-31',
    kind: 'Reference',
    title: 'Someone referenced your resource',
    body: 'A public learning path referenced a resource you created or shared.',
  },
  {
    id: 'sn3',
    date: '2026-01-31',
    kind: 'Follow',
    title: 'Someone followed you',
    body: 'You have a new follower. Social and collaboration features will be expanded over time.',
  },
]

const progressNotifications: TypedNotice[] = [
  {
    id: 'pn1',
    date: '2026-01-31',
    kind: 'Step completed',
    title: 'You completed a step',
    body: 'Your learning progress for that step has been updated.',
  },
  {
    id: 'pn2',
    date: '2026-01-31',
    kind: 'Milestone',
    title: 'Milestone: 30% complete',
    body: 'You reached 30% completion on a learning path.',
  },
  {
    id: 'pn3',
    date: '2026-01-31',
    kind: 'Reminder',
    title: 'Keep-learning reminders (optional)',
    body: 'You can set daily or weekly reminders to stay consistent.',
  },
]

const pathUpdateNotifications: TypedNotice[] = [
  {
    id: 'un1',
    date: '2026-01-31',
    kind: 'Updated',
    title: 'A path you follow was updated',
    body: 'The author updated the path (added / removed / reordered steps).',
  },
  {
    id: 'un2',
    date: '2026-01-31',
    kind: 'Forked',
    title: 'Your path was forked or saved',
    body: 'Your learning path received a new fork or save.',
  },
]

function statusBadgeClass(status: ServiceNotice['status']) {
  if (status === 'operational') return 'text-foreground'
  if (status === 'degraded') return 'text-muted-foreground'
  return 'text-destructive'
}
</script>
