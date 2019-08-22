<template>
  <div class="container">
    <div class="content">
      <div class="top">
        <div class="header">
          <img
            style="width: 40px;margin-right: 20px;"
            alt="logo"
            class="logo"
            src="https://qnimg.vadxq.com/blog/2017/logo.jpg"
          />
          <span style="font-size: 16px; font-weight: bold;">清竹茶馆</span> -
          <span>管理后台</span>
        </div>
        <div class="desc">做有故事的茶馆</div>
      </div>
      <div class="login">
        <a-form>
          <a-tabs size="large" :tabBarStyle="{textAlign: 'center'}" style="padding: 0 2px;">
            <a-tab-pane tab="登录" key="1">
              <a-form-item label="账号">
                <a-input type="text" size="large" placeholder="请输入账号" v-model="login.uid">
                  <a-icon slot="prefix" type="user" />
                </a-input>
                <a-alert v-if="loginUidRegex" message="只允许4-16位英文字母、数字、下划线和减号" banner />
                <a-alert v-if="loginUidShortRegex"  message="账户长度过短" banner />
              </a-form-item>
              <a-form-item label="密码">
                <a-input size="large" placeholder="请输入密码" type="password" v-model="login.password">
                  <a-icon slot="prefix" type="lock" />
                </a-input>
                <a-alert v-if="loginPWRegex" message="密码只能为英文字母数字标点符号" banner />
              </a-form-item>
              <div>
                <a-checkbox v-model="isSave">自动登录</a-checkbox>
              </div>
              <a-form-item>
                <a-button
                  :loading="logging"
                  style="width: 100%;margin-top: 24px"
                  size="large"
                  htmlType="submit"
                  type="primary"
                  @click="signUp()"
                  :disabled="loginDisabled"
                >登录</a-button>
              </a-form-item>
            </a-tab-pane>

            <a-tab-pane class="signin-tab" tab="注册" key="2">
              <a-form-item label="邮箱">
                <a-input type="text" size="large" placeholder="请输入邮箱" v-model="signinData.email">
                  <a-icon slot="prefix" type="mail" />
                </a-input>
                <a-alert v-if="signinMailRegex" message="邮箱不正确" banner />
              </a-form-item>
              <a-form-item label="账号">
                <a-input type="text" size="large" placeholder="请输入登陆账号" v-model="signinData.uid">
                  <a-icon slot="prefix" type="user" />
                </a-input>
                <a-alert v-if="signinUidRegex" message="只允许4-16位英文字母、数字、下划线和减号" banner />
                <a-alert v-if="signinUidShortRegex"  message="账户长度过短" banner />
              </a-form-item>
              <a-form-item label="用户名">
                <a-input type="text" size="large" placeholder="请输入用户名" v-model="signinData.username">
                  <a-icon slot="prefix" type="profile" />
                </a-input>
              </a-form-item>
              <a-form-item label="手机">
                <a-input type="text" size="large" placeholder="请输入手机号" v-model="signinData.phone">
                  <a-icon slot="prefix" type="phone" />
                </a-input>
                <a-alert v-if="signinPhoneRegex" message="手机号错误" banner />
              </a-form-item>
              <a-form-item label="密码">
                <a-input size="large" type="password" placeholder="请输入密码" v-model="signinData.password">
                  <a-icon slot="prefix" type="lock" />
                </a-input>
                <a-alert v-if="signinPasswordRegex" message="密码只能为英文字母数字标点符号" banner />
              </a-form-item>
              <a-form-item label="验证密码">
                <a-input size="large" type="password" placeholder="请再次输入密码" v-model="againPass">
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
                  :disabled="signinDisabled"
                  @click="signIn()"
                >注册</a-button>
              </a-form-item>
            </a-tab-pane>
          </a-tabs>
        </a-form>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "Login",
  data() {
    return {
      logging: false,
      logguping: false,
      error: '',
      login: {
        uid: '',
        password: ''
      },
      signinData: {
        uid: '',
        username: '',
        phone: '',
        password: '',
        email: ''
      },
      againPass: '',
      isSave: false
    };
  },
  computed: {
    // 用户输入验证
    // 控制登陆按钮
    loginDisabled () {
      return this.loginUidRegex || this.loginUidShortRegex || this.loginPWRegex || this.login.uid === '' || this.login.password === ''
    },
    // 控制注册按钮
    signinDisabled () {
      return this.signinMailRegex || this.signinUidRegex || this.signinUidShortRegex || this.signinPhoneRegex === '' || this.signinPasswordRegex || this.againPassRegex
        || this.signinData.password === '' || this.signinData.uid === '' || this.signinData.phone === '' || this.signinData.email === '' || this.signinData.username === ''
    },
    // 控制登陆参数
    loginUidRegex() {
      return this.login.uid.length > 4 && !/^[a-zA-Z0-9_-]{4,16}$/.test(this.login.uid)
    },
    // 控制登陆账户过短
    loginUidShortRegex() {
      return this.login.uid!== '' && this.login.uid.length < 5
    },
    // 控制登陆密码参数
    loginPWRegex() {
      return this.login.password !== '' && /[\u4e00-\u9fa5]/.test(this.login.password)
    },
    // 控制注册参数
    signinMailRegex() {
      return this.signinData.email !== '' && !/^([\w-_]+(?:\.[\w-_]+)*)@((?:[a-z0-9]+(?:-[a-zA-Z0-9]+)*)+\.[a-z]{2,6})$/i.test(this.signinData.email)
    },
    // 注册账户参数
    signinUidRegex() {
      return this.signinData.uid.length > 4 && !/^[a-zA-Z0-9_-]{4,16}$/.test(this.signinData.uid)
    },
    // 登陆账户过短
    signinUidShortRegex() {
      return this.signinData.uid!== '' && this.signinData.uid.length < 5
    },
    // 注册手机号
    signinPhoneRegex() {
      return this.signinData.phone !== '' && !/^[1]([3-9])[0-9]{9}$/.test(this.signinData.phone)
    },
    // 注册密码
    signinPasswordRegex() {
      return this.signinData.password !== '' && /[\u4e00-\u9fa5]/.test(this.signinData.password)
    },
    // 确认密码
    againPassRegex() {
      return this.againPass !== '' && this.againPass !== this.signinData.password
    }
  },
  methods: {
    // 登录
    async signUp() {
      this.logging = true;
      let res = await this.$http.post('/api/v1/login', this.login);
      if (res.data.success) {
        localStorage.setItem('token', res.data.data.token);
        if (this.isSave) {
          localStorage.setItem('uid', this.login.uid)
          localStorage.setItem('id', btoa(this.login.password))
        }
        this.$store.dispatch('user/getUserInfo');
        this.$router.push(this.$route.query.redirect || '/');
        this.$message.success('欢迎回来！', 3);
      } else {
        this.$message.error(res.data.message);
      }
      this.logging = false;
    },
    // 注册
    async signIn() {
      this.logguping = true;
      let res = await this.$http.post('/api/v1/join', this.signinData);
      if (res.data.success) {
        this.$message.success('注册成功', 3);
      } else {
        this.$message.error(res.data.message);
      }
      this.logging = false;
    },
  },
  mounted() {
  },
};
</script>

<style  scoped>
.container {
  display: flex;
  flex-direction: column;
  height: 100vh;
  overflow: auto;
  background: #f0f2f5 url("../assets/login_bg2.png") center;
  background-size: 100%;
}
.content {
  padding: 32px 0;
  flex: 1;
}
@media (min-width: 768px) {
  .content： {
    padding: 112px 0 24px;
  }
}
.top {
  text-align: center;
}
.header {
  height: 44px;
  line-height: 44px;
}
.header a {
  text-decoration: none;
}
.logo {
  height: 44px;
  vertical-align: top;
  margin-right: 16px;
}
.title {
  font-size: 33px;
  color: rgba(0, 0, 0, 0.85);
  font-family: "Myriad Pro", "Helvetica Neue", Arial, Helvetica, sans-serif;
  font-weight: 600;
  position: relative;
  top: 2px;
}
.desc {
  font-size: 14px;
  color: rgba(0, 0, 0, 0.45);
  margin-top: 12px;
  margin-bottom: 40px;
}
.login {
  width: 368px;
  margin: 0 auto;
}
.signin-tab .ant-form-item {
  margin: 0;
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
</style>