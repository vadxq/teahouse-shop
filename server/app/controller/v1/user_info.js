'use strict';

const Controller = require('../../core/base_controller');

/**
 * @param app.Controller user info manage
 */
class UserInfoController extends Controller {

  // 获取个人信息
  async getUserInfo() {
    const uid = this.ctx.current_user.uid;
    if (!uid) {
      this.fail(400, '用户信息错误');
    } else {
      const resData = await this.ctx.service.userInfo.getUserInfo(uid);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    }
  }

  // 修改密码
  async changePass() {
    const reqData = this.ctx.request.body;
    console.log(reqData);
    if (!reqData.hasOwnProperty('oldPassword') || !reqData.hasOwnProperty('newPassword')) {
      this.fail(400, '输入错误');
    } else {
      if (reqData.oldPassword !== reqData.newPassword) {
        const resData = await this.ctx.service.userInfo.changePassword(reqData);
        if (resData.status) {
          this.success(resData.res);
        } else {
          this.fail(500, resData.res);
        }
      } else {
        this.fail(400, '新密码不能与旧密码相同');
      }
    }
  }

  // 修改个人信息
  async changeUserInfo() {
    const reqData = this.ctx.request.body;
    if (reqData) {
      const resData = await this.ctx.service.userInfo.changeUserInfo(reqData);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    } else {
      this.fail(400, '输入有误');
    }
  }
}

module.exports = UserInfoController;
