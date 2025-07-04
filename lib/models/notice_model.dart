class NoticeModel {
  int id;
  String? title;
  String? content;
  int created_at;
  bool show = false;
  List<String>? tags;

  NoticeModel(this.id, this.title, this.content, this.created_at, this.tags);

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(json['id'], json['title'], json['content'],
        json['created_at'], List<String>.from(json['tags']));
  }

  Map<String, dynamic> toJson(NoticeModel noticeModel) {
    return {
      'id': noticeModel.id,
      'title': noticeModel.title,
      'content': noticeModel.content,
      'tags': noticeModel.tags,
      'created_at': noticeModel.created_at,
    };
  }
}
