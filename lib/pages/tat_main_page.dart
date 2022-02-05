// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import 'package:tat/pages/course_table_page.dart';
import 'package:tat/pages/my_account_page.dart';
import 'package:tat/strings.dart';
import 'package:tat/utils/debug_log.dart';
import 'package:tat/widgets/bottom_bar.dart';

class TATMainPage extends StatefulWidget {
  const TATMainPage({Key? key}) : super(key: key);

  static const routeName = 'main_page';

  Widget _toTabPage(_TabInfo tabInfo) {
    switch (tabInfo.type) {
      case _TabType.courseTable:
        return const CourseTablePage();
      case _TabType.grades:
        // TODO(TU): replace with GradesPage().
        return const CourseTablePage();
      case _TabType.bulletin:
        // TODO(TU): replace with BulletinPage().
        return const CourseTablePage();
      case _TabType.calendar:
        // TODO(TU): replace with CalendarPage().
        return const CourseTablePage();
      case _TabType.myAccount:
        return const MyAccountPage();
      case _TabType.debugBoard:
        // TODO(TU): replace with DebugBoard().
        return const MyAccountPage();
    }
  }

  List<_TabInfo> get _tabList => [
        _TabInfo.courseTable(),
        _TabInfo.grades(),
        _TabInfo.bulletin(),
        _TabInfo.calendar(),
        _TabInfo.myAccount(),
        _TabInfo.debugBoard(),
      ];

  @override
  State<TATMainPage> createState() => _TATMainPageState();
}

class _TATMainPageState extends State<TATMainPage> with AutomaticKeepAliveClientMixin {
  final PageController _pageController = PageController();

  final _CurrentMainPageTabIndex _currentIndex = _CurrentMainPageTabIndex();

  PageView get _tatPageView => PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => widget._toTabPage(widget._tabList[index]),
        itemCount: widget._tabList.length,
        controller: _pageController,
        onPageChanged: _currentIndex.changeIndex,
      );

  List<SalomonBottomBarItem> get _bottomBarItems => widget._tabList.map((tabInfo) {
        return SalomonBottomBarItem(
          title: Text(tabInfo.label),
          icon: Icon(
            tabInfo.iconSelector.original,
          ),
          activeIcon: Icon(
            tabInfo.iconSelector.selected,
          ),
        );
      }).toList();

  Widget? get _tatButtonBar => BlocBuilder<_CurrentMainPageTabIndex, int>(
        bloc: _currentIndex,
        builder: (_, currentIndex) => SalomonBottomBar(
          items: _bottomBarItems,
          currentIndex: currentIndex,
          onTap: (index) {
            if (_pageController.hasClients && _pageController.page != null) {
              _pageController.jumpToPage(index);
            }
          },
        ),
      );

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: _tatPageView,
      bottomNavigationBar: _tatButtonBar,
    );
  }
}

enum _TabType {
  courseTable,
  grades,
  bulletin,
  calendar,
  myAccount,
  debugBoard,
}

class _IconSelector {
  const _IconSelector({required this.original, required this.selected});

  final IconData original;
  final IconData selected;
}

class _TabInfo {
  _TabInfo.courseTable()
      : type = _TabType.courseTable,
        label = Strings.mainPageCourseTableTabName,
        iconSelector = const _IconSelector(
          original: Icons.access_time,
          selected: Icons.access_time_filled,
        );

  _TabInfo.grades()
      : type = _TabType.grades,
        label = Strings.mainPageGradesTabName,
        iconSelector = const _IconSelector(
          original: Icons.book_outlined,
          selected: Icons.book_rounded,
        );

  _TabInfo.bulletin()
      : type = _TabType.bulletin,
        label = Strings.mainPageBulletinTabName,
        iconSelector = const _IconSelector(
          original: Icons.article_outlined,
          selected: Icons.article,
        );

  _TabInfo.calendar()
      : type = _TabType.calendar,
        label = Strings.mainPageCalendarTabName,
        iconSelector = const _IconSelector(
          original: Icons.today_outlined,
          selected: Icons.today,
        );

  _TabInfo.myAccount()
      : type = _TabType.myAccount,
        label = Strings.mainPageMyAccountTabName,
        iconSelector = const _IconSelector(
          original: Icons.account_circle_outlined,
          selected: Icons.account_circle,
        );

  _TabInfo.debugBoard()
      : type = _TabType.debugBoard,
        label = Strings.mainPageDebugBoardTabName,
        iconSelector = const _IconSelector(
          original: Icons.settings_applications_outlined,
          selected: Icons.settings_applications,
        );

  final _IconSelector iconSelector;
  final _TabType type;
  final String label;
}

class _CurrentMainPageTabIndex extends Cubit<int> {
  _CurrentMainPageTabIndex() : super(0);

  void changeIndex(int newPageIndex) => emit(newPageIndex);

  @override
  void onChange(Change<int> change) {
    _log(change, areaName: 'currentTabIndex');
    super.onChange(change);
  }
}

void _log(Object object, {String? areaName}) => debugLog(
      object,
      name: areaName != null ? '${TATMainPage.routeName} $areaName' : TATMainPage.routeName,
    );
