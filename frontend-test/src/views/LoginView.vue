<template>
  <div class="login-view">
    <h2>登录</h2>
    <form @submit.prevent="login">
      <input type="text" v-model="phone" placeholder="Phone" required>
      <input type="password" v-model="password" placeholder="密码" required>
      <button type="submit">登录</button>
    </form>
  </div>
</template>

<script setup>
import { ref, getCurrentInstance } from 'vue'
import { useRouter } from 'vue-router'

const phone = ref('')
const password = ref('')
const router = useRouter()
const instance = getCurrentInstance() // 获取当前组件实例

const login = async () => {
  try {
    const response = await instance.proxy.$axios.post('/api/user/login', {
      phone: phone.value,
      password: password.value
    })
    
    // 保存 token 到 localStorage
    localStorage.setItem('token', response.data.token)
    
    // 更新全局登录状态
    instance.proxy.$root.isAuthenticated = true // 通过 instance.proxy 访问 $root
    
    // 跳转到用户页面
    router.push('/user')
  } catch (error) {
    const errorMessage = error.response?.data?.message || 
                       error.response?.data?.error || 
                       error.message || 
                       '登录失败，请稍后重试'
    alert('登录失败：' + errorMessage)
  }
}
</script>

<style scoped>
.login-view {
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