// ignore_for_file: directives_ordering

// 🎯 Dart imports:
import 'dart:async';

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

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key, LoginSuccessAction? loginSuccessAction})
      : _loginSuccessAction = loginSuccessAction,
        super(key: key);

  static const routeName = 'login_page';

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

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  StreamSubscription<AuthState>? authBlocStreamSubscription;
  String? loginFailedMsg;
  Completer? loginCompleter;

  Future<String?>? _handleLoginCallBack(LoginData loginData) async {
    final authBloc = ref.watch(authBlocProvider);
    final credential = widget._generateCredentialFrom(loginData);

    loginCompleter = Completer();
    loginFailedMsg = Strings.unknownLoginFailedMsg;

    authBloc.add(AuthInitialLoginCalled(credential));
    _log('authBloc event added: ${(AuthInitialLoginCalled).toString()}', areaName: '_handleLoginCallBack');

    assert(loginCompleter != null, 'loginCompleter should not be null when _handleLoginCallBack called.');

    await loginCompleter?.future;
    return loginFailedMsg;
  }

  @override
  void initState() {
    super.initState();
    _log('on initState', areaName: (_LoginPageState).toString());

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      final authBloc = ref.watch(authBlocProvider);
      authBlocStreamSubscription = authBloc.stream.listen((state) {
        _log('receive authBloc stream data: $state', areaName: 'initState');
        if (state is AuthInitialLoginSuccess) {
          loginFailedMsg = null;
          widget._loginSuccessAction?.call();
          loginCompleter?.complete();
        } else if (state is AuthInitialLoginFailure) {
          loginFailedMsg = Strings.getLoginFailedMsgFrom(state.errorType);
          loginCompleter?.complete();
        }
      });
    });
  }

  @override
  void dispose() {
    _log('on dispose', areaName: (_LoginPageState).toString());

    authBlocStreamSubscription?.cancel();

    if (!(loginCompleter?.isCompleted ?? true)) {
      loginCompleter?.complete();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FlutterLogin(
        title: Strings.loginPageTitle,
        footer: Strings.loginPageFooter,
        logo: ImageAssets.tatLogoTransparentWhite,
        onLogin: _handleLoginCallBack,
        onRecoverPassword: (_) => null,
        hideForgotPasswordButton: true,
        userType: LoginUserType.name,
        theme: TATThemes.loginPageTheme,
        userValidator: widget._userNameValidator,
        passwordValidator: widget._passwordValidator,
        messages: LoginMessages(
          userHint: Strings.loginBoxUserNameInputHint,
          passwordHint: Strings.loginBoxPasswordInputHint,
        ),
      );
}

class LoginPageRouteParams {
  const LoginPageRouteParams({required this.loginSuccessAction});

  final LoginSuccessAction? loginSuccessAction;
}

void _log(Object object, {String? areaName, bool? secure}) => debugLog(
      object,
      secure: secure ?? false,
      name: areaName != null ? '${LoginPage.routeName} $areaName' : LoginPage.routeName,
    );
