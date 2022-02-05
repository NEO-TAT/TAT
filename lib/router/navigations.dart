// 🐦 Flutter imports:
import 'package:flutter/widgets.dart';

// 📦 Package imports:
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import 'package:tat/pages/login_page.dart';

void launchLoginPage(
  BuildContext context, {
  LoginSuccessAction? loginSuccessAction,
}) {
  final extra = LoginPageRouteParams(
    loginSuccessAction: loginSuccessAction,
  );

  context.pushNamed(
    LoginPage.routeName,
    extra: extra,
  );
}
