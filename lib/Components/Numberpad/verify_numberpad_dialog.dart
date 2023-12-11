/*
  기능: 비밀번호 설정시 비밀번호확인용 다이얼로그
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/VM/setting_ctrl.dart';

/// 비밀번호 사용을 활성화하면 띄워지는 다이어로그
void verifyNumberpadDialog(BuildContext context) {
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
    settingController.verifyPadNum = "".obs; // 비밀번호 확인 리스트 초기화
  }

  /// 비밀번호 확인하는 함수
  bool saveNumber() {
    bool status = false;
    if (settingController.tempPadNum == settingController.verifyPadNum.value) {
      // SQLite에 비밀번호 저장 및 비밀번호 사용 스위치 status 값 저장
      // 저장 후 저장 성공했다고 띄워주기위해 true
      settingController.savePassword(settingController.verifyPadNum.value, 1);
      status = true;
    } else {
      status = false;
    }
    return status;
  }

  Future<void> dialogFuture = showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return AlertDialog(
          title: const Center(child: Text("비밀번호 확인")),
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
                        showNumber(settingController, 1),
                        showNumber(settingController, 2),
                        showNumber(settingController, 3),
                        showNumber(settingController, 4),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // 문자열의 뒤에서 한 글자 제거
                          if (settingController.verifyPadNum.value.isNotEmpty) {
                            settingController.verifyPadNum.value =
                                settingController.verifyPadNum.value.substring(
                                    0,
                                    settingController
                                            .verifyPadNum.value.length -
                                        1);
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
                      height: 420,
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
                              settingController.verifyPadNum.value +=
                                  setKeypadShape()[index].toString();

                              if (settingController.verifyPadNum.value.length ==
                                  4) {
                                // verifyNumber에서 true return해주면 성공했다고 띄워주기
                                if (saveNumber() == true) {
                                  settingController.saveStatus = true;
                                  // 바로 삭제할수도 있어서 또 불러와서 id 조회
                                  settingController.initPasswordValue();
                                  Get.back();
                                  showSnackbar(
                                    result: "저장 성공",
                                    resultText: "비밀번호가 성공적으로 설정되었습니다.",
                                    resultbackColor:
                                        Theme.of(context).colorScheme.tertiary,
                                    resultTextColor: Theme.of(context)
                                        .colorScheme
                                        .onTertiary,
                                  );
                                } else {
                                  showSnackbar(
                                    result: "저장 실패",
                                    resultText: "비밀번호가 일치하지 않습니다. 다시 시도해주세요.",
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
                                duration: const Duration(milliseconds: 500),
                                decoration: BoxDecoration(
                                  color: settingController
                                          .buttonClickStatus[index].value
                                      ? Colors.grey
                                      : Theme.of(context).colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: Text(
                                    "${setKeypadShape()[index]}",
                                    style: TextStyle(
                                      fontSize: 40,
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
  // 다이얼로그가 닫힌 후의 로직
  dialogFuture.then((value) {
    // 다이얼로그가 닫힘을 확인하고 로직 수행
    if (settingController.saveStatus == true) {
      // 저장이 성공한 경우
      settingController.passwordValue.value = true;
      settingController.tempPadNum = "";
    } else {
      // 저장이 실패하거나 다이얼로그가 닫히지 않은 경우
      settingController.passwordValue.value = false;
      settingController.resetNumber();
      settingController.tempPadNum = "";
    }
  });
}

  /// nuberPad 위에 버튼 누를 때 나오는 * 부분
  Widget showNumber(SettingController settingController, int valueLength) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
      child: Container(
        width: 65,
        height: 65,
        color: Colors.blueGrey,
        child: Center(
            child: Text(
          settingController.verifyPadNum.value.length < valueLength ? "" : "*",
          style: const TextStyle(fontSize: 45),
        )),
      ),
    );
  }

