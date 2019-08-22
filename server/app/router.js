'use strict';

/**
 * @param {Egg.Application} app - egg application
 */
module.exports = app => {
  const { router, controller } = app;
  app.router.prefix('/api');
  // 登陆
  const auth = app.middleware.auth();
  // 管理后台
  const role = app.middleware.role();
  // 管理员
  const adminRole = app.middleware.adminRole();
  // 所有用户（包含未登录用户）
  const allRole = app.middleware.allRole();

  router.get('/', auth, controller.home.index);
  // 注册
  router.post('/v1/join', controller.v1.sign.signUp);
  // 登陆
  router.post('/v1/login', controller.v1.sign.signIn);

  // 修改密码
  router.post('/v1/user/pass', auth, controller.v1.userInfo.changePass);
  // 获取个人信息
  router.get('/v1/user/info', auth, controller.v1.userInfo.getUserInfo);
  // 修改个人信息
  router.put('/v1/user/info', auth, controller.v1.userInfo.changeUserInfo);

  // admin，获取用户列表
  router.get('/v1/admin/users/:sort', auth, role, controller.v1.userAdmin.getUserList);
  // admin，禁用启用账户
  router.post('/v1/admin/users/status', auth, adminRole, controller.v1.userAdmin.changeStatus);
  // admin，修改权限
  router.post('/v1/admin/users/role', auth, adminRole, controller.v1.userAdmin.changeRole);

  // admin，商品添加
  router.post('/v1/admin/product', auth, adminRole, controller.v1.productAdmin.addProduct);
  // admin，商品修改/上架下架/推荐不推荐/新品不新品
  router.put('/v1/admin/product', auth, adminRole, controller.v1.productAdmin.changeProduct);
  // admin，商品删除
  router.delete('/v1/admin/product/:pid', auth, adminRole, controller.v1.productAdmin.deleteProduct);
  // 商品详情，区分admin/工作人员/用户/未登录用户
  router.get('/v1/product/:pid', allRole, controller.v1.productInfo.getProductDetail);
  // 商品列表，区分admin/工作人员/用户/未登录用户
  router.get('/v1/products/list', allRole, controller.v1.productInfo.getProductList);
  // 新品推荐商品列表
  router.post('/v1/products/list', allRole, controller.v1.productInfo.postProductList);

  // 购物车查询
  router.get('/v1/shoppingcart', auth, controller.v1.shoppingCart.getShoppingCartList);
  // 购物车添加
  router.post('/v1/shoppingcart', auth, controller.v1.shoppingCart.addShopItem);
  // 购物车删除
  router.delete('/v1/shoppingcart/:scid', auth, controller.v1.shoppingCart.delShopItem);
  // 购物车修改
  router.put('/v1/shoppingcart', auth, controller.v1.shoppingCart.changeShopItem);

  // 生成订单
  router.post('/v1/order', auth, controller.v1.order.addOrderItem);
  // 接单
  router.post('/v1/admin/order', auth, role, controller.v1.order.makeOrderItem);
  // 查询订单(通过订单号和用户id)
  router.post('/v1/admin/orders', auth, role, controller.v1.order.getOrderItem);
  // 查询订单列表
  router.get('/v1/admin/orders', auth, role, controller.v1.order.getOrderList);
  // 删除订单
  router.delete('/v1/admin/order/:oid', auth, adminRole, controller.v1.order.delOrderItem);
  // 获取我的订单
  router.get('/v1/orders/:uid', auth, controller.v1.order.getMyOrder);

  // 获取qiniu token
  router.post('/v1/admin/qiniu', auth, adminRole, controller.v1.qiniu.getToken);
};
