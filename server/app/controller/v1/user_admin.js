'use strict';

const Controller = require('../../core/base_controller');

class UserAdminController extends Controller {
  // 禁用启用账户
  async changeStatus() {
    const reqData = this.ctx.request.body;
    if (!reqData.hasOwnProperty('uid') || !reqData.hasOwnProperty('status')) {
      this.fail(400, '输入错误');
    } else {
      const resData = await this.ctx.service.userAdmin.changeStatus(reqData);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    }
  }

  // 获取用户列表
  async getUserList() {
    const { sort } = this.ctx.params;
    const query = this.ctx.request.query;
    if (!sort || !query.hasOwnProperty('page') || !query.hasOwnProperty('limit')) {
      this.fail(400, '用户信息错误');
    } else {
      const resData = await this.ctx.service.userAdmin.getUserList(sort, query);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    }
  }

  // 修改权限，分为工作人员，超级管理员和普通用户，只有超级管理员才有权限
  async changeRole() {
    const reqData = this.ctx.request.body;
    if (!reqData.hasOwnProperty('uid') || !reqData.hasOwnProperty('role')) {
      this.fail(400, '输入错误');
    } else {
      const resData = await this.ctx.service.userAdmin.changeRole(reqData);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    }
  }
}

module.exports = UserAdminController;
