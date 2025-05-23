<template>
  <div class="settings-view">
    <router-view>
      <h2>设置</h2>

      <!-- 修改密码 -->
      <section class="setting-section">
        <h3>修改密码</h3>
        <form @submit.prevent="updatePassword">
          <input
            type="password"
            v-model="passwordForm.oldPassword"
            placeholder="旧密码"
            required
          />
          <input
            type="password"
            v-model="passwordForm.newPassword"
            placeholder="新密码"
            required
          />
          <button type="submit">修改密码</button>
        </form>
      </section>

      <!-- 重置密码 -->
      <section class="setting-section">
        <h3>重置密码</h3>
        <form @submit.prevent="resetPassword">
          <input
            type="email"
            v-model="resetPasswordForm.email"
            placeholder="注册邮箱"
            required
          />
          <button type="submit">发送重置链接</button>
        </form>
      </section>

      <!-- 修改手机号 -->
      <section class="setting-section">
        <h3>修改手机号</h3>
        <form @submit.prevent="updatePhone">
          <input
            type="tel"
            v-model="phoneForm.newPhone"
            placeholder="新手机号"
            required
          />
          <button type="submit">更新手机号</button>
        </form>
      </section>

      <!-- 修改用户名 -->
      <section class="setting-section">
        <h3>修改用户名</h3>
        <form @submit.prevent="updateUsername">
          <input
            type="text"
            v-model="usernameForm.newUsername"
            placeholder="新用户名"
            required
          />
          <button type="submit">更新用户名</button>
        </form>
      </section></router-view
    >
  </div>
</template>

<script>
export default {
  name: "SettingsView",
  data() {
    return {
      passwordForm: {
        oldPassword: "",
        newPassword: "",
      },
      resetPasswordForm: {
        email: "",
      },
      phoneForm: {
        newPhone: "",
      },
      usernameForm: {
        newUsername: "",
      },
    };
  },
  methods: {
    async updatePassword() {
      try {
        const response = await this.$axios.post(
          "/api/user/updatePassword",
          this.passwordForm
        );
        alert("密码修改成功");
        this.passwordForm = { oldPassword: "", newPassword: "" };
      } catch (error) {
        alert(
          "密码修改失败：" + error.response?.data?.message || error.message
        );
      }
    },
    async resetPassword() {
      try {
        const response = await this.$axios.post(
          "/api/user/resetPassword",
          this.resetPasswordForm
        );
        alert("重置密码链接已发送到您的邮箱");
        this.resetPasswordForm = { email: "" };
      } catch (error) {
        alert(
          "发送重置链接失败：" + error.response?.data?.message || error.message
        );
      }
    },
    async updatePhone() {
      try {
        const response = await this.$axios.post(
          "/api/user/updatePhone",
          this.phoneForm
        );
        alert("手机号更新成功");
        this.phoneForm = { newPhone: "" };
      } catch (error) {
        alert(
          "手机号更新失败：" + error.response?.data?.message || error.message
        );
      }
    },
    async updateUsername() {
      try {
        const response = await this.$axios.post(
          "/api/user/updateUsername",
          this.usernameForm
        );
        alert("用户名更新成功");
        this.usernameForm = { newUsername: "" };
      } catch (error) {
        alert(
          "用户名更新失败：" + error.response?.data?.message || error.message
        );
      }
    },
  },
};
</script>

<style scoped>
.settings-view {
  max-width: 600px;
  margin: 0 auto;
  padding: 2rem;
}

.setting-section {
  margin-bottom: 2rem;
  padding: 1rem;
  border: 1px solid #eee;
  border-radius: 4px;
}

h3 {
  margin-bottom: 1rem;
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
