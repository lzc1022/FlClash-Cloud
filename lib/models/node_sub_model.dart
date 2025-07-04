class NodeSubModel {
  String? name;
  String? url;
  bool isChoosed = false;
  NodeSubModel({this.name, this.url, this.isChoosed = false});
  NodeSubModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
    isChoosed = json['isChoosed'] ?? false;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['url'] = url;
    data['isChoosed'] = isChoosed;
    return data;
  }
}
