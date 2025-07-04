import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/base_appbar.dart';
import '../../../common/box.dart';
import '../../../common/jh_login_text_field.dart';
import '../../../common/kcolors.dart';
import '../../../common/keyboard_util.dart';
import 'index.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  // 主视图
  Widget _buildView() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: JhLoginTextField(
                controller: controller.phonereController,
                hintText: '请输入用户名',
                text: controller.phonereController.text,
                maxLength: 30,
                inputCallBack: (value) => controller.usreName = value,
                border: InputBorder.none,
                keyboardType: TextInputType.text,
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
                isPwd: true,
                text: controller.passwordController.text,
                keyboardType: TextInputType.text,
                inputCallBack: (value) => controller.pwd = value,
                border: InputBorder.none,
                maxLength: 30,
              ),
            ),
            vBox(30),
            Row(children: [
              Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: controller.isRememberAccount,
                      onChanged: (value) {
                        controller.updateCheckbox(value!);
                      },
                    ),
                  ),
                  hBox(10),
                  const Text('记住密码')
                ],
              ),
              const Spacer(),
              GestureDetector(
                  onTap: () {
                    controller.goForgetPwd();
                  },
                  child: Container(
                      width: 100,
                      height: 30,
                      alignment: Alignment.center,
                      child: const Text('忘记密码')))
            ]),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                controller.login();
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(22)),
                child: Text(
                  '登录',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {
                controller.goRegister();
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 44,
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
    return GetBuilder<LoginController>(
      init: LoginController(),
      id: "login",
      builder: (_) {
        return Scaffold(
          backgroundColor: KColors.MainColor,
          appBar: BaseAppBar(
            '登录',
            bgColor: Colors.transparent,
            leftWidget: Container(),
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
