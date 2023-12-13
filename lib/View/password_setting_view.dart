/*
  기능: 비밀번호 및 생체인증을 설정하는 뷰
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/Numberpad/numberpad_dialog.dart';
import 'package:guardians_of_health_project/Model/local_auth.dart';
import 'package:guardians_of_health_project/VM/setting_ctrl.dart';

class PasswordSettingView extends StatelessWidget {
  const PasswordSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingController settingController = Get.put(SettingController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("비밀번호 설정"),
      ),
      body: Obx(
        () => Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.background,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "비밀번호 사용",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Switch(
                      value: settingController.passwordValue.value,
                      onChanged: (value) {
                        settingController.passwordValue.value = value;
                        if (value == true) {
                          // 비밀번호 설정 다이어로그
                          numberpadDialog(context);
                        } else {
                          if (settingController.savedPwId != null) {
                            settingController
                                .deletePassword(settingController.savedPwId!);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              color: Theme.of(context).colorScheme.background,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "생체인식 사용",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
                    child: Switch(
                      value: settingController.biometricsValue.value,
                      onChanged: (value) async {
                        // 실제 디바이스에서 테스트해봐야함;
                        settingController.biometricsValue.value = value;
                        if (value == true) {
                          bool isAuthenticated = await LocalAuth.authenticate();
                          if (isAuthenticated) {
                            // 생체 인식이 성공한 경우 처리
                            print('Biometric authentication successful!');
                          } else {
                            // 생체 인식이 실패하거나 사용자가 취소한 경우 처리
                            print(
                                'Biometric authentication failed or canceled.');
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
