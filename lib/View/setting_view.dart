/*
  기능: 다양한 기능을 가지고있는 Drawer -> 사용자 설정 등
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/select_screen_mode.dart';
import 'package:guardians_of_health_project/VM/setting_ctrl.dart';
import 'package:guardians_of_health_project/View/my_record_view.dart';
import 'package:guardians_of_health_project/View/password_setting_view.dart';
import 'package:guardians_of_health_project/main.dart';

  
class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final settingController = Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    MyAppState? myAppState = context.findRootAncestorStateOfType<MyAppState>();

    return Scaffold(
        body: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                leading: const Icon(
                  Icons.analytics_outlined,
                  size: 35,
                ),
                title: const Text(
                  "  내 쾌변 기록",
                  style: TextStyle(
                    fontSize: 25
                  ),
                ),
                onTap: (){
                  Get.to(const MyRecordView());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                leading: const Icon(
                  Icons.key_outlined,
                  size: 35,
                ),
                title: const Text(
                  "  비밀번호 설정",
                  style: TextStyle(
                    fontSize: 25
                  ),                
                ),
                onTap: (){
                  settingController.initPasswordValue();
                  Get.to(() => const PasswordSettingView());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                leading: const Icon(
                  Icons.medical_information_outlined,
                  size: 35,
                ),
                title: const Text(
                  "  건강 정보",
                  style: TextStyle(
                    fontSize: 25
                  ),                
                ),
                onTap: (){
              
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                leading: const Icon(
                  Icons.settings_suggest,
                  size: 35,
                ),
                title: const Text(
                  "  테마 변경",
                  style: TextStyle(
                    fontSize: 25
                  ),                
                ),
                onTap: (){
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return SelectScreenMode(onChangeTheme: myAppState!.changeThemeMode(ThemeMode.light), onChangeThemeColor: myAppState!.changeSeedColor(Colors.white));
                    }
                  );
                },
              ),
            ),
          ],
        ),
      );
  }
} //  END


  
