import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:feapp/pages/cart_page.dart';
import 'package:feapp/pages/home_page.dart';
import 'package:feapp/pages/me_page.dart';
import 'package:feapp/pages/memu_page.dart';
import 'package:feapp/provides/app_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  PageController _pageController;

  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(title: Text('首页'), icon: Icon(CupertinoIcons.home)),
    BottomNavigationBarItem(
        title: Text('菜单'), icon: Icon(CupertinoIcons.search)),
    BottomNavigationBarItem(
        title: Text('购物车'), icon: Icon(CupertinoIcons.shopping_cart)),
    BottomNavigationBarItem(
        title: Text('我的'), icon: Icon(CupertinoIcons.profile_circled)),
  ];

  final List<Widget> tabBodies = [
    HomePage(),
    MenuPage(),
    CartPage(),
    MePage(),
  ];

  int currentIndex = 0;
  var currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = tabBodies[currentIndex];
    _pageController = new PageController()
      ..addListener(() {
        if (currentPage != _pageController.page.round()) {
          setState(() {
            currentPage = _pageController.page.round();
          });
        }
      });
    _setLogin();
  }

  _setLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') != null && prefs.getString('uid') != null) {
      Provider.of<AppState>(context).updateIsLogin(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: bottomTabs,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            currentPage = tabBodies[currentIndex];
          });
        },
      ),
      body: IndexedStack(
        index: currentIndex,
        children: tabBodies,
      ),
    );
  }
}
