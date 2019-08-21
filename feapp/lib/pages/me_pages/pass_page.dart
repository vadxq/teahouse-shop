import 'package:feapp/service/service_methods.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PassPage extends StatefulWidget {
  @override
  _PassPageState createState() => _PassPageState();
}

class _PassPageState extends State<PassPage> with SingleTickerProviderStateMixin{
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
  }
  _changePass() async{
    // 取消焦点
    FocusScope.of(context).requestFocus(FocusNode());

    // 判断表单是否有效
    if (_formKey.currentState.validate()) {
      // 获取输入框内容
      var oldPassword = _usernameController.value.text;
      var newPassword = _passwordController.value.text;
      print(newPassword);
      var data = await changePass({'oldPassword': oldPassword, 'newPassword': newPassword}, context);
      Fluttertoast.showToast(msg: data['message']);
      if (data['success'] == true) {
        Navigator.pushNamedAndRemoveUntil(
            context, 'SignPage', (router) => router == null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.reply, color: Colors.white,),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            );
          },
        ), 
        centerTitle: true,
        title: new Text(
          '修改密码',
          style: new TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(50, 20, 50, 0),
        child: _getBody()
      ),
    );
  }

  _getBody() {
    return ListView(children: <Widget>[
      Form(
          // 将 key 设置给表单，用于判断表单是否有效
          key: _formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                // 表单输入框，参数同 TextField 基本类似
                child: TextFormField(
                  obscureText: true,
                  controller: _usernameController,
                  style: TextStyle(color: Color.fromARGB(200, 0, 0, 0), fontSize: 16.0),
                  decoration: InputDecoration(
                      icon: Icon(Icons.account_box, size: 24.0, color: Color.fromARGB(150, 0, 0, 0)),
                      labelText: '请输入原密码',
                      labelStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0)),
                      helperStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0))),
                  validator: (value) => value.trim().isEmpty ? '原密码不能为空' : null,
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
                padding: const EdgeInsets.only(top: 30.0),
                child: SizedBox(
                  child: RaisedButton(
                      color: Colors.lightBlueAccent,
                      padding: EdgeInsets.fromLTRB(50, 7, 50, 7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24.0))
                      ),
                      onPressed: _changePass,
                      child: Text(
                        '修 改',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      )),
                ),
              )
            ],
          )),

    ],);
  }
}