'use strict';

const Service = require('egg').Service;

class ShoppingCartService extends Service {
  /**
   * addOrderItem
   * @param {Object} req -
   * @param {String} uid - uid
   * @return {Object} - return data
   */
  async addOrderItem(req, uid) {
    req.uid = uid;
    const orderItem = await this.ctx.model.Order.create(req);
    // console.log(orderItem);
    if (orderItem) {
      const updateUserOrder = await this.ctx.model.User.update({
        uid,
      }, {
        /* eslint-disable-next-line */
        '$push': { order: orderItem.oid },
      });
      // 删除购物车
      for (const item of req.item) {
        await this.ctx.model.ShoppingCart.findOneAndUpdate({ scid: item.scid }, { status: 2 });
      }
      if (updateUserOrder) {
        return {
          status: 1,
          res: orderItem,
        };
      }
    }
    return {
      status: 0,
      res: '添加失败',
    };
  }

  /**
   * makeOrderItem 接单
   * 更新用户积分，更改i订单状态，更新商品出货量
   * @param {Object} req -
   * @return {Object} - return data
   */
  async makeOrderItem(req) {
    const updateOrder = await this.ctx.model.Order.findOneAndUpdate({ oid: req.oid, status: 1 }, { status: 2 });
    if (updateOrder) {
      // 修改商品销售情况
      req.item.forEach(async element => {
        // const pro = await this.ctx.model.Product.findOne({ pid: element.pid });
        await this.ctx.model.Product.findOneAndUpdate({ pid: element.pid }, { $inc: { count: element.count, sale: element.sale } });
      });
      // 更新用户积分
      await this.ctx.model.User.findOneAndUpdate({ uid: req.uid }, { $inc: { score: req.sale } });
      return {
        status: 1,
        res: updateOrder,
      };
    }
    return {
      status: 0,
      res: '接单失败',
    };
  }

  /**
   * getOrderItem
   * @param {Object} req -
   * @return {Object} - return data
   */
  async getOrderItem(req) {
    if (req.sort === 'oid') {
      if (req.hasOwnProperty('id') && req.id.length === 24) {
        const orderListByOid = await this.ctx.model.Order.find({ oid: req.id, status: { $in: [ 1, 2 ] } });
        if (orderListByOid) {
          return {
            status: 1,
            res: {
              data: orderListByOid,
            },
          };
        }
      }
      return {
        status: 0,
        res: '订单号错误，查询失败',
      };
    }
    if (req.sort === 'uid') {
      if (req.hasOwnProperty('id') && req.id.length > 3) {
        if (req.hasOwnProperty('page') && req.hasOwnProperty('limit')) {
          const orderListByUid = await this.ctx.model.Order.find({ uid: req.id, status: { $in: [ 1, 2 ] } })
            .skip((+req.page - 1) * +req.limit)
            .limit(+req.limit)
            .sort({ _id: -1 });
          const pages = await this.ctx.model.Order.find({ uid: req.id, status: { $in: [ 1, 2 ] } }).count() / req.limit;
          if (orderListByUid) {
            return {
              status: 1,
              res: {
                data: orderListByUid,
                pages: Math.ceil(pages),
                currentPage: +req.page,
              },
            };
          }
        } else {
          const orderListByUid = await this.ctx.model.Order.find({ uid: req.id, status: { $in: [ 1, 2 ] } });
          if (orderListByUid) {
            return {
              status: 1,
              res: orderListByUid,
            };
          }
        }
      }
      return {
        status: 0,
        res: '用户账户错误，查询失败',
      };
    }
    return {
      status: 0,
      res: '查询失败',
    };
  }

  /**
   * getOrderList
   * @param {Object} req -
   * @return {Object} - return data
   */
  async getOrderList(req) {
    const orderList = await this.ctx.model.Order.find({ status: { $in: [ 1, 2 ] } })
      .skip((+req.page - 1) * +req.limit)
      .limit(+req.limit)
      .sort({ oid: -1 });
    const pages = await this.ctx.model.Order.find({ status: { $in: [ 1, 2 ] } }).count() / req.limit;
    if (orderList) {
      return {
        status: 1,
        res: {
          data: orderList,
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

  /**
   * delOrderItem
   * @param {String} oid -
   * @return {Object} - return data
   */
  async delOrderItem(oid) {
    const orderList = await this.ctx.model.Order.findOneAndUpdate({ oid }, { status: 0 });
    if (orderList) {
      return {
        status: 1,
        res: orderList,
      };
    }
    return {
      status: 0,
      res: '删除失败',
    };
  }

  /**
   * getMyOrder
   * @param {String} uid -
   * @return {Object} - return data
   */
  async getMyOrder(uid) {
    const user = await this.ctx.model.User.findOne({ uid }, {
      uid: 1, order: 1,
    }).populate(
      'Orders'
    );
    const items = await this.ctx.model.Order.find({
      oid: { $in: user.order }, status: { $in: [ 1, 2 ] },
    }).sort({ oid: -1 });
    if (user) {
      return {
        res: {
          items,
          uid,
        },
        status: 1,
      };
    }
    return {
      status: 0,
      res: '查询失败',
    };
  }
}

module.exports = ShoppingCartService;
