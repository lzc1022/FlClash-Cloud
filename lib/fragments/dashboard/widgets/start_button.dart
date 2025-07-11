import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/services/index.dart';
import '../../../models/suscription_model.dart';

class StartButton extends StatefulWidget {
  const StartButton({super.key});

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isStart = false;

  @override
  void initState() {
    super.initState();
    isStart = globalState.appState.runTime != null;
    _controller = AnimationController(
      vsync: this,
      value: isStart ? 1 : 0,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  handleSwitchStart() {
    isStart = !isStart;
    updateController();
    debouncer.call(
      DebounceTag.updateStatus,
      () {
        globalState.appController.updateStatus(isStart);
      },
      duration: moreDuration,
    );
  }

  updateController() {
    if (isStart) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final state = ref.watch(startButtonSelectorStateProvider);
        if (!state.isInit || !state.hasProfile) {
          return Container();
        }
        ref.listenManual(
          runTimeProvider.select((state) => state != null),
          (prev, next) {
            if (next != isStart) {
              isStart = next;
              updateController();
            }
          },
          fireImmediately: true,
        );
        final textWidth = globalState.measure
                .computeTextSize(
                  Text(
                    utils.getTimeDifference(
                      DateTime.now(),
                    ),
                    style: context.textTheme.titleMedium?.toSoftBold,
                  ),
                )
                .width +
            16;
        return AnimatedBuilder(
          animation: _controller.view,
          builder: (_, child) {
            return SizedBox(
              width: 56 + textWidth * _controller.value,
              height: 56,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  SubscriptionModel? model =
                      UserInfo.instance.subscriptionModel;
                  if (model != null) {
                    var d = model.d ?? 0;
                    var u = model.u ?? 0;
                    //当前流量
                    var currentGB = d + u;
                    //总流量
                    var totalGB = model.transferEnable ?? 0;
                    if (currentGB >= totalGB) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            '温馨提示',
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          content: Text(
                            '当前流量已用完，请购买套餐',
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 关闭弹窗
                              },
                              child: Text('确认'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      handleSwitchStart();
                    }
                  }
                },
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      alignment: Alignment.center,
                      child: AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: _controller,
                      ),
                    ),
                    Expanded(
                      child: ClipRect(
                        child: OverflowBox(
                          maxWidth: textWidth,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: child!,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: child,
        );
      },
      child: Consumer(
        builder: (_, ref, __) {
          final runTime = ref.watch(runTimeProvider);
          final text = utils.getTimeText(runTime);
          return Text(
            text,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.toSoftBold
                .copyWith(color: context.colorScheme.onPrimaryContainer),
          );
        },
      ),
    );
  }
}
