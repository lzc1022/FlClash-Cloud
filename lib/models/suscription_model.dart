class SubscriptionModel {
  int? planId;
  String? token;
  int? expiredAt;
  int? u;
  int? d;
  int? transferEnable;
  String? email;
  String? subscribeUrl;
  int? resetDay;
  PlanModel? plan;

  SubscriptionModel({
    this.planId,
    this.token,
    this.expiredAt,
    this.u,
    this.d,
    this.transferEnable,
    this.email,
    this.subscribeUrl,
    this.resetDay = 0,
    this.plan,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      planId: json['plan_id'],
      token: json['token'],
      expiredAt: json['expired_at'],
      u: json['u'],
      d: json['d'],
      transferEnable: json['transfer_enable'],
      email: json['email'],
      subscribeUrl: json['subscribe_url'],
      resetDay: json['reset_day'],
      plan: json['plan'] != null ? PlanModel.fromJson(json['plan']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan_id': planId,
      'token': token,
      'expired_at': expiredAt,
      'u': u,
      'd': d,
      'transfer_enable': transferEnable,
      'email': email,
      'subscribe_url': subscribeUrl,
      'reset_day': resetDay,
      'plan': plan?.toJson(),
    };
  }
}

class PlanModel {
  int? id;
  int? groupId;
  int? transferEnable;
  String? name;
  Map<String, dynamic>? prices;
  int? sell;
  int? speedLimit;
  int? deviceLimit;
  bool? show;
  int? sort;
  bool? renew;
  String? content;
  String? resetTrafficMethod;
  int? capacityLimit;
  int? createdAt;
  int? updatedAt;

  PlanModel({
    this.id,
    this.groupId,
    this.transferEnable,
    this.name,
    this.prices,
    this.sell,
    this.speedLimit,
    this.deviceLimit,
    this.show,
    this.sort,
    this.renew,
    this.content,
    this.resetTrafficMethod,
    this.capacityLimit,
    this.createdAt,
    this.updatedAt,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'],
      groupId: json['group_id'],
      transferEnable: json['transfer_enable'],
      name: json['name'],
      prices: json['prices'],
      sell: json['sell'],
      speedLimit: json['speed_limit'],
      deviceLimit: json['device_limit'],
      show: json['show'],
      sort: json['sort'],
      renew: json['renew'],
      content: json['content'],
      resetTrafficMethod: json['reset_traffic_method']?.toString(),
      capacityLimit: json['capacity_limit'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'transfer_enable': transferEnable,
      'name': name,
      'prices': prices,
      'sell': sell,
      'speed_limit': speedLimit,
      'device_limit': deviceLimit,
      'show': show,
      'sort': sort,
      'renew': renew,
      'content': content,
      'reset_traffic_method': resetTrafficMethod,
      'capacity_limit': capacityLimit,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
