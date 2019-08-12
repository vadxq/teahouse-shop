<template>
  <div class="content">
    <div class="user-info">
      <a-form-item label="账号">
        <a-input type="text" size="large" disabled="true" v-model="userInfo.uid">
          <a-icon slot="prefix" type="user" />
        </a-input>
      </a-form-item>
      <a-form-item label="权限">
        <a-input type="text" size="large" disabled="true" v-if="userInfo.role > 10" value="管理员">
          <a-icon slot="prefix" type="user" />
        </a-input>
        <a-input type="text" size="large" disabled="true" v-if="userInfo.role === 10" value="工作人员">
          <a-icon slot="prefix" type="user" />
        </a-input>
      </a-form-item>
      <a-form-item label="邮箱">
        <a-input type="text" size="large" placeholder="请输入邮箱" v-model="userInfo.email">
          <a-icon slot="prefix" type="mail" />
        </a-input>
        <a-alert v-if="signinMailRegex" message="邮箱不正确" banner />
      </a-form-item>
      <a-form-item label="用户名">
        <a-input type="text" size="large" placeholder="请输入用户名" v-model="userInfo.username">
          <a-icon slot="prefix" type="profile" />
        </a-input>
      </a-form-item>
      <a-form-item label="手机">
        <a-input type="text" size="large" placeholder="请输入手机号" v-model="userInfo.phone">
          <a-icon slot="prefix" type="phone" />
        </a-input>
        <a-alert v-if="signinPhoneRegex" message="手机号错误" banner />
      </a-form-item>
      <!-- <a-form-item label="收货地址">
        <a-input type="text" size="large" placeholder="请输入收货地址" >
          <a-icon slot="prefix" type="shop" />
        </a-input>
        <a-alert v-if="signinPhoneRegex" message="手机号错误" banner />
      </a-form-item> -->

      <a-form-item>
        <a-button
          :loading="logguping"
          style="width: 100%;margin-top: 10px"
          size="large"
          htmlType="submit"
          type="white"
          :disabled="signinDisabled"
          @click="changeInfo()"
        >修改</a-button>
      </a-form-item>
    </div>

    <div class="change-pass">
      <a-form-item label="原密码">
        <a-input size="large" type="password" placeholder="请输入原密码" v-model="oldPassword">
          <a-icon slot="prefix" type="lock" />
        </a-input>
        <a-alert v-if="oldPasswordRegex" message="密码只能为英文字母数字标点符号" banner />
      </a-form-item>
      <a-form-item label="新密码">
        <a-input size="large" type="password" placeholder="请输入新密码" v-model="newPassword">
          <a-icon slot="prefix" type="lock" />
        </a-input>
        <a-alert v-if="newPasswordRegex" message="密码只能为英文字母数字标点符号" banner />
        <a-alert v-if="allpassRegex" message="新密码不能与旧密码相同" banner />
      </a-form-item>
      <a-form-item label="验证密码">
        <a-input size="large" type="password" placeholder="请再次输入新密码" v-model="againPass">
          <a-icon slot="prefix" type="unlock" />
        </a-input>
        <a-alert v-if="againPassRegex" message="两次密码不正确" banner />
      </a-form-item>

      <a-form-item>
        <a-button
          :loading="logguping"
          style="width: 100%;margin-top: 10px"
          size="large"
          htmlType="submit"
          type="white"
          :disabled="passDisabled"
          @click="changePass()"
        >修改</a-button>
      </a-form-item>
    </div>
  </div>
</template>

<script>
export default {
  name: "profile",
  data() {
    return {
      oldPassword: '',
      newPassword: '',
      againPass: ''
    };
  },
  computed: {
    userInfo() {
      return this.$store.state.user
    },
    // 控制个人信息参数验证
    signinDisabled() {
      return this.signinMailRegex
        || this.signinPhoneRegex
        || this.userInfo.username === ''
        || this.userInfo.phone === ''
        || this.userInfo.email === ''
        || this.userInfo.username === ''
    },
    signinMailRegex() {
      return this.userInfo.email !== '' && !/^([\w-_]+(?:\.[\w-_]+)*)@((?:[a-z0-9]+(?:-[a-zA-Z0-9]+)*)+\.[a-z]{2,6})$/i.test(this.userInfo.email)
    },
    signinPhoneRegex() {
      return this.userInfo.phone !== '' && !/^[1]([3-9])[0-9]{9}$/.test(this.userInfo.phone)
    },
    // 控制密码修改控制参数
    passDisabled() {
      return this.oldPasswordRegex || this.againPassRegex || this.newPasswordRegex
        || this.oldPassword === ''
        || this.newPassword === ''
        || this.againPass === ''
    },
    oldPasswordRegex() {
      return this.oldPassword !== '' && /[\u4e00-\u9fa5]/.test(this.oldPassword)
    },
    newPasswordRegex() {
      return this.newPassword !== '' && /[\u4e00-\u9fa5]/.test(this.newPassword)
    },
    againPassRegex() {
      return this.againPass !== '' && this.againPass !== this.newPassword
    },
    allpassRegex() {
      return this.newPassword === this.oldPassword && this.newPassword !== '' && this.oldPassword !== ''
    }
  },
  methods: {
    async changeInfo() {
      this.logging = true;
      let res = await this.$http.put('/api/v1/user/info', {
        phone: this.userInfo.phone,
        username: this.userInfo.username,
        email: this.userInfo.email,
      });
      if (res.data.success) {
        this.$store.dispatch('user/getUserInfo');
        this.$message.success(res.data.message);
      } else {
        this.$message.error(res.data.message);
      }
      this.logging = false;
    },
    async changePass() {
      let res = await this.$http.post('/api/v1/user/pass', {
        oldPassword: this.oldPassword,
        newPassword: this.newPassword,
      });
      if (res.data.success) {
        localStorage.removeItem('token');
        this.$router.push('/login');
        this.$message.success(res.data.message);
      } else {
        this.$message.error(res.data.message);
      }
    },
  },
  mounted() {
  },
};
</script>

<style  scoped>
.content {
  display: flex;
  flex-direction: row;
}


.change-pass {
  width: 30%;
  margin: 0 0 0 40px;
}
.user-info {
  flex: 1;
}

@media screen and (max-width: 576px) {
  .login {
    width: 95%;
  }
}
@media screen and (max-width: 320px) {
  .captcha-button {
    font-size: 14px;
  }
}
.icon {
  font-size: 24px;
  color: rgba(0, 0, 0, 0.2);
  margin-left: 16px;
  vertical-align: middle;
  cursor: pointer;
  transition: color 0.3s;
}
.icon:hover {
  color: #1890ff;
}
.ant-form-item {
  margin-bottom: 0;
}

</style>