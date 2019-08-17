import 'package:dio/dio.dart';
import 'dart:async';
// import 'dart:io';
import './../config/service_url.dart';

Future getHomePageContent() async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.get(servicePath['homePageContext']);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('err');
    }
  } catch(e) {
    print(e);
  }
}

Future getHomePageNew() async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.get(servicePath['homePageNew']);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('err');
    }
  } catch(e) {
    print(e);
  }
}

Future getMenuPageList(data) async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.get('${servicePath['menuPageList']}?page=${data['page']}&limit=${data['limit']}');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('err');
    }
  } catch(e) {
    print(e);
  }
}

Future loginPageData(data) async {
  try {
    Response response;
    print(data);
    Dio dio = new Dio();
    response = await dio.post(servicePath['loginPage'], data: data);
    print(response);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('err');
    }
  } catch(e) {
    print(e);
  }
}

Future joinPageData(data) async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.post(servicePath['joinPage'], data: data);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('err');
    }
  } catch(e) {
    print(e);
  }
}

