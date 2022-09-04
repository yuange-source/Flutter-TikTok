import 'package:fluro/fluro.dart';
import 'package:flutter_tiktok/routers/common/router_init.dart';
import 'package:flutter_tiktok/pages/homePage.dart';

class HomeRouter implements IRouterProvider {
  static String homePage = "/home/index";

  @override
  void initRouter(FluroRouter router) {
    router.define(homePage,
        handler: Handler(handlerFunc: (_, params) => HomePage()));
  }
}
