import 'dart:async';

import 'package:fl_clash/common/jh_screen_utils.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../../../common/box.dart';
import '../../../common/dio_http/toast_util.dart';
import '../../../common/ex_decoration.dart';
import '../../../common/jh_device_utils.dart';
import '../../../common/jh_sp_utils.dart';
import '../../../common/my/base_controller.dart';
import '../../../common/routers/names.dart';
import '../../../common/services/event_bus/event_bus.dart';
import '../../../models/user_infomessage_model.dart';

class MineController extends BaseGetController {
  MineController();
  UserInfoMessageModel userInfoMessageModel = UserInfoMessageModel();
  //版本
  String version = '';
  String money = '余额0 佣金0';
  //订阅
  StreamSubscription? subscription;

  @override
  void onReady() async {
    super.onReady();
    version = await JhDeviceUtils.version();
    ToastUtils.show('加载中...');
    subscription = eventListen<UpdateSubscribeEvent>((event) {
      getUserInfo();
    });
    getUserInfo();
  }

  //获取用户信息
  getUserInfo() {
    request.requestUserInfo(
      success: (data) {
        userInfoMessageModel = data;
        money =
            '余额${(userInfoMessageModel.data?.balance ?? 0) / 100.0} 佣金${(userInfoMessageModel.data?.commissionBalance.toDouble() ?? 0) / 100.0}';
        update(["mine"]);
        JhSpUtils.saveModel('userInfo', userInfoMessageModel);
        ToastUtils.dismiss();
      },
      fail: (code, msg) {
        ToastUtils.dismiss();
      },
    );
  }

  //购买会员
  buyVip() {
    Get.toNamed(RouteNames.systemVipChannel);
  }

  //退出
  loginOut() {
    ToastUtils.toast('退出登录成功');
    JhSpUtils.remove('token');
    SpUtil.remove('token');
    Get.offAllNamed(RouteNames.systemLogin);
  }

  //退出登录
  logout() {
    SmartDialog.show(
        alignment: Alignment.bottomCenter,
        builder: (_) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: JhScreenUtils.bottomSafeHeight + 20),
            decoration: BoxDecorationExtension.circularBorderTop(
                radius: 10, backgroundColor: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                vBox(20),
                const Text(
                  '是否退出登录?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                vBox(20),
                GestureDetector(
                  onTap: () {
                    SmartDialog.dismiss();
                    loginOut();
                  },
                  child: const SizedBox(
                    width: 250,
                    child: Text(
                      '确定',
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                vBox(20),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    SmartDialog.dismiss();
                  },
                  child: const SizedBox(
                    width: 250,
                    child: Text(
                      textAlign: TextAlign.center,
                      '取消',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void onClose() {
    super.onClose();
    subscription?.cancel();
  }
}
