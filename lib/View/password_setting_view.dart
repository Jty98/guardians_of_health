import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/numberpad_dialog.dart';
import 'package:guardians_of_health_project/VM/setting_ctrl.dart';
import 'package:guardians_of_health_project/my_theme.dart';

class PasswordSettingView extends StatelessWidget {
  const PasswordSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    // final settingController = Get.find<SettingController>();
    final SettingController settingController = Get.put(SettingController());
    // settingController.initPasswordValue();
    print("id: ${settingController.savedPwId}");
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
                      fontSize: 18,
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
                        if(value == true) {
                          // 비밀번호 설정 다이어로그
                          numberpadDialog(context);
                        } else {
                          if(settingController.savedPwId != null){
                            settingController.deletePassword(settingController.savedPwId!);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              color: Theme.of(context).colorScheme.background,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "생체인식 사용",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Switch(
                      value: settingController.biometricsValue.value,
                      onChanged: (value) {
                        settingController.biometricsValue.value = value;
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
