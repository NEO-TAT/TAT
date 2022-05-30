// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:tat/strings.dart';

class BulletinPage extends StatelessWidget {
  const BulletinPage({super.key});

  PreferredSizeWidget? get _appBar => AppBar(
        title: const Text(Strings.mainPageBulletinTabName),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar,
        body: SafeArea(
          child: Container(),
        ),
      );
}
