import 'dart:async';
import 'dart:ui';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/fragments/profiles/edit_profile.dart';
import 'package:fl_clash/fragments/profiles/override_profile.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/services/event_bus/event_bus.dart';
import '../../common/services/user_info_model/user_info.dart';
import '../../pages/system/vip_channel/view.dart';

//套餐界面
class ProfilesFragment extends StatefulWidget {
  const ProfilesFragment({super.key});

  @override
  State<ProfilesFragment> createState() => _ProfilesFragmentState();
}

class _ProfilesFragmentState extends State<ProfilesFragment> with PageMixin {
  Function? applyConfigDebounce;
//订阅刷新通知
  StreamSubscription? updateVipSubscription;
  _updateProfiles() async {
    final profiles = globalState.config.profiles;
    final messages = [];
    final updateProfiles = profiles.map<Future>(
      (profile) async {
        if (profile.type == ProfileType.file) return;
        globalState.appController.setProfile(
          profile.copyWith(isUpdating: true),
        );
        try {
          await globalState.appController.updateProfile(profile);
        } catch (e) {
          messages.add("${profile.label ?? profile.id}: $e \n");
          globalState.appController.setProfile(
            profile.copyWith(
              isUpdating: false,
            ),
          );
        }
      },
    );
    final titleMedium = context.textTheme.titleMedium;
    await Future.wait(updateProfiles);
    if (messages.isNotEmpty) {
      globalState.showMessage(
        title: appLocalizations.tip,
        message: TextSpan(
          children: [
            for (final message in messages)
              TextSpan(text: message, style: titleMedium)
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    //订阅刷新通知
    updateVipSubscription = eventListen<UpdateSubscribeEvent>((event) {
      if (event.name == 'update_subscribe') {
        receiveNotice();
      }
    });
  }

  ///刷新套餐
  @override
  List<Widget> get actions => [
        IconButton(
          onPressed: () {
            _updateProfiles();
          },
          icon: const Icon(Icons.sync),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        ref.listenManual(
          isCurrentPageProvider(PageLabel.profiles),
          (prev, next) {
            if (prev != next && next == true) {
              initPageState();
            }
          },
          fireImmediately: true,
        );
        final profilesSelectorState = ref.watch(profilesSelectorStateProvider);
        var appList = profilesSelectorState.profiles;
        appList = List.from(appList);
        if (appList.length > 1) {
          appList.removeRange(1, appList.length);
        }

        if (profilesSelectorState.profiles.isEmpty) {
          return GestureDetector(
            onTap: () {
              var url = UserInfo.instance.subscriptionModel?.subscribeUrl;
              if (url != null) {
                globalState.appController.addProfileFormURL(url);
              }
            },
            child: NullStatus(
              label: '点我重新刷新套餐或重启客户端',
            ),
          );
        }
        return Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 88,
            ),
            child: Grid(
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              crossAxisCount: profilesSelectorState.columns,
              children: [
                for (int i = 0; i < appList.length; i++)
                  GridItem(
                    child: ProfileItem(
                      key: Key(appList[i].id),
                      profile: appList[i],
                      groupValue: profilesSelectorState.currentProfileId,
                      onChanged: (profileId) {
                        ref.read(currentProfileIdProvider.notifier).value =
                            profileId;
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 接收通知并刷新套餐数据
  void receiveNotice() {
    setState(() {
      _updateProfiles();
    });
  }
}

class ProfileItem extends StatelessWidget {
  final Profile profile;
  final String? groupValue;
  final void Function(String? value) onChanged;

  const ProfileItem({
    super.key,
    required this.profile,
    required this.groupValue,
    required this.onChanged,
  });

  _handleDeleteProfile(BuildContext context) async {
    final res = await globalState.showMessage(
      title: appLocalizations.tip,
      message: TextSpan(
        text: appLocalizations.deleteProfileTip,
      ),
    );
    if (res != true) {
      return;
    }
    await globalState.appController.deleteProfile(profile.id);
  }

  Future updateProfile() async {
    final appController = globalState.appController;
    if (profile.type == ProfileType.file) return;
    await globalState.safeRun(silence: false, () async {
      try {
        appController.setProfile(
          profile.copyWith(
            isUpdating: true,
          ),
        );
        await appController.updateProfile(profile);
      } catch (e) {
        appController.setProfile(
          profile.copyWith(
            isUpdating: false,
          ),
        );
        rethrow;
      }
    });
  }

  _handleShowEditExtendPage(BuildContext context) {
    showExtend(
      context,
      builder: (_, type) {
        return AdaptiveSheetScaffold(
          type: type,
          body: EditProfile(
            profile: profile,
            context: context,
          ),
          title: "${appLocalizations.edit}${appLocalizations.profile}",
        );
      },
    );
  }

  List<Widget> _buildUrlProfileInfo(BuildContext context) {
    final subscriptionInfo = profile.subscriptionInfo;
    return [
      const SizedBox(
        height: 8,
      ),
      if (subscriptionInfo != null)
        SubscriptionInfoView(
          subscriptionInfo: subscriptionInfo,
        ),
      Text(
        profile.lastUpdateDate?.lastUpdateTimeDesc ?? "",
        style: context.textTheme.labelMedium?.toLight,
      ),
    ];
  }

  List<Widget> _buildFileProfileInfo(BuildContext context) {
    return [
      const SizedBox(
        height: 8,
      ),
      Text(
        profile.lastUpdateDate?.lastUpdateTimeDesc ?? "",
        style: context.textTheme.labelMedium?.toLight,
      ),
    ];
  }

  // _handleCopyLink(BuildContext context) async {
  //   await Clipboard.setData(
  //     ClipboardData(
  //       text: profile.url,
  //     ),
  //   );
  //   if (context.mounted) {
  //     context.showNotifier(appLocalizations.copySuccess);
  //   }
  // }

  _handleExportFile(BuildContext context) async {
    final commonScaffoldState = context.commonScaffoldState;
    final res = await commonScaffoldState?.loadingRun<bool>(
      () async {
        final file = await profile.getFile();
        final value = await picker.saveFile(
          profile.label ?? profile.id,
          file.readAsBytesSync(),
        );
        if (value == null) return false;
        return true;
      },
      title: appLocalizations.tip,
    );
    if (res == true && context.mounted) {
      context.showNotifier(appLocalizations.exportSuccess);
    }
  }

  _handlePushGenProfilePage(BuildContext context, String id) {
    BaseNavigator.push(
      context,
      OverrideProfile(
        profileId: id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      isSelected: false,
      onPressed: () {},
      child: ListItem(
        key: Key(profile.id),
        horizontalTitleGap: 16,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        trailing: null,
        onTap: () {
          BaseNavigator.push(
            context,
            VipChannelPage(),
          );
        },
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    profile.label ?? profile.id,
                    style: context.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Text(
                    '购买套餐',
                    style: context.textTheme.titleMedium,
                    maxLines: 1,
                  )
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...switch (profile.type) {
                    ProfileType.file => _buildFileProfileInfo(context),
                    ProfileType.url => _buildUrlProfileInfo(context),
                  },
                ],
              ),
            ],
          ),
        ),
        tileTitleAlignment: ListTileTitleAlignment.titleHeight,
      ),
    );
  }
}

class ReorderableProfilesSheet extends StatefulWidget {
  final List<Profile> profiles;
  final SheetType type;

  const ReorderableProfilesSheet({
    super.key,
    required this.profiles,
    required this.type,
  });

  @override
  State<ReorderableProfilesSheet> createState() =>
      _ReorderableProfilesSheetState();
}

class _ReorderableProfilesSheetState extends State<ReorderableProfilesSheet> {
  late List<Profile> profiles;

  @override
  void initState() {
    super.initState();
    profiles = List.from(widget.profiles);
  }

  Widget proxyDecorator(
    Widget child,
    int index,
    Animation<double> animation,
  ) {
    final profile = profiles[index];
    return AnimatedBuilder(
      animation: animation,
      builder: (_, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double scale = lerpDouble(1, 1.02, animValue)!;
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        key: Key(profile.id),
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: CommonCard(
          type: CommonCardType.filled,
          child: ListTile(
            contentPadding: const EdgeInsets.only(
              right: 44,
              left: 16,
            ),
            title: Text(profile.label ?? profile.id),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveSheetScaffold(
      type: widget.type,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            globalState.appController.setProfiles(profiles);
          },
          icon: Icon(
            Icons.save,
          ),
        )
      ],
      body: Padding(
        padding: EdgeInsets.only(bottom: 32),
        child: ReorderableListView.builder(
          buildDefaultDragHandles: false,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          proxyDecorator: proxyDecorator,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final profile = profiles.removeAt(oldIndex);
              profiles.insert(newIndex, profile);
            });
          },
          itemBuilder: (_, index) {
            final profile = profiles[index];
            return Container(
              key: Key(profile.id),
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: CommonCard(
                type: CommonCardType.filled,
                child: ListTile(
                  contentPadding: const EdgeInsets.only(
                    right: 16,
                    left: 16,
                  ),
                  title: Text(profile.label ?? profile.id),
                  trailing: ReorderableDragStartListener(
                    index: index,
                    child: const Icon(Icons.drag_handle),
                  ),
                ),
              ),
            );
          },
          itemCount: profiles.length,
        ),
      ),
      title: appLocalizations.profilesSort,
    );
  }
}
