// 📦 Package imports:
import 'package:tat_core/tat_core.dart';

class Strings {
  // commons
  static const empty = '';
  static const whiteSpace = ' ';

  // debug names
  static const debugFlagTAT = 'TAT';

  // global names
  static const appBarTitle = 'TAT - 北科生活 APP';

  // main page
  static const mainPageCourseTable = '課表';
  static const mainPageMyAccount = '帳戶';

  // login page
  static const loginPageTitle = 'Login to NTUT';
  static const loginPageFooter = '© NTUT Programming Club';
  static const loginBoxUserNameInputHint = 'account';
  static const loginBoxPasswordInputHint = 'password';
  static const userNameIsEmptyErrMsg = 'Please enter your account ID';
  static const passwordIsEmptyErrMsg = 'Please enter your password';

  static const unknownLoginFailedMsg = 'Unknown error occurred!';
  static const wrongCredentialLoginFailedMsg = 'Incorrect account or password, please try again';
  static const needsResetPasswordLoginFailedMsg = 'The password has expired, please reset it and try again';
  static const needsVerifyMobileLoginFailedMsg =
      'The phone number has not been set or verified, please fix it and try again';
  static const accountLockedLoginFailedMsg = 'Account is locked, please try again after unlocking';

  static String getLoginFailedMsgFrom(SimpleLoginResultType loginResultType) {
    if (loginResultType == SimpleLoginResultType.wrongCredential) return wrongCredentialLoginFailedMsg;
    if (loginResultType == SimpleLoginResultType.needsResetPassword) return needsResetPasswordLoginFailedMsg;
    if (loginResultType == SimpleLoginResultType.needsVerifyMobile) return needsVerifyMobileLoginFailedMsg;
    if (loginResultType == SimpleLoginResultType.locked) return accountLockedLoginFailedMsg;

    // This msg will not appeared on screen if `loginResultType` is `SimpleLoginResultType.success`.
    if (loginResultType == SimpleLoginResultType.success) return '';
    return unknownLoginFailedMsg;
  }
}
