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
        <template v-if="$route.path.startsWith('/user/profile')">
          <router-link to="/user/profile/dashboard" class="sidebar-item">仪表盘</router-link>
          <router-link to="/user/profile/analytics" class="sidebar-item">分析</router-link>
        </template>
        <template v-else-if="$route.path.startsWith('/user/settings')">
          <router-link to="/user/settings" class="sidebar-item">设置</router-link>
          <router-link to="/user/settings/analytics" class="sidebar-item">分析</router-link>
        </template>
        <template v-else-if="$route.path.startsWith('/user/messages')">
          <router-link to="/user/messages/history" class="sidebar-item">历史记录</router-link>
        </template>
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

<script setup>
import { ref, onMounted, getCurrentInstance } from 'vue'
import { useRouter } from 'vue-router'

const isAuthenticated = ref(!!localStorage.getItem('token'))
const router = useRouter()
const instance = getCurrentInstance() // 获取当前组件实例

onMounted(() => {
  // 通过 instance.proxy 访问 $root
  instance.proxy.$root.$watch('isAuthenticated', (newVal) => {
    isAuthenticated.value = newVal
  })
})

const logout = () => {
  localStorage.removeItem('token')
  isAuthenticated.value = false
  instance.proxy.$root.isAuthenticated = false // 通过 instance.proxy 访问 $root
  router.push('/login')
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