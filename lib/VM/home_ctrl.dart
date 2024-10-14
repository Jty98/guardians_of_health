/*
  기능: 탭바의 상태관리를 위한 GetXController
*/

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
// import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

// GetX로 Tabbar 상태관리를 위해서 with GetSingleTickerProviderStateMixin 추가
class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late PersistentTabController tabController;

  // tabbar init
  @override
  void onInit() async {
    super.onInit();
    tabController = PersistentTabController(initialIndex: 0);
    await Future.delayed(const Duration(microseconds: 3000));
    FlutterNativeSplash.remove();
  }

  // tabbar dispose
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
