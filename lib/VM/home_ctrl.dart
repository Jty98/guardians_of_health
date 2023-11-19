import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

// GetX로 Tabbar 상태관리를 위해서 with GetSingleTickerProviderStateMixin 추가
class HomeController extends GetxController with GetSingleTickerProviderStateMixin {

  late PersistentTabController tabController;
  // int initialSelectedTab = 0;

  // tabbar init
  @override
  void onInit() {
    super.onInit();
    tabController = PersistentTabController(initialIndex: 0);
  }

  // tabbar dispose
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }


}