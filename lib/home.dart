/*
  기능: 앱의 공통적으로 띄워주는 위젯들(Appbar, Drawer, Tabbar)들을 분리해놓은 위젯
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/Appbar/myappbar.dart';
import 'package:guardians_of_health_project/View/calendar_view.dart';
import 'package:guardians_of_health_project/View/near_toilet_view.dart';
import 'package:guardians_of_health_project/View/setting_view.dart';
import 'package:guardians_of_health_project/VM/home_ctrl.dart';
import 'package:guardians_of_health_project/View/mainpage_view.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class Home extends StatelessWidget {
  final Function(ThemeMode) onChangeTheme; 
  final Function(Color) onChangeThemeColor;
  const Home({super.key, required this.onChangeTheme, required this.onChangeThemeColor});

  @override
  Widget build(BuildContext context) {
    final HomeController homecontroller = Get.put(HomeController());

    return Scaffold(
      appBar: const MyAppBar(),
      body: PersistentTabView(
        context,
        controller: homecontroller.tabController,
        screens: _buildScreens(), // 탭바누르면 이동할 페이지들 함수
        items: _navBarsItems(context), // 탭들 디자인하는 함수
        confineInSafeArea: true,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        resizeToAvoidBottomInset: true, // 키보드 눌렀을 때 화면 자동으로 위로 올라감
        hideNavigationBarWhenKeyboardShows:
            true, // resizeToAvoidBottomInset를 돕는애
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(30.0.r),
        ),
        navBarHeight: 80.h,
        navBarStyle: NavBarStyle.style11,
      ),
    );
  }

  // ---------- Functions ----------

  // 탭바 디자인 설정 리스트 함수
  List<PersistentBottomNavBarItem> _navBarsItems(context) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: "홈",
        textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSecondary),
        activeColorPrimary: Theme.of(context).colorScheme.onSecondary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.calendar),
        title: "쾌변기록",
        textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSecondary),
        activeColorPrimary: Theme.of(context).colorScheme.onSecondary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.map),
        title: "긴급지도",
        textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSecondary),
        activeColorPrimary: Theme.of(context).colorScheme.onSecondary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.settings),
        title: "설정",
        textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSecondary),
        activeColorPrimary: Theme.of(context).colorScheme.onSecondary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  // 탭바 누르면 이동할 페이지
  List<Widget> _buildScreens() {
    return  [
      MainPageView(onChangeTheme: onChangeTheme,onChangeThemeColor: onChangeThemeColor),
      const CalendarView(),
      const NearToiletView(), // 지도 페이지 추가시 바꾸기
      SettingView(onChangeTheme: onChangeTheme,onChangeThemeColor: onChangeThemeColor) 
    ];
  }
} // End
