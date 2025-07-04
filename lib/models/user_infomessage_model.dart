// To parse this JSON data, do
//
//     final userInfoMessageModel = userInfoMessageModelFromJson(jsonString);

import 'dart:convert';

UserInfoMessageModel userInfoMessageModelFromJson(String str) =>
    UserInfoMessageModel.fromJson(json.decode(str));

String userInfoMessageModelToJson(UserInfoMessageModel data) =>
    json.encode(data.toJson());

class UserInfoMessageModel {
  Data? data;

  UserInfoMessageModel({
    this.data,
  });

  factory UserInfoMessageModel.fromJson(Map<String, dynamic> json) =>
      UserInfoMessageModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  final String email;
  final double transferEnable;
  final int? lastLoginAt; // 允许为 null
  final int createdAt;
  final bool banned; // 账户状态, true: 被封禁, false: 正常
  final bool remindExpire;
  final bool remindTraffic;
  final int? expiredAt; // 允许为 null
  double balance; // 消费余额
  final double commissionBalance; // 剩余佣金余额
  final int planId;
  final double? discount; // 允许为 null
  final double? commissionRate; // 允许为 null
  final String? telegramId; // 允许为 null
  final String uuid;
  final String avatarUrl;

  Data({
    required this.email,
    required this.transferEnable,
    this.lastLoginAt,
    required this.createdAt,
    required this.banned,
    required this.remindExpire,
    required this.remindTraffic,
    this.expiredAt,
    required this.balance,
    required this.commissionBalance,
    required this.planId,
    this.discount,
    this.commissionRate,
    this.telegramId,
    required this.uuid,
    required this.avatarUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        // 字符串字段，如果为 null，返回空字符串
        email: json['email'] as String? ?? '',

        // 转换为 double，如果为 null，返回 0.0
        transferEnable: (json['transfer_enable'] as num?)?.toDouble() ?? 0.0,

        // 时间字段可以为 null
        lastLoginAt: json['last_login_at'] as int?,

        // 确保 createdAt 为 int，并提供默认值
        createdAt: json['created_at'] as int? ?? 0,
        // 处理布尔值
        banned: json['banned'] == 1 || json['banned'] == true,
        remindExpire:
            json['remind_expire'] == true || json['remind_expire'] == 1,
        remindTraffic:
            json['remind_traffic'] == 1 || json['remind_traffic'] == true,

        // 允许 expiredAt 为 null
        expiredAt: json['expired_at'] as int?,

        // 转换 balance 为 double，并处理 null
        balance: ((json['balance'] as num?)?.toDouble() ?? 0.0),

        // 转换 commissionBalance 为 double，并处理 null
        commissionBalance:
            (json['commission_balance'] as num?)?.toDouble() ?? 0.0,

        // 保证 planId 是 int，提供默认值 0
        planId: json['plan_id'] as int? ?? 0,

        // 允许 discount 和 commissionRate 为 null
        discount: (json['discount'] as num?)?.toDouble(),
        commissionRate: (json['commission_rate'] as num?)?.toDouble(),

        // 允许 telegramId 为 null
        telegramId: json['telegram_id'] as String?,

        // uuid 和 avatarUrl，如果为 null 返回空字符串
        uuid: json['uuid'] as String? ?? '',
        avatarUrl: json['avatar_url'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "transfer_enable": transferEnable,
        "last_login_at": lastLoginAt,
        "created_at": createdAt,
        "banned": banned,
        "remind_expire": remindExpire,
        "remind_traffic": remindTraffic,
        "expired_at": expiredAt,
        "balance": balance,
        "commission_balance": commissionBalance,
        "plan_id": planId,
        "discount": discount,
        "commission_rate": commissionRate,
        "telegram_id": telegramId,
        "uuid": uuid,
        "avatar_url": avatarUrl,
      };
}
