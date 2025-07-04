import 'dart:io';
import 'dart:math';

import 'package:fl_clash/common/box.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/image_x.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/images.dart';
import '../../common/routers/names.dart';
import '../../common/services/index.dart';
import '../../state.dart';
import 'widgets/start_button.dart';

//首页
class DashboardFragment extends ConsumerStatefulWidget {
  const DashboardFragment({super.key});

  @override
  ConsumerState<DashboardFragment> createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends ConsumerState<DashboardFragment>
    with PageMixin {
  final key = GlobalKey<SuperGridState>();

  @override
  void initState() {
    super.initState();
    ref.listenManual(
      isCurrentPageProvider(PageLabel.dashboard),
      (prev, next) {
        if (prev != next && next == true) {
          initPageState();
        }
      },
      fireImmediately: true,
    );

    // Listen for the URL from the initial network request.
    ref.listenManual<String?>(initialUrlProvider, (previous, next) {
      if (next != null && next.isNotEmpty) {
        _addProfileFromUrl(next);
        // Reset the provider to null to prevent re-triggering.
        ref.read(initialUrlProvider.notifier).state = null;
      }
    });
  }

  /// A simple method to add a profile from a URL programmatically.
  Future<void> _addProfileFromUrl(String url) async {
    if (url.trim().isNotEmpty) {
      // 检查是否已存在相同url的profile，已存在则不添加
      final profiles = ref.read(profilesProvider);
      final exists = profiles.any((p) => p.url == url);
      if (!exists) {
        globalState.appController.addProfileFormURL(url);
      }
    }
  }

  @override
  Widget? get floatingActionButton => const StartButton();

  @override
  List<Widget> get actions => [
        ValueListenableBuilder(
          valueListenable: key.currentState!.addedChildrenNotifier,
          builder: (_, addedChildren, child) {
            return ValueListenableBuilder(
              valueListenable: key.currentState!.isEditNotifier,
              builder: (_, isEdit, child) {
                if (!isEdit || addedChildren.isEmpty) {
                  return Container();
                }
                return child!;
              },
              child: child,
            );
          },
          child: IconButton(
            onPressed: () {
              key.currentState!.showAddModal();
            },
            icon: Icon(
              Icons.add_circle,
            ),
          ),
        ),
        IconButton(
          icon: ValueListenableBuilder(
            valueListenable: key.currentState!.isEditNotifier,
            builder: (_, isEdit, ___) {
              return isEdit
                  ? Icon(Icons.save)
                  : Icon(
                      Icons.edit,
                    );
            },
          ),
          onPressed: () {
            key.currentState!.isEditNotifier.value =
                !key.currentState!.isEditNotifier.value;
          },
        ),
        //客服
        GestureDetector(
          onTap: () {
            launchUrl(
              Uri.parse("https://img.hsjiasuqi.com/"),
            );
          },
          child: ImageX.asset(AssetsImages.kefuPng, width: 36, height: 36),
        ),
      ];

  _handleSave(List<GridItem> girdItems, WidgetRef ref) {
    final dashboardWidgets = girdItems
        .map(
          (item) => DashboardWidget.getDashboardWidget(item),
        )
        .toList();
    ref.read(appSettingProvider.notifier).updateState(
          (state) => state.copyWith(dashboardWidgets: dashboardWidgets),
        );
    // 新增：保存到本地，确保下次启动能加载
    globalState.appController.savePreferences();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardStateProvider);
    final notice = ref.watch(noticeContentProvider) ?? '';
    final columns = max(4 * ((dashboardState.viewWidth / 320).ceil()), 8);
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
          padding: const EdgeInsets.all(16).copyWith(
            bottom: 88,
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: notice.isNotEmpty
                    ? () {
                        Get.toNamed(RouteNames.systemNotice,
                            arguments: UserInfo.instance.noticeList);
                      }
                    : null,
                child: SizedBox(
                  width: context.width - 40,
                  height: 30,
                  child: notice.isNotEmpty
                      ? Marquee(
                          text: notice,
                          blankSpace: 150.0,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 15),
                        )
                      : Container(),
                ),
              ),
              vBox(20),
              SuperGrid(
                key: key,
                crossAxisCount: columns,
                crossAxisSpacing: 16.ap,
                mainAxisSpacing: 16.ap,
                children: [
                  ...dashboardState.dashboardWidgets
                      .where(
                        (item) =>
                            item.platforms.contains(
                              SupportPlatform.currentPlatform,
                            ) &&
                            item != DashboardWidget.intranetIp &&
                            !(Platform.isMacOS &&
                                (item == DashboardWidget.systemProxyButton ||
                                    item == DashboardWidget.tunButton)),
                      )
                      .map(
                        (item) => item.widget,
                      ),
                ],
                onSave: (girdItems) {
                  _handleSave(girdItems, ref);
                },
                addedItemsBuilder: (girdItems) {
                  return DashboardWidget.values
                      .where(
                        (item) =>
                            !girdItems.contains(item.widget) &&
                            item.platforms.contains(
                              SupportPlatform.currentPlatform,
                            ) &&
                            item != DashboardWidget.intranetIp,
                      )
                      .map((item) => item.widget)
                      .toList();
                },
              )
            ],
          )),
    );
  }
}
