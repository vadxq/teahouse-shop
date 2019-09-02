# `清竹茶馆商城`api文档

+ ## 注册
    ### url: "/api/v1/join"
    ### methods: POST
    ### params:

      {
          "uid": 用户名, string, required,
          "password": 密码, string, required,
          "email": 邮箱, string, required,
          "phone": 手机号, string, required,
          "username": 用户名, string, required,
      }
    ### return: code 200

        {
            "data": {
              "token": token, passport token,
              "data": 个人信息
            },
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400

        {
            "message": error message,
            "success": false,
            "status": 500/400
        }

+ ## 登录
    ### url: "/api/v1/login"
    ### methods: POST
    ### params:

        {
            "uid": 账户, string, required,
            "password": 密码, string, required
        }
    ### return: code 200

        {
            "data": {
              "token": token, passport token,
            },
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400

        {
            "message": error message,
            "success": false,
            "status": 500/400
        }
    ### forbidden: code 403

+ ## 修改密码
    ### url: "/api/v1/user/pass"
    ### methods: POST
    ### params:

        {
            "oldPassword": 旧密码, string, required,
            "newPassword": 新密码, string, required
        }
    ### return: code 200

        {
            "data": '修改成功',
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 获取个人信息
    ### url: "/api/v1/user/info"
    ### methods: GET
    ### return: code 200

        {
            "data": 用户信息,
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 修改个人信息
    ### url: "/api/v1/user/info"
    ### methods: POST
    ### params:

        {
            "email": 邮箱, string, required,
            "phone": 手机号, string, required,
            "username": 用户名, string, required,
        }
    ### return: code 200

        {
            "data": "修改成功",
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 获取用户列表（admin）
    ### url: "/api/v1/admin/users/:sort"
    ### methods: GET
    ### query:
        sort：member/worker
    ### params:
        {
          "page": 页码,
          "limit": 每页条数
        }
    ### return: code 200

        {
            "data": {
              "data": [],用户列表,
              "pages": 总页码,
              "currentPage": 当前页码,
            },
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 禁用启用账户(admin)
    ### url: "/api/v1/users/status"
    ### methods: POST
    ### params:

        {
            "status": Boolean, required,
            "uid": 用户名, string, required,
        }
    ### return: code 200

        {
            "data": "修改成功",
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 修改权限（admin）
    ### url: "/api/v1/users/role"
    ### methods: POST
    ### params:

        {
            "role": 权限等级, Number, required,
            "uid": 用户名, string, required,
        }
    ### return: code 200

        {
            "data": "修改成功",
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 商品添加（admin）
    ### url: "/api/v1/admin/product"
    ### methods: POST
    ### params:

        {
            "title": string, required,
            "desc": string, required,
            "cover": string, required,
            "price": Number, required,
            "new": boolean, required,
            "recommend": boolean, required,
        }
    ### return: code 200

        {
            "data": 商品信息,
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 商品修改/上架下架/推荐不推荐/新品不新品（admin）
    ### url: "/api/v1/admin/product"
    ### methods: PUT
    ### params:

        {
            "title": string, required,
            "desc": string, required,
            "cover": string, required,
            "price": Number, required,
            "new": boolean, required,
            "recommend": boolean, required,
            "count": req.count,
            "check": req.check,
        }
    ### return: code 200

        {
            "data": 商品信息,
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 商品删除（admin）
    ### url: "/api/v1/admin/product/:pid"
    ### methods: DELETE
    ### query:
        pid: 商品id

    ### return: code 200

        {
            "data": 商品信息,
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 商品详情
    ### url: "/api/v1/product/:pid"
    ### methods: GET
    ### query:
        pid: 商品id

    ### return: code 200

        {
            "data": 商品信息,
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 商品列表
    ### url: "/api/v1/products/list"
    ### methods: GET
    ### query:

        {
          "page": 页码,
          "limit": 每页条数
        }

    ### return: code 200

        {
            "data": {
              "data": [],商品列表,
              "pages": 总页码,
              "currentPage": 当前页码,
            },
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 新品推荐商品列表
    ### url: "/api/v1/products/list"
    ### methods: POST

    ### return: code 200

        {
            "data": []商品列表,
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 购物车查询
    ### url: "/api/v1/shoppingcart"
    ### methods: GET

    ### return: code 200

        {
            "data": [], 购物车列表,
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 购物车添加
    ### url: "/api/v1/shoppingcart"
    ### methods: POST

    ### params：

        商品信息

    ### return: code 200

        {
            "data": 商品信息,
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 购物车删除
    ### url: "/api/v1/shoppingcart/:scid"
    ### methods: DELETE
    ### qeury：

        scid 购物车id

    ### return: code 200

        {
            "data": '删除成功',
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 购物车修改
    ### url: "/api/v1/shoppingcart"
    ### methods: PUT

    ### params：

        {
            "scid": 购物车id, string, required,
            "count": 商品数量,number, required
        }

    ### return: code 200

        {
            "data": 商品信息,
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 生成订单
    ### url: "/api/v1/order"
    ### methods: POST

    ### params：

        {
            "orderItem": 订单信息, object, required,
        }

    ### return: code 200

        {
            "data": 订单信息,
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 接单
    ### url: "/api/v1/admin/order"
    ### methods: POST

    ### params：

        {
            "oid": 订单id, string, required,
            "status": 状态, Boolean, required
        }

    ### return: code 200

        {
            "data": 订单信息,
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 查询订单(通过订单号)
    ### url: "/api/v1/admin/orders"
    ### methods: GET

    ### query:

        {
            "sort": 'oid'/'uid',
            "id": 订单号,string, required
        }

    ### return: code 200

        {
            "data": 订单信息,
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 查询订单(通过用户id)
    ### url: "/api/v1/admin/orders"
    ### methods: GET

    ### query:

        {
            "sort": 'uid', 
            "id": 用户帐号,string, required,
            "page": 页码,
            "limit": 每页条数
        }

    ### return: code 200

        {
            "data": {
              "data": [],订单列表,
              "pages": 总页码,
              "currentPage": 当前页码,
            },
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 查询订单列表
    ### url: "/api/v1/admin/orders"
    ### methods: GET

    ### query:

        {
          "page": 页码,
          "limit": 每页条数
        }

    ### return: code 200

        {
            "data": {
              "data": [],订单列表,
              "pages": 总页码,
              "currentPage": 当前页码,
            },
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 删除订单
    ### url: "/api/v1/admin/order/:oid"
    ### methods: DELETE

    ### query:

        oid: 订单id

    ### return: code 200

        {
            "data": 商品信息,
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 获取我的订单
    ### url: "/api/v1/orders/:uid"
    ### methods: GET

    ### return: code 200

        {
            "data": {
              "uid": 用户uid,
              "items": [], 订单列表
            },
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }

+ ## 获取qiniu token
    ### url: "/api/v1/admin/qiniu"
    ### methods: POST

    ### params：

        {
            "bucket": 仓库名, string, required,
        }

    ### return: code 200

        {
            "data": token,
            "status": 200,
            "success": true,
            "message": '操作成功',
        }
    ### error: code 500/400/403

        {
            "message": error message,
            "success": false,
            "status": 500/400/403/
        }
