import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/base_appbar.dart';
import '../../../common/box.dart';
import '../../../common/jh_count_down_btn.dart';
import '../../../common/jh_login_text_field.dart';
import '../../../common/kcolors.dart';
import '../../../common/keyboard_util.dart' show KeyboardUtils;
import 'index.dart';

class RegiserPage extends GetView<RegiserController> {
  const RegiserPage({super.key});

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
                maxLength: 30,
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
                hintText: '请输入密码',
                keyboardType: TextInputType.text,
                isPwd: true,
                inputCallBack: (value) => controller.pwd = value,
                border: InputBorder.none,
              ),
            ),
            vBox(20),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 15),
            //   decoration: const BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.all(Radius.circular(10)),
            //   ),
            //   child: JhLoginTextField(
            //     controller: controller.inviteCodeController,
            //     hintText: 'zEkPo8YX',
            //     keyboardType: TextInputType.text,
            //     inputCallBack: (value) => controller.inviteCode = value,
            //     border: InputBorder.none,
            //   ),
            // ),
            Container(
              alignment: Alignment.centerLeft,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Text('hIq7DXCl'),
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
                  getCodeText: '获取验证码',
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
                controller.regiser();
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(22)),
                child: Text(
                  '注册',
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
    return GetBuilder<RegiserController>(
      init: RegiserController(),
      id: "regiser",
      builder: (_) {
        return Scaffold(
          backgroundColor: KColors.MainColor,
          appBar: const BaseAppBar(
            '注册',
            bgColor: Colors.transparent,
          ),
          body: SafeArea(
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  KeyboardUtils.hideKeyboard(context);
                },
                child: _buildView()),
          ),
        );
      },
    );
  }
}
