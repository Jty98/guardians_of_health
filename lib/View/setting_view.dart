/*
  기능: 다양한 기능을 가지고있는 Drawer -> 사용자 설정 등
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/select_screen_mode.dart';
import 'package:guardians_of_health_project/my_theme.dart';

  
class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
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
                  Get.bottomSheet(
                    backgroundColor: Colors.white,
                    const SelectScreenMode()    // 테마 선택 bottom sheet 불러오기
                    // SelectScreenMode(onChangeTheme: _changeThemeMode(_themeMode))    // 테마 선택 bottom sheet 불러오기
                  );
                },
              ),
            ),
          ],
        ),
      );
  }
} //  END


  
