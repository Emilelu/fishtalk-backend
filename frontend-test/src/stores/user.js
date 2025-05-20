import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useUserStore = defineStore('user', () => {
  const user = ref(null)
  const token = ref(null)

  const isLogin = computed(() => !!token.value)

  function setUser(userData) {
    user.value = userData
  }

  function setToken(tokenData) {
    token.value = tokenData
  }

  function clearUser() {
    user.value = null
    token.value = null
  }

  return {
    user,
    token,
    isLogin,
    setUser,
    setToken,
    clearUser
  }
}) 