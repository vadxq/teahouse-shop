import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MePage extends StatefulWidget {
  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('我的'),),
      body: _getBody(),
    );
  }

  _getBody() {
    return Container(
      child: Column(
        children: <Widget>[
          FlatButton(
            padding: EdgeInsets.all(0),
            child: Text(
              '检查是否登陆',
            ),
            onPressed: () {
              _isLogin();
            },
          ),
          FlatButton(
            padding: EdgeInsets.all(0),
            child: Text(
              '退出登陆',
            ),
            onPressed: () {
              _removeToken();
            },
          ),
          FlatButton(
            padding: EdgeInsets.all(0),
            child: Text(
              '登陆/注册',
            ),
            onPressed: () {
              _outLogin();
            },
          ),
        ],
      ),
    );
  }
  _getData() async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  _removeData() async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    setState(() {
      prefs.remove('token');
    });
  }
  _isLogin() async{
    String token = await _getData();
    print(token);
    if (token != '' && token != null) {
      Fluttertoast.showToast(msg: '你已登录');
    } else {
      Fluttertoast.showToast(msg: '请登录');
    }
  }

  _removeToken() async{
    await _removeData();
  }
  _outLogin() async{
    await _removeData();
    Navigator.pushNamedAndRemoveUntil(
            context, "SignPage", (router) => router == null);
  }
}