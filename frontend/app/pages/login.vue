<script setup lang="ts">
import { gsap } from 'gsap'
import { useAuthStore } from '~/stores/auth'

definePageMeta({
  layout: 'default',
  middleware: 'guest'
})

const { t } = useI18n()
const auth = useAuthStore()
const form = reactive({
  email: '',
  password: ''
})
const loading = ref(false)
const errors = ref<Record<string, string[]>>({})

// GSAP reveals
const loginBox = ref()
const loginTitle = ref()
const loginItems = ref([])

onMounted(() => {
  const tl = gsap.timeline()
  tl.from(loginBox.value, {
    opacity: 0,
    y: 30,
    duration: 0.5,
    ease: 'power3.out'
  })
  .from(loginTitle.value, {
    opacity: 0,
    x: -15,
    duration: 0.4
  }, "-=0.2")
  .from(loginItems.value, {
    opacity: 0,
    y: 10,
    stagger: 0.04,
    duration: 0.3
  }, "-=0.2")
})

const handleLogin = async () => {
  loading.value = true
  errors.value = {}
  
  try {
    const response = await $fetch<{ token: string, user: any }>('/login', {
      method: 'POST',
      baseURL: useRuntimeConfig().public.apiBase,
      body: form
    })
    
    auth.setToken(response.token)
    auth.setUser(response.user)
    
    // Animate out before navigating
    gsap.to(loginBox.value, {
      opacity: 0,
      scale: 0.95,
      y: -20,
      duration: 0.5,
      onComplete: () => navigateTo('/')
    })
  } catch (e: any) {
    if (e.response?._data?.errors) {
      errors.value = e.response._data.errors
    } else {
      errors.value = { server: [e.message || 'An unexpected error occurred'] }
    }
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="flex justify-center items-center py-10">
    <div ref="loginBox" class="w-full max-w-md p-8 md:p-10 rounded-[2.5rem] bg-white dark:bg-slate-800/50 backdrop-blur-xl border border-slate-200 dark:border-white/10 shadow-2xl relative overflow-hidden group transition-colors duration-300">
      <!-- Background decoration -->
      <div class="absolute -top-24 -right-24 w-48 h-48 bg-purple-500/10 blur-3xl rounded-full group-hover:bg-purple-500/20 transition-colors duration-500"></div>
      <div class="absolute -bottom-24 -left-24 w-48 h-48 bg-pink-500/10 blur-3xl rounded-full group-hover:bg-pink-500/20 transition-colors duration-500"></div>

      <div class="relative z-10">
        <div class="mb-10">
          <h2 ref="loginTitle" class="text-4xl font-bold mb-2 dark:text-white text-slate-800 transition-colors">{{ t('login') }}</h2>
          <p class="text-slate-500 dark:text-white/60">{{ t('login_subtitle') }}</p>
        </div>

        <form @submit.prevent="handleLogin" class="space-y-6">
          <div ref="el => loginItems[0] = el">
            <label class="block text-sm font-semibold mb-2 ml-1 text-slate-700 dark:text-white/80">{{ t('email_address') }}</label>
            <div class="relative">
              <fa icon="user" class="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 dark:text-white/30" />
              <input 
                v-model="form.email" 
                type="email" 
                placeholder="email@example.com" 
                class="w-full bg-slate-50 dark:bg-white/5 border border-slate-200 dark:border-white/10 rounded-2xl py-4 pl-12 pr-4 focus:ring-2 focus:ring-purple-500 outline-none transition-all placeholder:text-slate-400 dark:placeholder:text-white/20 dark:text-white text-slate-800"
                required
              />
            </div>
            <p v-if="errors.email" class="text-rose-400 text-xs mt-2 ml-1">{{ errors.email[0] }}</p>
          </div>

          <div ref="el => loginItems[1] = el">
            <label class="block text-sm font-semibold mb-2 ml-1 text-slate-700 dark:text-white/80">{{ t('password') }}</label>
            <div class="relative">
              <fa icon="lock" class="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 dark:text-white/30" />
              <input 
                v-model="form.password" 
                type="password" 
                placeholder="••••••••" 
                class="w-full bg-slate-50 dark:bg-white/5 border border-slate-200 dark:border-white/10 rounded-2xl py-4 pl-12 pr-4 focus:ring-2 focus:ring-purple-500 outline-none transition-all placeholder:text-slate-400 dark:placeholder:text-white/20 dark:text-white text-slate-800"
                required
              />
            </div>
            <p v-if="errors.password" class="text-rose-400 text-xs mt-2 ml-1">{{ errors.password[0] }}</p>
          </div>

          <div ref="el => loginItems[2] = el" class="pt-2">
            <button 
              type="submit" 
              :disabled="loading"
              class="w-full bg-indigo-600 dark:bg-white text-white dark:text-indigo-900 py-4 rounded-2xl font-bold hover:bg-indigo-700 dark:hover:bg-white/90 active:scale-95 transition-all duration-200 disabled:opacity-50 disabled:active:scale-100 flex items-center justify-center gap-2 shadow-lg shadow-indigo-600/20 dark:shadow-none"
            >
              <span v-if="loading" class="w-5 h-5 border-2 border-current border-t-transparent rounded-full animate-spin"></span>
              <span>{{ loading ? t('authenticating') : t('login') }}</span>
            </button>
          </div>

          <div ref="el => loginItems[3] = el" class="text-center text-sm text-slate-500 dark:text-white/40 pt-2">
            {{ t('dont_have_account') }} <NuxtLink to="/register" class="text-indigo-600 dark:text-white font-bold hover:underline transition-colors">{{ t('create_one') }}</NuxtLink>
          </div>
        </form>
        
        <div v-if="errors.server" class="mt-6 p-4 bg-rose-500/20 border border-rose-500/30 rounded-2xl text-rose-600 dark:text-rose-200 text-sm flex items-center gap-3">
          <fa icon="exclamation-triangle" />
          {{ errors.server[0] }}
        </div>
      </div>
    </div>
  </div>
</template>
