import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feapp/service/service_methods.dart';

class SignPage extends StatefulWidget {
  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<String> _pageIndicators = ['登录', '注册'];
  List<Widget> _pages = [];
  int _position = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pageIndicators.length, vsync: this);
    _pages..add(LoginPage())..add(RegisterPage());

    _tabController.addListener(() {
      if (_tabController.indexIsChanging)
        setState(() => _position = _tabController.index);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
            primarySwatch: Colors.lightBlue,
            iconTheme: IconThemeData(color: Colors.lightBlue)),
        child: Scaffold(
          backgroundColor: Color.fromRGBO(222, 222, 222, 0.6),
          body: Container(
            padding: const EdgeInsets.all(20.0),
            alignment: Alignment.center,
            color: Color.fromARGB(224, 222, 222, 222),
            child: SingleChildScrollView(
              child: SafeArea(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    // 顶部页面切换指示器
                    TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        controller: _tabController,
                        indicatorWeight: 4.0,
                        indicatorColor: Color.fromARGB(150, 0, 0, 0),
                        tabs: _pageIndicators
                            .map((v) => Text(v,
                                style: TextStyle(
                                    color: Color.fromARGB(150, 0, 0, 0), fontSize: 24.0)))
                            .toList()),
                    Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: SizedBox(
                            // 切换界面列表
                            child: IndexedStack(
                                children: _pages, index: _position),
                            // height: MediaQuery.of(context).size.height / 2
                            )
                            )
                  ])),
            ),
          ),
        ));
  }
}

/// 登录界面
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _setData(token) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', _usernameController.value.text.toString());
    // prefs.setString('pass', _passwordController.value.text.toString());
    prefs.setString('token', token.toString());
  }

  _login() async{
    // 取消焦点
    FocusScope.of(context).requestFocus(FocusNode());

    // 判断表单是否有效
    if (_formKey.currentState.validate()) {
      // 获取输入框内容
      var username = _usernameController.value.text;
      var password = _passwordController.value.text;
      var data = await loginPageData({'uid': username, 'password': password});
      Fluttertoast.showToast(msg: data['message']);
      if (data['success'] == true) {
        _setData(data['data']['token']);
        // Navigator.of(context).pop(true);
        Navigator.pushNamedAndRemoveUntil(
            context, 'IndexPage', (router) => router == null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        // 将 key 设置给表单，用于判断表单是否有效
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              // 表单输入框，参数同 TextField 基本类似
              child: TextFormField(
                controller: _usernameController,
                style: TextStyle(color: Color.fromARGB(200, 0, 0, 0), fontSize: 16.0),
                decoration: InputDecoration(
                    icon: Icon(Icons.account_box, size: 24.0, color: Color.fromARGB(150, 0, 0, 0)),
                    labelText: '请输入账号',
                    labelStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0)),
                    helperStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0))),
                // 有效条件(为空不通过，返回提示语，通过返回 null)
                validator: (value) => value.trim().isEmpty ? '账号不能为空' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                obscureText: true,
                controller: _passwordController,
                style: TextStyle(color: Color.fromARGB(200, 0, 0, 0), fontSize: 16.0),
                decoration: InputDecoration(
                    icon:
                        Icon(Icons.sms_failed, size: 24.0, color: Color.fromARGB(150, 0, 0, 0)),
                    labelText: '请输入密码',
                    labelStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0)),
                    helperStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0))),
                validator: (value) =>
                    value.trim().length < 6 ? '密码长度不能小于6位' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                // 主要用于使 RaisedButton 和上层容器同宽
                // width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                    color: Colors.blue,
                    padding: EdgeInsets.fromLTRB(50, 7, 50, 7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24.0))),
                    onPressed: _login,
                    child: Text(
                      '登 录',
                      style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20.0),
                    )),
              ),
            )
          ],
        ));
  }
}

/// 注册界面
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _uidController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  _register() async{
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState.validate()) {
      var username = _usernameController.value.text;
      var email = _emailController.value.text;
      var uid = _uidController.value.text;
      var password = _passwordController.value.text;
      var phone = _phoneController.value.text;
      var data = await joinPageData({
        'username': username,
        'email': email,
        'uid': uid,
        'password': password,
        'phone': phone,
      });
      Fluttertoast.showToast(msg: data['message']);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                controller: _emailController,
                style: TextStyle(color: Color.fromARGB(200, 0, 0, 0), fontSize: 16.0),
                decoration: InputDecoration(
                    icon: Icon(Icons.email,
                        size: 24.0, color: Color.fromARGB(150, 0, 0, 0)),
                    labelText: '请输入邮箱',
                    labelStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0)),
                    helperStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0))),
                validator: (value) => value.trim().isEmpty ? '邮箱不能为空' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                controller: _uidController,
                style: TextStyle(color: Color.fromARGB(200, 0, 0, 0), fontSize: 16.0),
                decoration: InputDecoration(
                    icon: Icon(Icons.account_box,
                        size: 24.0, color: Color.fromARGB(150, 0, 0, 0)),
                    labelText: '请输入账号',
                    labelStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0)),
                    helperStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0))),
                validator: (value) => value.trim().isEmpty ? '账号不能为空' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                controller: _usernameController,
                style: TextStyle(color: Color.fromARGB(200, 0, 0, 0), fontSize: 16.0),
                decoration: InputDecoration(
                    icon: Icon(Icons.account_circle,
                        size: 24.0, color: Color.fromARGB(150, 0, 0, 0)),
                    labelText: '请输入用户名',
                    labelStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0)),
                    helperStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0))),
                validator: (value) => value.trim().isEmpty ? '用户名不能为空' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                controller: _phoneController,
                style: TextStyle(color: Color.fromARGB(200, 0, 0, 0), fontSize: 16.0),
                decoration: InputDecoration(
                    icon: Icon(Icons.phone_android,
                        size: 24.0, color: Color.fromARGB(150, 0, 0, 0)),
                    labelText: '请输入手机号',
                    labelStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0)),
                    helperStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0))),
                validator: (value) => value.trim().isEmpty ? '手机号不能为空' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                obscureText: true,
                controller: _passwordController,
                style: TextStyle(color: Color.fromARGB(200, 0, 0, 0), fontSize: 16.0),
                decoration: InputDecoration(
                    icon: Icon(Icons.sms_failed,
                        size: 24.0, color: Color.fromARGB(150, 0, 0, 0)),
                    labelText: '请输入密码',
                    labelStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0)),
                    helperStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0))),
                validator: (value) =>
                    value.trim().length < 6 ? '密码长度不能小于6位' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                obscureText: true,
                controller: _confirmController,
                style: TextStyle(color: Color.fromARGB(200, 0, 0, 0), fontSize: 16.0),
                decoration: InputDecoration(
                    icon: Icon(Icons.sms_failed,
                        size: 24.0, color: Color.fromARGB(150, 0, 0, 0)),
                    labelText: '请确认密码',
                    labelStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0)),
                    helperStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0))),
                validator: (value) =>
                    value.trim() != _passwordController.value.text
                        ? '两次输入密码不相同'
                        : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                // width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                    color: Colors.white10,
                    padding: EdgeInsets.fromLTRB(50, 7, 50, 7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24.0))),
                    onPressed: _register,
                    child: Text(
                      '注 册',
                      style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20.0),
                    )),
              ),
            )
          ],
        ));
  }
}
