class HistoryModel {
  String? name;
  String? url;
  String? ping;
  String? time;
  String? download;
  String? upload;
  HistoryModel({
    this.name,
    this.url,
    this.ping,
    this.time,
    this.download,
    this.upload,
  });
  factory HistoryModel.fromJson(Map<String,dynamic> json){
    return HistoryModel(
      name: json['name'],
      url: json['url'],
      ping: json['ping'],
      time: json['time'],
      download: json['download'],
      upload: json['upload'],
    );
  }
}
