import 'package:flutter/material.dart';
// import 'package:fluro/fluro.dart';
// import 'package:feapp/router/router.dart';
// import 'package:feapp/router/application.dart';
import 'package:feapp/pages/splash_page.dart';
import 'package:feapp/pages/index_page.dart';
import 'package:feapp/pages/sign_page.dart';

void main() {
  // 注册 fluro routes
  // Router router = Router();
  // Routes.configureRoutes(router);
  // Application.router = router;

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: '清竹茶馆',
        // onGenerateRoute: Application.router.generator,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.lightBlueAccent
        ),
        home: SplashPage(),
        routes: <String, WidgetBuilder> {
          'IndexPage': (BuildContext context) => IndexPage(),
          'SignPage': (BuildContext context) => SignPage()
        },
        // routes: <String, WidgetBuilder>{
        //   '/': (BuildContext context) => new ArticleListScreen(),
        //   '/new': (BuildContext context) => new NewArticle(),
        // },
      )
    );
  }
}
