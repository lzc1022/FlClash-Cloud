import '../../../common/dio_http/toast_util.dart';
import '../../../common/my/base_controller.dart';
import '../../../models/plan_model.dart';

class VipChannelController extends BaseGetController {
  VipChannelController();
  List<Plan> plans = [];

  _initData() {
    request.requestBuyVip(
      success: (data) {
        ToastUtils.dismiss();
        plans = data;
        update(["vip_channel"]);
      },
      fail: (code, msg) {
        ToastUtils.dismiss();
      },
    );
  }

  @override
  void onReady() {
    super.onReady();
    ToastUtils.show();
    _initData();
  }
}
