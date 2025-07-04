// import '../index.dart';

import '../../models/notice_model.dart';
import '../../models/order_model.dart';
import '../../models/plan_model.dart';
import '../../models/suscription_model.dart';
import '../../models/user_infomessage_model.dart';
import '../app_config.dart';
import '../dio_http/function.dart';
import '../dio_http/index.dart';
import '../jh_encrypt_utils.dart';
import '../jh_sp_utils.dart';
import '../services/user_info_model/user_info.dart';
import '../services/user_info_model/user_model.dart' show UserModel;

typedef SuccessOver<T> = Function(T data, bool over);

class HomeApi {
  //登录
  requestLogin(String email, String password,
      {Success<UserModel>? success, Fail? fail}) {
    var url = AppConfig.apiLogin;
    HttpUtils.post(
      url,
      {'email': email, 'password': password},
      success: (data) {
        UserModel model = UserModel.fromJson(data['data']);

        if (success != null) {
          success(model);
        }
      },
      fail: (code, msg) {
        if (fail != null) {
          fail(code, msg);
        }
      },
    );
  }

  //注册
  requestRegister(
      String email, String password, String inviteCode, String emailCode,
      {Success<UserModel>? success, Fail? fail}) {
    var url = AppConfig.apiRegister;
    HttpUtils.post(
      url,
      {
        'email': email,
        'password': password,
        'invite_code': inviteCode,
        'email_code': emailCode
      },
      success: (data) {
        UserModel model = UserModel.fromJson(data['data']);
        if (success != null) {
          success(model);
        }
      },
      fail: (code, msg) {
        if (fail != null) {
          fail(code, msg);
        }
      },
    );
  }

  //重置密码
  requestResetPwd(String email, String password, String emailCode,
      {Success<bool>? success, Fail? fail}) {
    var url = AppConfig.apiResetPassword;
    HttpUtils.post(
      url,
      {'email': email, 'password': password, 'email_code': emailCode},
      success: (data) {
        bool result = data['data'];
        if (success != null) {
          success(result);
        }
      },
      fail: (code, msg) {
        if (fail != null) {
          fail(code, msg);
        }
      },
    );
  }

  //发送验证码
  requestSendCode(String email,
      {Success<Map<String, dynamic>>? success, Fail? fail}) {
    var url = AppConfig.apiSendCode;
    HttpUtils.post(
      url,
      {'email': email},
      success: (data) {
        if (success != null) {
          success(data);
        }
      },
      fail: (code, msg) {
        if (fail != null) {
          fail(code, msg);
        }
      },
    );
  }

  //获取用户信息
  requestUserInfo({Success<UserInfoMessageModel>? success, Fail? fail}) {
    var url = AppConfig.apiGetUserInfo;
    HttpUtils.get(
      url,
      {},
      success: (data) {
        UserInfoMessageModel model = UserInfoMessageModel.fromJson(data);
        if (success != null) {
          success(model);
        }
      },
      fail: (code, msg) {
        if (fail != null) {
          fail(code, msg);
        }
      },
    );
  }

  //购买套餐
  requestBuyVip({Success<List<Plan>>? success, Fail? fail}) {
    var url = AppConfig.apiBuyVip;
    HttpUtils.get(
      url,
      {},
      success: (data) {
        var resultData = (data["data"] as List)
            .cast<Map<String, dynamic>>()
            .map((json) => Plan.fromJson(json))
            .toList();
        if (success != null) {
          success(resultData);
        }
      },
      fail: (code, msg) {
        if (fail != null) {
          fail(code, msg);
        }
      },
    );
  }

  //订单列表
  requestOrderList({Success<List<Order>>? success, Fail? fail}) {
    var url = AppConfig.apiOrderList;
    HttpUtils.get(
      url,
      {},
      success: (data) {
        final ordersJson = data["data"] as List;
        if (success != null) {
          success(ordersJson
              .map((json) => Order.fromJson(json as Map<String, dynamic>))
              .toList());
        }
      },
      fail: (code, msg) {
        if (fail != null) {
          fail(code, msg);
        }
      },
    );
  }

  //取消订单
  requestOrderCancel(String tradeNo, {Success<bool>? success, Fail? fail}) {
    var url = AppConfig.apiOrderCancel;
    HttpUtils.post(
      url,
      {'trade_no': tradeNo},
      success: (data) {
        bool result = data['data'];
        if (success != null) {
          success(result);
        }
      },
      fail: (code, msg) {
        if (fail != null) {
          fail(code, msg);
        }
      },
    );
  }

  //创建订单
  requestOrderCreate(String planId, String period,
      {Success<Map<String, dynamic>>? success, Fail? fail}) {
    var url = AppConfig.apiOrderCreate;
    HttpUtils.post(url, {'plan_id': planId, 'period': period}, success: (data) {
      if (success != null) {
        success(data);
      }
    }, fail: (code, msg) {});
  }

  //获取公告
  requestNotice({Success<List<NoticeModel>>? success, Fail? fail}) {
    var url = AppConfig.apiGetNotice;
    HttpUtils.get(
      url,
      {},
      success: (data) {
        var resultData = (data["data"] as List)
            .cast<Map<String, dynamic>>()
            .map((json) => NoticeModel.fromJson(json))
            .toList();
        if (success != null) {
          success(resultData);
        }
      },
      fail: (code, msg) {
        if (fail != null) {
          fail(code, msg);
        }
      },
    );
  }

  //获取支付方式
  requestOrderPayWay({Success<List<dynamic>>? success, Fail? fail}) {
    var url = AppConfig.apiGetPayWay;
    HttpUtils.get(
      url,
      {},
      success: (data) {
        var resultData = data["data"] as List;
        if (success != null) {
          success(resultData);
        }
      },
      fail: (code, msg) {
        if (fail != null) {
          fail(code, msg);
        }
      },
    );
  }

  //计算订单
  requestOrderCalc(String tradeNo, String method,
      {Success<Map<String, dynamic>>? success, Fail? fail}) {
    var url = AppConfig.apiOrderPay;
    HttpUtils.post(url, {'trade_no': tradeNo, 'method': method},
        success: (data) {
      if (success != null) {
        success(data);
      }
    }, fail: (code, msg) {
      if (fail != null) {
        fail(code, msg);
      }
    });
  }

  //获取订阅连接
  requestSubscribeUrl({Success<SubscriptionModel>? success, Fail? fail}) {
    var url = AppConfig.apiGetSubscribeUrl;
    var resultData = JhSpUtils.getModel('userInfo');
    UserInfoMessageModel userInfoMessageModel = UserInfoMessageModel();
    var uuid = '';
    var ip = UserInfo.instance.ip ?? '';
    if (resultData != null) {
      userInfoMessageModel = UserInfoMessageModel.fromJson(resultData);
      uuid = userInfoMessageModel.data?.uuid ?? '';
    }
    var key = JhEncryptUtils.aesEncrypt('$uuid:$ip');

    HttpUtils.get(url, UserInfo.instance.isConnectVPN ? {} : {'t': key},
        success: (data) {
      SubscriptionModel model = SubscriptionModel.fromJson(data['data']);
      if (success != null) {
        success(model);
      }
    }, fail: (code, msg) {
      if (fail != null) {
        fail(code, msg);
      }
    });
  }

  //订单详情
  requsestDetail(String tradeNo, {Success<Order>? success, Fail? fail}) {
    var url = '${AppConfig.apiOrderDetail}?trade_no=$tradeNo';
    HttpUtils.get(
      url,
      {},
      success: (data) {
        Order model = Order.fromJson(data['data']);
        if (success != null) {
          success(model);
        }
      },
      fail: (code, msg) {
        if (fail != null) {
          fail(code, msg);
        }
      },
    );
  }

  //佣金转入
  requestCommissionTransfer(String transferAmount,
      {Success<bool>? success, Fail? fail}) {
    var url = AppConfig.apiSendCode;
    HttpUtils.post(
      url,
      {'transfer_amount': transferAmount},
      success: (data) {
        bool result = data['data'];
        if (success != null) {
          success(result);
        }
      },
      fail: (code, msg) {
        if (fail != null) {
          fail(code, msg);
        }
      },
    );
  }

  ///分割线
}
