import 'package:get/get.dart';

import '../../../models/notice_model.dart';

class NoticeController extends GetxController {
  NoticeController();
  List<NoticeModel> noticeList = Get.arguments ?? [];
  _initData() {
    update(["notice"]);
  }

  void onTap() {}

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
