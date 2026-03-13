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
  name: '',
  email: '',
  password: '',
  password_confirmation: ''
})
const loading = ref(false)
const errors = ref<Record<string, string[]>>({})

const regBox = ref()
const regItems = ref([])

onMounted(() => {
  gsap.from(regBox.value, {
    opacity: 0,
    scale: 0.95,
    duration: 0.5,
    ease: 'power2.out'
  })
  
  gsap.from(regItems.value, {
    opacity: 0,
    x: 20,
    stagger: 0.04,
    duration: 0.4,
    delay: 0.1
  })
})

const handleRegister = async () => {
  loading.value = true
  errors.value = {}
  
  try {
    const response = await $fetch<{ token: string, user: any }>('/register', {
      method: 'POST',
      baseURL: useRuntimeConfig().public.apiBase,
      body: form
    })
    
    auth.setToken(response.token)
    auth.setUser(response.user)
    
    navigateTo('/')
  } catch (e: any) {
    if (e.response?._data?.errors) {
      errors.value = e.response._data.errors
    } else {
      errors.value = { server: [e.message || 'Registration failed'] }
    }
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="flex justify-center items-center py-10 px-4">
    <div ref="regBox" class="w-full max-w-2xl p-8 md:p-12 rounded-[2.5rem] dark:bg-slate-800/50 bg-white dark:text-white text-slate-900 shadow-2xl relative overflow-hidden transition-colors border border-slate-200 dark:border-white/10">
      <!-- Decor -->
      <div class="absolute top-0 right-0 w-48 h-48 bg-indigo-500/5 dark:bg-indigo-500/10 rounded-bl-full -z-0"></div>
      
      <div class="relative z-10">
        <h2 class="text-3xl md:text-4xl font-bold mb-10 flex items-center gap-4">
          <span class="w-12 h-1.5 bg-gradient-to-r from-indigo-600 to-purple-600 rounded-full"></span>
          {{ t('register') }}
        </h2>

        <form @submit.prevent="handleRegister" class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-6">
          <div ref="el => regItems[0] = el">
            <label class="block text-sm font-semibold mb-2 ml-1 opacity-80">{{ t('full_name') }}</label>
            <input v-model="form.name" type="text" placeholder="John Doe" class="w-full bg-slate-50 dark:bg-white/5 border border-slate-200 dark:border-white/10 rounded-2xl py-4 px-5 focus:ring-2 focus:ring-indigo-500 outline-none transition-all dark:text-white" required />
            <p v-if="errors.name" class="text-rose-500 text-xs mt-2 ml-1">{{ errors.name[0] }}</p>
          </div>

          <div ref="el => regItems[1] = el">
            <label class="block text-sm font-semibold mb-2 ml-1 opacity-80">{{ t('email_address') }}</label>
            <input v-model="form.email" type="email" placeholder="email@example.com" class="w-full bg-slate-50 dark:bg-white/5 border border-slate-200 dark:border-white/10 rounded-2xl py-4 px-5 focus:ring-2 focus:ring-indigo-500 outline-none transition-all dark:text-white" required />
            <p v-if="errors.email" class="text-rose-500 text-xs mt-2 ml-1">{{ errors.email[0] }}</p>
          </div>

          <div ref="el => regItems[2] = el">
            <label class="block text-sm font-semibold mb-2 ml-1 opacity-80">{{ t('password') }}</label>
            <input v-model="form.password" type="password" placeholder="••••••••" class="w-full bg-slate-50 dark:bg-white/5 border border-slate-200 dark:border-white/10 rounded-2xl py-4 px-5 focus:ring-2 focus:ring-indigo-500 outline-none transition-all dark:text-white" required />
            <p v-if="errors.password" class="text-rose-500 text-xs mt-2 ml-1">{{ errors.password[0] }}</p>
          </div>

          <div ref="el => regItems[3] = el">
            <label class="block text-sm font-semibold mb-2 ml-1 opacity-80">{{ t('confirm_password') }}</label>
            <input v-model="form.password_confirmation" type="password" placeholder="••••••••" class="w-full bg-slate-50 dark:bg-white/5 border border-slate-200 dark:border-white/10 rounded-2xl py-4 px-5 focus:ring-2 focus:ring-indigo-500 outline-none transition-all dark:text-white" required />
          </div>

          <div ref="el => regItems[4] = el" class="md:col-span-2 pt-6">
            <button 
              type="submit" 
              :disabled="loading"
              class="w-full bg-indigo-600 hover:bg-indigo-700 text-white py-4 rounded-2xl font-bold active:scale-95 transition-all flex items-center justify-center gap-3 shadow-xl shadow-indigo-600/20"
            >
              <fa v-if="loading" icon="cog" class="animate-spin text-lg" />
              <span class="text-lg">{{ loading ? t('creating_account') : t('register') }}</span>
            </button>
          </div>

          <div class="md:col-span-2 text-center text-sm text-slate-500 dark:text-white/40 pt-4">
            {{ t('already_have_account') }} <NuxtLink to="/login" class="text-indigo-600 dark:text-white font-bold hover:underline transition-all">{{ t('sign_in') }}</NuxtLink>
          </div>
        </form>

        <div v-if="errors.server" class="mt-8 p-4 bg-rose-500/10 border border-rose-500/20 rounded-2xl text-rose-500 dark:text-rose-400 text-sm flex items-center gap-3">
          <fa icon="exclamation-triangle" />
          {{ errors.server[0] }}
        </div>
      </div>
    </div>
  </div>
</template>
