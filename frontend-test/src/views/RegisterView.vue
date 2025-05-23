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

<script>
export default {
  name: 'RegisterView',
  data() {
    return {
      username: '',
      password: '',
      confirmPassword: ''
    }
  },
  methods: {
    register() {
      // 实现注册逻辑
      this.$router.push('/login')
    }
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