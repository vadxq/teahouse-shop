'use strict';

const Controller = require('../../core/base_controller');

class SaleDataController extends Controller {
  async getSaleData() {
    const resData = await this.ctx.service.saleData.getSaleData();
    if (resData.status) {
      this.success(resData.res);
    } else {
      this.fail(500, resData.res);
    }
  }
}

module.exports = SaleDataController;
