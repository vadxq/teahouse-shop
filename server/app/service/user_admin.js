'use strict';

const Service = require('egg').Service;

class UserAdminService extends Service {
  /**
   * change status
   * @param {Object} req - uid and status
   * @return {Object} - return data
   */
  async changeStatus(req) {
    const res = await this.ctx.model.User.findOneAndUpdate({
      uid: req.uid }, {
      status: req.status,
    });
    if (res) {
      return {
        status: 1,
        res: '修改成功',
      };
    }
    return {
      status: 0,
      res: '修改失败',
    };
  }

  /**
   * getUserList
   * @param {String} sort - member / worker
   * @param {Object} req - page / limit
   * @return {Object} - return data
   */
  async getUserList(sort, req) {
    if (sort === 'member') {
      const res = await this.ctx.model.User.find({ role: { $lt: 10 } })
        .skip((+req.page - 1) * +req.limit)
        .limit(+req.limit)
        .sort({ _id: -1 });
      const pages = await this.ctx.model.User.find({ role: { $lt: 10 } }).count() / req.limit;
      if (res) {
        return {
          status: 1,
          res: {
            data: res,
            pages: Math.ceil(pages),
            currentPage: +req.page,
          },
        };
      }
    }
    if (sort === 'worker') {
      const workerRes = await this.ctx.model.User.find({ role: { $gte: 10 } })
        .skip((+req.page - 1) * +req.limit)
        .limit(+req.limit)
        .sort({ _id: -1 });
      const pages = await this.ctx.model.User.find({ role: { $gte: 10 } }).count() / req.limit;
      if (workerRes) {
        return {
          status: 1,
          res: {
            data: workerRes,
            pages: Math.ceil(pages),
            currentPage: +req.page,
          },
        };
      }
      return {
        status: 0,
        res: '查询失败',
      };
    }
  }

  /**
   * change role
   * @param {Object} req - uid and role
   * @return {Object} - return data
   */
  async changeRole(req) {
    const res = await this.ctx.model.User.findOneAndUpdate({
      uid: req.uid }, {
      role: req.role,
    });
    console.log(res);
    if (res) {
      return {
        status: 1,
        res: '修改成功',
      };
    }
    return {
      status: 0,
      res: '修改失败',
    };
  }
}

module.exports = UserAdminService;
