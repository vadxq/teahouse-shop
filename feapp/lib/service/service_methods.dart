import 'package:dio/dio.dart';
import 'dart:async';
import './../config/service_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feapp/provides/app_state.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

// 获取首页轮播图
Future getHomePageContent() async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.get(servicePath['homePageContext']);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('err');
    }
  } catch (e) {
    print(e);
  }
}

// 获取首页推荐
Future getHomePageNew() async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.get(servicePath['homePageNew']);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('err');
    }
  } catch (e) {
    print(e);
  }
}

// 获取菜单列表
Future getMenuPageList(data) async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.get(
      '${servicePath['menuPageList']}?page=${data['page']}&limit=${data['limit']}',
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('err');
    }
  } catch (e) {
    print(e);
  }
}

// 获取购物车列表
Future getShoppingCartList(context) async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.get(
      '${servicePath['shoppingCartList']}',
      options: Options(headers: {
        'Authorization': await _getData(),
        'connectTimeout': 15000
      }),
    );
    print(await _getData());
    if (response.statusCode == 200) {
      if (response.data['success']) {
        Provider.of<AppState>(context)
            .updateShoppingCart(response.data['data']['items']);
      } else {
        if (response.data['status'] == 403 || response.data['status'] == 401) {
          _removeData(context);
          Fluttertoast.showToast(msg: '登录过期');
        } else {
          Fluttertoast.showToast(msg: response.data['message']);
        }
      }
    } else {
      throw Exception('err');
    }
  } catch (e) {
    print(e);
  }
}

// 登录
Future loginPageData(data) async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.post(servicePath['loginPage'], data: data);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('err');
    }
  } catch (e) {
    print(e);
  }
}

// 注册
Future joinPageData(data) async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.post(servicePath['joinPage'], data: data);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('err');
    }
  } catch (e) {
    print(e);
  }
}

// 添加购物车
Future addShoppingCart(data) async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.post(
      servicePath['shoppingCartList'],
      data: data,
      options: Options(headers: {
        'Authorization': await _getData(),
        'connectTimeout': 15000
      }),
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('err');
    }
  } catch (e) {
    print(e);
  }
}

// 删除购物车商品
Future deleteShoppingCart(data, context) async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.delete(
      servicePath['shoppingCartList'] + '/' + data,
      options: Options(headers: {
        'Authorization': await _getData(),
        'connectTimeout': 15000
      }),
    );
    if (response.statusCode == 200) {
      if (response.data['success']) {
        getShoppingCartList(context);
        return response.data;
      } else {
        if (response.data['status'] == 403 || response.data['status'] == 401) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'SignPage', (router) => router == null);
        }
        Fluttertoast.showToast(msg: response.data['message']);
      }
    } else {
      throw Exception('err');
    }
  } catch (e) {
    print(e);
  }
}

// 修改购物车
Future putShoppingCart(data, context) async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.put(
      servicePath['shoppingCartList'],
      data: data,
      options: Options(headers: {
        'Authorization': await _getData(),
        'connectTimeout': 15000
      }),
    );
    if (response.statusCode == 200) {
      if (response.data['success']) {
        getShoppingCartList(context);
        return response.data;
      } else {
        if (response.data['status'] == 403 || response.data['status'] == 401) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'SignPage', (router) => router == null);
        }
        Fluttertoast.showToast(msg: response.data['message']);
      }
    } else {
      throw Exception('err');
    }
  } catch (e) {
    print(e);
  }
}

// 生成订单
Future makeOrderItem(data, context) async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.post(
      servicePath['makeOrder'],
      data: data,
      options: Options(headers: {
        'Authorization': await _getData(),
        'connectTimeout': 15000
      }),
    );
    if (response.statusCode == 200) {
      if (response.data['success']) {
        getShoppingCartList(context);
        return response.data;
      } else {
        if (response.data['status'] == 403 || response.data['status'] == 401) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'SignPage', (router) => router == null);
        }
        Fluttertoast.showToast(msg: response.data['message']);
      }
    } else {
      throw Exception('err');
    }
  } catch (e) {
    print(e);
  }
}

// 获取我的订单
Future getMyOrderList(uid, context) async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.get(
      servicePath['getOrders'] + uid,
      options: Options(headers: {
        'Authorization': await _getData(),
        'connectTimeout': 15000
      }),
    );
    if (response.statusCode == 200) {
      // print(response);
      if (response.data['success']) {
        return response.data;
      } else {
        if (response.data['status'] == 403 || response.data['status'] == 401) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'SignPage', (router) => router == null);
        }
        Fluttertoast.showToast(msg: response.data['message']);
      }
    } else {
      throw Exception('err');
    }
  } catch (e) {
    print(e);
  }
}

// 修改密码
Future changePass(data, context) async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.post(
      servicePath['userPass'],
      data: data,
      options: Options(headers: {
        'Authorization': await _getData(),
        'connectTimeout': 15000
      }),
    );
    if (response.statusCode == 200) {
      if (response.data['success']) {
        return response.data;
      } else {
        if (response.data['status'] == 403 || response.data['status'] == 401) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'SignPage', (router) => router == null);
        }
        Fluttertoast.showToast(msg: response.data['message']);
      }
    } else {
      throw Exception('err');
    }
  } catch (e) {
    print(e);
  }
}

// 获取个人信息
Future getUserInfo(context) async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.get(
      servicePath['userInfo'],
      options: Options(headers: {
        'Authorization': await _getData(),
        'connectTimeout': 15000
      }),
    );
    if (response.statusCode == 200) {
      if (response.data['success']) {
        Provider.of<AppState>(context)
            .updateLevel(response.data['data']['score']);
        return response.data;
      } else {
        if (response.data['status'] == 403 || response.data['status'] == 401) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'SignPage', (router) => router == null);
        }
        Fluttertoast.showToast(msg: response.data['message']);
      }
    } else {
      throw Exception('err');
    }
  } catch (e) {
    print(e);
  }
}

//修改个人信息
Future changeUserInfo(data, context) async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.put(
      servicePath['userInfo'],
      data: data,
      options: Options(headers: {
        'Authorization': await _getData(),
        'connectTimeout': 15000
      }),
    );
    if (response.statusCode == 200) {
      if (response.data['success']) {
        return response.data;
      } else {
        if (response.data['status'] == 403 || response.data['status'] == 401) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'SignPage', (router) => router == null);
        }
        Fluttertoast.showToast(msg: response.data['message']);
      }
    } else {
      throw Exception('err');
    }
  } catch (e) {
    print(e);
  }
}

// 获取 token
Future _getData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return 'bearer ' + prefs.getString('token');
}

// 去除登陆状态
_removeData(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
  prefs.remove('uid');
  Provider.of<AppState>(context).updateIsLogin(false);
}
