// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_login/flutter_login.dart';

// 🌎 Project imports:
import 'package:tat/assets.dart';
import 'package:tat/strings.dart';
import 'package:tat/themes.dart';
import 'package:tat/utils/debug_log.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routeId = 'login_page';

  String? _userNameValidator(String? userName) {
    _log('$userName', areaName: 'userNameValidator');
    return userName != null && userName.trim().isNotEmpty ? null : Strings.userNameIsEmptyErrMsg;
  }

  String? _passwordValidator(String? password) {
    _log('$password', areaName: 'passwordValidator', secure: true);
    return password != null && password.isNotEmpty ? null : Strings.passwordIsEmptyErrMsg;
  }

  Future<String?>? _onLogin(LoginData credential) {
    return null;
  }

  @override
  Widget build(BuildContext context) => FlutterLogin(
        title: Strings.loginPageTitle,
        footer: Strings.loginPageFooter,
        logo: ImageAssets.tatLogoTransparentWhite,
        onLogin: _onLogin,
        onRecoverPassword: (_) => null,
        hideForgotPasswordButton: true,
        userType: LoginUserType.name,
        theme: TATThemes.loginPageTheme,
        userValidator: _userNameValidator,
        passwordValidator: _passwordValidator,
        messages: LoginMessages(
          userHint: Strings.loginBoxUserNameInputHint,
          passwordHint: Strings.loginBoxPasswordInputHint,
        ),
      );
}

void _log(Object object, {String? areaName, bool? secure}) => debugLog(
      object,
      secure: secure ?? false,
      name: areaName != null ? '${LoginPage.routeId} $areaName' : LoginPage.routeId,
    );
