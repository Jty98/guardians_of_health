/*
  기능: 비밀번호 및 생체인증을 설정하는 뷰
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/Numberpad/numberpad_dialog.dart';
import 'package:guardians_of_health_project/Components/snacbar_widget.dart';
import 'package:guardians_of_health_project/VM/security_ctrl.dart';

class SecuritySettingView extends StatelessWidget {
  const SecuritySettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final SecurityController securityController = Get.put(SecurityController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("잠금 설정"),
      ),
      body: Obx(
        () => Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.background,
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "비밀번호 사용",
                        style: TextStyle(
                          fontSize: 23.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Switch(
                          value: securityController.passwordValue
                              .value, // main의 sharedPreference로 가져온 isPassword
                          onChanged: (value) {
                            securityController.passwordValue.value = value;
                            if (value == true) {
                              // 비밀번호 설정 다이어로그
                              numberpadDialog(context);
                            } else {
                              securityController.deletePwSharePreferencese();
                              securityController.deleteBioSharePreferencese();
                              // 생체인식도 같이 꺼지기
                              securityController.biometricsValue.value = false;
                              // 키패드 담겨있는거 초기화
                              securityController.resetNumber();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              color: Theme.of(context).colorScheme.background,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    securityController.passwordValue.value == true
                        ? Row(
                            children: [
                              Text(
                                "생체인식 사용",
                                style: TextStyle(
                                  fontSize: 23.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "생체인식 사용",
                                style: TextStyle(
                                  fontSize: 23.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                              Text(
                                "비밀번호 등록시 사용가능",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                            ],
                          ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
                      child: Switch(
                          value: securityController.biometricsValue
                              .value, // main의 sharedPreference로 가져온 isPrivated
                          onChanged: securityController.passwordValue.value ==
                                  true
                              ? (value) async {
                                  securityController.biometricsValue.value =
                                      value;
                                  if (value == true) {
                                    // 생체 인식이 성공한 경우 처리
                                    securityController.authenticate(context, 1); // 저장이라서 0을 넣어주면 안됨
                                    securityController
                                        .saveBioSharePreferencese();
                                  } else {
                                    securityController.cancelAuthentication();
                                    securityController
                                        .deleteBioSharePreferencese();
                                  }
                                }
                              : null),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
