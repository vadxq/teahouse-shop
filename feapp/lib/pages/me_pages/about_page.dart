import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
              '关于我们',
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil.getInstance().setWidth(48)),
            ),
            backgroundColor: Colors.lightBlueAccent,
          )),
      body: Center(
          child: Container(
        width: ScreenUtil().setWidth(1080),
        padding: EdgeInsets.fromLTRB(
            ScreenUtil.getInstance().setWidth(36),
            ScreenUtil.getInstance().setWidth(36),
            ScreenUtil.getInstance().setWidth(36),
            0),
        color: Colors.lightBlueAccent[100],
        child: Column(
          children: <Widget>[
            Container(
              width: ScreenUtil.getInstance().setWidth(300),
              height: ScreenUtil.getInstance().setWidth(300),
              margin:
                  EdgeInsets.only(top: ScreenUtil.getInstance().setWidth(96)),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://qnimg.vadxq.com/blog/2017/logo.jpg'),
                      fit: BoxFit.cover)),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: ScreenUtil.getInstance().setWidth(56)),
              child: Text(
                '清竹茶馆',
                style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setWidth(62),
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: ScreenUtil.getInstance().setWidth(36)),
              child: Text(
                '做有故事的茶馆',
                style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setWidth(52),
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: ScreenUtil.getInstance().setWidth(66)),
              child: Text(
                '欢迎各位客官前来品尝~',
                style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setWidth(42),
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: ScreenUtil.getInstance().setWidth(36)),
              child: Text(
                '与身边的你的那一位',
                style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setWidth(42),
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: ScreenUtil.getInstance().setWidth(36)),
              child: Text(
                '说说故事，喝喝茶',
                style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setWidth(42),
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: ScreenUtil.getInstance().setWidth(36)),
              child: Text(
                '多么惬意与幸福',
                style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setWidth(42),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
