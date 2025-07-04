class VipPriceModel {
  String? title;
  bool ischoosed;
  String? type;
  String? price;
  VipPriceModel({this.title, this.ischoosed = false, this.type, this.price});
  factory VipPriceModel.fromJson(Map<String, dynamic> json) {
    return VipPriceModel(
      title: json['title'],
      ischoosed: json['ischoosed'] ?? false,
      type: json['type'],
      price: json['price'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['ischoosed'] = ischoosed;
    data['type'] = type;
    data['price'] = price;
    return data;
  }
}
