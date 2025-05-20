<template>
  <div class="user-container">
    <h1>用户管理</h1>
    
    <!-- 注册模块 -->
    <div class="section">
      <h2>用户注册</h2>
      <el-form :model="registerForm" label-width="80px">
        <el-form-item label="手机号">
          <el-input v-model="registerForm.phone" placeholder="请输入手机号"></el-input>
        </el-form-item>
        <el-form-item label="密码">
          <el-input v-model="registerForm.password" type="password" placeholder="请输入密码"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleRegister">注册</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 登录模块 -->
    <div class="section">
      <h2>用户登录</h2>
      <el-form :model="loginForm" label-width="80px">
        <el-form-item label="手机号">
          <el-input v-model="loginForm.phone" placeholder="请输入手机号"></el-input>
        </el-form-item>
        <el-form-item label="密码">
          <el-input v-model="loginForm.password" type="password" placeholder="请输入密码"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleLogin">登录</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 用户信息修改模块 -->
    <div class="section" v-if="isLogin">
      <h2>用户信息修改</h2>
      <el-tabs type="border-card">
        <el-tab-pane label="修改用户名">
          <el-form :model="usernameForm" label-width="100px">
            <el-form-item label="新用户名">
              <el-input v-model="usernameForm.newUsername" placeholder="请输入新用户名"></el-input>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="handleUpdateUsername">提交</el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>
        
        <el-tab-pane label="修改手机号">
          <el-form :model="phoneForm" label-width="100px">
            <el-form-item label="新手机号">
              <el-input v-model="phoneForm.newPhone" placeholder="请输入新手机号"></el-input>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="handleUpdatePhone">提交</el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>
        
        <el-tab-pane label="修改密码">
          <el-form :model="passwordForm" label-width="100px">
            <el-form-item label="原密码">
              <el-input v-model="passwordForm.oldPassword" type="password" placeholder="请输入原密码"></el-input>
            </el-form-item>
            <el-form-item label="新密码">
              <el-input v-model="passwordForm.newPassword" type="password" placeholder="请输入新密码"></el-input>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="handleUpdatePassword">提交</el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>
        
        <el-tab-pane label="重置密码">
          <el-form :model="resetPasswordForm" label-width="100px">
            <el-form-item label="手机号">
              <el-input v-model="resetPasswordForm.phone" placeholder="请输入手机号"></el-input>
            </el-form-item>
            <el-form-item label="新密码">
              <el-input v-model="resetPasswordForm.newPassword" type="password" placeholder="请输入新密码"></el-input>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="handleResetPassword">提交</el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { 
  register, 
  login, 
  updateUsername as apiUpdateUsername, 
  updatePhone as apiUpdatePhone, 
  updatePassword as apiUpdatePassword, 
  resetPassword as apiResetPassword 
} from '@/api/user'

const userStore = useUserStore()
const isLogin = computed(() => userStore.isLogin)

// 注册表单
const registerForm = ref({
  phone: '',
  password: ''
})

// 登录表单
const loginForm = ref({
  phone: '',
  password: ''
})

// 修改用户名表单
const usernameForm = ref({
  newUsername: ''
})

// 修改手机号表单
const phoneForm = ref({
  newPhone: ''
})

// 修改密码表单
const passwordForm = ref({
  oldPassword: '',
  newPassword: ''
})

// 重置密码表单
const resetPasswordForm = ref({
  phone: '',
  newPassword: ''
})

// 处理注册
const handleRegister = async () => {
  try {
    const res = await register(registerForm.value)
    ElMessage.success('注册成功')
  } catch (error) {
    ElMessage.error(error.message)
  }
}

// 处理登录
const handleLogin = async () => {
  try {
    const res = await login(loginForm.value)
    userStore.setUser(res.data.user)
    userStore.setToken(res.data.token)
    ElMessage.success('登录成功')
  } catch (error) {
    ElMessage.error(error.message)
  }
}

// 更新用户名
const handleUpdateUsername = async () => {
  try {
    await apiUpdateUsername(usernameForm.value)
    ElMessage.success('用户名修改成功')
  } catch (error) {
    ElMessage.error(error.message)
  }
}

// 更新手机号
const handleUpdatePhone = async () => {
  try {
    await apiUpdatePhone(phoneForm.value)
    ElMessage.success('手机号修改成功')
  } catch (error) {
    ElMessage.error(error.message)
  }
}

// 更新密码
const handleUpdatePassword = async () => {
  try {
    await apiUpdatePassword(passwordForm.value)
    ElMessage.success('密码修改成功')
  } catch (error) {
    ElMessage.error(error.message)
  }
}

// 重置密码
const handleResetPassword = async () => {
  try {
    await apiResetPassword(resetPasswordForm.value)
    ElMessage.success('密码重置成功')
  } catch (error) {
    ElMessage.error(error.message)
  }
}
</script>

<style scoped>
.user-container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
}

.section {
  margin-bottom: 40px;
  padding: 20px;
  border: 1px solid #ebeef5;
  border-radius: 4px;
}
</style> 