// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:tat/router/navigations.dart';
import 'package:tat/strings.dart';

class MyAccountPage extends ConsumerWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  PreferredSizeWidget get _appBar => AppBar(
        title: const Text(Strings.mainPageMyAccountTabName),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: _appBar,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () => launchLoginPage(context),
                          child: const Text('Login'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
