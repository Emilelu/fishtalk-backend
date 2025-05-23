<template>
  <div class="register-view">
    <h2>注册</h2>
    <form @submit.prevent="register">
      <input type="text" v-model="username" placeholder="用户名" required>
      <input type="password" v-model="password" placeholder="密码" required>
      <input type="password" v-model="confirmPassword" placeholder="确认密码" required>
      <button type="submit">注册</button>
    </form>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const username = ref('')
const password = ref('')
const confirmPassword = ref('')
const router = useRouter()

const register = async () => {
  try {
    const response = await $axios.post('/api/user/register', {
      username: username.value,
      password: password.value,
      confirmPassword: confirmPassword.value
    })
    router.push('/login')
  } catch (error) {
    alert('注册失败：' + error.response?.data?.message || error.message)
  }
}
</script>

<style scoped>
.register-view {
  max-width: 400px;
  margin: 0 auto;
  padding: 2rem;
}

form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

input {
  padding: 0.5rem;
  border: 1px solid #ccc;
  border-radius: 4px;
}

button {
  padding: 0.5rem;
  background-color: #2c3e50;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
</style> 