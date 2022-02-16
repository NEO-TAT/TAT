// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:tat/data/local_storage/tat_storage.dart';
import 'package:tat/router/tat_router.dart';
import 'package:tat/strings.dart';
import 'package:tat/themes.dart';
import 'package:tat/types/return_types.dart';
import 'package:tat/utils/debug_log.dart';

Future<void> runTAT() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Hive.initFlutter();
  WidgetsBinding.instance?.addObserver(
    _TATLifeCycleEventHandler(
      detachedCallBack: _handleAppDetached,
    ),
  );
  await TATStorage().init();
  _beginRunTAT();
}

Future<void> _handleAppDetached() async {
  await TATStorage().dispose();
  await Hive.close();
}

void _beginRunTAT() {
  GoRouter.setUrlPathStrategy(UrlPathStrategy.path);
  runApp(
    const ProviderScope(
      child: _TAT(),
    ),
  );
}

class _TATLifeCycleEventHandler extends WidgetsBindingObserver {
  _TATLifeCycleEventHandler({
    required FutureVoidCallBack detachedCallBack,
  }) : _detachedCallBack = detachedCallBack;
  final FutureVoidCallBack _detachedCallBack;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    _log('lifecycle => $state', areaName: 'didChangeAppLifecycleState');

    switch (state) {
      case AppLifecycleState.detached:
        await _detachedCallBack();
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
    }
  }
}

class _TAT extends StatelessWidget {
  const _TAT({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: Strings.appBarTitle,
        theme: TATThemes.createAppThemeData(context),
        routerDelegate: tatRouter.routerDelegate,
        routeInformationParser: tatRouter.routeInformationParser,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child ?? const SizedBox.shrink(),
        ),
      );
}

void _log(Object object, {required String areaName}) => debugLog(
      object,
      name: 'ROOT_SCOPE $areaName',
    );
