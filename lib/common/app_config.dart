/// 常量
class AppConfig {
  static const String appApi =
      'https://akk201.oss-ap-northeast-1.aliyuncs.com/do1.json';
  //  服务器地址
  static String wpApiBaseUrl = 'https://vmpx.ffoky.xyz/'; // wp 服务器
  //配置
  static const String apiConfig = 'api/v1/guest/comm/config';
  //注册
  static const String apiRegister = 'api/v1/passport/auth/register';
  //登录
  static const String apiLogin = 'api/v1/passport/auth/login';
  //发送验证码
  static const String apiSendCode = 'api/v1/passport/comm/sendEmailVerify';
  //重置密码
  static const String apiResetPassword = 'api/v1/passport/auth/forget';
  //获取用户信息
  static const String apiGetUserInfo = 'api/v1/user/info';
  //退出登录
  static const String apiLogout = 'api/v1/user/logout';
  //订阅套餐
  static const String apiBuyVip = 'api/v1/user/plan/fetch';
  //订单列表
  static const String apiOrderList = 'api/v1/user/order/fetch';
  //订单详情
  static const String apiOrderDetail = 'api/v1/user/order/detail';
  //取消订单
  static const String apiOrderCancel = 'api/v1/user/order/cancel';
  //创建订单
  static const String apiOrderCreate = 'api/v1/user/order/save';
  //获取支付方式
  static const String apiGetPayWay = 'api/v1/user/order/getPaymentMethod';
  //结算订单
  static const String apiOrderPay = 'api/v1/user/order/checkout';
  //订阅连接
  static const String apiGetSubscribeUrl = 'api/v1/user/getSubscribe';
  //佣金转入
  static const String apiCommissionTransfer = 'api/v1/user/transfer';
  //公告
  static const String apiGetNotice = 'api/v1/user/notice/fetch';
  // 本地存储key
  static const storageToken = 'token'; // 登录成功后 token
  static const appUserInfo = 'appUserInfo'; // 用户信息缓存

  static const String refreshNoData = "没有更多数据啦";
  static const String refreshError = "加载失败!";
  static const String refreshPull = "下拉加载";
  static const String refreshHeaderIdle = "上拉刷新";
  static const String refreshHeaderFailed = "刷新失败!";
  static const String refreshHeaderSuccess = "刷新成功";
  static const String refreshHeaderFreed = "释放刷新";
  static const String refreshEmpty = "没有更多内容啦~";
}
