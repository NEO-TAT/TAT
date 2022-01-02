// 🐦 Flutter imports:
import 'package:flutter/widgets.dart';

class _ImagePaths {
  static const _imageRootPath = 'assets/images';

  // Common-used images
  static const tatLogo = '$_imageRootPath/tat.png';
  static const tatLogoRounded = '$_imageRootPath/tat-round.png';
  static const tatLogoTransparentWhite = '$_imageRootPath/tat-transparent-white.png';
}

class ImageAssets {
  static const tatLogo = AssetImage(_ImagePaths.tatLogo);
  static const tatLogoRounded = AssetImage(_ImagePaths.tatLogoRounded);
  static const tatLogoTransparentWhite = AssetImage(_ImagePaths.tatLogoTransparentWhite);
}
