import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import axios from './plugins/axios'

const app = createApp(App)

app.use(createPinia())
app.use(router)
app.use(ElementPlus)

app.config.globalProperties.$axios = axios

// 初始化全局登录状态
app.config.globalProperties.isAuthenticated = !!localStorage.getItem('token')

app.mount('#app') 