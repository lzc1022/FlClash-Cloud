import 'package:get/get.dart';

import '../api/home_api.dart';

/// @description :基类 Controller
class BaseGetController extends GetxController {
  ///HTTP请求仓库
  late HomeApi request;

  @override
  void onInit() {
    super.onInit();
    request = Get.find<HomeApi>();
  }
}
