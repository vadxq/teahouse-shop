import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  List _shoppingCartList = [];
  int _money = 0;
  int _total = 0;
  bool _isLogin = false;

  List get value => _shoppingCartList;
  int get totalPrice => _money;
  int get total => _total;
  bool get isLogin => _isLogin;

  void updateShoppingCart(data) {
    _shoppingCartList = data;
    _money = 0;
    for (var item in _shoppingCartList) {
      _money += item['sale'];
    }
    _total = _shoppingCartList.length;
    notifyListeners();
  }

  void updateIsLogin(data) {
    _isLogin = data;
    notifyListeners();
  }
}
