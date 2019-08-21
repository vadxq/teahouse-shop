import 'package:feapp/provides/app_state.dart';
import 'package:flutter/material.dart';
import 'package:feapp/pages/splash_page.dart';
import 'package:feapp/pages/index_page.dart';
import 'package:feapp/pages/sign_page.dart';
import 'package:provider/provider.dart';

void main() async{
  runApp(
    ChangeNotifierProvider(
      builder: (context) => AppState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: '清竹茶馆',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.lightBlueAccent
        ),
        home: SplashPage(),
        routes: <String, WidgetBuilder> {
          'IndexPage': (BuildContext context) => IndexPage(),
          'SignPage': (BuildContext context) => SignPage()
        },
      )
    );
  }
}
