class PayTypeModel {
  String? name;
  String? icon;
  String? id;
  String? payment;
  String? handling_fee_percent;
  bool isChoosed = false;

  PayTypeModel({
    this.name,
    this.icon,
    this.id,
    this.payment,
    this.handling_fee_percent,
    this.isChoosed = false,
  });

  PayTypeModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    id = json['id'].toString();
    payment = json['payment'];
    isChoosed = json['isChoosed'] ?? false;
    handling_fee_percent = json['handling_fee_percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['icon'] = icon;
    data['id'] = id;
    data['payment'] = payment;
    data['isChoosed'] = isChoosed;
    data['handling_fee_percent'] = handling_fee_percent;
    return data;
  }
}
