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
  static const appEncryptionKey = 'TATStorageEncryptionKey';

  // main page
  static const mainPageCourseTableTabName = '課表';
  static const mainPageGradesTabName = '成績';
  static const mainPageBulletinTabName = '佈告欄';
  static const mainPageCalendarTabName = '行事曆';
  static const mainPageMyAccountTabName = '帳戶';
  static const mainPageDebugBoardTabName = 'Debug';

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

  static String getLoginFailedMsgFrom(AccountStatus loginResultType) {
    if (loginResultType == AccountStatus.receivedInvalidCredential) return wrongCredentialLoginFailedMsg;
    if (loginResultType == AccountStatus.needsResetPassword) return needsResetPasswordLoginFailedMsg;
    if (loginResultType == AccountStatus.needsVerifyMobile) return needsVerifyMobileLoginFailedMsg;
    if (loginResultType == AccountStatus.locked) return accountLockedLoginFailedMsg;

    // This msg will not appeared on screen if `loginResultType` is `SimpleLoginResultType.success`.
    if (loginResultType == AccountStatus.normal) return '';
    return unknownLoginFailedMsg;
  }
}
