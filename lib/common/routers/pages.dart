import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pages/home.dart';
import '../../pages/system/forgetPwd/view.dart';
import '../../pages/system/login/view.dart';
import '../../pages/system/mine/view.dart';
import '../../pages/system/notice/view.dart';
import '../../pages/system/order_list/view.dart';
import '../../pages/system/regiser/view.dart';
import '../../pages/system/user_wallet/view.dart';
import '../../pages/system/vip_channel/view.dart';
import '../../pages/system/vip_sub_channel/view.dart';
import 'names.dart';
import 'observers.dart';

// 路由 Pages
class RoutePages {
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  // 列表
  static List<GetPage> list = [
    GetPage(
      name: RouteNames.home,
      page: () => const HomePage(),
    ),
    // GetPage(
    //   name: RouteNames.node,
    //   page: () => const NodePage(),
    // ),
    GetPage(
      name: RouteNames.systemLogin,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: RouteNames.systemRegiser,
      page: () => const RegiserPage(),
    ),
    GetPage(
      name: RouteNames.mine,
      page: () => const MinePage(),
    ),
    GetPage(
      name: RouteNames.systemForgetPwd,
      page: () => const ForgetpwdPage(),
    ),
    GetPage(
      name: RouteNames.systemVipChannel,
      page: () => const VipChannelPage(),
    ),
    GetPage(
      name: RouteNames.systemVipSubChannel,
      page: () => const VipSubChannelPage(),
    ),
    GetPage(
      name: RouteNames.systemOrderList,
      page: () => const OrderListPage(),
    ),
    GetPage(
      name: RouteNames.systemUserWallet,
      page: () => const UserWalletPage(),
    ),
    GetPage(
      name: RouteNames.systemNotice,
      page: () => const NoticePage(),
    ),
  ];
}
