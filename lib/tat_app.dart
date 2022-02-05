// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:tat/router/tat_router.dart';
import 'package:tat/strings.dart';
import 'package:tat/themes.dart';

Future<void> runTAT() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  _beginRunTAT();
}

void _beginRunTAT() {
  GoRouter.setUrlPathStrategy(UrlPathStrategy.path);
  runApp(
    const ProviderScope(
      child: _TAT(),
    ),
  );
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
