<template>
  <div class="user-container">
    <!-- 顶部导航栏 -->
    <nav class="top-nav">
      <router-link to="/login" class="nav-item" v-if="!isAuthenticated">登录</router-link>
      <router-link to="/register" class="nav-item" v-if="!isAuthenticated">注册</router-link>
      <template v-else>
        <router-link to="/user/profile" class="nav-item">个人资料</router-link>
        <router-link to="/user/settings" class="nav-item">设置</router-link>
        <router-link to="/user/messages" class="nav-item">消息</router-link>
        <button @click="logout" class="logout-button">退出</button>
      </template>
    </nav>

    <div class="main-content">
      <!-- 侧边栏 -->
      <aside class="sidebar">
        <router-link to="/user/dashboard" class="sidebar-item">仪表盘</router-link>
        <router-link to="/user/analytics" class="sidebar-item">分析</router-link>
        <router-link to="/user/history" class="sidebar-item">历史记录</router-link>
      </aside>

      <!-- 主内容区 -->
      <section class="content-area">
        <router-view v-slot="{ Component }">
          <transition name="fade" mode="out-in">
            <component :is="Component" v-if="Component" />
            <div v-else class="loading">加载中...</div>
          </transition>
        </router-view>
      </section>
    </div>
  </div>
</template>

<script>
export default {
  name: 'UserView',
  data() {
    return {
      isAuthenticated: !!localStorage.getItem('token') // 根据 token 判断登录状态
    }
  },
  created() {
    // 监听全局登录状态变化
    this.$root.$watch('isAuthenticated', (newVal) => {
      this.isAuthenticated = newVal
    })
  },
  methods: {
    logout() {
      localStorage.removeItem('token')
      this.isAuthenticated = false
      this.$root.isAuthenticated = false
      this.$router.push('/login')
    }
  }
}
</script>

<style>
/* 添加全局样式 */
html, body {
  margin: 0;
  padding: 0;
  height: 100%;
}

.user-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.top-nav {
  background-color: #2c3e50;
  padding: 1rem;
  display: flex;
  gap: 1rem;
  position: sticky;
  top: 0;
  z-index: 100;
}

.nav-item {
  color: white;
  text-decoration: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  transition: background-color 0.3s;
  margin-right: 0.5rem;
}

.nav-item:hover {
  background-color: #34495e;
}

.main-content {
  display: flex;
  flex: 1;
}

.sidebar {
  width: 200px;
  background-color: #34495e;
  padding: 1rem;
}

.sidebar-item {
  display: block;
  color: white;
  text-decoration: none;
  padding: 0.5rem;
  margin-bottom: 0.5rem;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.sidebar-item:hover {
  background-color: #2c3e50;
}

.content-area {
  flex: 1;
  padding: 2rem;
  background-color: #ecf0f1;
}

/* 添加过渡效果 */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.loading {
  padding: 20px;
  text-align: center;
  color: #666;
}

/* 修改退出按钮样式 */
.logout-button {
  background-color: #e74c3c;
  color: white;
  border: none;
  border-radius: 4px;
  padding: 0.5rem 1rem;
  cursor: pointer;
  transition: background-color 0.3s;
  margin-left: auto; /* 将退出按钮推到最右边 */
}

.logout-button:hover {
  background-color: #c0392b;
}
</style> 