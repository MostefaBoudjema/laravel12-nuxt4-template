import { defineStore } from 'pinia'

interface User {
  id: number
  name: string
  email: string
  roles: string[]
  permissions: string[]
}

export const useAuthStore = defineStore('auth', () => {
  const user = ref<User | null>(null)
  const token = useCookie('auth_token', {
    maxAge: 60 * 60 * 24 * 7, // 1 week
    sameSite: 'lax',
  })

  const isAuthenticated = computed(() => !!token.value && !!user.value)
  const isAdmin = computed(() => user.value?.roles.includes('admin') || false)
  const isManager = computed(() => user.value?.roles.includes('manager') || false)

  const hasPermission = (permission: string) => {
    if (isAdmin.value) return true
    return user.value?.permissions.includes(permission) || false
  }

  const hasRole = (role: string) => {
    return user.value?.roles.includes(role) || false
  }

  async function fetchUser() {
    if (!token.value) return

    try {
      const response = await $fetch<{ success: boolean; data: { user: User } }>('/me', {
        baseURL: useRuntimeConfig().public.apiBase,
        headers: {
          Authorization: `Bearer ${token.value}`
        }
      })
      user.value = response.data.user
    } catch (error) {
      token.value = null
      user.value = null
    }
  }

  function setToken(newToken: string) {
    token.value = newToken
  }

  function setUser(newUser: User) {
    user.value = newUser
  }

  async function logout() {
    if (token.value) {
      try {
        await $fetch('/logout', {
          method: 'POST',
          baseURL: useRuntimeConfig().public.apiBase,
          headers: {
            Authorization: `Bearer ${token.value}`
          }
        })
      } catch (e) {
        // Continue logout even if API fails
      }
    }
    token.value = null
    user.value = null
    navigateTo('/login')
  }

  return {
    user,
    token,
    isAuthenticated,
    isAdmin,
    isManager,
    fetchUser,
    setToken,
    setUser,
    logout,
    hasPermission,
    hasRole
  }
})
