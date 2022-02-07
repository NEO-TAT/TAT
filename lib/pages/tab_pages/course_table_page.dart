// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:tat/strings.dart';

class CourseTablePage extends StatelessWidget {
  const CourseTablePage({Key? key}) : super(key: key);

  PreferredSizeWidget? get _appBar => AppBar(
        title: const Text(Strings.mainPageCourseTableTabName),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar,
        body: SafeArea(
          child: Container(),
        ),
      );
}
