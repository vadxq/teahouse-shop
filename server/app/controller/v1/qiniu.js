'use strict';

const Controller = require('../../core/base_controller');

class QiniuController extends Controller {
  async getToken() {
    // bucket
    const reqData = this.ctx.request.body;
    if (!reqData.hasOwnProperty('bucket')) {
      this.fail(400, '输入错误');
    } else {
      const resData = await this.ctx.service.qiniu.getToken(reqData.bucket);
      if (resData.status) {
        this.success(resData.res);
      } else {
        this.fail(500, resData.res);
      }
    }
  }
}

module.exports = QiniuController;
