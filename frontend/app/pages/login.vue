<script setup lang="ts">
import { gsap } from 'gsap'
import { useAuthStore } from '~/stores/auth'

definePageMeta({
  layout: 'default',
  middleware: 'guest'
})

const { t } = useI18n()
const auth = useAuthStore()
const api = useApi()
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
    const response = await api<{ success: boolean; data: { token: string; user: any } }>('/login', {
      method: 'POST',
      body: form
    })
    
    auth.setToken(response.data.token)
    auth.setUser(response.data.user)
    
    // Animate out before navigating
    gsap.to(loginBox.value, {
      opacity: 0,
      scale: 0.95,
      y: -20,
      duration: 0.5,
      onComplete: () => navigateTo('/dashboard')
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
          <div :ref="el => loginItems[0] = el">
            <UiInput
              v-model="form.email"
              id="login-email"
              type="email"
              :label="t('email_address')"
              placeholder="email@example.com"
              :error="errors.email?.[0] || ''"
              size="lg"
              autocomplete="email"
            >
              <template #left>
                <fa icon="user" />
              </template>
            </UiInput>
          </div>

          <div :ref="el => loginItems[1] = el">
            <UiInput
              v-model="form.password"
              id="login-password"
              type="password"
              :label="t('password')"
              placeholder="••••••••"
              :error="errors.password?.[0] || ''"
              size="lg"
              autocomplete="current-password"
            >
              <template #left>
                <fa icon="lock" />
              </template>
            </UiInput>
          </div>

          <div :ref="el => loginItems[2] = el" class="pt-2">
            <UiButton
              type="submit"
              :loading="loading"
              :disabled="loading"
              block
              size="lg"
            >
              {{ loading ? t('authenticating') : t('login') }}
            </UiButton>
          </div>

          <div :ref="el => loginItems[3] = el" class="text-center text-sm text-slate-500 dark:text-white/40 pt-2">
            {{ t('dont_have_account') }} <NuxtLink to="/register" class="text-indigo-600 dark:text-white font-bold hover:underline transition-colors">{{ t('create_one') }}</NuxtLink>
          </div>
        </form>
        
        <div v-if="errors.server" class="mt-6">
          <UiAlert variant="danger" :title="t('login')" dismissible @close="errors.server = undefined">
            {{ errors.server[0] }}
          </UiAlert>
        </div>
      </div>
    </div>
  </div>
</template>
