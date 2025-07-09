import 'package:dio/dio.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/dio_http/toast_util.dart';
import '../../../common/jh_sp_utils.dart';
import '../../../common/my/base_controller.dart';
import '../../../common/routers/names.dart';
import '../../../common/services/user_info_model/user_info.dart' show UserInfo;
import '../../../enum/enum.dart';
import '../../../state.dart';

class LoginController extends BaseGetController {
  LoginController();
  //用户名
  String usreName = JhSpUtils.getString("userName") ?? '';
  //密码
  String pwd = JhSpUtils.getString("userPwd") ?? '';
  bool isRememberAccount = JhSpUtils.getBool("isRememberAccount") ?? false;
  TextEditingController phonereController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    if (isRememberAccount) {
      phonereController.text = JhSpUtils.getString("userName") ?? '';
      passwordController.text = JhSpUtils.getString("userPwd") ?? '';
    }
    //  await getIPAddress();
  }

  Future<String> getIPAddress() async {
    Dio dio = Dio();
    try {
      //备用地址: https://ipinfo.io/json
      final result = await dio.get('https://ipinfo.io/json');

      if (result.statusCode == 200) {
        UserInfo.instance.ip = result.data['ip'];
        if (kDebugMode) {
          print('📶 获取到的公网IP地址: ${result.data}');
        }
        return result.data.toString();
      }
    } catch (e) {
      // IDKitLog.error('Failed to get IP address: $e');
    }
    return '';
  }

  updateCheckbox(bool value) {
    isRememberAccount = value;
    JhSpUtils.saveBool('isRememberAccount', value);
    update(["login"]);
  }

  //登录方法
  login() {
    if (usreName.isEmpty) {
      ToastUtils.toast("请输入用户名");
      return;
    }
    if (pwd.isEmpty) {
      ToastUtils.toast("请输入密码");
      return;
    }
    ToastUtils.show('登录中...');
    request.requestLogin(
      usreName,
      pwd,
      success: (data) {
        if (data.auth_data != null) {
          ToastUtils.dismiss();
          SpUtil.putString('token', data.auth_data!);
          SpUtil.putString('userName', usreName);
          SpUtil.putString('userPwd', pwd);

          Future.delayed(const Duration(seconds: 1), () {
            globalState.appController.toPage(PageLabel.dashboard);
            Get.offAllNamed(RouteNames.home);
          });
        }
      },
      fail: (code, msg) {
        ToastUtils.dismiss();
      },
    );
  }

  //去注册页
  goRegister() {
    Get.toNamed(RouteNames.systemRegiser);
  }

  //忘记密码
  goForgetPwd() {
    Get.toNamed(RouteNames.systemForgetPwd);
  }
}
