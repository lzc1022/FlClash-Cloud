import 'package:flustars_flutter3/flustars_flutter3.dart';

import '../../../models/notice_model.dart';
import '../../../models/profile.dart';
import '../../../models/suscription_model.dart';
import 'user_model.dart';

class UserInfo {
  static final UserInfo _instance = UserInfo._internal();

  factory UserInfo() {
    return _instance;
  }
  static UserInfo get instance => _instance;

  UserInfo._internal();
  String? token;
  String? ip;
  Profile? profile;
  List<NoticeModel> noticeList = [];
  SubscriptionModel? subscriptionModel;
  String noticeContent = '暂无公告';
  bool isConnectVPN = false;
  String get getToken => SpUtil.getString('token') ?? '';
  UserModel? userModel;

  // 获取用户信息
  UserModel? getUserInfo() {
    return SpUtil.getObj(
        'userInfo', (v) => UserModel.fromJson(v as Map<String, dynamic>));
  }

  // 保存用户信息
  void saveUserInfo(UserModel userModel) {
    this.userModel = userModel;
    SpUtil.putObject('userInfo', userModel.toJson());
  }

  // 保存Map类型的用户信息
  void saveUserInfoMap(String key, Map<String, dynamic> value) {
    SpUtil.putObject(key, value);
  }

  // 获取Map类型的用户信息
  UserModel? getUserInfoMap(String key) {
    return SpUtil.getObj(
        key, (v) => UserModel.fromJson(v as Map<String, dynamic>));
  }

  // 保存token
  void saveToken(String token) {
    SpUtil.putString('token', token);
    this.token = token;
  }
}
