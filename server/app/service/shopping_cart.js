'use strict';

const Service = require('egg').Service;

class ShoppingCartService extends Service {
  /**
   * addShopItem
   * @param {Object} req -
   * @param {String} uid - uid
   * @return {Object} - return data
   */
  async addShopItem(req, uid) {
    req.uid = uid;
    let updateShop;
    console.log(req);
    delete req._id;
    const testExist = await this.ctx.model.ShoppingCart.findOne({ uid, pid: req.pid, status: 1 });
    if (testExist) {
      updateShop = await this.ctx.model.ShoppingCart.findOneAndUpdate({ uid, pid: req.pid }, { count: req.count, sale: testExist.price * req.count });
      if (updateShop) {
        return {
          status: 1,
          res: updateShop,
        };
      }
    } else {
      req.sale = req.price * req.count;
      const shoppingCartItem = await this.ctx.model.ShoppingCart.create(req);
      if (shoppingCartItem) {
        updateShop = await this.ctx.model.User.update({
          uid,
        }, {
          /* eslint-disable-next-line */
          '$push': { shoppingCart: shoppingCartItem.scid },
        });
        if (updateShop) {
          return {
            status: 1,
            res: shoppingCartItem,
          };
        }
      }
    }
    return {
      status: 0,
      res: '添加失败',
    };
  }

  /**
   * getShoppingCartList
   * @param {Object} req - { pid }
   * @return {Object} - return data
   */
  async getShoppingCartList(req) {
    const user = await this.ctx.model.User.findOne({ uid: req }, {
      uid: 1, shoppingCart: 1,
    }).populate(
      // {
      //   path: 'scid',
      //   select: 'title',
      //   model: 'ShoppingCart',
      // }
      'ShoppingCarts'
    // ).exec(
    //   (err, posts) => {
    //     console.log(posts);
    //   }
    );
    const items = await this.ctx.model.ShoppingCart.find({
      scid: { $in: user.shoppingCart }, status: 1,
    });
    // user.shoppingCart = items;
    if (user) {
      return {
        res: {
          items,
          uid: req,
        },
        status: 1,
      };
    }
    return {
      status: 0,
      res: '查询失败',
    };
  }

  /**
   * delShopItem
   * @param {String} scid - { pid }
   * @return {Object} - return data
   */
  async delShopItem(scid) {
    const uid = this.ctx.current_user.uid;
    const items = await this.ctx.model.ShoppingCart.findOneAndUpdate({
      scid, status: 1, uid,
    }, { status: 0 });
    const updateShop = await this.ctx.model.User.update({
      uid,
    }, {
      /* eslint-disable-next-line */
      '$pull': { shoppingCart: scid },
    });
    if (items && updateShop) {
      return {
        res: '删除成功',
        status: 1,
      };
    }
    return {
      status: 0,
      res: '删除失败',
    };
  }

  /**
   * change ShopItem
   * @param {Object} reqData - { scid, count }
   * @return {Object} - return data
   */
  async changeShopItem(reqData) {
    const item = await this.ctx.model.ShoppingCart.findOne({ scid: reqData.scid, status: 1 });
    if (item) {
      const result = await this.ctx.model.ShoppingCart.findOneAndUpdate({
        scid: reqData.scid, status: 1,
      }, { count: reqData.count, sale: item.price * reqData.count });
      console.log(result);
      if (result) {
        return {
          res: result,
          status: 1,
        };
      }
    }
    return {
      status: 0,
      res: '修改失败',
    };
  }
}

module.exports = ShoppingCartService;
