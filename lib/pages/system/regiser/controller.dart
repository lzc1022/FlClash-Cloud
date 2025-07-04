import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/dio_http/toast_util.dart';
import '../../../common/my/base_controller.dart';
import '../../../common/routers/names.dart';

class RegiserController extends BaseGetController {
  RegiserController();

  //邮箱
  String email = '';
  //密码
  String pwd = '';
  //邀请码
  String inviteCode = 'hIq7DXCl';
  //验证码
  String code = '';
  //是否发送验证码
  bool isSendCode = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController inviteCodeController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  _initData() {
    update(["regiser"]);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

//注册方法
  regiser() async {
    if (email.isEmpty) {
      ToastUtils.toast("请输入邮箱");
      return;
    }
    if (pwd.isEmpty) {
      ToastUtils.toast("请输入密码");
      return;
    }
    if (code.isEmpty) {
      ToastUtils.toast("请输入验证码");
      return;
    }
    //如果注册成功，直接登录
    ToastUtils.show('注册中...');
    request.requestRegister(
      email,
      pwd,
      inviteCode,
      code,
      success: (data) {
        if (data.auth_data != null) {
          ToastUtils.dismiss();
          SpUtil.putString('token', data.auth_data!);
          SpUtil.putString('userName', email);
          SpUtil.putString('userPwd', pwd);

          Get.offAllNamed(RouteNames.home);
        }
      },
      fail: (code, msg) {
        ToastUtils.toast('注册失败');
      },
    );
  }

  //获取验证码
  getCode() async {
    if (email.isEmpty) {
      ToastUtils.toast("请输入邮箱");
      return;
    }
    // 支持的邮箱后缀列表
    final List<String> allowedDomains = [
      'gmail.com',
      'qq.com',
      '163.com',
      'yahoo.com',
      'sina.com',
      '126.com',
      'outlook.com',
      'yeah.net',
      'foxmail.com',
      'techovax.com',
    ];

    // 提取域名部分
    final domain = email.split('@').length > 1 ? email.split('@')[1] : '';

    if (!allowedDomains.contains(domain)) {
      ToastUtils.toast("不支持的邮箱域名");
      return;
    }

    isSendCode = true;
    //发送验证码
    request.requestSendCode(email, success: (data) {
      ToastUtils.toast("验证码已发送");
    }, fail: (code, msg) {});
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    inviteCodeController.dispose();
    codeController.dispose();
    super.dispose();
  }
}
