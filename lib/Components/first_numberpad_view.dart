import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/VM/setting_ctrl.dart';

/// 비밀번호 사용을 활성화하면 띄워지는 다이어로그
firstNumberpadDialog(BuildContext context) {
  final settingController = Get.find<SettingController>();
  Timer _timer;

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
              fontSize: 20,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        messageText: Text(
          resultText,
          style: TextStyle(
              color: resultTextColor,
              fontSize: 15,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        duration: const Duration(milliseconds: 800),
        backgroundColor: resultbackColor,
        snackPosition: SnackPosition.TOP,
        borderRadius: 50, // 둥글게하기
        margin: const EdgeInsets.fromLTRB(60, 10, 60, 10), // 마진값으로 사이즈 조절
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
          title: const Text("비밀번호로 잠금해제"),
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
                              print(settingController.padNum);

                              // 2초 뒤에 false 넣어줘서 원상복구하기
                              _timer =
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
}
