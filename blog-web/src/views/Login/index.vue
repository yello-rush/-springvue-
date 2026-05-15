<template>
  <div class="auth-page">
    <div class="auth-shell">
      <section class="auth-left">
        <div class="brand-mark"></div>
        <h1 class="brand-title">习习中博客</h1>
        <p class="brand-subtitle">记录技术与生活，沉淀成长轨迹</p>
        <ul class="brand-list">
          <li>个人内容管理</li>
          <li>评论互动与收藏</li>
          <li>简洁流畅的阅读体验</li>
        </ul>
      </section>

      <section class="auth-right">
        <button class="back-btn" @click="backToHome">
          <i class="el-icon-back"></i>
        </button>

        <transition name="auth-switch" mode="out-in">
          <div :key="currentForm" class="form-panel">
            <template v-if="currentForm === 'account'">
              <div class="panel-icon"><i class="el-icon-user-solid"></i></div>
              <h2 class="panel-title">登录</h2>
              <p class="panel-desc">欢迎访问博客网站，请输入邮箱账号和密码。</p>

              <el-form :model="loginForm" :rules="rules" ref="ruleFrom">
                <el-form-item class="form-item" prop="username">
                  <el-input
                    v-model="loginForm.username"
                    prefix-icon="el-icon-message"
                    placeholder="请输入邮箱"
                    @keyup.enter.native="handleLogin"
                  />
                </el-form-item>

                <el-form-item class="form-item" prop="password">
                  <el-input
                    v-model="loginForm.password"
                    prefix-icon="el-icon-lock"
                    placeholder="请输入密码"
                    show-password
                    @keyup.enter.native="handleLogin"
                  />
                </el-form-item>

                <div class="form-actions">
                  <el-checkbox v-model="rememberMe">记住我</el-checkbox>
                </div>

                <el-form-item class="form-item submit-item">
                  <el-button class="submit-btn" type="primary" :loading="loading" @click="handleLogin">
                    登 录
                  </el-button>
                </el-form-item>
              </el-form>

              <div class="form-switch">
                <a @click="switchForm('register')">立即注册</a>
                <span class="sep">|</span>
                <a @click="switchForm('forgot')">忘记密码?</a>
              </div>
            </template>

            <template v-else-if="currentForm === 'register'">
              <div class="panel-icon"><i class="el-icon-s-promotion"></i></div>
              <h2 class="panel-title">注册</h2>
              <p class="panel-desc">欢迎加入习习中博客，填写信息完成注册。</p>

              <el-form :model="registerForm" :rules="rules" ref="registerForm">
                <el-form-item class="form-item" prop="nickname">
                  <el-input v-model="registerForm.nickname" prefix-icon="el-icon-user-solid" placeholder="请输入昵称" />
                </el-form-item>

                <el-form-item class="form-item" prop="email">
                  <el-input v-model="registerForm.email" prefix-icon="el-icon-message" placeholder="请输入邮箱" />
                </el-form-item>

                <el-form-item class="form-item" prop="password">
                  <el-input v-model="registerForm.password" prefix-icon="el-icon-lock" placeholder="请输入密码" show-password />
                </el-form-item>

                <el-form-item class="form-item" prop="rePassword">
                  <el-input v-model="registerForm.rePassword" prefix-icon="el-icon-lock" placeholder="请再次输入密码" show-password />
                </el-form-item>

                <el-form-item class="form-item" prop="securityCode">
                  <el-tooltip effect="dark" content="安全码用于找回密码，请牢记（4位数字）" placement="top">
                    <el-input v-model.trim="registerForm.securityCode" prefix-icon="el-icon-key" placeholder="请设置4位安全码" maxlength="4" />
                  </el-tooltip>
                </el-form-item>

                <el-form-item class="form-item" prop="code">
                  <el-input v-model.trim="registerForm.code" prefix-icon="el-icon-picture-outline" placeholder="请输入图片中的数字验证码">
                    <template slot="append">
                      <img class="captcha-image" :src="registerCaptchaUrl" alt="验证码" title="点击刷新验证码" @click="refreshRegisterCaptcha" />
                    </template>
                  </el-input>
                </el-form-item>

                <p class="service-terms">注册即表示您同意《用户服务协议》与《隐私政策》，并承诺遵守社区发布规范。</p>

                <el-form-item class="form-item submit-item">
                  <el-button class="submit-btn" :loading="loading" @click="handleRegister">注 册</el-button>
                </el-form-item>
              </el-form>

              <div class="form-switch">已有账号？<a @click="switchForm('account')">立即登录</a></div>
            </template>

            <template v-else>
              <div class="panel-icon"><i class="el-icon-refresh-left"></i></div>
              <h2 class="panel-title">找回密码</h2>
              <p class="panel-desc">通过账号与安全码找回密码。</p>

              <el-form :model="forgotForm" :rules="rules" ref="forgotForm">
                <el-form-item class="form-item" prop="email">
                  <el-input v-model="forgotForm.email" prefix-icon="el-icon-message" placeholder="请输入注册邮箱" />
                </el-form-item>

                <el-form-item class="form-item" prop="securityCode">
                  <el-input v-model.trim="forgotForm.securityCode" prefix-icon="el-icon-key" placeholder="请输入4位安全码" maxlength="4" />
                </el-form-item>

                <el-form-item class="form-item" prop="password">
                  <el-input v-model="forgotForm.password" prefix-icon="el-icon-lock" placeholder="请输入新密码" show-password />
                </el-form-item>

                <el-form-item class="form-item submit-item">
                  <el-button class="submit-btn" :loading="loading" @click="handleResetPassword">重置密码</el-button>
                </el-form-item>
              </el-form>

              <div class="form-switch"><a @click="switchForm('account')">返回登录</a></div>
            </template>
          </div>
        </transition>
      </section>
    </div>

    <el-dialog
      title="请拖动滑块完成拼图"
      width="360px"
      :visible.sync="isShowSliderVerify"
      :close-on-click-modal="false"
      @close="refresh"
      append-to-body
    >
      <slider-verify ref="sliderVerify" @success="onSuccess" @fail="onFail" @again="onAgain" />
    </el-dialog>
  </div>
</template>

<script>
import { disableScroll, enableScroll } from "@/utils/scroll";
import { registerApi, forgotPasswordApi } from "@/api/auth";
import SliderVerify from "./components/SliderVerify.vue";

export default {
  name: "Login",
  components: { SliderVerify },
  computed: {
    registerCaptchaUrl() {
      return `https://dummyimage.com/110x40/5b8ff9/ffffff&text=${this.registerCaptchaText}&t=${this.registerCaptchaSeed}`;
    },
  },
  data() {
    const validatePass2 = (rule, value, callback) => {
      if (!value) return callback(new Error("请再次输入密码"));
      if (value !== this.registerForm.password) return callback(new Error("两次输入密码不一致"));
      callback();
    };

    const validateCode = (rule, value, callback) => {
      if (this.currentForm !== "register") return callback();
      if (!value) return callback(new Error("请输入验证码"));
      if (String(value).trim() !== this.registerCaptchaText) return callback(new Error("验证码不正确"));
      callback();
    };

    return {
      currentForm: "account",
      loading: false,
      rememberMe: false,
      isShowSliderVerify: false,
      registerCaptchaText: "",
      registerCaptchaSeed: Date.now(),
      loginForm: {
        username: "",
        password: "",
        source: "PC",
      },
      registerForm: {
        nickname: "",
        email: "",
        password: "",
        rePassword: "",
        securityCode: "",
        code: "",
      },
      forgotForm: {
        email: "",
        securityCode: "",
        password: "",
      },
      rules: {
        nickname: [
          { required: true, message: "请输入昵称", trigger: "blur" },
          { min: 2, max: 16, message: "长度在 2 到 16 个字符", trigger: "blur" },
        ],
        username: [
          { required: true, message: "请输入邮箱", trigger: "blur" },
          { type: "email", message: "请输入正确的邮箱", trigger: "blur" },
        ],
        email: [
          { required: true, message: "请输入邮箱", trigger: "blur" },
          { type: "email", message: "请输入正确的邮箱", trigger: "blur" },
        ],
        password: [
          { required: true, message: "请输入密码", trigger: "blur" },
          { min: 6, max: 16, message: "长度在 6 到 16 个字符", trigger: "blur" },
        ],
        rePassword: [{ validator: validatePass2, trigger: "blur" }],
        securityCode: [
          { required: true, message: "请输入4位安全码", trigger: "blur" },
          { pattern: /^\d{4}$/, message: "安全码必须是4位数字", trigger: "blur" },
        ],
        code: [{ validator: validateCode, trigger: "blur" }],
      },
    };
  },
  created() {
    this.$nextTick(() => disableScroll());
    this.refreshRegisterCaptcha();
  },
  beforeDestroy() {
    enableScroll();
  },
  methods: {
    async onSuccess(captcha) {
      this.loginForm.nonceStr = captcha.nonceStr;
      this.loginForm.value = captcha.value;
      this.login();
    },
    onFail() {
      this.$message.error("验证失败，请重试");
    },
    onAgain() {
      this.$message.error("验证失败，请重试");
    },
    refresh() {
      this.$refs.sliderVerify?.refresh();
    },
    switchForm(form) {
      this.currentForm = form;
      this.loading = false;
      if (form === "register") this.refreshRegisterCaptcha();
    },
    async login() {
      this.loading = true;
      try {
        await this.$store.dispatch("loginAction", this.loginForm);
        this.$refs.sliderVerify?.verifySuccessEvent();
        this.$message.success("登录成功");
        this.handleClose();
      } catch (error) {
        const rawMessage = error?.message || "";
        const normalizedMessage =
          rawMessage
            .replace(/用户名或密码错误/g, "邮箱或密码错误")
            .replace(/账号或密码错误/g, "邮箱或密码错误")
            .replace(/账号不存在/g, "邮箱不存在") || "登录失败，请重试";
        this.$message.error(normalizedMessage);
        this.refresh();
      } finally {
        this.loading = false;
      }
    },
    handleLogin() {
      this.$refs.ruleFrom.validate((valid) => {
        if (valid) this.login();
      });
    },
    handleRegister() {
      this.$refs.registerForm.validate(async (valid) => {
        if (!valid) return;
        this.loading = true;
        try {
          await registerApi(this.registerForm);
          this.$message.success("注册成功");
          this.switchForm("account");
        } catch (error) {
          this.$message.error(error.message || "注册失败，请重试");
        } finally {
          this.refreshRegisterCaptcha();
          this.loading = false;
        }
      });
    },
    handleResetPassword() {
      this.$refs.forgotForm.validate(async (valid) => {
        if (!valid) return;
        this.loading = true;
        try {
          await forgotPasswordApi(this.forgotForm);
          this.$message.success("密码重置成功");
          this.switchForm("account");
        } catch (error) {
          this.$message.error(error.message || "重置失败，请重试");
        } finally {
          this.loading = false;
        }
      });
    },
    refreshRegisterCaptcha() {
      this.registerCaptchaText = String(Math.floor(1000 + Math.random() * 9000));
      this.registerCaptchaSeed = Date.now();
      this.registerForm.code = "";
    },
    handleClose() {
      this.$router.go(-1);
    },
    backToHome() {
      this.$router.push("/");
    },
  },
};
</script>

<style scoped lang="scss">
.auth-page {
  min-height: calc(100vh - 80px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px 16px;
  background: linear-gradient(135deg, #edf3ff 0%, #d8e6ff 100%);
}

.auth-shell {
  width: 980px;
  max-width: 100%;
  min-height: 620px;
  background: #fff;
  border-radius: 20px;
  overflow: hidden;
  display: grid;
  grid-template-columns: 1fr 460px;
  box-shadow: 0 20px 46px rgba(44, 86, 165, 0.18);
}

.auth-left {
  padding: 48px 40px;
  color: #fff;
  background: linear-gradient(160deg, #5978f2 0%, #5267cf 52%, #4454a9 100%);
}

.brand-mark {
  width: 14px;
  height: 14px;
  border-radius: 50%;
  background: #fff;
  margin-bottom: 18px;
  box-shadow: 0 0 0 6px rgba(255, 255, 255, 0.25);
}

.brand-title {
  margin: 0 0 12px;
  font-size: 40px;
  font-weight: 700;
}

.brand-subtitle {
  margin: 0;
  font-size: 16px;
  opacity: 0.96;
}

.brand-list {
  margin: 36px 0 0;
  padding: 0;
  list-style: none;
}

.brand-list li {
  margin: 12px 0;
  font-size: 15px;
  opacity: 0.96;
}

.brand-list li::before {
  content: "•";
  margin-right: 10px;
}

.auth-right {
  position: relative;
  padding: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.back-btn {
  position: absolute;
  top: 18px;
  right: 18px;
  width: 34px;
  height: 34px;
  border: none;
  border-radius: 50%;
  background: #f2f5fb;
  color: #677089;
  cursor: pointer;
}

.form-panel {
  width: 100%;
  max-width: 360px;
  max-height: calc(100vh - 170px);
  overflow-y: auto;
  padding-right: 4px;
}

.form-panel::-webkit-scrollbar {
  width: 6px;
}

.form-panel::-webkit-scrollbar-thumb {
  background: rgba(120, 132, 170, 0.35);
  border-radius: 6px;
}

.auth-switch-enter-active,
.auth-switch-leave-active {
  transition: opacity 0.28s ease, transform 0.28s ease;
}

.auth-switch-enter,
.auth-switch-leave-to {
  opacity: 0;
  transform: translateY(10px);
}

.panel-icon {
  width: 72px;
  height: 72px;
  margin: 0 auto 14px;
  border-radius: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 34px;
  background: linear-gradient(135deg, #5d7cf4 0%, #6c8bff 100%);
  box-shadow: 0 10px 24px rgba(83, 115, 230, 0.35);
}

.panel-title {
  margin: 0;
  text-align: center;
  font-size: 28px;
  color: #222;
}

.panel-desc {
  margin: 8px 0 22px;
  text-align: center;
  color: #7a8091;
  font-size: 14px;
}

.form-item {
  margin-bottom: 16px;
}

.form-item :deep(.el-input__inner) {
  height: 44px;
  border-radius: 10px;
  border: 1px solid #dce1ee;
  padding-left: 40px;
  padding-right: 42px;
}

.form-item :deep(.el-input__prefix) {
  left: 10px;
  color: #9097a8;
}

.form-item :deep(.el-input-group__append) {
  padding: 0;
  border-radius: 0 10px 10px 0;
  overflow: hidden;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  margin-bottom: 14px;
}

.submit-item {
  margin-bottom: 8px;
}

.submit-btn {
  width: 100%;
  height: 44px;
  border: none;
  border-radius: 10px;
  font-size: 16px;
  font-weight: 600;
  color: #fff;
  background: linear-gradient(135deg, #5d7cf4 0%, #6789ff 100%);
}

.form-switch {
  margin-top: 12px;
  text-align: center;
  color: #7f8798;
  font-size: 14px;
}

.form-switch a {
  color: #5d7cf4;
  cursor: pointer;
  text-decoration: none;
}

.sep {
  margin: 0 10px;
  color: #c6cbd8;
}

.captcha-image {
  width: 110px;
  height: 40px;
  display: block;
  cursor: pointer;
}

.service-terms {
  margin: -2px 0 14px;
  color: #8a90a0;
  font-size: 12px;
  line-height: 1.6;
}

@media (max-width: 960px) {
  .auth-shell {
    width: 460px;
    min-height: auto;
    grid-template-columns: 1fr;
  }

  .auth-left {
    display: none;
  }
}

@media (max-width: 480px) {
  .auth-page {
    padding: 10px;
  }

  .auth-right {
    padding: 20px 14px;
  }

  .panel-title {
    font-size: 24px;
  }
}
</style>
