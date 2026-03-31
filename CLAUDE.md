# Learnpathly Frontend

## Design Context

### Users
Self-learners and hobbyists exploring topics at their own pace. They use the platform in varied contexts — desktop study sessions, mobile browsing. The primary job: turn scattered online resources into structured, actionable learning paths they can track over time.

### Brand Personality
**Warm, inviting, encouraging.** The interface should feel like a personal mentor or well-designed knowledge journal — approachable, never intimidating or corporate. Calm and refined, not flashy.

### Aesthetic Direction
Editorial warmth with serif mastheads and generous whitespace. The stone/amber palette gives a grounded, bookish feel. Light mode only.

**Anti-references (must avoid):**
- AI slop: purple-blue gradients, neon on dark, cyan accents, glassmorphism, hero metrics, generic "AI" aesthetic
- Corporate enterprise dashboards
- Playful/toy-like bubble fonts

**Design DNA:**
- Editorial split-panel layouts for auth pages (dark left panel with serif masthead + light right form panel)
- Warm neutrals: stone-950 for dark surfaces, stone-50 for light backgrounds, amber-500 for accent/interaction
- Tight `space-y-4` groupings for form fields, generous `space-y-6+` between sections
- Left-border accent bars on form inputs showing validation state (emerald=valid, red=error, stone-200=neutral)
- Card grids with `aspect-video` thumbnails, `object-cover` images, hover `scale-105` transform
- Dark sidebar in Account layout with active nav dot + chevron indicator

### Design Principles
1. **Warm editorial** — Serif headings, generous whitespace, warm stone/amber palette. Never cold or clinical.
2. **Progressive disclosure** — Start simple, reveal complexity through interaction. Basic options first.
3. **Consistent rhythm** — Tight groupings within sections, generous space between sections. Never equal spacing everywhere.
4. **Image discipline** — Always `aspect-video` containers, `object-cover object-center` images, explicit inline styles for reliability.
5. **Meaningful motion** — Hover scale transforms (duration-500), opacity transitions. No layout-shifting animations.

## Tech Stack
- Vue 3 + Vite + TypeScript
- Tailwind CSS with CSS variables for theming
- lucide-vue-next (icons)
- shadcn-vue/nuxt (Button, input, card, dialog components)
- Pinia (state management)
- Vue Router

## Project Structure
```
app/src/
  api/          # API client modules
  assets/       # CSS, static assets
  components/   # Reusable components (ui/, NavBar.vue, AppFooter.vue)
  i18n/         # Internationalization
  pages/        # Route pages
  router.ts     # Route definitions
  stores/       # Pinia stores (auth)
  utils/        # Utilities (avatars, backendUrl, platform, plan)
```
