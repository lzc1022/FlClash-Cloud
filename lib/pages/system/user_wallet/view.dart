import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/base_appbar.dart';
import '../../../common/box.dart';
import '../../../common/jh_login_text_field.dart';
import '../../../common/kcolors.dart';
import '../../../common/keyboard_util.dart';
import 'index.dart';
import 'widgets/wallet_cell.dart';

class UserWalletPage extends GetView<UserWalletController> {
  const UserWalletPage({super.key});

  // 主视图
  Widget _buildView() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            WalletCell(
              money: controller.money,
              commission: controller.commission,
            ),
            vBox(25),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      vBox(10),
                      const Text(
                        '佣金划转到余额',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      vBox(10),
                      Text('当前佣金余额:￥${controller.commission}'),
                      JhLoginTextField(
                        controller: controller.moneyController,
                        hintText: '请输入划转金额',
                        inputCallBack: (value) => controller.payMoney = value,
                        border: InputBorder.none,
                        maxLength: 30,
                      ),
                      vBox(10),
                      GestureDetector(
                        onTap: () {
                          controller.withdraw();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 44,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(22)),
                          child: Text(
                            '确认划转',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      vBox(10),
                      const Text(
                        '划转说明：佣金划转到余额后，只可用于购买套餐，不可提现',
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                      vBox(10),
                    ]))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserWalletController>(
      init: UserWalletController(),
      id: "user_wallet",
      builder: (_) {
        return Scaffold(
          backgroundColor: KColors.MainColor,
          appBar: const BaseAppBar('我的钱包', bgColor: Colors.transparent),
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
