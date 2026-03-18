<script setup lang="ts">
import { gsap } from 'gsap'
import { useAuthStore } from '~/stores/auth'

const { t } = useI18n()
const auth = useAuthStore()
const heroRef = ref()
const featuresRef = ref()

const features = [
  { 
    icon: 'shield-alt', 
    title: 'Enterprise Security', 
    desc: 'Spatie permissions, JWT auth, and role-based access control built in.',
    gradient: 'from-emerald-500 to-teal-500'
  },
  { 
    icon: 'zap', 
    title: 'Nitro Performance', 
    desc: 'Server-side rendering with Nuxt 4 and high-speed API with Laravel 12.',
    gradient: 'from-indigo-500 to-violet-500'
  },
  { 
    icon: 'layer-group', 
    title: 'Scalable UI', 
    desc: 'Premium components with GSAP animations and dark mode support.',
    gradient: 'from-purple-500 to-fuchsia-500'
  },
  { 
    icon: 'globe', 
    title: 'Global Ready', 
    desc: 'i18n support with multi-language and timezone handling out of the box.',
    gradient: 'from-orange-500 to-rose-500'
  }
]

const stats = [
  { value: '99.9%', label: 'Uptime SLA' },
  { value: '<100ms', label: 'API Latency' },
  { value: '50K+', label: 'Active Users' }
]

definePageMeta({
  layout: 'default',
  auth: false
})

onMounted(() => {
  // Hero animations
  const tl = gsap.timeline()
  
  tl.from('.badge-animate', {
    opacity: 0,
    y: 30,
    scale: 0.9,
    duration: 0.6,
    ease: 'power3.out'
  })
  .from('.title-animate', {
    opacity: 0,
    y: 80,
    duration: 1,
    ease: 'power4.out'
  }, '-=0.3')
  .from('.subtitle-animate', {
    opacity: 0,
    y: 40,
    duration: 0.8,
    ease: 'power3.out'
  }, '-=0.6')
  .from('.cta-animate', {
    opacity: 0,
    y: 30,
    stagger: 0.15,
    duration: 0.6,
    ease: 'back.out(1.7)'
  }, '-=0.4')
  .from('.stats-animate', {
    opacity: 0,
    y: 30,
    stagger: 0.1,
    duration: 0.5,
    ease: 'power2.out'
  }, '-=0.3')

  // Scroll-triggered feature animations
  gsap.from('.feature-card', {
    scrollTrigger: {
      trigger: featuresRef.value,
      start: 'top 80%',
      toggleActions: 'play none none reverse'
    },
    opacity: 0,
    y: 60,
    stagger: 0.15,
    duration: 0.8,
    ease: 'power3.out'
  })
})
</script>

<template>
  <div class="relative bg-slate-950 text-white overflow-x-hidden">
    <!-- Animated Background -->
    <div class="fixed inset-0 z-0 pointer-events-none">
      <!-- Gradient orbs -->
      <div class="absolute top-0 left-1/4 w-[800px] h-[800px] bg-indigo-600/20 rounded-full blur-[150px] animate-pulse"></div>
      <div class="absolute bottom-0 right-1/4 w-[600px] h-[600px] bg-purple-600/20 rounded-full blur-[120px] animate-pulse" style="animation-delay: 1s;"></div>
      <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[1000px] h-[1000px] bg-emerald-600/10 rounded-full blur-[200px]"></div>
      
      <!-- Grid pattern -->
      <div class="absolute inset-0 bg-[linear-gradient(rgba(255,255,255,0.02)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,0.02)_1px,transparent_1px)] bg-[size:100px_100px]"></div>
    </div>

    <!-- Hero Section - Full Screen -->
    <section ref="heroRef" class="relative z-10 min-h-screen flex flex-col justify-center items-center px-6 lg:px-12">
      <div class="max-w-6xl mx-auto text-center">
        <!-- Badge -->
        <div class="badge-animate inline-flex items-center gap-3 px-5 py-2.5 rounded-full bg-white/5 border border-white/10 backdrop-blur-sm mb-10">
          <span class="flex h-2.5 w-2.5 rounded-full bg-emerald-400 animate-pulse"></span>
          <span class="text-sm font-semibold text-white/80 tracking-wide">{{ t('new_v2_launch') || 'v2.0 Now Available' }}</span>
          <fa icon="sparkles" class="text-amber-400 text-sm" />
        </div>

        <!-- Main Title -->
        <h1 class="title-animate text-6xl sm:text-7xl lg:text-9xl font-black tracking-tighter mb-8 leading-[0.9]">
          <span class="block bg-gradient-to-r from-white via-indigo-200 to-white bg-clip-text text-transparent">
            Build Fast.
          </span>
          <span class="block mt-2">
            <span class="bg-gradient-to-r from-indigo-400 via-purple-400 to-pink-400 bg-clip-text text-transparent italic">
              Scale Forever.
            </span>
          </span>
        </h1>

        <!-- Subtitle -->
        <p class="subtitle-animate text-lg sm:text-xl lg:text-2xl text-white/60 max-w-3xl mx-auto mb-12 leading-relaxed font-light">
          {{ t('hero_description') || 'The ultimate SaaS starter kit powered by Laravel 12 and Nuxt 4. Launch your next big idea with enterprise-grade security and stunning design.' }}
        </p>

        <!-- CTA Buttons -->
        <div class="flex flex-col sm:flex-row justify-center items-center gap-4 mb-20">
          <UiButton
            :to="auth.isAuthenticated ? '/dashboard' : '/register'"
            variant="primary"
            size="lg"
            class="cta-animate !px-10 !py-5 !rounded-2xl !text-lg !bg-gradient-to-r !from-indigo-500 !to-purple-600 !border-0 !shadow-2xl !shadow-indigo-500/30 hover:!shadow-indigo-500/50 hover:!scale-105 !transition-all !duration-300"
          >
            {{ auth.isAuthenticated ? t('dashboard') : t('start_free_trial') || 'Get Started Free' }}
            <fa icon="arrow-right" class="ml-2" />
          </UiButton>
          <UiButton
            v-if="!auth.isAuthenticated"
            to="/login"
            variant="secondary"
            size="lg"
            class="cta-animate !px-10 !py-5 !rounded-2xl !text-lg !bg-white/5 !border-white/10 !text-white hover:!bg-white/10 !backdrop-blur-sm !transition-all !duration-300"
          >
            <fa icon="play" class="mr-2" />
            {{ t('view_demo') || 'Live Demo' }}
          </UiButton>
        </div>

        <!-- Stats -->
        <div class="flex flex-wrap justify-center gap-8 lg:gap-16">
          <div v-for="(stat, i) in stats" :key="i" class="stats-animate text-center">
            <div class="text-3xl lg:text-5xl font-black bg-gradient-to-r from-white to-white/60 bg-clip-text text-transparent">
              {{ stat.value }}
            </div>
            <div class="text-sm lg:text-base text-white/40 mt-1 font-medium">{{ stat.label }}</div>
          </div>
        </div>
      </div>

      <!-- Scroll indicator -->
      <div class="absolute bottom-8 left-1/2 -translate-x-1/2 flex flex-col items-center gap-2 text-white/30">
        <span class="text-xs uppercase tracking-widest">Scroll</span>
        <div class="w-6 h-10 rounded-full border-2 border-white/20 flex justify-center pt-2">
          <div class="w-1.5 h-1.5 rounded-full bg-white/60 animate-bounce"></div>
        </div>
      </div>
    </section>

    <!-- Features Section - Full Width -->
    <section ref="featuresRef" class="relative z-10 min-h-screen flex items-center py-24 px-6 lg:px-12">
      <div class="max-w-7xl mx-auto w-full">
        <div class="text-center mb-20">
          <h2 class="text-4xl lg:text-6xl font-black tracking-tight mb-6">
            Everything You Need
          </h2>
          <p class="text-xl text-white/50 max-w-2xl mx-auto">
            Production-ready features that let you focus on what matters most
          </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div 
            v-for="(feature, i) in features" 
            :key="i" 
            class="feature-card group relative p-8 rounded-3xl bg-white/5 border border-white/10 backdrop-blur-sm hover:bg-white/10 hover:border-white/20 transition-all duration-500 hover:-translate-y-2"
          >
            <!-- Gradient glow on hover -->
            <div :class="`absolute inset-0 rounded-3xl bg-gradient-to-br ${feature.gradient} opacity-0 group-hover:opacity-10 transition-opacity duration-500 blur-xl`"></div>
            
            <div class="relative">
              <div :class="`w-14 h-14 rounded-2xl flex items-center justify-center mb-6 bg-gradient-to-br ${feature.gradient} shadow-lg shadow-black/20`">
                <fa :icon="feature.icon" class="text-2xl text-white" />
              </div>
              <h3 class="text-xl font-bold mb-3 text-white">{{ feature.title }}</h3>
              <p class="text-white/50 leading-relaxed text-sm">{{ feature.desc }}</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Section - Full Screen -->
    <section class="relative z-10 min-h-[70vh] flex items-center justify-center px-6 lg:px-12">
      <div class="absolute inset-0 bg-gradient-to-b from-indigo-600/20 via-purple-600/20 to-transparent"></div>
      <div class="relative max-w-4xl mx-auto text-center">
        <h2 class="text-4xl lg:text-7xl font-black tracking-tight mb-6">
          Ready to <span class="bg-gradient-to-r from-indigo-400 to-purple-400 bg-clip-text text-transparent">Launch?</span>
        </h2>
        <p class="text-xl text-white/50 mb-10 max-w-2xl mx-auto">
          Join thousands of developers building the future with our SaaS framework
        </p>
        <UiButton
          :to="auth.isAuthenticated ? '/dashboard' : '/register'"
          variant="primary"
          size="lg"
          class="!px-12 !py-6 !rounded-2xl !text-xl !bg-white !text-slate-950 hover:!bg-white/90 !shadow-2xl !shadow-white/20 hover:!scale-105 !transition-all !duration-300"
        >
          {{ auth.isAuthenticated ? 'Go to Dashboard' : 'Start Building Now' }}
          <fa icon="rocket" class="ml-3" />
        </UiButton>
      </div>
    </section>

  </div>
</template>

<style scoped>
/* Smooth scroll behavior */
html {
  scroll-behavior: smooth;
}

/* Custom selection */
::selection {
  background: rgba(99, 102, 241, 0.3);
  color: white;
}

/* Animation keyframes for floating effect */
@keyframes float {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-20px);
  }
}
</style>
