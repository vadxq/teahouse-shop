import 'package:feapp/pages/me_pages/about_page.dart';
import 'package:feapp/pages/me_pages/pass_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:feapp/pages/me_pages/orders_page.dart';
import 'package:feapp/pages/me_pages/info_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:feapp/service/service_methods.dart';
import 'package:feapp/provides/app_state.dart';
import 'package:provider/provider.dart';

class MePage extends StatefulWidget {
  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1794)..init(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(222, 222, 222, 0.6),
      // appBar: AppBar(title: Text('我的'),),
      body: _getBody(),
    );
  }

  var userInfo;
  
  @override
  void initState() {
    _loadData();
    super.initState();
  }
  
  // 推出登陆
  _removeData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove('token');
      prefs.remove('uid');
    });
    Fluttertoast.showToast(msg: '退出成功');
    Provider.of<AppState>(context).updateIsLogin(false);
  }

  // 拨打电话
  _launchURL() async {
    const url = 'tel:+86 176793786618';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  
  _loadData() async{
    var data = await getUserInfo(context);
    if(data['success']) {
      setState(() {
        userInfo = {
          'uid': data['data']['uid'],
          'email': data['data']['email'],
          'username': data['data']['username'],
          'phone': data['data']['phone'],
          'avtor': data['data']['avtor'],
        };
      });
    } else {
      Fluttertoast.showToast(msg: data['message']);
    }
  }

  _outLogin() async{
    Navigator.pushNamedAndRemoveUntil(
      context, "SignPage", (router) => router == null);
  }

  _getBody() {
    if (Provider.of<AppState>(context).isLogin) {
      return Container(
        child: ListView(
          children: <Widget>[
            _topHeader(),
            _firstActionList(),
            _secondActionList(),
          ],
        ),
      );
    } else {
      return Center(
        child: FlatButton(
          padding: EdgeInsets.all(0),
          color: Colors.lightBlueAccent,
          child: Text(
            '登陆/注册',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              // height: 1.4,
            ),
          ),
          onPressed: () {
            _outLogin();
          },
        ),
      );
    }
  }
  
  // 头像
  Widget _topHeader() {
    return Container(
      width: ScreenUtil().setWidth(1080),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
      color: Colors.lightBlueAccent[100],
      child: Column(children: <Widget>[
        Container(
          width: 110,
          height: 110,
          margin: EdgeInsets.only(top:30),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(userInfo['avtor']),
              fit: BoxFit.cover
            )
          ),
        ),
        Container(
          margin: EdgeInsets.only(top:10),
          child: Text(
            userInfo['username'],
            style: TextStyle(
              fontSize: ScreenUtil().setSp(54),
              color: Colors.white,
            ),
          ),
        )
      ],),
    );
  }

  // 我的订单/个人信息/修改密码列表
  Widget _firstActionList(){
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Column(
        children: <Widget>[
          _listTile('我的订单', Icons.assignment, OrdersPage()),
          _listTile('个人信息', Icons.person_outline, InfoPage()),
          _listTile('修改密码', Icons.lock_outline, PassPage()),
        ],
      ),
    );
  }

  // 关于我们/客服咨询/退出登录列表
  Widget _secondActionList(){
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Column(
        children: <Widget>[
          _listTile('关于我们', Icons.info_outline, AboutPage()),
          _myTelTile(),
          _loginOutTile(),
        ],
      ),
    );
  }

  // 生成item
  // title, icon, navigator
  Widget _listTile(title, icon, navigator) {
    return Container(
      // margin: EdgeInsets.only(top:20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,color: Colors.black12
          )
        ),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Icon(Icons.arrow_right),
        onTap: (){
          // IndexP;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => navigator
            ),
          );
          // Navigator.of(context).pushNamed('/');
        },
      ),
    );
  }

  Widget _myTelTile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,color: Colors.black12
          )
        ),
      ),
      child: ListTile(
        leading: Icon(Icons.stay_current_portrait),
        title: Text('客服电话'),
        trailing: Icon(Icons.arrow_right),
        onTap: (){
          _launchURL();
          // IndexP;
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (BuildContext context) => new MemberInfoPage()
          //   ),
          // );
          // Navigator.of(context).pushNamed('/');
        },
      ),
    );
  }

  // 退出登陆
  Widget _loginOutTile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,color: Colors.black12
          )
        ),
      ),
      child: ListTile(
        leading: Icon(Icons.delete_outline),
        title: Text('退出登录'),
        trailing: Icon(Icons.arrow_right),
        onTap: (){
          _removeData();
        },
      ),
    );
  }
}
