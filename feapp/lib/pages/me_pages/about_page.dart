import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
          '关于我们',
          style: new TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center(
        child: Container(
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
                  image: NetworkImage('https://qnimg.vadxq.com/blog/2017/logo.jpg'),
                  fit: BoxFit.cover
                )
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:20),
              child: Text(
                '清竹茶馆',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:15),
              child: Text(
                '做有故事的茶馆',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:30),
              child: Text(
                '欢迎各位客官前来品尝~',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:5),
              child: Text(
                '与身边的你的那一位',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:5),
              child: Text(
                '说说故事，喝喝茶',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:5),
              child: Text(
                '多么惬意与幸福',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          ),
        )
      ),
    );
  }
}