'use strict';

/**
 * @param app.middleware authorization
 */

module.exports = () => {
  return async function auth(ctx, next) {
    const authorization = ctx.request.headers.authorization;
    if (!authorization) {
      ctx.body = {
        status: 401,
        success: false,
        message: '请登录',
      };
      return;
    }
    const token = authorization.slice(7);
    const vf = ctx.app.jwt.decode(token, ctx.app.config.jwt.secret);
    if (!vf) {
      ctx.body = {
        status: 403,
        success: false,
        message: 'token错误',
      };
      return;
    }

    if (vf.exp < Date.now()) {
      ctx.body = {
        status: 403,
        success: false,
        message: 'token过期',
      };
      return;
    }
    // 赋予ctx current_user参数
    ctx.current_user = await ctx.model.User.findOne({ uid: vf.uid });
    if (!ctx.current_user) {
      ctx.body = {
        status: 401,
        success: false,
        message: '用户不存在',
      };
      return;
    }

    if (!ctx.current_user.status) {
      ctx.body = {
        status: 401,
        success: false,
        message: '用户被禁用',
      };
      return;
    }

    await next();
  };
};
