import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  List _shoppingCartList = []; // 购物车列表
  double _money = 0.00; // 购物车计算总价钱
  int _total = 0; // 总数量
  bool _isLogin = false; // 是否登陆
  int _level = 0; // 等级
  double _score = 0.00; // 积分
  double _sale = 0.00; // 打折后总价
  double _cut = 1.0; // 折扣

  List get value => _shoppingCartList;
  double get totalPrice => _money;
  double get totalSale => _sale;
  int get total => _total;
  bool get isLogin => _isLogin;
  int get level => _level;
  double get score => _score;

  void updateShoppingCart(data) {
    _shoppingCartList = data;
    _money = 0.00;
    for (var item in _shoppingCartList) {
      _money += item['sale'].toDouble();
    }
    _sale = _money * _cut;
    _total = _shoppingCartList.length;
    notifyListeners();
  }

  void updateIsLogin(data) {
    _isLogin = data;
    notifyListeners();
  }

  void updateLevel(score) {
    _score = score.toDouble();
    if (score < 200.00) {
      _level = 1;
    } else if (score >= 200.00 && score < 500.00) {
      _level = 2;
      _cut = 0.98;
    } else if (score >= 500.00 && score < 1000.00) {
      _level = 3;
      _cut = 0.95;
    } else if (score >= 1000.00 && score < 1500.00) {
      _level = 4;
      _cut = 0.92;
    } else if (score >= 1500.00) {
      _level = 5;
      _cut = 0.88;
    }
    notifyListeners();
  }
}
