// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:tat/keys.dart';
import 'package:tat/router/router.dart';
import 'package:tat/strings.dart';
import 'package:tat/themes.dart';

Future<void> runTAT() async {
  _beginRunTAT();
}

void _beginRunTAT() {
  runApp(const TAT());
}

class TAT extends StatelessWidget {
  const TAT({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: Strings.appBarTitle,
        theme: TATTheme.createAppThemeData(context),
        onGenerateInitialRoutes: TATRouter.createInitialRoutes,
        onGenerateRoute: TATRouter.createRoute,
        navigatorKey: TATKeyProvider.navigatorKey,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child ?? const SizedBox.shrink(),
        ),
      );
}
