import { createRouter, createWebHistory } from 'vue-router'
import UserView from '@/views/UserView.vue'
import ProfileView from '@/views/ProfileView.vue'
import SettingsView from '@/views/SettingsView.vue'
import MessagesView from '@/views/MessagesView.vue'
import DashboardView from '@/views/DashboardView.vue'
import AnalyticsView from '@/views/AnalyticsView.vue'
import HistoryView from '@/views/HistoryView.vue'

const routes = [
  {
    path: '/',
    redirect: '/user'
  },
  {
    path: '/login',
    component: () => import('@/views/LoginView.vue')
  },
  {
    path: '/register',
    component: () => import('@/views/RegisterView.vue')
  },
  {
    path: '/user',
    component: UserView,
    meta: { requiresAuth: true },
    children: [
      { path: 'profile', component: ProfileView },
      { path: 'settings', component: SettingsView },
      { path: 'messages', component: MessagesView },
      { path: 'dashboard', component: DashboardView },
      { path: 'analytics', component: AnalyticsView },
      { path: 'history', component: HistoryView },
      { path: '', redirect: '/user/dashboard' }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

// 添加全局前置守卫
router.beforeEach((to, from, next) => {
  const isAuthenticated = !!localStorage.getItem('token')
  
  if (to.meta.requiresAuth && !isAuthenticated) {
    // 如果需要认证且未登录，跳转到登录页面
    next('/login')
  } else if ((to.path === '/login' || to.path === '/register') && isAuthenticated) {
    // 如果已登录但尝试访问登录或注册页面，跳转到用户页面
    next('/user')
  } else {
    // 其他情况正常导航
    next()
  }
})

export default router 