import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/dio_http/toast_util.dart';
import '../../../common/my/base_controller.dart';

class ForgetpwdController extends BaseGetController {
  ForgetpwdController();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  String email = '';
  String password = '';
  String code = '';
  bool isSendCode = false;

  _initData() {
    update(["forgetpwd"]);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  //重置密码
  resetPwd() {
    if (email.isEmpty) {
      ToastUtils.toast("请输入邮箱");
      return;
    }
    if (password.isEmpty) {
      ToastUtils.toast("请输入新密码");
      return;
    }
    if (code.isEmpty) {
      ToastUtils.toast("请输入验证码");
      return;
    }
    request.requestResetPwd(
      email,
      password,
      code,
      success: (data) {
        if (data) {
          ToastUtils.toast("重置密码成功");
          Get.back();
        }
      },
      fail: (code, msg) {},
    );
  }

  //获取验证码
  getCode() {
    if (email.isEmpty) {
      ToastUtils.toast("请输入邮箱");
      return;
    }
    isSendCode = true;
    //发送验证码
    request.requestSendCode(email, success: (data) {
      ToastUtils.toast("验证码已发送");
    }, fail: (code, msg) {
      isSendCode = false;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    codeController.dispose();
    super.dispose();
  }
}
