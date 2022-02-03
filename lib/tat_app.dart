// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:tat/keys.dart';
import 'package:tat/router/tat_navigater.dart';
import 'package:tat/strings.dart';
import 'package:tat/themes.dart';

Future<void> runTAT() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  _beginRunTAT();
}

void _beginRunTAT() {
  runApp(
    const ProviderScope(
      child: _TAT(),
    ),
  );
}

class _TAT extends StatelessWidget {
  const _TAT({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: Strings.appBarTitle,
        theme: TATThemes.createAppThemeData(context),
        onGenerateInitialRoutes: TATNavigator.createInitialRoutes,
        onGenerateRoute: TATNavigator.createRoute,
        navigatorKey: TATKeyProvider.navigatorKey,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child ?? const SizedBox.shrink(),
        ),
      );
}
