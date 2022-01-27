// ignore_for_file: directives_ordering

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_login/flutter_login.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tat_core/tat_core.dart';

// 🌎 Project imports:
import 'package:tat/assets.dart';
import 'package:tat/bloc/auth/auth_bloc.dart';
import 'package:tat/providers/bloc_providers.dart';
import 'package:tat/strings.dart';
import 'package:tat/themes.dart';
import 'package:tat/utils/debug_log.dart';

/// A function to be invoked after logged in successfully.
typedef LoginSuccessAction = void Function();

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key, LoginSuccessAction? loginSuccessAction})
      : _loginSuccessAction = loginSuccessAction,
        super(key: key);

  static const routeId = 'login_page';

  final LoginSuccessAction? _loginSuccessAction;

  String? _userNameValidator(String? userName) {
    _log('$userName', areaName: 'userNameValidator');
    return userName != null && userName.trim().isNotEmpty ? null : Strings.userNameIsEmptyErrMsg;
  }

  String? _passwordValidator(String? password) {
    _log('$password', areaName: 'passwordValidator', secure: true);
    return password != null && password.isNotEmpty ? null : Strings.passwordIsEmptyErrMsg;
  }

  LoginCredential _generateCredentialFrom(LoginData loginData) => LoginCredential(
        userId: loginData.name.trim(),
        password: loginData.password,
      );

  Future<String?>? _handleLoginCallBack(LoginData loginData, WidgetRef ref) {
    final authBloc = ref.watch(authBlocProvider);
    final credential = _generateCredentialFrom(loginData);
    authBloc.add(AuthInitialLoginCalled(credential));

    // TODO(TU): add bloc stream listener to know if login success.
    // if login success
    _loginSuccessAction?.call();
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => FlutterLogin(
        title: Strings.loginPageTitle,
        footer: Strings.loginPageFooter,
        logo: ImageAssets.tatLogoTransparentWhite,
        onLogin: (loginData) => _handleLoginCallBack(loginData, ref),
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

class LoginPageRouteParams {
  const LoginPageRouteParams({required this.loginSuccessAction});

  final LoginSuccessAction loginSuccessAction;
}

void _log(Object object, {String? areaName, bool? secure}) => debugLog(
      object,
      secure: secure ?? false,
      name: areaName != null ? '${LoginPage.routeId} $areaName' : LoginPage.routeId,
    );
