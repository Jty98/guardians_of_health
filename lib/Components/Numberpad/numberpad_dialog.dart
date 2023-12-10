/*
  기능: 비밀번호를 설정하기위해 스위치를 활성화하면 나오는 숫자패드 다이얼로그
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/Numberpad/verify_numberpad_dialog.dart';
import 'package:guardians_of_health_project/VM/setting_ctrl.dart';

/// 비밀번호 사용을 활성화하면 띄워지는 다이어로그
void numberpadDialog(BuildContext context) {
  final settingController = Get.find<SettingController>();
  // 다이얼로그가 닫혔는지 여부를 저장할 변수
  // ignore: unused_local_variable
  bool dialogClosed = false;

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

  Future<void> dialogFuture = showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return AlertDialog(
          // backgroundColor: Colors.transparent,
          title: const Text("비밀번호 설정"),
          content: SizedBox(
            width: 500,
            height: 550,
            child: Center(
              child: Column(
                children: [
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                          child: Container(
                            width: 60,
                            height: 60,
                            color: Colors.blueGrey,
                            child: Center(
                                child: Text(
                              settingController.padNum.value.isEmpty ? "" : "*",
                              style: const TextStyle(fontSize: 40),
                            )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                          child: Container(
                            width: 60,
                            height: 60,
                            color: Colors.blueGrey,
                            child: Center(
                                child: Text(
                              settingController.padNum.value.length < 2
                                  ? ""
                                  : "*",
                              style: const TextStyle(fontSize: 40),
                            )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                          child: Container(
                            width: 60,
                            height: 60,
                            color: Colors.blueGrey,
                            child: Center(
                                child: Text(
                              settingController.padNum.value.length < 3
                                  ? ""
                                  : "*",
                              style: const TextStyle(fontSize: 40),
                            )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                          child: Container(
                            width: 60,
                            height: 60,
                            color: Colors.blueGrey,
                            child: Center(
                                child: Text(
                              settingController.padNum.value.length < 4
                                  ? ""
                                  : "*",
                              style: const TextStyle(fontSize: 40),
                            )),
                          ),
                        ),
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
                          }
                        },
                        child: const Icon(
                          Icons.backspace_outlined,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      width: 300,
                      height: 400,
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
                                // 누른 키패드값을 tempPadNum에 저장
                                settingController.tempPadNum =
                                    settingController.padNum.value;

                                Get.back();
                                verifyNumberpadDialog(context);
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
                                      : Colors.amber,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "${setKeypadShape()[index]}",
                                    style: const TextStyle(
                                      fontSize: 40,
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

  // 다이얼로그가 닫힌 후의 로직
  // 비밀번호 설정이 완료되지 않고 다이어로그를 닫을 시에 스위치 꺼버리기
  dialogFuture.then((value) {
    dialogClosed = true;
    settingController.resetNumber();
    if (settingController.tempPadNum.length < 4) {
      settingController.tempPadNum = "";
      settingController.passwordValue.value = false;
    }
  });
}
