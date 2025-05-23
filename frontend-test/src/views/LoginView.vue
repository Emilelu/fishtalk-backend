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

<script>
export default {
  name: 'LoginView',
  data() {
    return {
      phone: '',
      password: ''
    }
  },
  methods: {
    async login() {
      try {
        const response = await this.$axios.post('/api/user/login', {
          phone: this.phone,
          password: this.password
        })
        
        // 保存 token 到 localStorage
        localStorage.setItem('token', response.data.token)
        
        // 更新全局登录状态
        this.$root.isAuthenticated = true
        
        // 跳转到用户页面
        this.$router.push('/user')
      } catch (error) {
        // 改进错误处理逻辑
        const errorMessage = error.response?.data?.message || 
                           error.response?.data?.error || 
                           error.message || 
                           '登录失败，请稍后重试'
        alert('登录失败：' + errorMessage)
      }
    }
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