import 'package:fl_clash/common/jh_extension.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/box.dart';
import '../../../common/dio_http/toast_util.dart';
import '../../../common/ex_decoration.dart';
import '../../../common/jh_screen_utils.dart';
import '../../../common/jh_sp_utils.dart';
import '../../../common/my/base_controller.dart';
import '../../../common/my/base_controller_mixin.dart';
import '../../../common/my/jh_dialog_comm.dart';
import '../../../common/services/event_bus/event_bus.dart';
import '../../../models/order_model.dart';
import '../../../models/pay_type_model.dart';
import '../../../models/plan_model.dart';
import '../../../models/user_infomessage_model.dart';
import '../../../models/vip_price_model.dart';
import 'widgets/pay_type_cell.dart';

class VipSubChannelController extends BaseGetController
    with BaseControllerMixin {
  VipSubChannelController();

  Plan model = Get.arguments;
  // 价格模型
  List<VipPriceModel> datas = [];
  // 选择的模型
  VipPriceModel choosedModel = VipPriceModel();
  //用户信息
  UserInfoMessageModel userInfoMessageModel = UserInfoMessageModel();
  // 订单号
  String tradeNo = '';
  // 选择的支付方式id
  String selectedMethod = '';
  // 真实支付金额
  String realPayMoney = '0.0';
  // 支付方式
  List<PayTypeModel> payTypeList = [];
  @override
  void onReady() {
    super.onReady();
    var resultData = JhSpUtils.getModel('userInfo');
    if (resultData != null) {
      userInfoMessageModel = UserInfoMessageModel.fromJson(resultData);
    }
    _formatPrice();
  }

  // 格式化数据
  _formatPrice() {
    if (model.monthPrice != null) {
      datas.add(VipPriceModel(
          title: '月付',
          ischoosed: false,
          type: 'month_price',
          price: '${model.monthPrice}'));
    }
    if (model.quarterPrice != null) {
      datas.add(VipPriceModel(
        title: '季付',
        ischoosed: false,
        type: 'quarter_price',
        price: '${model.quarterPrice}',
      ));
    }
    if (model.halfYearPrice != null) {
      datas.add(VipPriceModel(
        title: '半年',
        ischoosed: false,
        type: 'half_year_price',
        price: '${model.halfYearPrice}',
      ));
    }
    if (model.yearPrice != null) {
      datas.add(VipPriceModel(
        title: '一年',
        ischoosed: false,
        type: 'year_price',
        price: '${model.yearPrice}',
      ));
    }
    if (model.twoYearPrice != null) {
      datas.add(VipPriceModel(
        title: '两年',
        ischoosed: false,
        type: 'two_year_price',
        price: '${model.twoYearPrice}',
      ));
    }
    if (model.threeYearPrice != null) {
      datas.add(VipPriceModel(
        title: '三年',
        ischoosed: false,
        type: 'three_year_price',
        price: '${model.threeYearPrice}',
      ));
    }

    if (model.onetimePrice != null) {
      datas.add(VipPriceModel(
        title: '一次性',
        ischoosed: false,
        type: 'onetime_price',
        price: '${model.onetimePrice}',
      ));
    }
    choosedModel = datas.first;
    choosedModel.ischoosed = true;

    realPayMoney = userInfoMessageModel.data != null &&
            userInfoMessageModel.data!.balance / 100.0 >=
                choosedModel.price!.jhToNum
        ? '0.0'
        : (choosedModel.price.jhToNum -
                (userInfoMessageModel.data?.balance ?? 0.0) / 100.0)
            .toStringAsFixed(2);

    update(["vip_sub_channel"]);
  }

  //选择价格
  onTap(VipPriceModel model) {
    for (var element in datas) {
      element.ischoosed = false;
    }
    model.ischoosed = true;
    choosedModel = model;
    realPayMoney = userInfoMessageModel.data != null &&
            userInfoMessageModel.data!.balance / 100.0 >=
                choosedModel.price.jhToNum
        ? '0.0'
        : (choosedModel.price.jhToNum -
                (userInfoMessageModel.data?.balance ?? 0.0) / 100.0)
            .toStringAsFixed(2);

    update(["vip_sub_channel"]);
  }

  // 订阅事件
  buy() {
    ToastUtils.show('加载中...');
    request.requestOrderList(
      success: (data) {
        if (data.isNotEmpty) {
          for (var order in data) {
            // 未支付
            if (order.status == 0) {
              //取消订单
              cancel_order(order);
            }
          }
        }
        //创建订单
        create_order();
      },
      fail: (code, msg) {},
    );
  }

  // 取消订单
  cancel_order(Order order) {
    request.requestOrderCancel(
      order.tradeNo!,
      success: (data) {},
      fail: (code, msg) {},
    );
  }

  //创建订单
  create_order() {
    request.requestOrderCreate(
      model.id.toString(),
      choosedModel.type ?? '',
      success: (data) {
        if (data['data'] == null) {
          return;
        }
        tradeNo = data['data'].toString();

        print("订单创建成功 订单号$tradeNo");
        //获取支付方法
        request.requestOrderPayWay(
          success: (data) {
            if (data.isEmpty) {
              return;
            }
            ToastUtils.dismiss();
            payTypeList.clear();
            // 支付方式模型
            for (var element in data) {
              payTypeList.add(PayTypeModel.fromJson(element));
            }
            //默认选择第一个
            payTypeList.first.isChoosed = true;
            selectedMethod = payTypeList.first.id ?? '';
            //显示弹框
            JhDialogComm.payAlert(
              child: GetBuilder<VipSubChannelController>(
                id: "pay_dialog",
                builder: (_) {
                  return Container(
                    width: JhScreenUtils.screenWidth - 40,
                    padding: EdgeInsets.only(
                        top: 20,
                        left: 20,
                        right: 20,
                        bottom: JhScreenUtils.bottomSafeHeight),
                    decoration: BoxDecorationExtension.circularBorder(
                        radius: 10, backgroundColor: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '选择支付方式',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '应付金额:￥$realPayMoney',
                          style:
                              const TextStyle(fontSize: 15, color: Colors.red),
                        ),
                        vBox(10),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          itemCount: payTypeList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return PayTypeCell(
                              model: payTypeList[index],
                              onTap: (model) {
                                for (var element in payTypeList) {
                                  element.isChoosed = false;
                                }
                                model.isChoosed = true;
                                selectedMethod = model.id ?? '';
                                update(["pay_dialog"]);
                              },
                            );
                          },
                        ),
                        vBox(30),
                        GestureDetector(
                          onTap: () {
                            handlePayment();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red),
                            width: JhScreenUtils.screenWidth - 40,
                            height: 40,
                            child: const Text(
                              '支付',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        vBox(10),
                        GestureDetector(
                          onTap: () {
                            SmartDialog.dismiss();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red),
                            width: JhScreenUtils.screenWidth - 40,
                            height: 40,
                            child: const Text(
                              '关闭',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        vBox(10),
                      ],
                    ),
                  );
                },
              ),
            );
            update(["vip_sub_channel"]);
          },
          fail: (code, msg) {
            ToastUtils.dismiss();
          },
        );
      },
      fail: (code, msg) {
        ToastUtils.dismiss();
      },
    );
  }

  //支付:结算订单
  handlePayment() {
    var userName = SpUtil.getString('userName') ?? '';
    request.requestOrderCalc(
      tradeNo,
      selectedMethod,
      success: (response) {
        print('支付:结算订单成功 $response');
        // 获取 type 和 data 字段
        final type = response['type'];
        final data = response['data'];
        // 确保 type 是 int 并且 data 是期望的类型
        if (type is int) {
          // 如果 type 为 -1 且 data 为 true，表示订单已通过钱包余额支付成功
          if (type == -1 && data == true) {
            // 处理支付成功逻辑
            SmartDialog.dismiss();
            sendEvent(UpdateSubscribeEvent('update_subscribe'));
            ToastUtils.toast('支付成功');

            return;
          }
          // 如果 type 为 1 且 data 是 String 类型，认为它是支付链接
          if (type == 1 && data is String) {
            openPaymentUrl(data); // 打开支付链接
            return;
          }
        }

        SmartDialog.dismiss();
      },
      fail: (code, msg) {
        SmartDialog.dismiss();
      },
    );
  }

//打开支付链接
  void openPaymentUrl(String paymentUrl) {
    LogUtil.d('打开支付链接: $paymentUrl');
    final Uri url = Uri.parse(paymentUrl);
    launchUrl(url);
  }

  //监听订单状态
  void monitorOrderStatus() {
    request.requsestDetail(
      tradeNo,
      success: (order) {
        if (order.status == 3) {
          // 订单已支付，处理支付成功逻辑
          ToastUtils.toast('支付成功');
          sendEvent(UpdateSubscribeEvent('update_subscribe'));
          SmartDialog.dismiss();
        } else if (order.status == 0) {
          // 订单支付失败，处理支付失败逻辑
          SmartDialog.dismiss();
        } else if (order.status == 2) {
          // 订单支付失败，处理支付失败逻辑
          SmartDialog.dismiss();
        }
      },
      fail: (code, msg) {
        SmartDialog.dismiss();
      },
    );
  }

  /// 是否监听生命周期事件
  @override //  重写父类的listenLifecycleEvent属性，返回true表示监听生命周期事件
  bool get listenLifecycleEvent => true;
  @override
  void onResumed() {
    //  当页面恢复时调用，例如用户从其他应用返回当前应用时
    monitorOrderStatus();
  }
}
