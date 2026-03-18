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
  gsap.from(statsContainer.value.querySelectorAll('.stat-card'), {
    opacity: 0,
    y: 20,
    stagger: 0.05,
    duration: 0.4,
    ease: 'power2.out',
    delay: 0.1,
    clearProps: 'all' // This removes the inline styles after animation finishes
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
          <UiButton variant="secondary" size="lg">
            {{ t('new_project') }}
          </UiButton>
          <UiButton variant="ghost" size="lg" class="!text-white !border-indigo-400/30 !bg-indigo-500/20 hover:!bg-indigo-500/30">
            {{ t('documentation') }}
          </UiButton>
        </div>
      </div>
      <!-- Background SVG Decor -->
      <div class="absolute right-0 top-0 h-full w-1/3 opacity-10 hidden lg:flex items-center justify-center p-8">
        <fa icon="dashboard" class="text-[200px]" />
      </div>
    </div>

    <!-- Stats Grid -->
    <div ref="statsContainer" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
      <UiCard v-for="stat in stats" :key="stat.label" class="stat-card hover:shadow-xl hover:-translate-y-1 transition-all duration-300 !p-8">
        <div class="flex items-center justify-between mb-6">
          <div class="w-12 h-12 bg-indigo-500/10 rounded-2xl flex items-center justify-center text-indigo-600 dark:text-indigo-400">
            <fa :icon="stat.icon" class="text-xl" />
          </div>
          <UiBadge variant="success" size="sm">{{ stat.trend }}</UiBadge>
        </div>
        <p class="text-slate-500 dark:text-white/40 font-medium mb-1">
          {{ t(stat.label) }}
        </p>
        <h3 class="text-3xl font-bold dark:text-white text-slate-800 tracking-tight">
          {{ stat.value }}
        </h3>
      </UiCard>
    </div>

    <!-- Activity Feed -->
    <UiCard class="!p-8 md:!p-10">
      <template #header>
        <div class="flex items-center justify-between">
          <h3 class="text-xl font-bold dark:text-white text-slate-800 flex items-center gap-3">
            <fa icon="chart-bar" class="text-indigo-600" />
            {{ t('activity_feed') }}
          </h3>
          <UiButton variant="ghost" size="sm">{{ t('view_all') }}</UiButton>
        </div>
      </template>

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
    </UiCard>
  </div>
</template>
