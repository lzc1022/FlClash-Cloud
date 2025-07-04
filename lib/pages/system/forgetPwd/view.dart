import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/base_appbar.dart';
import '../../../common/box.dart';
import '../../../common/jh_count_down_btn.dart';
import '../../../common/jh_login_text_field.dart';
import '../../../common/kcolors.dart';
import 'index.dart';

class ForgetpwdPage extends GetView<ForgetpwdController> {
  const ForgetpwdPage({super.key});

  // 主视图
  Widget _buildView() {
    return SingleChildScrollView(
      child: Container(
        color: KColors.MainColor,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            vBox(60),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: JhLoginTextField(
                controller: controller.emailController,
                hintText: '请输入邮箱',
                keyboardType: TextInputType.text,
                inputCallBack: (value) => controller.email = value,
                border: InputBorder.none,
              ),
            ),
            vBox(20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: JhLoginTextField(
                controller: controller.passwordController,
                hintText: '请输入新密码',
                keyboardType: TextInputType.text,
                isPwd: true,
                inputCallBack: (value) => controller.password = value,
                border: InputBorder.none,
              ),
            ),
            vBox(20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: JhLoginTextField(
                controller: controller.codeController,
                hintText: '请输入验证码',
                keyboardType: TextInputType.number,
                inputCallBack: (value) => controller.code = value,
                border: InputBorder.none,
                rightWidget: JhCountDownBtn(
                  getCodeText: '发送验证码',
                  resendAfterText: '重新获取',
                  getVCode: () async {
                    controller.getCode();
                    return controller.isSendCode;
                  },
                ),
              ),
            ),
            vBox(40),
            GestureDetector(
              onTap: () {
                controller.resetPwd();
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(22)),
                child: Text(
                  '重置密码',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgetpwdController>(
      init: ForgetpwdController(),
      id: "forgetpwd",
      builder: (_) {
        return Scaffold(
          backgroundColor: KColors.MainColor,
          appBar: const BaseAppBar(
            '忘记密码',
            bgColor: Colors.transparent,
          ),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
