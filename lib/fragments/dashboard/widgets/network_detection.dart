import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/app.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _networkDetectionState = ValueNotifier<NetworkDetectionState>(
  const NetworkDetectionState(
    isTesting: false,
    isLoading: true,
    ipInfo: null,
  ),
);

class NetworkDetection extends ConsumerStatefulWidget {
  const NetworkDetection({super.key});

  @override
  ConsumerState<NetworkDetection> createState() => _NetworkDetectionState();
}

class _NetworkDetectionState extends ConsumerState<NetworkDetection> {
  bool? _preIsStart;
  Timer? _setTimeoutTimer;
  CancelToken? cancelToken;

  @override
  void initState() {
    ref.listenManual(checkIpNumProvider, (prev, next) {
      if (prev != next) {
        _startCheck();
      }
    });
    if (!_networkDetectionState.value.isTesting &&
        _networkDetectionState.value.isLoading) {
      _startCheck();
    }
    super.initState();
  }

  _startCheck() async {
    if (cancelToken != null) {
      cancelToken!.cancel();
      cancelToken = null;
    }
    debouncer.call(
      DebounceTag.checkIp,
      _checkIp,
    );
  }

  _checkIp() async {
    final appState = globalState.appState;
    final isInit = appState.isInit;
    if (!isInit) return;
    final isStart = appState.runTime != null;
    if (_preIsStart == false &&
        _preIsStart == isStart &&
        _networkDetectionState.value.ipInfo != null) {
      return;
    }
    _clearSetTimeoutTimer();
    _networkDetectionState.value = _networkDetectionState.value.copyWith(
      isLoading: true,
      ipInfo: null,
    );
    _preIsStart = isStart;
    if (cancelToken != null) {
      cancelToken!.cancel();
      cancelToken = null;
    }
    cancelToken = CancelToken();
    try {
      _networkDetectionState.value = _networkDetectionState.value.copyWith(
        isTesting: true,
      );
      final ipInfo = await request.checkIp(cancelToken: cancelToken);
      _networkDetectionState.value = _networkDetectionState.value.copyWith(
        isTesting: false,
      );
      if (ipInfo != null) {
        _networkDetectionState.value = _networkDetectionState.value.copyWith(
          isLoading: false,
          ipInfo: ipInfo,
        );
        return;
      }
      _clearSetTimeoutTimer();
      _setTimeoutTimer = Timer(const Duration(milliseconds: 300), () {
        _networkDetectionState.value = _networkDetectionState.value.copyWith(
          isLoading: false,
          ipInfo: null,
        );
      });
    } catch (e) {
      if (e.toString() == "cancelled") {
        _networkDetectionState.value = _networkDetectionState.value.copyWith(
          isLoading: true,
          ipInfo: null,
        );
      }
    }
  }

  @override
  void dispose() {
    _clearSetTimeoutTimer();
    super.dispose();
  }

  _clearSetTimeoutTimer() {
    if (_setTimeoutTimer != null) {
      _setTimeoutTimer?.cancel();
      _setTimeoutTimer = null;
    }
  }

  _countryCodeToEmoji(String countryCode) {
    final String code = countryCode.toUpperCase();
    if (code.length != 2) {
      return countryCode;
    }
    final int firstLetter = code.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = code.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getWidgetHeight(1),
      child: ValueListenableBuilder<NetworkDetectionState>(
        valueListenable: _networkDetectionState,
        builder: (_, state, __) {
          final ipInfo = state.ipInfo;
          final isLoading = state.isLoading;
          return CommonCard(
            onPressed: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: globalState.measure.titleMediumHeight + 16,
                  padding: baseInfoEdgeInsets.copyWith(
                    bottom: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ipInfo != null
                          ? Text(
                              _countryCodeToEmoji(
                                ipInfo.countryCode,
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.toLight
                                  .copyWith(
                                    fontFamily: FontFamily.twEmoji.value,
                                  ),
                            )
                          : Icon(
                              Icons.network_check,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        flex: 1,
                        child: TooltipText(
                          text: Text(
                            appLocalizations.networkDetection,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2),
                      AspectRatio(
                        aspectRatio: 1,
                      )
                    ],
                  ),
                ),
                Container(
                  padding: baseInfoEdgeInsets.copyWith(
                    top: 0,
                  ),
                  child: SizedBox(
                    height: globalState.measure.bodyMediumHeight + 2,
                    child: FadeThroughBox(
                      child: ipInfo != null
                          ? TooltipText(
                              text: Text(
                                ipInfo.ip,
                                style: context.textTheme.bodyMedium?.toLight
                                    .adjustSize(1),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : FadeThroughBox(
                              child: isLoading == false && ipInfo == null
                                  ? Text(
                                      "timeout",
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(color: Colors.red)
                                          .adjustSize(1),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(2),
                                      child: const AspectRatio(
                                        aspectRatio: 1,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                            ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
