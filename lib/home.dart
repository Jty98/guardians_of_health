import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/Appbar/myappbar.dart';
import 'package:guardians_of_health_project/VM/home_ctrl.dart';
import 'package:guardians_of_health_project/View/mainpage_view.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homecontroller = Get.put(HomeController());

    return Scaffold(
      appBar: const MyAppBar(),
      body: PersistentTabView(
        context,
        controller: homecontroller.tabController,
        screens: _buildScreens(), // 탭바누르면 이동할 페이지들 함수
        items: _navBarsItems(), // 탭들 디자인하는 함수
        confineInSafeArea: true,
        // backgroundColor: Colors.white, 
        // handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true, // 키보드 눌렀을 때 화면 자동으로 위로 올라감
        // stateManagement: true, 
        hideNavigationBarWhenKeyboardShows: true, // resizeToAvoidBottomInset를 돕는애
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          // colorBehindNavBar: Colors.red,
        ),
        // // popAllScreensOnTapOfSelectedTab: true,
        // // popActionScreens: PopActionScreensType.all,
        // itemAnimationProperties: const ItemAnimationProperties(
        //   // bar items property
        //   duration: Duration(milliseconds: 100),
        //   // curve: Curves.ease,
        // ),
        // screenTransitionAnimation: const ScreenTransitionAnimation(
        //   // 탭바 클릭시 발생하는 애니메이션
        //   animateTabTransition: false,
        //   // curve: Curves.ease,
        //   duration: Duration(milliseconds: 100),
        // ),
        navBarStyle: NavBarStyle.style6,
      ),
    );
  }

  // ---------- Functions ----------

  // 탭바 디자인 설정 리스트 함수
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: "홈",
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.calendar),
        title: "배변기록",
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.map),
        title: "급똥지도",
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  // 탭바 누르면 이동할 페이지
  List<Widget> _buildScreens() {
    return const [
      MainPageView(),
      MainPageView(),
      MainPageView(),
    ];
  }


} // End