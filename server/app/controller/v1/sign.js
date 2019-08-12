'use strict';

const Controller = require('../../core/base_controller');

/**
 * @param app.Controller signUp and signIn
 */
class SignController extends Controller {

  // 注册
  async signUp() {
    const userData = this.ctx.request.body;
    console.log(userData);
    if (!userData.hasOwnProperty('uid') || !userData.hasOwnProperty('password') || !userData.hasOwnProperty('email')) {
      this.fail(400, '输入错误');
    } else {
      const user = await this.ctx.service.user.signUp(userData);
      if (user.status) {
        this.success(user.res);
      } else {
        this.fail(500, user.res);
      }
    }
  }

  // 登陆
  async signIn() {
    const userData = this.ctx.request.body;
    console.log(userData);
    if (!userData.hasOwnProperty('uid') || !userData.hasOwnProperty('password')) {
      this.fail(400, '输入错误');
    } else {
      if (/([a-zA-Z0-9._-]+)+$/.test(userData.uid)) {
        const user = await this.ctx.service.user.signIn(userData);
        if (user.status) {
          this.success(user.res);
        } else {
          this.fail(500, user.res);
        }
      } else {
        this.fail(500, '用户名输入错误');
      }
    }
  }
}

module.exports = SignController;
