import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notice_model.dart';

export 'app.dart';
export 'config.dart';
export 'state.dart';

final localIpProvider = StateProvider<String?>((ref) => null);

final initialUrlProvider = StateProvider<String?>((ref) => null);
//通知内容
final noticeContentProvider = StateProvider<String?>((ref) => null);
//通知列表
final noticeListProvider = StateProvider<List<NoticeModel>>((ref) => []);
