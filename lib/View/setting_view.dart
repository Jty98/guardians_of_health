/*
  기능: 다양한 기능을 가지고있는 Drawer -> 사용자 설정 등
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/select_theme_bottomsheet.dart';
import 'package:guardians_of_health_project/VM/security_ctrl.dart';
import 'package:guardians_of_health_project/View/health_info_view.dart';
import 'package:guardians_of_health_project/View/my_record_view.dart';
import 'package:guardians_of_health_project/View/security_setting_view.dart';

class SettingView extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  final Function(Color) onChangeThemeColor;
  const SettingView({super.key, required this.onChangeTheme, required this.onChangeThemeColor});
  // const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final securityController = Get.find<SecurityController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
            child: ListTile(
              leading: const Icon(
                Icons.analytics_outlined,
                size: 35,
              ),
              title: Text(
                "  내 기록",
                style: TextStyle(fontSize: 25.sp),
              ),
              onTap: () => Get.to(() => const MyRecordView()),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
            child: ListTile(
              leading: const Icon(
                Icons.key_outlined,
                size: 35,
              ),
              title: Text(
                "  잠금 설정",
                style: TextStyle(fontSize: 25.sp),
              ),
              onTap: () => Get.to(() => const SecuritySettingView()),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
            child: ListTile(
              leading: const Icon(
                Icons.medical_information_outlined,
                size: 35,
              ),
              title: Text(
                "  건강 정보",
                style: TextStyle(fontSize: 25.sp),
              ),
              onTap: () => Get.to(() => const HealthInfoPage()),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
            child: ListTile(
              leading: const Icon(
                Icons.settings_suggest,
                size: 35,
              ),
              title: Text(
                "  테마 변경",
                style: TextStyle(fontSize: 25.sp),
              ),
              onTap: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return SelectScreenMode(
                          onChangeTheme: widget.onChangeTheme,
                          onChangeThemeColor: widget.onChangeThemeColor);
                      // return const SelectScreenMode();
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
} //  END


  
