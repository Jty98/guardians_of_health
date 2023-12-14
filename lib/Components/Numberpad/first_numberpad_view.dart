/*
  기능: 비밀번호를 사용할시에 앱 처음에 뜨는 다이얼로그
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/snacbar_widget.dart';
import 'package:guardians_of_health_project/VM/security_ctrl.dart';

/// 비밀번호 사용을 활성화하면 띄워지는 다이어로그
firstNumberpadDialog(BuildContext context) {
  final securityController = Get.find<SecurityController>();

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

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
          // backgroundColor: Colors.transparent,
          title: const Center(
              child: Text(
            "비밀번호로 잠금해제",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          content: SizedBox(
            width: 450.w,
            height: 620.h,
            child: Center(
              child: Column(
                children: [
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        showNumber(securityController, 1, context),
                        showNumber(securityController, 2, context),
                        showNumber(securityController, 3, context),
                        showNumber(securityController, 4, context),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // 문자열의 뒤에서 한 글자 제거
                          if (securityController.padNum.value.isNotEmpty) {
                            securityController.padNum.value =
                                securityController.padNum.value.substring(0,
                                    securityController.padNum.value.length - 1);
                            print("padNum: ${securityController.padNum}");
                          }
                        },
                        child: Icon(
                          Icons.backspace_outlined,
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 30.h,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
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
                            securityController.buttonClickStatus[index].value =
                                true;

                            // 키패드의 index를 padNum에 추가시키기
                            securityController.padNum.value +=
                                setKeypadShape()[index].toString();

                            if (securityController.padNum.value.length == 4) {
                              if (securityController.savedPassword ==
                                  securityController.padNum.value) {
                                securityController.resetNumber(); // 초기화 시켜버리기
                                Get.back();
                                showSnackbar(
                                    result: "환영합니다!",
                                    resultText: "오늘도 쾌변하세요!",
                                    resultbackColor:
                                        Theme.of(context).colorScheme.tertiary,
                                    resultTextColor: Theme.of(context)
                                        .colorScheme
                                        .onTertiary,
                                    securityController: securityController);
                              } else {
                                showSnackbar(
                                    result: "실패",
                                    resultText: "비밀번호를 다시 확인해주세요.",
                                    resultbackColor:
                                        Theme.of(context).colorScheme.error,
                                    resultTextColor:
                                        Theme.of(context).colorScheme.onError,
                                    securityController: securityController);
                              }
                            }

                            // 2초 뒤에 false 넣어줘서 원상복구하기
                            Timer(const Duration(milliseconds: 200), () {
                              securityController
                                  .buttonClickStatus[index].value = false;
                            });
                          },
                          child: Obx(
                            () => AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: securityController
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ));
    },
  );
}

/// nuberPad 위에 버튼 누를 때 나오는 * 부분
Widget showNumber(SecurityController securityController, int valueLength,
    BuildContext context) {
  return Padding(
    padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
    child: Container(
      width: 60.w,
      height: 60.h,
      color: Colors.blueGrey,
      child: Center(
          child: Text(
        securityController.padNum.value.length < valueLength ? "" : "*",
        style: TextStyle(fontSize: 35.sp),
        textAlign: TextAlign.center,
      )),
    ),
  );
}
