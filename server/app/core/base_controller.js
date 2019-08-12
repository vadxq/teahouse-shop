'use strict';

/**
 * @param app.Controller base Controller
 */
const { Controller } = require('egg');
class BaseController extends Controller {
  // getUser() {
  //   return this.ctx.session.user;
  // }

  success(data) {
    this.ctx.body = {
      data,
      status: 200,
      success: true,
      message: '操作成功',
    };
  }

  fail(status, err) {
    this.ctx.body = {
      message: err,
      success: false,
      status,
    };
  }

  notFound(msg) {
    msg = msg || 'not found';
    this.ctx.throw(404, msg);
  }
}
module.exports = BaseController;
