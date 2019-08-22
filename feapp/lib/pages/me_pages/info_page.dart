import 'package:feapp/service/service_methods.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  // 信息存储
  var userInfo;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<Null> _loadData() async {
    await Future.delayed(Duration(seconds: 1), () {
      getUserInfo(context).then((data) => setState(() {
            userInfo = {
              'uid': data['data']['uid'],
              'email': data['data']['email'],
              'username': data['data']['username'],
              'phone': data['data']['phone'],
            };
          }));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _changeUserInfo() async {
    // 取消焦点
    FocusScope.of(context).requestFocus(FocusNode());

    // 判断表单是否有效
    if (_formKey.currentState.validate()) {
      // 获取输入框内容
      var username = _usernameController.value.text;
      var phone = _phoneController.value.text;
      var email = _emailController.value.text;
      var data = await changeUserInfo(
          {'username': username, 'phone': phone, 'email': email}, context);
      Fluttertoast.showToast(msg: data['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1794)..init(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(ScreenUtil.getInstance().setWidth(145)),
          child: AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(
                    Icons.reply,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                );
              },
            ),
            centerTitle: true,
            title: new Text(
              '个人信息',
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil.getInstance().setWidth(48)),
            ),
            backgroundColor: Colors.lightBlueAccent,
          )),
      body: Container(
          margin: EdgeInsets.fromLTRB(50, 20, 50, 0), child: _getBody()),
    );
  }

  // 主容器
  _getBody() {
    if (userInfo != null) {
      return ListView(
        children: <Widget>[
          Form(
              // 将 key 设置给表单，用于判断表单是否有效
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: TextFormField(
                      initialValue: userInfo['uid'],
                      enabled: false,
                      style: TextStyle(
                          color: Color.fromARGB(200, 0, 0, 0),
                          fontSize: ScreenUtil.getInstance().setWidth(38)),
                      decoration: InputDecoration(
                          icon: Icon(Icons.account_box,
                              size: 24.0, color: Color.fromARGB(150, 0, 0, 0)),
                          labelText: '你的账号',
                          labelStyle:
                              TextStyle(color: Color.fromARGB(150, 0, 0, 0)),
                          helperStyle:
                              TextStyle(color: Color.fromARGB(150, 0, 0, 0))),
                      validator: (value) =>
                          value.trim().isEmpty ? '账号不能为空' : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: TextFormField(
                      controller: _emailController..text = userInfo['email'],
                      style: TextStyle(
                          color: Color.fromARGB(200, 0, 0, 0),
                          fontSize: ScreenUtil.getInstance().setWidth(38)),
                      decoration: InputDecoration(
                          icon: Icon(Icons.email,
                              size: 24.0, color: Color.fromARGB(150, 0, 0, 0)),
                          labelText: '请输入邮箱',
                          labelStyle:
                              TextStyle(color: Color.fromARGB(150, 0, 0, 0)),
                          helperStyle:
                              TextStyle(color: Color.fromARGB(150, 0, 0, 0))),
                      validator: (value) =>
                          value.trim().isEmpty ? '邮箱不能为空' : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: TextFormField(
                      controller: _usernameController
                        ..text = userInfo['username'],
                      style: TextStyle(
                          color: Color.fromARGB(200, 0, 0, 0),
                          fontSize: ScreenUtil.getInstance().setWidth(38)),
                      decoration: InputDecoration(
                          icon: Icon(Icons.account_circle,
                              size: 24.0, color: Color.fromARGB(150, 0, 0, 0)),
                          labelText: '请输入用户名',
                          labelStyle:
                              TextStyle(color: Color.fromARGB(150, 0, 0, 0)),
                          helperStyle:
                              TextStyle(color: Color.fromARGB(150, 0, 0, 0))),
                      validator: (value) =>
                          value.trim().isEmpty ? '用户名不能为空' : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: TextFormField(
                      controller: _phoneController..text = userInfo['phone'],
                      style: TextStyle(
                          color: Color.fromARGB(200, 0, 0, 0),
                          fontSize: ScreenUtil.getInstance().setWidth(38)),
                      decoration: InputDecoration(
                          icon: Icon(Icons.phone_android,
                              size: 24.0, color: Color.fromARGB(150, 0, 0, 0)),
                          labelText: '请输入手机号',
                          labelStyle:
                              TextStyle(color: Color.fromARGB(150, 0, 0, 0)),
                          helperStyle:
                              TextStyle(color: Color.fromARGB(150, 0, 0, 0))),
                      validator: (value) =>
                          value.trim().isEmpty ? '手机号不能为空' : null,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: ScreenUtil.getInstance().setWidth(88)),
                    child: SizedBox(
                      child: RaisedButton(
                          color: Colors.lightBlueAccent,
                          padding: EdgeInsets.fromLTRB(
                              ScreenUtil.getInstance().setWidth(150),
                              ScreenUtil.getInstance().setWidth(18),
                              ScreenUtil.getInstance().setWidth(150),
                              ScreenUtil.getInstance().setWidth(18)),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24.0))),
                          onPressed: _changeUserInfo,
                          child: Text(
                            '修 改',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    ScreenUtil.getInstance().setWidth(48)),
                          )),
                    ),
                  )
                ],
              )),
        ],
      );
    } else {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
  }
}
