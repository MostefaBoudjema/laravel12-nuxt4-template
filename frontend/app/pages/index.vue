<script setup lang="ts">
import { gsap } from 'gsap'
import { useAuthStore } from '~/stores/auth'

definePageMeta({
  layout: 'dashboard',
  middleware: 'auth',
  title: 'dashboard' // This links to $t('dashboard') in layout
})

const { t } = useI18n()
const auth = useAuthStore()

// Staggered reveal for stats
const statsContainer = ref()
onMounted(() => {
  gsap.from('.stat-card', {
    opacity: 0,
    y: 20,
    stagger: 0.05,
    duration: 0.4,
    ease: 'power2.out',
    delay: 0.1
  })
})

const stats = [
  { label: 'total_revenue', value: '$45,230', icon: 'dashboard', trend: '+12.5%' },
  { label: 'active_users', value: '2,450', icon: 'users', trend: '+3.2%' },
  { label: 'monthly_sales', value: '842', icon: 'chart-bar', trend: '+8.1%' },
  { label: 'system_uptime', value: '99.9%', icon: 'cog', trend: '0%' }
]
</script>

<template>
  <div class="space-y-8 pb-10">
    <!-- Welcome Section -->
    <div class="bg-gradient-to-r from-indigo-600 to-purple-600 rounded-[2rem] p-8 md:p-12 text-white shadow-xl shadow-indigo-500/20 relative overflow-hidden">
      <div class="relative z-10 max-w-2xl">
        <h2 class="text-3xl md:text-4xl font-bold mb-4">{{ t('welcome_title', { name: auth.user?.name }) }}</h2>
        <p class="text-indigo-100 text-lg leading-relaxed mb-8 opacity-90">
          {{ t('welcome_subtitle') }}
        </p>
        <div class="flex flex-wrap gap-4">
          <button class="bg-white text-indigo-600 px-8 py-3.5 rounded-2xl font-bold hover:bg-slate-50 transition-all shadow-lg active:scale-95">{{ t('new_project') }}</button>
          <button class="bg-indigo-500/20 text-white border border-indigo-400/30 px-8 py-3.5 rounded-2xl font-bold hover:bg-indigo-500/30 transition-all active:scale-95">{{ t('documentation') }}</button>
        </div>
      </div>
      <!-- Background SVG Decor -->
      <div class="absolute right-0 top-0 h-full w-1/3 opacity-10 hidden lg:flex items-center justify-center p-8">
        <fa icon="dashboard" class="text-[200px]" />
      </div>
    </div>

    <!-- Stats Grid -->
    <div ref="statsContainer" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
      <div v-for="stat in stats" :key="stat.label" class="stat-card dark:bg-slate-800 bg-white p-8 rounded-[2rem] border border-slate-100 dark:border-white/10 shadow-sm hover:shadow-xl hover:-translate-y-1 transition-all duration-300">
        <div class="flex items-center justify-between mb-6">
          <div class="w-12 h-12 bg-indigo-500/10 rounded-2xl flex items-center justify-center text-indigo-600 dark:text-indigo-400">
            <fa :icon="stat.icon" class="text-xl" />
          </div>
          <span class="text-emerald-500 font-bold text-xs bg-emerald-500/10 px-3 py-1.5 rounded-xl">{{ stat.trend }}</span>
        </div>
        <p class="text-slate-500 dark:text-white/40 font-medium mb-1">
          {{ t(stat.label) }}
        </p>
        <h3 class="text-3xl font-bold dark:text-white text-slate-800 tracking-tight">
          {{ stat.value }}
        </h3>
      </div>
    </div>

    <!-- Activity Feed -->
    <div class="dark:bg-slate-800 bg-white rounded-[2rem] border border-slate-100 dark:border-white/10 shadow-sm p-8 md:p-10">
      <div class="flex items-center justify-between mb-8">
        <h3 class="text-xl font-bold dark:text-white text-slate-800 flex items-center gap-3">
          <fa icon="chart-bar" class="text-indigo-600" />
          {{ t('activity_feed') }}
        </h3>
        <button class="text-sm font-semibold text-indigo-600 hover:text-indigo-700 transition-colors">{{ t('view_all') }}</button>
      </div>
      
      <div class="space-y-4">
        <div v-for="j in 5" :key="j" class="flex items-center gap-5 p-5 hover:bg-slate-50 dark:hover:bg-white/5 rounded-2xl transition-all border border-transparent hover:border-slate-200 dark:hover:border-white/10">
          <div class="w-12 h-12 rounded-full dark:bg-white/10 bg-slate-100 flex items-center justify-center text-slate-400 dark:text-slate-500">
            <fa icon="user" class="text-lg" />
          </div>
          <div class="flex-1">
            <p class="font-bold dark:text-white text-slate-800">{{ t('action_performed') }}</p>
            <p class="text-xs text-slate-500 dark:text-white/40 mt-1">{{ t('hours_ago') }}</p>
          </div>
          <div class="hidden sm:block">
             <fa icon="check-circle" class="text-emerald-500 text-lg" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
