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
    const response = await api<{ success: boolean; data: { token: string; user: any } }>('/register', {
      method: 'POST',
      body: form
    })
    
    auth.setToken(response.data.token)
    auth.setUser(response.data.user)
    
    navigateTo('/dashboard')
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
          <div :ref="el => regItems[0] = el">
            <UiInput
              v-model="form.name"
              id="register-name"
              type="text"
              :label="t('full_name')"
              placeholder="John Doe"
              :error="errors.name?.[0] || ''"
              size="lg"
              autocomplete="name"
            />
          </div>

          <div :ref="el => regItems[1] = el">
            <UiInput
              v-model="form.email"
              id="register-email"
              type="email"
              :label="t('email_address')"
              placeholder="email@example.com"
              :error="errors.email?.[0] || ''"
              size="lg"
              autocomplete="email"
            />
          </div>

          <div :ref="el => regItems[2] = el">
            <UiInput
              v-model="form.password"
              id="register-password"
              type="password"
              :label="t('password')"
              placeholder="••••••••"
              :error="errors.password?.[0] || ''"
              size="lg"
              autocomplete="new-password"
            />
          </div>

          <div :ref="el => regItems[3] = el">
            <UiInput
              v-model="form.password_confirmation"
              id="register-password-confirm"
              type="password"
              :label="t('confirm_password')"
              placeholder="••••••••"
              size="lg"
              autocomplete="new-password"
            />
          </div>

          <div :ref="el => regItems[4] = el" class="md:col-span-2 pt-6">
            <UiButton
              type="submit"
              :loading="loading"
              :disabled="loading"
              block
              size="lg"
            >
              <span class="text-lg">{{ loading ? t('creating_account') : t('register') }}</span>
            </UiButton>
          </div>

          <div class="md:col-span-2 text-center text-sm text-slate-500 dark:text-white/40 pt-4">
            {{ t('already_have_account') }} <NuxtLink to="/login" class="text-indigo-600 dark:text-white font-bold hover:underline transition-all">{{ t('sign_in') }}</NuxtLink>
          </div>
        </form>

        <div v-if="errors.server" class="mt-8">
          <UiAlert variant="danger" dismissible @close="errors.server = undefined">
            {{ errors.server[0] }}
          </UiAlert>
        </div>
      </div>
    </div>
  </div>
</template>
