class AppUpdateModel {
  String apkUrl;
  String apkName;
  String title;
  String content;
  String version;
  int forcedUpgrade; //是否强制升级 1 是 0 否

  AppUpdateModel(this.apkUrl, this.apkName, this.title, this.content,
      this.version, this.forcedUpgrade);

  factory AppUpdateModel.fromJson(Map<String, dynamic> json) {
    return AppUpdateModel(
      json['apkUrl'],
      json['apkName'],
      json['title'],
      json['content'],
      json['version'],
      json['forcedUpgrade'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['apkUrl'] = apkUrl;
    data['apkName'] = apkName;
    data['title'] = title;
    data['content'] = content;
    data['version'] = version;
    data['forcedUpgrade'] = forcedUpgrade;
    return data;
  }
}
