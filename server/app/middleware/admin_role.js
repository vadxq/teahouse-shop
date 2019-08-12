'use strict';

/**
 * @param app.middleware role
 */

module.exports = () => {
  return async function adminRole(ctx, next) {
    if (ctx.current_user.role < 100) {
      ctx.body = {
        status: 401,
        success: false,
        message: '无权限',
      };
      return;
    }

    await next();
  };
};
