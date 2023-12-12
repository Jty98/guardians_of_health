/*
  기능: 비밀번호를 사용할시에 앱 처음에 뜨는 다이얼로그
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/VM/setting_ctrl.dart';

/// 비밀번호 사용을 활성화하면 띄워지는 다이어로그
firstNumberpadDialog(BuildContext context) {
  final settingController = Get.find<SettingController>();

  /// keypad 안에 들어갈 버튼 리스트 설정하는 함수
  List<dynamic> setKeypadShape() {
    List<dynamic> keypadList = [];
    List<dynamic> dynamicKeyList = ["", 0, ""];

    for (int i = 1; i <= 12; i++) {
      if (i > 9) {
        keypadList.add(dynamicKeyList[i - 10]);
      } else {
        keypadList.add(i);
      }
    }
    return keypadList;
  }

  /// 비밀번호 확인이 틀렸을 때 띄우는 스낵바
  showSnackbar(
      {required String result,
      required String resultText,
      required Color resultbackColor,
      required Color resultTextColor}) {
    Get.showSnackbar(
      GetSnackBar(
        titleText: Text(
          result,
          style: TextStyle(
              color: resultTextColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        messageText: Text(
          resultText,
          style: TextStyle(
              color: resultTextColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        duration: const Duration(milliseconds: 800),
        backgroundColor: resultbackColor,
        snackPosition: SnackPosition.TOP,
        borderRadius: 50.r, // 둥글게하기
        margin: EdgeInsets.fromLTRB(60.w, 10.h, 60.w, 10.h), // 마진값으로 사이즈 조절
      ),
    );
    settingController.padNum = "".obs; // 비밀번호 확인 리스트 초기화
  }

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
          // backgroundColor: Colors.transparent,
          title: const Center(child: Text("비밀번호로 잠금해제")),
          content: SizedBox(
            width: MediaQuery.of(context).size.width.w * 0.85,
            height: MediaQuery.of(context).size.height.h * 0.85,
            child: Center(
              child: Column(
                children: [
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        showNumber(settingController, 1, context),
                        showNumber(settingController, 2, context),
                        showNumber(settingController, 3, context),
                        showNumber(settingController, 4, context),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // 문자열의 뒤에서 한 글자 제거
                          if (settingController.padNum.value.isNotEmpty) {
                            settingController.padNum.value =
                                settingController.padNum.value.substring(0,
                                    settingController.padNum.value.length - 1);
                            print("padNum: ${settingController.padNum}");
                          }
                        },
                        child: const Icon(
                          Icons.backspace_outlined,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width.w * 0.62,
                      height: MediaQuery.of(context).size.height.h * 0.62,
                      child: GridView.builder(
                        itemCount: setKeypadShape().length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              // index값에 true넣어주기
                              settingController.buttonClickStatus[index].value =
                                  true;

                              // 키패드의 index를 padNum에 추가시키기
                              settingController.padNum.value +=
                                  setKeypadShape()[index].toString();

                              if (settingController.padNum.value.length == 4) {
                                if (settingController.savedPassword ==
                                    settingController.padNum.value) {
                                  Get.back();
                                  showSnackbar(
                                    result: "환영합니다!",
                                    resultText: "오늘도 쾌변하세요!",
                                    resultbackColor:
                                        Theme.of(context).colorScheme.tertiary,
                                    resultTextColor: Theme.of(context)
                                        .colorScheme
                                        .onTertiary,
                                  );
                                } else {
                                  showSnackbar(
                                    result: "실패",
                                    resultText: "비밀번호를 다시 확인해주세요.",
                                    resultbackColor:
                                        Theme.of(context).colorScheme.error,
                                    resultTextColor:
                                        Theme.of(context).colorScheme.onError,
                                  );
                                }
                              }

                              // 2초 뒤에 false 넣어줘서 원상복구하기
                              Timer(const Duration(milliseconds: 200), () {
                                settingController
                                    .buttonClickStatus[index].value = false;
                              });
                            },
                            child: Obx(
                              () => AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: settingController
                                          .buttonClickStatus[index].value
                                      ? Colors.grey
                                      : Theme.of(context).colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(100.r),
                                ),
                                child: Center(
                                  child: Text(
                                    "${setKeypadShape()[index]}",
                                    style: TextStyle(
                                      fontSize: 40.sp,
                                      color: Theme.of(context).colorScheme.onTertiary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                ],
              ),
            ),
          ));
    },
  );
}

  /// nuberPad 위에 버튼 누를 때 나오는 * 부분
  Widget showNumber(SettingController settingController, int valueLength, BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
      child: Container(
        width: 50.w,
        height: 50.h,
        color: Colors.blueGrey,
        child: Center(
            child: Text(
          settingController.padNum.value.length < valueLength ? "" : "*",
          style: TextStyle(fontSize: 35.sp),
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
