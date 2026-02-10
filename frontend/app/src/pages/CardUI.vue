<template>
  <div class="min-h-screen bg-background">
    <div class="mx-auto max-w-7xl px-4 py-8 space-y-12">

      <!-- ─── Section 1: Weight Tier Cards ─── -->
      <section>
        <div class="mb-6">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Weight Tier System</h2>
          <p class="text-sm text-muted-foreground mt-1">Gradient border effects ranked by importance level</p>
        </div>

        <div class="flex flex-wrap gap-6">
          <div
            v-for="card in tierCards"
            :key="card.weight"
            :class="['group shrink-0 w-56 h-72 rounded-md shadow-sm cursor-pointer transition-all duration-300 card-hover', tierClass(card.weight)]"
          >
            <div class="h-full flex flex-col overflow-hidden rounded-md">
              <div class="px-3 py-2 border-b border-border/50 flex items-center justify-between">
                <span class="px-2 py-0.5 text-xs font-bold rounded uppercase tracking-wider" :style="tierBadgeStyle(card.weight)">
                  {{ card.weight }}
                </span>
                <span class="text-xs text-muted-foreground">#{{ String(card.id).padStart(3, '0') }}</span>
              </div>
              <div class="relative h-28 bg-white overflow-hidden px-2">
                <img v-if="card.thumbnail" :src="card.thumbnail" :alt="card.title" class="w-full h-full object-cover" />
                <div v-else class="w-full h-full flex items-center justify-center">
                  <div class="w-12 h-12 rounded-full flex items-center justify-center text-xl font-bold text-white" :style="{ background: tierAccent(card.weight) }">
                    {{ card.title.charAt(0) }}
                  </div>
                </div>
              </div>
              <div class="px-3 py-2 border-b border-border/50 bg-white">
                <h3 class="text-sm font-bold text-foreground line-clamp-1">{{ card.title }}</h3>
              </div>
              <div class="px-3 py-2 flex-1 bg-muted/30">
                <p class="text-xs text-muted-foreground line-clamp-2">{{ card.summary }}</p>
              </div>
              <div class="px-3 py-2 border-t border-border/50 flex items-center justify-between">
                <span class="text-xs text-muted-foreground">{{ card.platform }}</span>
                <span class="text-xs font-medium text-foreground">{{ card.type }}</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- ─── Section 2: Enhanced Gradient Border Cards ─── -->
      <section>
        <div class="mb-6">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Gradient Border Effects</h2>
          <p class="text-sm text-muted-foreground mt-1">Animated gradient borders with glow effects</p>
        </div>

        <div class="flex flex-wrap gap-6">
          <div
            v-for="card in gradientCards"
            :key="card.tier"
            :class="['shrink-0 w-56 h-72 rounded-lg cursor-pointer transition-all duration-500 gradient-card', `gradient-${card.tier}`]"
          >
            <div class="h-full flex flex-col overflow-hidden rounded-lg bg-card m-[2px]">
              <div class="px-3 py-2 flex items-center justify-between">
                <span class="text-xs font-bold uppercase tracking-widest" :style="{ color: card.accentColor }">
                  {{ card.tier }}
                </span>
                <span class="text-xs text-muted-foreground">#{{ String(card.id).padStart(3, '0') }}</span>
              </div>
              <div class="relative h-28 bg-white overflow-hidden px-2">
                <img v-if="card.thumbnail" :src="card.thumbnail" :alt="card.title" class="w-full h-full object-cover" />
                <div v-else class="w-full h-full flex items-center justify-center">
                  <div class="w-12 h-12 rounded-full flex items-center justify-center text-xl font-bold text-white" :style="{ background: card.accentColor }">
                    {{ card.title.charAt(0) }}
                  </div>
                </div>
              </div>
              <div class="px-3 py-2 bg-white">
                <h3 class="text-sm font-bold text-foreground line-clamp-1">{{ card.title }}</h3>
              </div>
              <div class="px-3 py-2 flex-1">
                <p class="text-xs text-muted-foreground line-clamp-2">{{ card.summary }}</p>
              </div>
              <div class="px-3 py-2 border-t border-border/30 flex items-center justify-between">
                <span class="text-xs text-muted-foreground">{{ card.platform }}</span>
                <span class="text-xs font-medium" :style="{ color: card.accentColor }">{{ card.type }}</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- ─── Section 3: Glassmorphism Cards ─── -->
      <section>
        <div class="mb-6">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Glassmorphism</h2>
          <p class="text-sm text-muted-foreground mt-1">Frosted glass effect with translucent layers</p>
        </div>

        <div class="relative rounded-xl overflow-hidden p-8" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);">
          <div class="flex flex-wrap gap-6">
            <div
              v-for="card in glassCards"
              :key="card.id"
              class="shrink-0 w-56 h-72 rounded-xl cursor-pointer transition-all duration-300 glass-card hover:scale-105 hover:shadow-2xl"
            >
              <div class="h-full flex flex-col overflow-hidden rounded-xl">
                <div class="px-3 py-2 flex items-center justify-between border-b border-white/10">
                  <span class="px-2 py-0.5 text-xs font-medium rounded bg-white/20 text-white backdrop-blur-sm">
                    {{ card.category }}
                  </span>
                  <span class="text-xs text-white/60">#{{ String(card.id).padStart(3, '0') }}</span>
                </div>
                <div class="relative h-28 overflow-hidden px-2 py-1">
                  <img v-if="card.thumbnail" :src="card.thumbnail" :alt="card.title" class="w-full h-full object-cover rounded-md opacity-90" />
                  <div v-else class="w-full h-full flex items-center justify-center">
                    <div class="w-12 h-12 rounded-full bg-white/20 backdrop-blur flex items-center justify-center text-xl font-bold text-white">
                      {{ card.title.charAt(0) }}
                    </div>
                  </div>
                </div>
                <div class="px-3 py-2 border-b border-white/10">
                  <h3 class="text-sm font-bold text-white line-clamp-1">{{ card.title }}</h3>
                </div>
                <div class="px-3 py-2 flex-1">
                  <p class="text-xs text-white/70 line-clamp-2">{{ card.summary }}</p>
                </div>
                <div class="px-3 py-2 border-t border-white/10 flex items-center justify-between">
                  <span class="text-xs text-white/60">{{ card.platform }}</span>
                  <span class="text-xs font-medium text-white/90">{{ card.type }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- ─── Section 4: Neumorphism Cards ─── -->
      <section>
        <div class="mb-6">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Neumorphism</h2>
          <p class="text-sm text-muted-foreground mt-1">Soft UI with embossed depth</p>
        </div>

        <div class="rounded-xl p-8 bg-[#e8e8e8]">
          <div class="flex flex-wrap gap-6">
            <div
              v-for="card in neuCards"
              :key="card.id"
              class="shrink-0 w-56 h-72 rounded-2xl cursor-pointer transition-all duration-300 neu-card hover:scale-[1.03]"
            >
              <div class="h-full flex flex-col overflow-hidden rounded-2xl">
                <div class="px-3 py-2 flex items-center justify-between">
                  <span class="px-2 py-0.5 text-xs font-medium rounded-full bg-[#e8e8e8] text-slate-600 shadow-[inset_2px_2px_4px_#c8c8c8,inset_-2px_-2px_4px_#ffffff]">
                    {{ card.category }}
                  </span>
                  <span class="text-xs text-slate-400">#{{ String(card.id).padStart(3, '0') }}</span>
                </div>
                <div class="relative h-28 overflow-hidden px-3 py-1">
                  <img v-if="card.thumbnail" :src="card.thumbnail" :alt="card.title" class="w-full h-full object-cover rounded-xl" />
                  <div v-else class="w-full h-full flex items-center justify-center rounded-xl shadow-[inset_4px_4px_8px_#c8c8c8,inset_-4px_-4px_8px_#ffffff]">
                    <div class="w-12 h-12 rounded-full bg-gradient-to-br from-blue-400 to-purple-500 flex items-center justify-center text-xl font-bold text-white shadow-lg">
                      {{ card.title.charAt(0) }}
                    </div>
                  </div>
                </div>
                <div class="px-3 py-2">
                  <h3 class="text-sm font-bold text-slate-700 line-clamp-1">{{ card.title }}</h3>
                </div>
                <div class="px-3 py-1 flex-1">
                  <p class="text-xs text-slate-500 line-clamp-2">{{ card.summary }}</p>
                </div>
                <div class="px-3 py-2 flex items-center justify-between">
                  <span class="text-xs text-slate-400">{{ card.platform }}</span>
                  <span class="text-xs font-medium text-slate-600">{{ card.type }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- ─── Section 5: Holo / Rainbow Cards ─── -->
      <section>
        <div class="mb-6">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Holographic</h2>
          <p class="text-sm text-muted-foreground mt-1">Rainbow shimmer with prismatic light effects</p>
        </div>

        <div class="flex flex-wrap gap-6">
          <div
            v-for="card in holoCards"
            :key="card.id"
            class="shrink-0 w-56 h-72 rounded-lg cursor-pointer transition-all duration-300 holo-card hover:scale-105"
          >
            <div class="h-full flex flex-col overflow-hidden rounded-lg bg-white relative z-10">
              <div class="px-3 py-2 border-b border-border/50 flex items-center justify-between">
                <span class="px-2 py-0.5 text-xs font-bold rounded holo-badge">
                  {{ card.category }}
                </span>
                <span class="text-xs text-muted-foreground">#{{ String(card.id).padStart(3, '0') }}</span>
              </div>
              <div class="relative h-28 overflow-hidden px-2">
                <img v-if="card.thumbnail" :src="card.thumbnail" :alt="card.title" class="w-full h-full object-cover" />
                <div v-else class="w-full h-full flex items-center justify-center">
                  <div class="w-12 h-12 rounded-full holo-badge flex items-center justify-center text-xl font-bold text-white">
                    {{ card.title.charAt(0) }}
                  </div>
                </div>
              </div>
              <div class="px-3 py-2 border-b border-border/50">
                <h3 class="text-sm font-bold text-foreground line-clamp-1">{{ card.title }}</h3>
              </div>
              <div class="px-3 py-2 flex-1">
                <p class="text-xs text-muted-foreground line-clamp-2">{{ card.summary }}</p>
              </div>
              <div class="px-3 py-2 border-t border-border/50 flex items-center justify-between">
                <span class="text-xs text-muted-foreground">{{ card.platform }}</span>
                <span class="text-xs font-medium text-foreground">{{ card.type }}</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- ─── Section 6: Dark Neon / Cyberpunk Cards ─── -->
      <section>
        <div class="mb-6">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Cyberpunk Neon</h2>
          <p class="text-sm text-muted-foreground mt-1">Dark theme with neon glow accents</p>
        </div>

        <div class="rounded-xl p-8 bg-[#0a0e27]">
          <div class="flex flex-wrap gap-6">
            <div
              v-for="(card, i) in neonCards"
              :key="card.id"
              :class="['shrink-0 w-56 h-72 rounded-lg cursor-pointer transition-all duration-300 hover:scale-105', `neon-card-${neonColors[i % neonColors.length].key}`]"
            >
              <div class="h-full flex flex-col overflow-hidden rounded-lg">
                <div class="px-3 py-2 flex items-center justify-between border-b" :style="{ borderColor: neonColors[i % neonColors.length].color + '30' }">
                  <span class="px-2 py-0.5 text-xs font-bold rounded uppercase tracking-wider" :style="{ color: neonColors[i % neonColors.length].color, textShadow: `0 0 8px ${neonColors[i % neonColors.length].color}60` }">
                    {{ card.category }}
                  </span>
                  <span class="text-xs text-gray-500">#{{ String(card.id).padStart(3, '0') }}</span>
                </div>
                <div class="relative h-28 overflow-hidden px-2 py-1">
                  <img v-if="card.thumbnail" :src="card.thumbnail" :alt="card.title" class="w-full h-full object-cover rounded opacity-80" />
                  <div v-else class="w-full h-full flex items-center justify-center">
                    <div class="w-12 h-12 rounded-full flex items-center justify-center text-xl font-bold" :style="{ color: neonColors[i % neonColors.length].color, border: `2px solid ${neonColors[i % neonColors.length].color}`, boxShadow: `0 0 15px ${neonColors[i % neonColors.length].color}40, inset 0 0 15px ${neonColors[i % neonColors.length].color}20` }">
                      {{ card.title.charAt(0) }}
                    </div>
                  </div>
                </div>
                <div class="px-3 py-2">
                  <h3 class="text-sm font-bold text-gray-100 line-clamp-1">{{ card.title }}</h3>
                </div>
                <div class="px-3 py-1 flex-1">
                  <p class="text-xs text-gray-400 line-clamp-2">{{ card.summary }}</p>
                </div>
                <div class="px-3 py-2 border-t flex items-center justify-between" :style="{ borderColor: neonColors[i % neonColors.length].color + '20' }">
                  <span class="text-xs text-gray-500">{{ card.platform }}</span>
                  <span class="text-xs font-medium" :style="{ color: neonColors[i % neonColors.length].color }">{{ card.type }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- ─── Section 7: Brutalist Cards ─── -->
      <section>
        <div class="mb-6">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Brutalist</h2>
          <p class="text-sm text-muted-foreground mt-1">Raw, bold, unapologetic design with hard shadows</p>
        </div>

        <div class="flex flex-wrap gap-6">
          <div
            v-for="(card, i) in brutalistCards"
            :key="card.id"
            :class="['shrink-0 w-56 h-72 cursor-pointer transition-all duration-200 brutalist-card', `brutalist-${brutalistAccents[i % brutalistAccents.length]}`]"
            :style="{ border: '3px solid #000', boxShadow: '6px 6px 0px #000' }"
          >
            <div class="h-full flex flex-col overflow-hidden bg-white">
              <div class="px-3 py-2 border-b-3 border-black flex items-center justify-between">
                <span class="px-2 py-0.5 text-xs font-black uppercase tracking-wider text-white" :style="{ background: brutalistColorMap[brutalistAccents[i % brutalistAccents.length]] }">
                  {{ card.category }}
                </span>
                <span class="text-xs font-mono font-bold">#{{ String(card.id).padStart(3, '0') }}</span>
              </div>
              <div class="relative h-28 overflow-hidden bg-[#f0f0f0] border-b-3 border-black">
                <img v-if="card.thumbnail" :src="card.thumbnail" :alt="card.title" class="w-full h-full object-cover" />
                <div v-else class="w-full h-full flex items-center justify-center">
                  <div class="w-14 h-14 flex items-center justify-center text-2xl font-black text-white" :style="{ background: brutalistColorMap[brutalistAccents[i % brutalistAccents.length]] }">
                    {{ card.title.charAt(0) }}
                  </div>
                </div>
              </div>
              <div class="px-3 py-2 border-b-2 border-black bg-white">
                <h3 class="text-sm font-black text-black uppercase line-clamp-1">{{ card.title }}</h3>
              </div>
              <div class="px-3 py-2 flex-1">
                <p class="text-xs text-gray-700 line-clamp-2 font-mono">{{ card.summary }}</p>
              </div>
              <div class="px-3 py-2 border-t-2 border-black flex items-center justify-between">
                <span class="text-xs font-bold text-black uppercase">{{ card.platform }}</span>
                <span class="text-xs font-bold" :style="{ color: brutalistColorMap[brutalistAccents[i % brutalistAccents.length]] }">{{ card.type }}</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- ─── Section 8: Aurora / Liquid Gradient Cards ─── -->
      <section>
        <div class="mb-6">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Aurora Liquid</h2>
          <p class="text-sm text-muted-foreground mt-1">Flowing gradients with Northern Lights atmosphere</p>
        </div>

        <div class="flex flex-wrap gap-6">
          <div
            v-for="(card, i) in auroraCards"
            :key="card.id"
            class="shrink-0 w-56 h-72 rounded-2xl cursor-pointer transition-all duration-500 hover:scale-105 aurora-card overflow-hidden"
            :style="{ background: auroraGradients[i % auroraGradients.length] }"
          >
            <div class="h-full flex flex-col overflow-hidden rounded-2xl backdrop-blur-sm bg-white/5">
              <div class="px-3 py-2 flex items-center justify-between border-b border-white/10">
                <span class="px-2 py-0.5 text-xs font-semibold rounded-full bg-white/15 text-white backdrop-blur-md">
                  {{ card.category }}
                </span>
                <span class="text-xs text-white/50">#{{ String(card.id).padStart(3, '0') }}</span>
              </div>
              <div class="relative h-28 overflow-hidden px-2 py-1">
                <img v-if="card.thumbnail" :src="card.thumbnail" :alt="card.title" class="w-full h-full object-cover rounded-xl opacity-85" />
                <div v-else class="w-full h-full flex items-center justify-center">
                  <div class="w-12 h-12 rounded-full bg-white/15 backdrop-blur flex items-center justify-center text-xl font-bold text-white border border-white/20">
                    {{ card.title.charAt(0) }}
                  </div>
                </div>
              </div>
              <div class="px-3 py-2 border-b border-white/10">
                <h3 class="text-sm font-bold text-white line-clamp-1">{{ card.title }}</h3>
              </div>
              <div class="px-3 py-1 flex-1">
                <p class="text-xs text-white/65 line-clamp-2">{{ card.summary }}</p>
              </div>
              <div class="px-3 py-2 border-t border-white/10 flex items-center justify-between">
                <span class="text-xs text-white/50">{{ card.platform }}</span>
                <span class="text-xs font-medium text-white/80">{{ card.type }}</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- ─── Section 9: Retro Terminal / CRT ─── -->
      <section>
        <div class="mb-6">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Retro Terminal</h2>
          <p class="text-sm text-muted-foreground mt-1">CRT scanline aesthetic with phosphor glow</p>
        </div>

        <div class="rounded-xl p-8 bg-[#0c0c0c]">
          <div class="flex flex-wrap gap-6">
            <div
              v-for="(card, i) in retroCards"
              :key="card.id"
              :class="['shrink-0 w-56 h-72 cursor-pointer transition-all duration-300 retro-card', `retro-${retroAccents[i % retroAccents.length]}`]"
            >
              <div class="h-full flex flex-col overflow-hidden font-mono">
                <div class="px-3 py-2 flex items-center justify-between border-b" :style="{ borderColor: retroColorMap[retroAccents[i % retroAccents.length]] + '40' }">
                  <span class="text-xs font-bold uppercase tracking-widest" :style="{ color: retroColorMap[retroAccents[i % retroAccents.length]] }">
                    &gt; {{ card.category }}
                  </span>
                  <span class="text-xs" :style="{ color: retroColorMap[retroAccents[i % retroAccents.length]] + '60' }">#{{ String(card.id).padStart(3, '0') }}</span>
                </div>
                <div class="relative h-28 overflow-hidden flex items-center justify-center border-b" :style="{ borderColor: retroColorMap[retroAccents[i % retroAccents.length]] + '20' }">
                  <div class="text-6xl font-black" :style="{ color: retroColorMap[retroAccents[i % retroAccents.length]] + '30' }">
                    {{ card.title.charAt(0) }}
                  </div>
                </div>
                <div class="px-3 py-2">
                  <h3 class="text-sm font-bold line-clamp-1" :style="{ color: retroColorMap[retroAccents[i % retroAccents.length]] }">{{ card.title }}</h3>
                </div>
                <div class="px-3 py-1 flex-1">
                  <p class="text-xs line-clamp-2" :style="{ color: retroColorMap[retroAccents[i % retroAccents.length]] + '80' }">{{ card.summary }}</p>
                </div>
                <div class="px-3 py-2 border-t flex items-center justify-between" :style="{ borderColor: retroColorMap[retroAccents[i % retroAccents.length]] + '30' }">
                  <span class="text-xs" :style="{ color: retroColorMap[retroAccents[i % retroAccents.length]] + '60' }">{{ card.platform }}</span>
                  <span class="text-xs blink-cursor" :style="{ color: retroColorMap[retroAccents[i % retroAccents.length]] }">{{ card.type }}_</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- ─── Section 10: Watercolor / Ink Wash ─── -->
      <section>
        <div class="mb-6">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Watercolor</h2>
          <p class="text-sm text-muted-foreground mt-1">Soft ink wash with organic edges and translucent layers</p>
        </div>

        <div class="flex flex-wrap gap-6">
          <div
            v-for="(card, i) in watercolorCards"
            :key="card.id"
            class="shrink-0 w-56 h-72 rounded-3xl cursor-pointer transition-all duration-500 watercolor-card hover:scale-105 overflow-hidden"
            :style="{ background: watercolorBgs[i % watercolorBgs.length] }"
          >
            <div class="h-full flex flex-col overflow-hidden rounded-3xl">
              <div class="px-4 py-2 flex items-center justify-between">
                <span class="px-2 py-0.5 text-xs font-semibold rounded-full bg-white/40 text-gray-700 backdrop-blur-sm">{{ card.category }}</span>
                <span class="text-xs text-gray-500/60">#{{ String(card.id).padStart(3, '0') }}</span>
              </div>
              <div class="relative h-28 overflow-hidden px-4 py-1 flex items-center justify-center">
                <div class="w-16 h-16 rounded-full flex items-center justify-center text-2xl font-light" :style="{ background: watercolorDotBgs[i % watercolorDotBgs.length], color: 'white' }">
                  {{ card.title.charAt(0) }}
                </div>
              </div>
              <div class="px-4 py-2">
                <h3 class="text-sm font-semibold text-gray-800 line-clamp-1" style="font-family: Georgia, serif;">{{ card.title }}</h3>
              </div>
              <div class="px-4 py-1 flex-1">
                <p class="text-xs text-gray-600/80 line-clamp-2" style="font-family: Georgia, serif;">{{ card.summary }}</p>
              </div>
              <div class="px-4 py-2 flex items-center justify-between">
                <span class="text-xs text-gray-500/70" style="font-family: Georgia, serif;">{{ card.platform }}</span>
                <span class="text-xs font-medium text-gray-600" style="font-family: Georgia, serif;">{{ card.type }}</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- ─── Section 11: Mesh Gradient / Blob ─── -->
      <section>
        <div class="mb-6">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Mesh Gradient</h2>
          <p class="text-sm text-muted-foreground mt-1">Multi-point color mesh with organic blob shapes</p>
        </div>

        <div class="flex flex-wrap gap-6">
          <div
            v-for="(card, i) in meshCards"
            :key="card.id"
            class="shrink-0 w-56 h-72 rounded-2xl cursor-pointer transition-all duration-500 mesh-card hover:scale-105 overflow-hidden"
            :style="{ background: meshGradients[i % meshGradients.length] }"
          >
            <div class="h-full flex flex-col overflow-hidden rounded-2xl bg-black/10 backdrop-blur-xs">
              <div class="px-3 py-2 flex items-center justify-between border-b border-white/15">
                <span class="px-2 py-0.5 text-xs font-bold rounded-full bg-black/20 text-white backdrop-blur">{{ card.category }}</span>
                <span class="text-xs text-white/40">#{{ String(card.id).padStart(3, '0') }}</span>
              </div>
              <div class="relative h-28 overflow-hidden px-2 py-1 flex items-center justify-center">
                <div class="w-14 h-14 rounded-2xl bg-white/15 backdrop-blur-md flex items-center justify-center text-2xl font-bold text-white border border-white/20 shadow-lg">
                  {{ card.title.charAt(0) }}
                </div>
              </div>
              <div class="px-3 py-2 border-b border-white/10">
                <h3 class="text-sm font-bold text-white line-clamp-1 drop-shadow-sm">{{ card.title }}</h3>
              </div>
              <div class="px-3 py-1 flex-1">
                <p class="text-xs text-white/60 line-clamp-2">{{ card.summary }}</p>
              </div>
              <div class="px-3 py-2 border-t border-white/10 flex items-center justify-between">
                <span class="text-xs text-white/40">{{ card.platform }}</span>
                <span class="text-xs font-medium text-white/70">{{ card.type }}</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- ─── Section 12: Sketch / Wireframe ─── -->
      <section>
        <div class="mb-6">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Sketch / Wireframe</h2>
          <p class="text-sm text-muted-foreground mt-1">Hand-drawn pencil sketch aesthetic with wobbly borders</p>
        </div>

        <div class="flex flex-wrap gap-6">
          <div
            v-for="card in sketchCards"
            :key="card.id"
            class="shrink-0 w-56 h-72 cursor-pointer transition-all duration-300 sketch-card hover:rotate-1 hover:scale-105"
          >
            <div class="h-full flex flex-col overflow-hidden">
              <div class="px-3 py-2 flex items-center justify-between" style="border-bottom: 2px dashed #bbb;">
                <span class="px-2 py-0.5 text-xs font-bold rounded-sm bg-yellow-100 text-gray-700" style="font-family: 'Comic Sans MS', cursive;">{{ card.category }}</span>
                <span class="text-xs text-gray-400" style="font-family: 'Comic Sans MS', cursive;">#{{ String(card.id).padStart(3, '0') }}</span>
              </div>
              <div class="relative h-28 overflow-hidden flex items-center justify-center" style="border-bottom: 2px dashed #ccc;">
                <svg width="64" height="64" viewBox="0 0 64 64">
                  <circle cx="32" cy="32" r="28" fill="none" stroke="#aaa" stroke-width="2" stroke-dasharray="6,3" />
                  <text x="32" y="38" text-anchor="middle" fill="#888" font-size="22" font-family="Comic Sans MS, cursive">{{ card.title.charAt(0) }}</text>
                </svg>
              </div>
              <div class="px-3 py-2" style="border-bottom: 1px dashed #ddd;">
                <h3 class="text-sm font-bold text-gray-700 line-clamp-1" style="font-family: 'Comic Sans MS', cursive;">{{ card.title }}</h3>
              </div>
              <div class="px-3 py-2 flex-1">
                <p class="text-xs text-gray-500 line-clamp-2" style="font-family: 'Comic Sans MS', cursive;">{{ card.summary }}</p>
              </div>
              <div class="px-3 py-2 flex items-center justify-between" style="border-top: 2px dashed #bbb;">
                <span class="text-xs text-gray-400" style="font-family: 'Comic Sans MS', cursive;">{{ card.platform }}</span>
                <span class="text-xs font-bold text-gray-600" style="font-family: 'Comic Sans MS', cursive;">{{ card.type }}</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- ─── Section 13: Metallic / Brushed Steel ─── -->
      <section>
        <div class="mb-6">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Metallic</h2>
          <p class="text-sm text-muted-foreground mt-1">Brushed steel and chrome with reflective surfaces</p>
        </div>

        <div class="flex flex-wrap gap-6">
          <div
            v-for="(card, i) in metallicCards"
            :key="card.id"
            :class="['shrink-0 w-56 h-72 rounded-lg cursor-pointer transition-all duration-300 hover:scale-105', `metallic-${metallicTypes[i % metallicTypes.length]}`]"
          >
            <div class="h-full flex flex-col overflow-hidden rounded-lg metallic-inner">
              <div class="px-3 py-2 flex items-center justify-between border-b border-white/10">
                <span class="px-2 py-0.5 text-xs font-bold rounded uppercase tracking-wider" :style="metallicBadge(metallicTypes[i % metallicTypes.length])">{{ card.category }}</span>
                <span class="text-xs" :style="{ color: metallicTextSub(metallicTypes[i % metallicTypes.length]) }">#{{ String(card.id).padStart(3, '0') }}</span>
              </div>
              <div class="relative h-28 overflow-hidden px-2 py-1 flex items-center justify-center">
                <div class="w-14 h-14 rounded-full flex items-center justify-center text-2xl font-black metallic-icon" :style="metallicIconStyle(metallicTypes[i % metallicTypes.length])">
                  {{ card.title.charAt(0) }}
                </div>
              </div>
              <div class="px-3 py-2 border-b border-white/10">
                <h3 class="text-sm font-bold line-clamp-1" :style="{ color: metallicTextMain(metallicTypes[i % metallicTypes.length]) }">{{ card.title }}</h3>
              </div>
              <div class="px-3 py-1 flex-1">
                <p class="text-xs line-clamp-2" :style="{ color: metallicTextSub(metallicTypes[i % metallicTypes.length]) }">{{ card.summary }}</p>
              </div>
              <div class="px-3 py-2 border-t border-white/10 flex items-center justify-between">
                <span class="text-xs" :style="{ color: metallicTextSub(metallicTypes[i % metallicTypes.length]) }">{{ card.platform }}</span>
                <span class="text-xs font-bold" :style="{ color: metallicTextMain(metallicTypes[i % metallicTypes.length]) }">{{ card.type }}</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- ─── Section 14: Pixel Art / 8-bit ─── -->
      <section>
        <div class="mb-6">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Pixel Art / 8-bit</h2>
          <p class="text-sm text-muted-foreground mt-1">Retro gaming pixel aesthetic with chunky borders</p>
        </div>

        <div class="rounded-xl p-8" style="background: #2d1b69; image-rendering: pixelated;">
          <div class="flex flex-wrap gap-6">
            <div
              v-for="(card, i) in pixelCards"
              :key="card.id"
              class="shrink-0 w-56 h-72 cursor-pointer transition-all duration-200 pixel-card hover:translate-y-[-4px]"
              :style="{ border: `4px solid ${pixelPalette[i % pixelPalette.length]}`, boxShadow: `4px 4px 0px ${pixelPalette[i % pixelPalette.length]}80` }"
            >
              <div class="h-full flex flex-col overflow-hidden" style="font-family: 'Courier New', monospace; image-rendering: pixelated;">
                <div class="px-3 py-2 flex items-center justify-between border-b-4" :style="{ borderColor: pixelPalette[i % pixelPalette.length] + '60', background: pixelPalette[i % pixelPalette.length] + '15' }">
                  <span class="text-xs font-bold uppercase" :style="{ color: pixelPalette[i % pixelPalette.length] }">{{ card.category }}</span>
                  <span class="text-xs text-gray-400">#{{ String(card.id).padStart(3, '0') }}</span>
                </div>
                <div class="relative h-28 overflow-hidden flex items-center justify-center bg-[#1a0f3d]">
                  <div class="text-5xl font-black pixel-bounce" :style="{ color: pixelPalette[i % pixelPalette.length], textShadow: `3px 3px 0px ${pixelPalette[i % pixelPalette.length]}40` }">
                    {{ card.title.charAt(0) }}
                  </div>
                </div>
                <div class="px-3 py-2 bg-[#1a0f3d]">
                  <h3 class="text-sm font-bold text-gray-100 line-clamp-1">{{ card.title }}</h3>
                </div>
                <div class="px-3 py-1 flex-1 bg-[#1a0f3d]">
                  <p class="text-xs text-gray-400 line-clamp-2">{{ card.summary }}</p>
                </div>
                <div class="px-3 py-2 border-t-4 flex items-center justify-between bg-[#1a0f3d]" :style="{ borderColor: pixelPalette[i % pixelPalette.length] + '40' }">
                  <span class="text-xs text-gray-500">{{ card.platform }}</span>
                  <span class="text-xs font-bold" :style="{ color: pixelPalette[i % pixelPalette.length] }">{{ card.type }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- ─── Section 15: Live Data — Random Card Styles ─── -->
      <section>
        <div class="mb-6 flex items-center justify-between">
          <div>
            <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">My Resources — Random Styles</h2>
            <p class="text-sm text-muted-foreground mt-1">Each card gets a randomly assigned UI style from the showcase above</p>
          </div>
          <button
            class="px-4 py-2 text-xs font-semibold uppercase tracking-wider border border-border rounded-none bg-card hover:bg-muted transition"
            @click="reshuffleStyles"
          >
            Reshuffle
          </button>
        </div>

        <div v-if="loading" class="py-12 text-center">
          <div class="inline-block h-8 w-8 animate-spin border-b-2 border-foreground rounded-full" />
          <p class="mt-3 text-sm text-muted-foreground">Loading resources...</p>
        </div>

        <div v-else-if="liveResources.length === 0" class="py-12 text-center">
          <p class="text-sm text-muted-foreground">No resources found. Add some from the My Resources page.</p>
        </div>

        <div v-else class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-5">
          <template v-for="(r, idx) in liveResources" :key="r.id">

            <!-- Style: tier (gold/diamond/prismatic/obsidian) -->
            <div
              v-if="cardStyleMap[r.id]?.style === 'tier'"
              :class="['w-full h-72 rounded-md cursor-pointer transition-all duration-300 card-hover', tierClass(cardStyleMap[r.id].variant)]"
            >
              <div class="h-full flex flex-col overflow-hidden rounded-md">
                <div class="px-3 py-2 border-b border-border/50 flex items-center justify-between">
                  <span class="px-2 py-0.5 text-xs font-bold rounded uppercase tracking-wider" :style="tierBadgeStyle(cardStyleMap[r.id].variant)">{{ r.category_name || r.platform }}</span>
                  <span class="text-xs text-muted-foreground">#{{ String(r.id).padStart(3, '0') }}</span>
                </div>
                <div class="relative h-28 bg-white overflow-hidden px-2">
                  <img v-if="r.thumbnail" :src="r.thumbnail" :alt="r.title" class="w-full h-full object-cover" />
                  <div v-else class="w-full h-full flex items-center justify-center"><div class="w-12 h-12 rounded-full flex items-center justify-center text-xl font-bold text-white" :style="{ background: tierAccent(cardStyleMap[r.id].variant) }">{{ (r.title||'R').charAt(0) }}</div></div>
                </div>
                <div class="px-3 py-2 border-b border-border/50 bg-white"><h3 class="text-sm font-bold text-foreground line-clamp-1">{{ r.title }}</h3></div>
                <div class="px-3 py-2 flex-1 bg-muted/30"><p class="text-xs text-muted-foreground line-clamp-2">{{ r.summary || 'No description' }}</p></div>
                <div class="px-3 py-2 border-t border-border/50 flex items-center justify-between">
                  <span class="text-xs text-muted-foreground">{{ r.platform }}</span>
                  <span class="text-xs font-medium text-foreground">{{ r.resource_type }}</span>
                </div>
              </div>
            </div>

            <!-- Style: gradient -->
            <div
              v-else-if="cardStyleMap[r.id]?.style === 'gradient'"
              :class="['w-full h-72 rounded-lg cursor-pointer transition-all duration-500 gradient-card', `gradient-${cardStyleMap[r.id].variant}`]"
            >
              <div class="h-full flex flex-col overflow-hidden rounded-lg bg-card m-0.5">
                <div class="px-3 py-2 flex items-center justify-between">
                  <span class="text-xs font-bold uppercase tracking-widest" :style="{ color: cardStyleMap[r.id].color }">{{ r.category_name || r.platform }}</span>
                  <span class="text-xs text-muted-foreground">#{{ String(r.id).padStart(3, '0') }}</span>
                </div>
                <div class="relative h-28 bg-white overflow-hidden px-2">
                  <img v-if="r.thumbnail" :src="r.thumbnail" :alt="r.title" class="w-full h-full object-cover" />
                  <div v-else class="w-full h-full flex items-center justify-center"><div class="w-12 h-12 rounded-full flex items-center justify-center text-xl font-bold text-white" :style="{ background: cardStyleMap[r.id].color }">{{ (r.title||'R').charAt(0) }}</div></div>
                </div>
                <div class="px-3 py-2 bg-white"><h3 class="text-sm font-bold text-foreground line-clamp-1">{{ r.title }}</h3></div>
                <div class="px-3 py-2 flex-1"><p class="text-xs text-muted-foreground line-clamp-2">{{ r.summary || 'No description' }}</p></div>
                <div class="px-3 py-2 border-t border-border/30 flex items-center justify-between">
                  <span class="text-xs text-muted-foreground">{{ r.platform }}</span>
                  <span class="text-xs font-medium" :style="{ color: cardStyleMap[r.id].color }">{{ r.resource_type }}</span>
                </div>
              </div>
            </div>

            <!-- Style: glass -->
            <div
              v-else-if="cardStyleMap[r.id]?.style === 'glass'"
              class="w-full h-72 rounded-xl cursor-pointer transition-all duration-300 glass-card hover:scale-105 hover:shadow-2xl overflow-hidden"
              :style="{ background: cardStyleMap[r.id].bg }"
            >
              <div class="h-full flex flex-col overflow-hidden rounded-xl backdrop-blur-md bg-white/8">
                <div class="px-3 py-2 flex items-center justify-between border-b border-white/10">
                  <span class="px-2 py-0.5 text-xs font-medium rounded bg-white/20 text-white backdrop-blur-sm">{{ r.category_name || r.platform }}</span>
                  <span class="text-xs text-white/60">#{{ String(r.id).padStart(3, '0') }}</span>
                </div>
                <div class="relative h-28 overflow-hidden px-2 py-1">
                  <img v-if="r.thumbnail" :src="r.thumbnail" :alt="r.title" class="w-full h-full object-cover rounded-md opacity-90" />
                  <div v-else class="w-full h-full flex items-center justify-center"><div class="w-12 h-12 rounded-full bg-white/20 backdrop-blur flex items-center justify-center text-xl font-bold text-white">{{ (r.title||'R').charAt(0) }}</div></div>
                </div>
                <div class="px-3 py-2 border-b border-white/10"><h3 class="text-sm font-bold text-white line-clamp-1">{{ r.title }}</h3></div>
                <div class="px-3 py-2 flex-1"><p class="text-xs text-white/70 line-clamp-2">{{ r.summary || 'No description' }}</p></div>
                <div class="px-3 py-2 border-t border-white/10 flex items-center justify-between">
                  <span class="text-xs text-white/60">{{ r.platform }}</span>
                  <span class="text-xs font-medium text-white/90">{{ r.resource_type }}</span>
                </div>
              </div>
            </div>

            <!-- Style: neu -->
            <div
              v-else-if="cardStyleMap[r.id]?.style === 'neu'"
              class="w-full h-72 rounded-2xl cursor-pointer transition-all duration-300 neu-card hover:scale-[1.03]"
            >
              <div class="h-full flex flex-col overflow-hidden rounded-2xl">
                <div class="px-3 py-2 flex items-center justify-between">
                  <span class="px-2 py-0.5 text-xs font-medium rounded-full bg-[#e8e8e8] text-slate-600 shadow-[inset_2px_2px_4px_#c8c8c8,inset_-2px_-2px_4px_#ffffff]">{{ r.category_name || r.platform }}</span>
                  <span class="text-xs text-slate-400">#{{ String(r.id).padStart(3, '0') }}</span>
                </div>
                <div class="relative h-28 overflow-hidden px-3 py-1">
                  <img v-if="r.thumbnail" :src="r.thumbnail" :alt="r.title" class="w-full h-full object-cover rounded-xl" />
                  <div v-else class="w-full h-full flex items-center justify-center rounded-xl shadow-[inset_4px_4px_8px_#c8c8c8,inset_-4px_-4px_8px_#ffffff]"><div class="w-12 h-12 rounded-full bg-linear-to-br from-blue-400 to-purple-500 flex items-center justify-center text-xl font-bold text-white shadow-lg">{{ (r.title||'R').charAt(0) }}</div></div>
                </div>
                <div class="px-3 py-2"><h3 class="text-sm font-bold text-slate-700 line-clamp-1">{{ r.title }}</h3></div>
                <div class="px-3 py-1 flex-1"><p class="text-xs text-slate-500 line-clamp-2">{{ r.summary || 'No description' }}</p></div>
                <div class="px-3 py-2 flex items-center justify-between">
                  <span class="text-xs text-slate-400">{{ r.platform }}</span>
                  <span class="text-xs font-medium text-slate-600">{{ r.resource_type }}</span>
                </div>
              </div>
            </div>

            <!-- Style: holo -->
            <div
              v-else-if="cardStyleMap[r.id]?.style === 'holo'"
              class="w-full h-72 rounded-lg cursor-pointer transition-all duration-300 holo-card hover:scale-105"
            >
              <div class="h-full flex flex-col overflow-hidden rounded-lg bg-white relative z-10">
                <div class="px-3 py-2 border-b border-border/50 flex items-center justify-between">
                  <span class="px-2 py-0.5 text-xs font-bold rounded holo-badge">{{ r.category_name || r.platform }}</span>
                  <span class="text-xs text-muted-foreground">#{{ String(r.id).padStart(3, '0') }}</span>
                </div>
                <div class="relative h-28 overflow-hidden px-2">
                  <img v-if="r.thumbnail" :src="r.thumbnail" :alt="r.title" class="w-full h-full object-cover" />
                  <div v-else class="w-full h-full flex items-center justify-center"><div class="w-12 h-12 rounded-full holo-badge flex items-center justify-center text-xl font-bold text-white">{{ (r.title||'R').charAt(0) }}</div></div>
                </div>
                <div class="px-3 py-2 border-b border-border/50"><h3 class="text-sm font-bold text-foreground line-clamp-1">{{ r.title }}</h3></div>
                <div class="px-3 py-2 flex-1"><p class="text-xs text-muted-foreground line-clamp-2">{{ r.summary || 'No description' }}</p></div>
                <div class="px-3 py-2 border-t border-border/50 flex items-center justify-between">
                  <span class="text-xs text-muted-foreground">{{ r.platform }}</span>
                  <span class="text-xs font-medium text-foreground">{{ r.resource_type }}</span>
                </div>
              </div>
            </div>

            <!-- Style: neon -->
            <div
              v-else-if="cardStyleMap[r.id]?.style === 'neon'"
              :class="['w-full h-72 rounded-lg cursor-pointer transition-all duration-300 hover:scale-105', `neon-card-${cardStyleMap[r.id].variant}`]"
            >
              <div class="h-full flex flex-col overflow-hidden rounded-lg">
                <div class="px-3 py-2 flex items-center justify-between border-b" :style="{ borderColor: cardStyleMap[r.id].color + '30' }">
                  <span class="px-2 py-0.5 text-xs font-bold rounded uppercase tracking-wider" :style="{ color: cardStyleMap[r.id].color, textShadow: `0 0 8px ${cardStyleMap[r.id].color}60` }">{{ r.category_name || r.platform }}</span>
                  <span class="text-xs text-gray-500">#{{ String(r.id).padStart(3, '0') }}</span>
                </div>
                <div class="relative h-28 overflow-hidden px-2 py-1">
                  <img v-if="r.thumbnail" :src="r.thumbnail" :alt="r.title" class="w-full h-full object-cover rounded opacity-80" />
                  <div v-else class="w-full h-full flex items-center justify-center"><div class="w-12 h-12 rounded-full flex items-center justify-center text-xl font-bold" :style="{ color: cardStyleMap[r.id].color, border: `2px solid ${cardStyleMap[r.id].color}`, boxShadow: `0 0 15px ${cardStyleMap[r.id].color}40, inset 0 0 15px ${cardStyleMap[r.id].color}20` }">{{ (r.title||'R').charAt(0) }}</div></div>
                </div>
                <div class="px-3 py-2"><h3 class="text-sm font-bold text-gray-100 line-clamp-1">{{ r.title }}</h3></div>
                <div class="px-3 py-1 flex-1"><p class="text-xs text-gray-400 line-clamp-2">{{ r.summary || 'No description' }}</p></div>
                <div class="px-3 py-2 border-t flex items-center justify-between" :style="{ borderColor: cardStyleMap[r.id].color + '20' }">
                  <span class="text-xs text-gray-500">{{ r.platform }}</span>
                  <span class="text-xs font-medium" :style="{ color: cardStyleMap[r.id].color }">{{ r.resource_type }}</span>
                </div>
              </div>
            </div>

            <!-- Style: brutalist -->
            <div
              v-else-if="cardStyleMap[r.id]?.style === 'brutalist'"
              class="w-full h-72 cursor-pointer transition-all duration-200 brutalist-card"
              :style="{ border: '3px solid #000', boxShadow: '6px 6px 0px #000' }"
            >
              <div class="h-full flex flex-col overflow-hidden bg-white">
                <div class="px-3 py-2 border-b-3 border-black flex items-center justify-between">
                  <span class="px-2 py-0.5 text-xs font-black uppercase tracking-wider text-white" :style="{ background: cardStyleMap[r.id].color }">{{ r.category_name || r.platform }}</span>
                  <span class="text-xs font-mono font-bold">#{{ String(r.id).padStart(3, '0') }}</span>
                </div>
                <div class="relative h-28 overflow-hidden bg-[#f0f0f0] border-b-3 border-black">
                  <img v-if="r.thumbnail" :src="r.thumbnail" :alt="r.title" class="w-full h-full object-cover" />
                  <div v-else class="w-full h-full flex items-center justify-center"><div class="w-14 h-14 flex items-center justify-center text-2xl font-black text-white" :style="{ background: cardStyleMap[r.id].color }">{{ (r.title||'R').charAt(0) }}</div></div>
                </div>
                <div class="px-3 py-2 border-b-2 border-black bg-white"><h3 class="text-sm font-black text-black uppercase line-clamp-1">{{ r.title }}</h3></div>
                <div class="px-3 py-2 flex-1"><p class="text-xs text-gray-700 line-clamp-2 font-mono">{{ r.summary || 'No description' }}</p></div>
                <div class="px-3 py-2 border-t-2 border-black flex items-center justify-between">
                  <span class="text-xs font-bold text-black uppercase">{{ r.platform }}</span>
                  <span class="text-xs font-bold" :style="{ color: cardStyleMap[r.id].color }">{{ r.resource_type }}</span>
                </div>
              </div>
            </div>

            <!-- Style: aurora -->
            <div
              v-else-if="cardStyleMap[r.id]?.style === 'aurora'"
              class="w-full h-72 rounded-2xl cursor-pointer transition-all duration-500 hover:scale-105 aurora-card overflow-hidden"
              :style="{ background: cardStyleMap[r.id].bg }"
            >
              <div class="h-full flex flex-col overflow-hidden rounded-2xl backdrop-blur-sm bg-white/5">
                <div class="px-3 py-2 flex items-center justify-between border-b border-white/10">
                  <span class="px-2 py-0.5 text-xs font-semibold rounded-full bg-white/15 text-white backdrop-blur-md">{{ r.category_name || r.platform }}</span>
                  <span class="text-xs text-white/50">#{{ String(r.id).padStart(3, '0') }}</span>
                </div>
                <div class="relative h-28 overflow-hidden px-2 py-1">
                  <img v-if="r.thumbnail" :src="r.thumbnail" :alt="r.title" class="w-full h-full object-cover rounded-xl opacity-85" />
                  <div v-else class="w-full h-full flex items-center justify-center"><div class="w-12 h-12 rounded-full bg-white/15 backdrop-blur flex items-center justify-center text-xl font-bold text-white border border-white/20">{{ (r.title||'R').charAt(0) }}</div></div>
                </div>
                <div class="px-3 py-2 border-b border-white/10"><h3 class="text-sm font-bold text-white line-clamp-1">{{ r.title }}</h3></div>
                <div class="px-3 py-1 flex-1"><p class="text-xs text-white/65 line-clamp-2">{{ r.summary || 'No description' }}</p></div>
                <div class="px-3 py-2 border-t border-white/10 flex items-center justify-between">
                  <span class="text-xs text-white/50">{{ r.platform }}</span>
                  <span class="text-xs font-medium text-white/80">{{ r.resource_type }}</span>
                </div>
              </div>
            </div>

            <!-- Style: retro -->
            <div
              v-else-if="cardStyleMap[r.id]?.style === 'retro'"
              class="w-full h-72 cursor-pointer transition-all duration-300 retro-card overflow-hidden"
              :class="[`retro-${cardStyleMap[r.id].variant}`]"
            >
              <div class="h-full flex flex-col overflow-hidden font-mono">
                <div class="px-3 py-2 flex items-center justify-between border-b" :style="{ borderColor: cardStyleMap[r.id].color + '40' }">
                  <span class="text-xs font-bold uppercase tracking-widest" :style="{ color: cardStyleMap[r.id].color, textShadow: `0 0 6px ${cardStyleMap[r.id].color}80` }">{{ r.category_name || r.platform }}</span>
                  <span class="text-xs" :style="{ color: cardStyleMap[r.id].color + '80' }">> {{ String(r.id).padStart(3, '0') }}</span>
                </div>
                <div class="relative h-28 overflow-hidden px-2 py-1">
                  <img v-if="r.thumbnail" :src="r.thumbnail" :alt="r.title" class="w-full h-full object-cover rounded opacity-70 grayscale-[30%]" />
                  <div v-else class="w-full h-full flex items-center justify-center" :style="{ color: cardStyleMap[r.id].color }"><span class="text-4xl font-bold" style="text-shadow: 0 0 10px currentColor">{{ (r.title||'R').charAt(0) }}</span></div>
                </div>
                <div class="px-3 py-2"><h3 class="text-sm font-bold line-clamp-1" :style="{ color: cardStyleMap[r.id].color }">{{ r.title }}</h3></div>
                <div class="px-3 py-1 flex-1"><p class="text-xs line-clamp-2" :style="{ color: cardStyleMap[r.id].color + 'aa' }">{{ r.summary || 'No description' }}</p></div>
                <div class="px-3 py-2 border-t flex items-center justify-between" :style="{ borderColor: cardStyleMap[r.id].color + '30' }">
                  <span class="text-xs" :style="{ color: cardStyleMap[r.id].color + '80' }">$ {{ r.platform }}</span>
                  <span class="text-xs font-bold" :style="{ color: cardStyleMap[r.id].color }">{{ r.resource_type }}<span class="blink-cursor">_</span></span>
                </div>
              </div>
            </div>

            <!-- Style: watercolor -->
            <div
              v-else-if="cardStyleMap[r.id]?.style === 'watercolor'"
              class="w-full h-72 rounded-2xl cursor-pointer transition-all duration-500 hover:scale-105 watercolor-card overflow-hidden"
              :style="{ background: watercolorBgs[idx % watercolorBgs.length] }"
            >
              <div class="h-full flex flex-col overflow-hidden rounded-2xl">
                <div class="px-3 py-2 flex items-center justify-between">
                  <span class="px-2 py-0.5 text-xs font-medium rounded-full bg-white/50 backdrop-blur-sm" :style="{ color: cardStyleMap[r.id].color }">{{ r.category_name || r.platform }}</span>
                  <span class="text-xs text-gray-400">#{{ String(r.id).padStart(3, '0') }}</span>
                </div>
                <div class="relative h-28 overflow-hidden px-3 py-1">
                  <img v-if="r.thumbnail" :src="r.thumbnail" :alt="r.title" class="w-full h-full object-cover rounded-xl opacity-80" />
                  <div v-else class="w-full h-full flex items-center justify-center"><div class="w-14 h-14 rounded-full flex items-center justify-center text-xl font-light text-white" :style="{ background: cardStyleMap[r.id].color + '80' }">{{ (r.title||'R').charAt(0) }}</div></div>
                </div>
                <div class="px-3 py-2"><h3 class="text-sm font-semibold text-gray-700 line-clamp-1" style="font-family: Georgia, serif">{{ r.title }}</h3></div>
                <div class="px-3 py-1 flex-1"><p class="text-xs text-gray-500 line-clamp-2" style="font-family: Georgia, serif">{{ r.summary || 'No description' }}</p></div>
                <div class="px-3 py-2 flex items-center justify-between">
                  <span class="text-xs text-gray-400 italic">{{ r.platform }}</span>
                  <span class="text-xs font-medium" :style="{ color: cardStyleMap[r.id].color }">{{ r.resource_type }}</span>
                </div>
              </div>
            </div>

            <!-- Style: mesh -->
            <div
              v-else-if="cardStyleMap[r.id]?.style === 'mesh'"
              class="w-full h-72 rounded-xl cursor-pointer transition-all duration-500 hover:scale-105 mesh-card overflow-hidden"
              :style="{ background: meshGradients[idx % meshGradients.length] }"
            >
              <div class="h-full flex flex-col overflow-hidden rounded-xl">
                <div class="px-3 py-2 flex items-center justify-between border-b border-white/10">
                  <span class="px-2 py-0.5 text-xs font-bold rounded bg-black/20 text-white backdrop-blur-sm uppercase tracking-wider">{{ r.category_name || r.platform }}</span>
                  <span class="text-xs text-white/40">#{{ String(r.id).padStart(3, '0') }}</span>
                </div>
                <div class="relative h-28 overflow-hidden px-2 py-1">
                  <img v-if="r.thumbnail" :src="r.thumbnail" :alt="r.title" class="w-full h-full object-cover rounded-lg opacity-80" />
                  <div v-else class="w-full h-full flex items-center justify-center"><div class="w-12 h-12 rounded-full bg-white/10 backdrop-blur-md flex items-center justify-center text-xl font-bold text-white border border-white/20">{{ (r.title||'R').charAt(0) }}</div></div>
                </div>
                <div class="px-3 py-2 border-b border-white/10"><h3 class="text-sm font-bold text-white line-clamp-1">{{ r.title }}</h3></div>
                <div class="px-3 py-1 flex-1"><p class="text-xs text-white/60 line-clamp-2">{{ r.summary || 'No description' }}</p></div>
                <div class="px-3 py-2 border-t border-white/10 flex items-center justify-between">
                  <span class="text-xs text-white/40">{{ r.platform }}</span>
                  <span class="text-xs font-medium" :style="{ color: cardStyleMap[r.id].color }">{{ r.resource_type }}</span>
                </div>
              </div>
            </div>

            <!-- Style: sketch -->
            <div
              v-else-if="cardStyleMap[r.id]?.style === 'sketch'"
              class="w-full h-72 cursor-pointer transition-all duration-300 sketch-card hover:scale-[1.03] overflow-hidden"
            >
              <div class="h-full flex flex-col overflow-hidden">
                <div class="px-3 py-2 flex items-center justify-between border-b-2 border-dashed border-gray-400">
                  <span class="px-2 py-0.5 text-xs font-semibold text-gray-600 border border-dashed border-gray-400 rounded">{{ r.category_name || r.platform }}</span>
                  <span class="text-xs text-gray-400 font-mono">#{{ String(r.id).padStart(3, '0') }}</span>
                </div>
                <div class="relative h-28 overflow-hidden px-3 py-2">
                  <img v-if="r.thumbnail" :src="r.thumbnail" :alt="r.title" class="w-full h-full object-cover rounded opacity-60" style="filter: grayscale(60%) contrast(120%)" />
                  <div v-else class="w-full h-full flex items-center justify-center border-2 border-dashed border-gray-300 rounded"><span class="text-3xl font-bold text-gray-400">{{ (r.title||'R').charAt(0) }}</span></div>
                </div>
                <div class="px-3 py-2"><h3 class="text-sm font-bold text-gray-700 line-clamp-1" style="font-family: 'Segoe Print', 'Comic Sans MS', cursive">{{ r.title }}</h3></div>
                <div class="px-3 py-1 flex-1"><p class="text-xs text-gray-500 line-clamp-2" style="font-family: 'Segoe Print', 'Comic Sans MS', cursive">{{ r.summary || 'No description' }}</p></div>
                <div class="px-3 py-2 border-t-2 border-dashed border-gray-400 flex items-center justify-between">
                  <span class="text-xs text-gray-500">{{ r.platform }}</span>
                  <span class="text-xs font-semibold text-gray-600">{{ r.resource_type }}</span>
                </div>
              </div>
            </div>

            <!-- Style: metallic -->
            <div
              v-else-if="cardStyleMap[r.id]?.style === 'metallic'"
              :class="['w-full h-72 rounded-lg cursor-pointer transition-all duration-300 hover:scale-105 overflow-hidden', `metallic-${cardStyleMap[r.id].variant}`]"
            >
              <div class="h-full flex flex-col overflow-hidden rounded-lg">
                <div class="px-3 py-2 flex items-center justify-between border-b border-white/10">
                  <span class="px-2 py-0.5 text-xs font-bold rounded uppercase tracking-wider" :style="metallicBadge(cardStyleMap[r.id].variant)">{{ r.category_name || r.platform }}</span>
                  <span class="text-xs" :style="{ color: metallicTextSub(cardStyleMap[r.id].variant) }">#{{ String(r.id).padStart(3, '0') }}</span>
                </div>
                <div class="relative h-28 overflow-hidden px-2 py-1">
                  <img v-if="r.thumbnail" :src="r.thumbnail" :alt="r.title" class="w-full h-full object-cover rounded opacity-85" />
                  <div v-else class="w-full h-full flex items-center justify-center"><div class="w-12 h-12 rounded-full flex items-center justify-center text-xl font-bold" :style="metallicIconStyle(cardStyleMap[r.id].variant)">{{ (r.title||'R').charAt(0) }}</div></div>
                </div>
                <div class="px-3 py-2"><h3 class="text-sm font-bold line-clamp-1" :style="{ color: metallicTextMain(cardStyleMap[r.id].variant) }">{{ r.title }}</h3></div>
                <div class="px-3 py-1 flex-1"><p class="text-xs line-clamp-2" :style="{ color: metallicTextSub(cardStyleMap[r.id].variant) }">{{ r.summary || 'No description' }}</p></div>
                <div class="px-3 py-2 border-t border-white/10 flex items-center justify-between">
                  <span class="text-xs" :style="{ color: metallicTextSub(cardStyleMap[r.id].variant) }">{{ r.platform }}</span>
                  <span class="text-xs font-bold" :style="{ color: metallicTextMain(cardStyleMap[r.id].variant) }">{{ r.resource_type }}</span>
                </div>
              </div>
            </div>

            <!-- Style: pixel -->
            <div
              v-else-if="cardStyleMap[r.id]?.style === 'pixel'"
              class="w-full h-72 cursor-pointer transition-all duration-200 pixel-card overflow-hidden"
              :style="{ borderColor: cardStyleMap[r.id].color }"
            >
              <div class="h-full flex flex-col overflow-hidden">
                <div class="px-3 py-2 flex items-center justify-between border-b-4" :style="{ borderColor: cardStyleMap[r.id].color }">
                  <span class="px-2 py-0.5 text-xs font-bold uppercase" :style="{ color: '#fff', background: cardStyleMap[r.id].color }">{{ r.category_name || r.platform }}</span>
                  <span class="text-xs font-mono font-bold" :style="{ color: cardStyleMap[r.id].color }">#{{ String(r.id).padStart(3, '0') }}</span>
                </div>
                <div class="relative h-28 overflow-hidden bg-[#1a1a2e] px-2 py-1">
                  <img v-if="r.thumbnail" :src="r.thumbnail" :alt="r.title" class="w-full h-full object-cover" style="image-rendering: pixelated; filter: contrast(130%) saturate(130%)" />
                  <div v-else class="w-full h-full flex items-center justify-center"><span class="text-4xl font-black pixel-bounce" :style="{ color: cardStyleMap[r.id].color, textShadow: `3px 3px 0 ${cardStyleMap[r.id].color}40` }">{{ (r.title||'R').charAt(0) }}</span></div>
                </div>
                <div class="px-3 py-2 bg-[#1a1a2e]"><h3 class="text-sm font-bold text-white line-clamp-1" style="font-family: 'Press Start 2P', 'Courier New', monospace; font-size: 10px">{{ r.title }}</h3></div>
                <div class="px-3 py-1 flex-1 bg-[#1a1a2e]"><p class="text-xs text-gray-400 line-clamp-2 font-mono">{{ r.summary || 'No description' }}</p></div>
                <div class="px-3 py-2 bg-[#1a1a2e] border-t-4 flex items-center justify-between" :style="{ borderColor: cardStyleMap[r.id].color }">
                  <span class="text-xs font-mono text-gray-500">{{ r.platform }}</span>
                  <span class="text-xs font-bold" :style="{ color: cardStyleMap[r.id].color }">{{ r.resource_type }}</span>
                </div>
              </div>
            </div>

          </template>
        </div>
      </section>

    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { listMyResources, type DbResource } from '../api/resource'

// ─── Live data ───
const loading = ref(false)
const liveResources = ref<DbResource[]>([])

type CardStyleEntry = {
  style: string
  variant: string
  color: string
  bg: string
}

const cardStyleMap = ref<Record<number, CardStyleEntry>>({})

const allStyles: { style: string; variants: { variant: string; color: string; bg: string }[] }[] = [
  {
    style: 'tier',
    variants: [
      { variant: 'gold', color: '#ca8a04', bg: '' },
      { variant: 'diamond', color: '#0891b2', bg: '' },
      { variant: 'prismatic', color: '#7c3aed', bg: '' },
      { variant: 'obsidian', color: '#18181b', bg: '' },
      { variant: 'silver', color: '#71717a', bg: '' },
      { variant: 'bronze', color: '#d97706', bg: '' },
    ],
  },
  {
    style: 'gradient',
    variants: [
      { variant: 'emerald', color: '#10b981', bg: '' },
      { variant: 'sapphire', color: '#3b82f6', bg: '' },
      { variant: 'ruby', color: '#ef4444', bg: '' },
      { variant: 'amethyst', color: '#8b5cf6', bg: '' },
      { variant: 'gold', color: '#eab308', bg: '' },
    ],
  },
  {
    style: 'glass',
    variants: [
      { variant: 'purple', color: '', bg: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)' },
      { variant: 'pink', color: '', bg: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)' },
      { variant: 'blue', color: '', bg: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)' },
      { variant: 'teal', color: '', bg: 'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)' },
    ],
  },
  {
    style: 'neu',
    variants: [{ variant: 'default', color: '', bg: '' }],
  },
  {
    style: 'holo',
    variants: [{ variant: 'default', color: '', bg: '' }],
  },
  {
    style: 'neon',
    variants: [
      { variant: 'cyan', color: '#00FFFF', bg: '' },
      { variant: 'pink', color: '#FF006E', bg: '' },
      { variant: 'green', color: '#39FF14', bg: '' },
      { variant: 'purple', color: '#BF00FF', bg: '' },
      { variant: 'gold', color: '#FFD700', bg: '' },
    ],
  },
  {
    style: 'brutalist',
    variants: [
      { variant: 'red', color: '#FF0000', bg: '' },
      { variant: 'blue', color: '#0000FF', bg: '' },
      { variant: 'yellow', color: '#FFD700', bg: '' },
      { variant: 'green', color: '#00CC00', bg: '' },
    ],
  },
  {
    style: 'aurora',
    variants: [
      { variant: 'a', color: '', bg: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)' },
      { variant: 'b', color: '', bg: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)' },
      { variant: 'c', color: '', bg: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)' },
      { variant: 'd', color: '', bg: 'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)' },
      { variant: 'e', color: '', bg: 'linear-gradient(135deg, #fa709a 0%, #fee140 100%)' },
    ],
  },
  {
    style: 'retro',
    variants: [
      { variant: 'green', color: '#39FF14', bg: '' },
      { variant: 'amber', color: '#FFB000', bg: '' },
      { variant: 'cyan', color: '#00FFFF', bg: '' },
      { variant: 'red', color: '#FF3333', bg: '' },
      { variant: 'white', color: '#E0E0E0', bg: '' },
    ],
  },
  {
    style: 'watercolor',
    variants: [
      { variant: 'rose', color: '#e91e63', bg: '' },
      { variant: 'violet', color: '#9c27b0', bg: '' },
      { variant: 'ocean', color: '#2196f3', bg: '' },
      { variant: 'amber', color: '#ff9800', bg: '' },
      { variant: 'teal', color: '#009688', bg: '' },
    ],
  },
  {
    style: 'mesh',
    variants: [
      { variant: 'sunset', color: '#e879f9', bg: '' },
      { variant: 'forest', color: '#34d399', bg: '' },
      { variant: 'fire', color: '#f43f5e', bg: '' },
      { variant: 'arctic', color: '#67e8f9', bg: '' },
      { variant: 'candy', color: '#fb7185', bg: '' },
    ],
  },
  {
    style: 'sketch',
    variants: [{ variant: 'default', color: '', bg: '' }],
  },
  {
    style: 'metallic',
    variants: [
      { variant: 'steel', color: '#78909c', bg: '' },
      { variant: 'copper', color: '#b87333', bg: '' },
      { variant: 'titanium', color: '#607d8b', bg: '' },
      { variant: 'rose-gold', color: '#c47f7f', bg: '' },
      { variant: 'gunmetal', color: '#6b7b83', bg: '' },
    ],
  },
  {
    style: 'pixel',
    variants: [
      { variant: 'red', color: '#FF6B6B', bg: '' },
      { variant: 'teal', color: '#4ECDC4', bg: '' },
      { variant: 'yellow', color: '#FFE66D', bg: '' },
      { variant: 'purple', color: '#A78BFA', bg: '' },
      { variant: 'green', color: '#34D399', bg: '' },
    ],
  },
]

function assignRandomStyles(resources: DbResource[]) {
  const map: Record<number, CardStyleEntry> = {}
  for (const r of resources) {
    const styleGroup = allStyles[Math.floor(Math.random() * allStyles.length)]
    const variant = styleGroup.variants[Math.floor(Math.random() * styleGroup.variants.length)]
    map[r.id] = { style: styleGroup.style, ...variant }
  }
  cardStyleMap.value = map
}

function reshuffleStyles() {
  assignRandomStyles(liveResources.value)
}

onMounted(async () => {
  loading.value = true
  try {
    liveResources.value = await listMyResources()
    assignRandomStyles(liveResources.value)
  } catch { /* silent */ } finally {
    loading.value = false
  }
})

// ─── Demo card data ───
type DemoCard = {
  id: number
  title: string
  summary: string
  category: string
  platform: string
  type: string
  thumbnail: string
  weight?: string
  tier?: string
  accentColor?: string
}

const demoData: DemoCard[] = [
  { id: 1, title: 'Building LLMs from Scratch', summary: 'Complete guide on training large language models with PyTorch and custom datasets.', category: 'AI', platform: 'YouTube', type: 'video', thumbnail: '' },
  { id: 2, title: 'Vue 3 Composition API Deep Dive', summary: 'Master Vue 3 reactivity system, composables, and advanced patterns.', category: 'Frontend', platform: 'Medium', type: 'article', thumbnail: '' },
  { id: 3, title: 'FastAPI Production Architecture', summary: 'Building scalable REST APIs with async handlers, middleware, and dependency injection.', category: 'Backend', platform: 'GitHub', type: 'document', thumbnail: '' },
  { id: 4, title: 'Figma Auto Layout Masterclass', summary: 'Advanced responsive design with constraints, auto-layout, and component variants.', category: 'Design', platform: 'YouTube', type: 'video', thumbnail: '' },
  { id: 5, title: 'Tailwind CSS Component Patterns', summary: 'Reusable UI component patterns with Tailwind CSS utility-first approach.', category: 'UI', platform: 'Dev.to', type: 'article', thumbnail: '' },
  { id: 6, title: 'Docker & K8s for Developers', summary: 'Container orchestration, deployment strategies, and CI/CD pipelines.', category: 'Backend', platform: 'Substack', type: 'document', thumbnail: '' },
  { id: 7, title: 'Prompt Engineering Guide', summary: 'Systematic approaches to crafting effective prompts for GPT, Claude, and Gemini.', category: 'AI', platform: 'GitHub', type: 'document', thumbnail: '' },
  { id: 8, title: 'Three.js 3D Web Experiences', summary: 'Create immersive 3D web experiences with WebGL, shaders, and physics engines.', category: 'Frontend', platform: 'YouTube', type: 'video', thumbnail: '' },
]

// Section 1: Weight tiers
const tierCards = [
  { ...demoData[0], weight: 'soil' },
  { ...demoData[1], weight: 'iron' },
  { ...demoData[2], weight: 'bronze' },
  { ...demoData[3], weight: 'silver' },
  { ...demoData[4], weight: 'gold' },
  { ...demoData[5], weight: 'diamond' },
  { ...demoData[6], weight: 'prismatic' },
  { ...demoData[7], weight: 'obsidian' },
]

function tierClass(weight: string): string {
  const map: Record<string, string> = {
    soil: 'border border-stone-200 bg-stone-50',
    iron: 'border border-slate-300 bg-slate-50',
    bronze: 'border-2 border-amber-400 bg-amber-50',
    silver: 'border-2 border-zinc-300 bg-gradient-to-br from-zinc-50 to-zinc-100',
    gold: 'tier-gold',
    diamond: 'tier-diamond',
    prismatic: 'tier-prismatic',
    obsidian: 'tier-obsidian',
  }
  return map[weight] || 'border border-border bg-card'
}

function tierBadgeStyle(weight: string): Record<string, string> {
  const map: Record<string, Record<string, string>> = {
    soil: { backgroundColor: '#a8a29e20', color: '#78716c' },
    iron: { backgroundColor: '#64748b20', color: '#475569' },
    bronze: { backgroundColor: '#f59e0b20', color: '#d97706' },
    silver: { backgroundColor: '#a1a1aa20', color: '#71717a' },
    gold: { backgroundColor: '#eab30830', color: '#ca8a04' },
    diamond: { backgroundColor: '#06b6d420', color: '#0891b2' },
    prismatic: { background: 'linear-gradient(90deg, #ec489930, #8b5cf630)', color: '#7c3aed' },
    obsidian: { backgroundColor: '#18181b', color: '#a1a1aa' },
  }
  return map[weight] || {}
}

function tierAccent(weight: string): string {
  const map: Record<string, string> = {
    soil: '#78716c', iron: '#475569', bronze: '#d97706', silver: '#71717a',
    gold: '#ca8a04', diamond: '#0891b2', prismatic: '#7c3aed', obsidian: '#18181b',
  }
  return map[weight] || '#3b82f6'
}

// Section 2: Gradient border cards
const gradientCards = [
  { ...demoData[0], tier: 'emerald', accentColor: '#10b981' },
  { ...demoData[1], tier: 'sapphire', accentColor: '#3b82f6' },
  { ...demoData[2], tier: 'ruby', accentColor: '#ef4444' },
  { ...demoData[3], tier: 'amethyst', accentColor: '#8b5cf6' },
  { ...demoData[4], tier: 'gold', accentColor: '#eab308' },
]

// Section 3: Glass cards
const glassCards = demoData.slice(0, 5)

// Section 4: Neumorphism cards
const neuCards = demoData.slice(0, 4)

// Section 5: Holo cards
const holoCards = demoData.slice(0, 4)

// Section 6: Neon cards
const neonCards = demoData.slice(0, 5)
const neonColors = [
  { key: 'cyan', color: '#00FFFF' },
  { key: 'pink', color: '#FF006E' },
  { key: 'green', color: '#39FF14' },
  { key: 'purple', color: '#BF00FF' },
  { key: 'gold', color: '#FFD700' },
]

// Section 7: Brutalist cards
const brutalistCards = demoData.slice(0, 4)
const brutalistAccents = ['red', 'blue', 'yellow', 'green']
const brutalistColorMap: Record<string, string> = {
  red: '#FF0000', blue: '#0000FF', yellow: '#FFD700', green: '#00CC00',
}

// Section 8: Aurora cards
const auroraCards = demoData.slice(0, 5)
const auroraGradients = [
  'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
  'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)',
  'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)',
  'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)',
  'linear-gradient(135deg, #fa709a 0%, #fee140 100%)',
]

// Section 9: Retro Terminal
const retroCards = demoData.slice(0, 5)
const retroAccents = ['green', 'amber', 'cyan', 'red', 'white']
const retroColorMap: Record<string, string> = {
  green: '#39FF14', amber: '#FFB000', cyan: '#00FFFF', red: '#FF3333', white: '#E0E0E0',
}

// Section 10: Watercolor
const watercolorCards = demoData.slice(0, 5)
const watercolorBgs = [
  'linear-gradient(160deg, #fce4ec88 0%, #f3e5f588 30%, #e8eaf688 70%, #e0f7fa88 100%)',
  'linear-gradient(160deg, #fff3e088 0%, #fce4ec88 30%, #f3e5f588 70%, #e8eaf688 100%)',
  'linear-gradient(160deg, #e8f5e988 0%, #e0f2f188 30%, #e3f2fd88 70%, #ede7f688 100%)',
  'linear-gradient(160deg, #fff8e188 0%, #ffecb388 30%, #ffe0b288 70%, #ffccbc88 100%)',
  'linear-gradient(160deg, #e1f5fe88 0%, #b3e5fc88 30%, #b2dfdb88 70%, #c8e6c988 100%)',
]
const watercolorDotBgs = [
  'rgba(233,30,99,0.4)', 'rgba(156,39,176,0.4)', 'rgba(33,150,243,0.35)', 'rgba(255,152,0,0.4)', 'rgba(0,150,136,0.4)',
]

// Section 11: Mesh Gradient
const meshCards = demoData.slice(0, 5)
const meshGradients = [
  'radial-gradient(at 20% 30%, #e879f9 0%, transparent 50%), radial-gradient(at 80% 20%, #38bdf8 0%, transparent 50%), radial-gradient(at 50% 80%, #fb923c 0%, transparent 50%), #1e1b4b',
  'radial-gradient(at 30% 20%, #34d399 0%, transparent 50%), radial-gradient(at 70% 70%, #818cf8 0%, transparent 50%), radial-gradient(at 10% 80%, #f472b6 0%, transparent 50%), #0f172a',
  'radial-gradient(at 80% 30%, #facc15 0%, transparent 50%), radial-gradient(at 20% 70%, #f43f5e 0%, transparent 50%), radial-gradient(at 60% 90%, #a78bfa 0%, transparent 50%), #18181b',
  'radial-gradient(at 40% 10%, #67e8f9 0%, transparent 50%), radial-gradient(at 70% 60%, #c084fc 0%, transparent 50%), radial-gradient(at 20% 90%, #4ade80 0%, transparent 50%), #0c0a09',
  'radial-gradient(at 60% 20%, #fb7185 0%, transparent 50%), radial-gradient(at 30% 80%, #60a5fa 0%, transparent 50%), radial-gradient(at 80% 70%, #fbbf24 0%, transparent 50%), #1c1917',
]

// Section 12: Sketch
const sketchCards = demoData.slice(0, 5)

// Section 13: Metallic
const metallicCards = demoData.slice(0, 5)
const metallicTypes = ['steel', 'copper', 'titanium', 'rose-gold', 'gunmetal']

function metallicBadge(type: string): Record<string, string> {
  const m: Record<string, Record<string, string>> = {
    steel: { backgroundColor: '#b0bec530', color: '#78909c' },
    copper: { backgroundColor: '#d4845630', color: '#b87333' },
    titanium: { backgroundColor: '#b0bec520', color: '#607d8b' },
    'rose-gold': { backgroundColor: '#e8b4b830', color: '#c47f7f' },
    gunmetal: { backgroundColor: '#45505520', color: '#6b7b83' },
  }
  return m[type] || {}
}
function metallicTextMain(type: string): string {
  const m: Record<string, string> = { steel: '#e0e0e0', copper: '#f5d5b8', titanium: '#cfd8dc', 'rose-gold': '#f5d5d5', gunmetal: '#c0c8cc' }
  return m[type] || '#e0e0e0'
}
function metallicTextSub(type: string): string {
  const m: Record<string, string> = { steel: '#90a4ae', copper: '#b87333aa', titanium: '#78909c', 'rose-gold': '#c47f7faa', gunmetal: '#78909c' }
  return m[type] || '#90a4ae'
}
function metallicIconStyle(type: string): Record<string, string> {
  const m: Record<string, Record<string, string>> = {
    steel: { background: 'linear-gradient(180deg, #cfd8dc, #78909c)', color: '#263238' },
    copper: { background: 'linear-gradient(180deg, #e8b88a, #b87333)', color: '#3e2723' },
    titanium: { background: 'linear-gradient(180deg, #b0bec5, #546e7a)', color: '#eceff1' },
    'rose-gold': { background: 'linear-gradient(180deg, #f5d5d5, #c47f7f)', color: '#3e2723' },
    gunmetal: { background: 'linear-gradient(180deg, #78909c, #37474f)', color: '#eceff1' },
  }
  return m[type] || {}
}

// Section 14: Pixel Art
const pixelCards = demoData.slice(0, 5)
const pixelPalette = ['#FF6B6B', '#4ECDC4', '#FFE66D', '#A78BFA', '#34D399']
</script>

<style scoped>
/* ═══ Card hover tilt animation ═══ */
.card-hover:hover {
  animation: card-tilt-up 0.4s ease forwards;
}
@keyframes card-tilt-up {
  0%   { transform: rotate(0deg) scale(1); }
  30%  { transform: rotate(-4deg) scale(1.06); }
  100% { transform: rotate(0deg) scale(1.08); }
}

/* ═══ Tier: Gold — animated gradient border ═══ */
.tier-gold {
  background: linear-gradient(135deg, #fef3c7, #fef9c3, #fef3c7);
  border: 2px solid transparent;
  background-clip: padding-box;
  position: relative;
}
.tier-gold::before {
  content: '';
  position: absolute;
  inset: -2px;
  border-radius: inherit;
  background: linear-gradient(45deg, #FFD700, #FFF8DC, #DAA520, #FFD700);
  background-size: 300% 300%;
  animation: gold-shimmer 3s ease infinite;
  z-index: -1;
}
@keyframes gold-shimmer {
  0%, 100% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
}

/* ═══ Tier: Diamond — ice blue glow ═══ */
.tier-diamond {
  background: linear-gradient(135deg, #ecfeff, #f0f9ff, #ecfeff);
  border: 2px solid transparent;
  position: relative;
  box-shadow: 0 0 15px rgba(6, 182, 212, 0.15), 0 0 30px rgba(6, 182, 212, 0.08);
}
.tier-diamond::before {
  content: '';
  position: absolute;
  inset: -2px;
  border-radius: inherit;
  background: linear-gradient(45deg, #67e8f9, #a5f3fc, #22d3ee, #06b6d4, #67e8f9);
  background-size: 400% 400%;
  animation: diamond-pulse 4s ease infinite;
  z-index: -1;
}
@keyframes diamond-pulse {
  0%, 100% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
}

/* ═══ Tier: Prismatic — rainbow shifting border ═══ */
.tier-prismatic {
  background: linear-gradient(135deg, #faf5ff, #fdf2f8, #eff6ff, #faf5ff);
  border: 2px solid transparent;
  position: relative;
}
.tier-prismatic::before {
  content: '';
  position: absolute;
  inset: -2px;
  border-radius: inherit;
  background: conic-gradient(
    from 0deg, #ef4444, #f97316, #eab308, #22c55e, #06b6d4, #3b82f6, #8b5cf6, #ec4899, #ef4444
  );
  background-size: 100% 100%;
  animation: prismatic-spin 6s linear infinite;
  z-index: -1;
}
@keyframes prismatic-spin {
  from { filter: hue-rotate(0deg); }
  to   { filter: hue-rotate(360deg); }
}

/* ═══ Tier: Obsidian — dark void with subtle ember glow ═══ */
.tier-obsidian {
  background: linear-gradient(135deg, #18181b, #27272a, #18181b);
  border: 2px solid #3f3f46;
  position: relative;
  box-shadow: 0 0 20px rgba(0, 0, 0, 0.4), inset 0 1px 0 rgba(255, 255, 255, 0.05);
}
.tier-obsidian .text-foreground,
.tier-obsidian h3 {
  color: #e4e4e7 !important;
}
.tier-obsidian .text-muted-foreground {
  color: #a1a1aa !important;
}
.tier-obsidian .bg-white {
  background: #27272a !important;
}
.tier-obsidian .bg-muted\/30 {
  background: rgba(39, 39, 42, 0.5) !important;
}
.tier-obsidian .border-border\/50 {
  border-color: rgba(63, 63, 70, 0.5) !important;
}
.tier-obsidian::after {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: inherit;
  background: radial-gradient(ellipse at 30% 80%, rgba(239, 68, 68, 0.06) 0%, transparent 60%);
  pointer-events: none;
}

/* ═══ Gradient Border Cards ═══ */
.gradient-card { position: relative; }
.gradient-card::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: inherit;
  padding: 2px;
  background-size: 300% 300%;
  animation: gradient-border-flow 4s ease infinite;
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor;
  mask-composite: exclude;
}
.gradient-emerald::before { background: linear-gradient(45deg, #10b981, #34d399, #6ee7b7, #10b981); background-size: 300% 300%; animation: gradient-border-flow 4s ease infinite; }
.gradient-sapphire::before { background: linear-gradient(45deg, #2563eb, #3b82f6, #93c5fd, #2563eb); background-size: 300% 300%; animation: gradient-border-flow 4s ease infinite; }
.gradient-ruby::before { background: linear-gradient(45deg, #dc2626, #ef4444, #fca5a5, #dc2626); background-size: 300% 300%; animation: gradient-border-flow 4s ease infinite; }
.gradient-amethyst::before { background: linear-gradient(45deg, #7c3aed, #8b5cf6, #c4b5fd, #7c3aed); background-size: 300% 300%; animation: gradient-border-flow 4s ease infinite; }
.gradient-gold::before { background: linear-gradient(45deg, #ca8a04, #eab308, #fde68a, #ca8a04); background-size: 300% 300%; animation: gradient-border-flow 4s ease infinite; }
@keyframes gradient-border-flow {
  0%, 100% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
}
.gradient-card:hover { box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12); transform: translateY(-4px); }

/* ═══ Glass Card ═══ */
.glass-card {
  background: rgba(255, 255, 255, 0.08);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border: 1px solid rgba(255, 255, 255, 0.15);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
}
.glass-card:hover {
  background: rgba(255, 255, 255, 0.12);
  border-color: rgba(255, 255, 255, 0.25);
}

/* ═══ Neumorphism Card ═══ */
.neu-card {
  background: #e8e8e8;
  box-shadow: 8px 8px 16px #c8c8c8, -8px -8px 16px #ffffff;
}
.neu-card:hover {
  box-shadow: 4px 4px 8px #c8c8c8, -4px -4px 8px #ffffff, inset 2px 2px 4px #c8c8c8, inset -2px -2px 4px #ffffff;
}

/* ═══ Holographic Card ═══ */
.holo-card {
  position: relative;
  overflow: hidden;
  border: 2px solid transparent;
  background-clip: padding-box;
}
.holo-card::before {
  content: '';
  position: absolute;
  inset: -2px;
  border-radius: inherit;
  background: linear-gradient(
    45deg,
    #ff000040, #ff880040, #ffff0040, #00ff0040, #00ffff40, #0000ff40, #ff00ff40, #ff000040
  );
  background-size: 400% 400%;
  animation: holo-shift 6s linear infinite;
  z-index: -1;
}
.holo-card::after {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: inherit;
  background: linear-gradient(
    120deg,
    transparent 30%,
    rgba(255, 255, 255, 0.4) 50%,
    transparent 70%
  );
  mix-blend-mode: overlay;
  pointer-events: none;
  z-index: 20;
  animation: holo-shine 4s ease-in-out infinite;
}
@keyframes holo-shift {
  0%   { background-position: 0% 50%; }
  100% { background-position: 400% 50%; }
}
@keyframes holo-shine {
  0%, 100% { opacity: 0.3; transform: translateX(-100%); }
  50%      { opacity: 0.6; transform: translateX(100%); }
}
.holo-badge {
  background: linear-gradient(90deg, #ec4899, #8b5cf6, #3b82f6, #06b6d4);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  font-weight: 700;
}

/* ═══ Neon Cards ═══ */
.neon-card-cyan {
  background: #0a0e27;
  border: 1px solid #00FFFF30;
  box-shadow: 0 0 10px #00FFFF10, inset 0 0 10px #00FFFF05;
}
.neon-card-cyan:hover { box-shadow: 0 0 20px #00FFFF25, 0 0 40px #00FFFF10; border-color: #00FFFF60; }

.neon-card-pink {
  background: #0a0e27;
  border: 1px solid #FF006E30;
  box-shadow: 0 0 10px #FF006E10, inset 0 0 10px #FF006E05;
}
.neon-card-pink:hover { box-shadow: 0 0 20px #FF006E25, 0 0 40px #FF006E10; border-color: #FF006E60; }

.neon-card-green {
  background: #0a0e27;
  border: 1px solid #39FF1430;
  box-shadow: 0 0 10px #39FF1410, inset 0 0 10px #39FF1405;
}
.neon-card-green:hover { box-shadow: 0 0 20px #39FF1425, 0 0 40px #39FF1410; border-color: #39FF1460; }

.neon-card-purple {
  background: #0a0e27;
  border: 1px solid #BF00FF30;
  box-shadow: 0 0 10px #BF00FF10, inset 0 0 10px #BF00FF05;
}
.neon-card-purple:hover { box-shadow: 0 0 20px #BF00FF25, 0 0 40px #BF00FF10; border-color: #BF00FF60; }

.neon-card-gold {
  background: #0a0e27;
  border: 1px solid #FFD70030;
  box-shadow: 0 0 10px #FFD70010, inset 0 0 10px #FFD70005;
}
.neon-card-gold:hover { box-shadow: 0 0 20px #FFD70025, 0 0 40px #FFD70010; border-color: #FFD70060; }

/* ═══ Brutalist Card ═══ */
.brutalist-card {
  transition: transform 0.15s ease, box-shadow 0.15s ease;
}
.brutalist-card:hover {
  transform: translate(-3px, -3px);
  box-shadow: 9px 9px 0px #000 !important;
}
.brutalist-card:active {
  transform: translate(0, 0);
  box-shadow: 3px 3px 0px #000 !important;
}

/* ═══ Aurora Card ═══ */
.aurora-card {
  position: relative;
}
.aurora-card::after {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: inherit;
  background: linear-gradient(
    120deg,
    transparent 20%,
    rgba(255, 255, 255, 0.15) 45%,
    transparent 65%
  );
  pointer-events: none;
  animation: aurora-wave 5s ease-in-out infinite;
}
@keyframes aurora-wave {
  0%, 100% { transform: translateX(-50%) rotate(-5deg); }
  50%      { transform: translateX(50%) rotate(5deg); }
}

/* ═══ Retro Terminal / CRT Card ═══ */
.retro-card {
  background: #0d0208;
  border: 1px solid;
  position: relative;
  overflow: hidden;
}
.retro-card::before {
  content: '';
  position: absolute;
  inset: 0;
  background: repeating-linear-gradient(
    0deg,
    transparent,
    transparent 2px,
    rgba(0, 0, 0, 0.15) 2px,
    rgba(0, 0, 0, 0.15) 4px
  );
  pointer-events: none;
  z-index: 1;
}
.retro-card::after {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(ellipse at center, transparent 50%, rgba(0, 0, 0, 0.5) 100%);
  pointer-events: none;
  z-index: 2;
}
.retro-green { border-color: #39FF1440; box-shadow: 0 0 8px #39FF1415, inset 0 0 30px #39FF1408; }
.retro-amber { border-color: #FFB00040; box-shadow: 0 0 8px #FFB00015, inset 0 0 30px #FFB00008; }
.retro-cyan  { border-color: #00FFFF40; box-shadow: 0 0 8px #00FFFF15, inset 0 0 30px #00FFFF08; }
.retro-red   { border-color: #FF333340; box-shadow: 0 0 8px #FF333315, inset 0 0 30px #FF333308; }
.retro-white { border-color: #E0E0E040; box-shadow: 0 0 8px #E0E0E015, inset 0 0 30px #E0E0E008; }
.retro-card:hover { transform: scale(1.04); }

.blink-cursor { animation: blink 1s step-end infinite; }
@keyframes blink {
  50% { opacity: 0; }
}

/* ═══ Watercolor / Ink Wash Card ═══ */
.watercolor-card {
  border: none;
  position: relative;
  box-shadow: 0 2px 20px rgba(0, 0, 0, 0.05);
}
.watercolor-card::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: inherit;
  background: radial-gradient(ellipse at 25% 25%, rgba(255,255,255,0.5) 0%, transparent 60%);
  pointer-events: none;
  z-index: 1;
}
.watercolor-card:hover {
  box-shadow: 0 6px 30px rgba(0, 0, 0, 0.1);
}

/* ═══ Mesh Gradient / Blob Card ═══ */
.mesh-card {
  position: relative;
  border: 1px solid rgba(255, 255, 255, 0.1);
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.3);
}
.mesh-card::after {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: inherit;
  background: linear-gradient(
    135deg,
    transparent 30%,
    rgba(255, 255, 255, 0.08) 50%,
    transparent 70%
  );
  pointer-events: none;
  animation: mesh-shimmer 4s ease-in-out infinite;
}
@keyframes mesh-shimmer {
  0%, 100% { opacity: 0.3; }
  50%      { opacity: 0.8; }
}
.mesh-card:hover {
  box-shadow: 0 8px 40px rgba(0, 0, 0, 0.4);
  border-color: rgba(255, 255, 255, 0.2);
}

/* ═══ Sketch / Wireframe Card ═══ */
.sketch-card {
  background: #fefefe;
  border: 2px solid #d1d5db;
  position: relative;
  box-shadow: 2px 2px 0 #e5e7eb;
}
.sketch-card::before {
  content: '';
  position: absolute;
  inset: 0;
  background:
    repeating-linear-gradient(
      0deg,
      transparent,
      transparent 23px,
      #e5e7eb40 23px,
      #e5e7eb40 24px
    );
  pointer-events: none;
  z-index: 0;
}
.sketch-card:hover {
  box-shadow: 4px 4px 0 #d1d5db;
  border-color: #9ca3af;
}

/* ═══ Metallic / Brushed Cards ═══ */
.metallic-steel {
  background: linear-gradient(145deg, #37474f, #546e7a, #455a64, #37474f);
  border: 1px solid #607d8b40;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3), inset 0 1px 0 rgba(255, 255, 255, 0.1);
}
.metallic-copper {
  background: linear-gradient(145deg, #5d4037, #795548, #6d4c41, #5d4037);
  border: 1px solid #b8733340;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3), inset 0 1px 0 rgba(255, 255, 255, 0.08);
}
.metallic-titanium {
  background: linear-gradient(145deg, #455a64, #607d8b, #546e7a, #455a64);
  border: 1px solid #78909c40;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.25), inset 0 1px 0 rgba(255, 255, 255, 0.12);
}
.metallic-rose-gold {
  background: linear-gradient(145deg, #5d4037, #6d4c41, #5d4037);
  border: 1px solid #c47f7f30;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3), inset 0 1px 0 rgba(255, 200, 200, 0.1);
}
.metallic-gunmetal {
  background: linear-gradient(145deg, #263238, #37474f, #2c393f, #263238);
  border: 1px solid #45505530;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.4), inset 0 1px 0 rgba(255, 255, 255, 0.05);
}
[class^="metallic-"]:hover {
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.4), inset 0 1px 0 rgba(255, 255, 255, 0.15);
}

/* ═══ Pixel Art / 8-bit Card ═══ */
.pixel-card {
  background: #1a1a2e;
  border: 4px solid;
  image-rendering: pixelated;
  box-shadow: 4px 4px 0 rgba(0, 0, 0, 0.5);
}
.pixel-card:hover {
  transform: translate(-2px, -2px);
  box-shadow: 6px 6px 0 rgba(0, 0, 0, 0.5);
}
.pixel-card:active {
  transform: translate(0, 0);
  box-shadow: 2px 2px 0 rgba(0, 0, 0, 0.5);
}
.pixel-bounce {
  display: inline-block;
  animation: pixel-float 2s ease-in-out infinite;
}
@keyframes pixel-float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-6px); }
}
</style>
