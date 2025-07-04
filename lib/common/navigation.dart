import 'dart:io';

import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/fragments/fragments.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/pages/system/mine/index.dart';
import 'package:flutter/material.dart';

//10086 侧边栏平台判断
class Navigation {
  static Navigation? _instance;

  List<NavigationItem> getItems({
    bool openLogs = false,
    bool hasProxies = false,
  }) {
    var items = [
      const NavigationItem(
        icon: Icon(Icons.space_dashboard),
        label: PageLabel.dashboard,
        fragment: DashboardFragment(
          key: GlobalObjectKey(PageLabel.dashboard),
        ),
      ),
      NavigationItem(
        icon: const Icon(Icons.article),
        label: PageLabel.proxies,
        fragment: const ProxiesFragment(
          key: GlobalObjectKey(
            PageLabel.proxies,
          ),
        ),
        modes: hasProxies
            ? [NavigationItemMode.mobile, NavigationItemMode.desktop]
            : [],
      ),
      const NavigationItem(
        icon: Icon(Icons.folder),
        label: PageLabel.profiles,
        fragment: ProfilesFragment(
          key: GlobalObjectKey(
            PageLabel.profiles,
          ),
        ),
      ),
      const NavigationItem(
        icon: Icon(Icons.view_timeline),
        label: PageLabel.requests,
        fragment: RequestsFragment(
          key: GlobalObjectKey(
            PageLabel.requests,
          ),
        ),
        description: "requestsDesc",
        modes: [NavigationItemMode.desktop, NavigationItemMode.more],
      ),
      const NavigationItem(
        icon: Icon(Icons.ballot),
        label: PageLabel.connections,
        fragment: ConnectionsFragment(
          key: GlobalObjectKey(
            PageLabel.connections,
          ),
        ),
        description: "connectionsDesc",
        modes: [NavigationItemMode.desktop, NavigationItemMode.more],
      ),
      const NavigationItem(
        icon: Icon(Icons.storage),
        label: PageLabel.resources,
        description: "resourcesDesc",
        keep: false,
        fragment: Resources(
          key: GlobalObjectKey(
            PageLabel.resources,
          ),
        ),
        modes: [NavigationItemMode.more],
      ),
      NavigationItem(
        icon: const Icon(Icons.adb),
        label: PageLabel.logs,
        fragment: const LogsFragment(
          key: GlobalObjectKey(
            PageLabel.logs,
          ),
        ),
        description: "logsDesc",
        modes: openLogs
            ? [NavigationItemMode.desktop, NavigationItemMode.more]
            : [],
      ),
      const NavigationItem(
        icon: Icon(Icons.construction),
        label: PageLabel.tools,
        fragment: MinePage(),
        modes: [NavigationItemMode.desktop, NavigationItemMode.mobile],
      ),
    ];
    // macOS和Windows下过滤掉“请求”和“连接”页面
    if (Platform.isMacOS || Platform.isWindows) {
      items = items
          .where((item) =>
              item.label != PageLabel.requests &&
              item.label != PageLabel.connections)
          .toList();
    }
    return items;
  }

  Navigation._internal();

  factory Navigation() {
    _instance ??= Navigation._internal();
    return _instance!;
  }
}

final navigation = Navigation();
