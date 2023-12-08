import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Model/database_handler.dart';
import 'package:guardians_of_health_project/VM/setting_ctrl.dart';

/// 비밀번호 사용을 활성화하면 띄워지는 다이어로그
void verifyNumberpadDialog(BuildContext context) {
  final settingController = Get.find<SettingController>();
  Timer _timer;
  // 다이얼로그가 닫혔는지 여부를 저장할 변수
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

  /// 비밀번호 확인이 틀렸을 때 띄우는 스낵바
  showSnackbar() {
    Get.showSnackbar(const GetSnackBar(
      title: "실패",
      message: "비밀번호가 일치하지 않습니다.",
      duration: Duration(seconds: 2),
    ));
    settingController.verifyPadNum = "".obs; // 비밀번호 확인 리스트 초기화
  }

  /// 비밀번호 확인하는 함수
  bool verifyNumber() {
    DatabaseHandler handler = DatabaseHandler();
    bool verify = false;
    if (settingController.tempPadNum.value ==
        settingController.verifyPadNum.value) {
      // SQLite에 비밀번호 저장 및 비밀번호 사용 스위치 status 값 저장
      savePassword() {
        
      }
      print("저장");
      // 저장 후 저장 성공했다고 띄워주기위해 true
      verify = true;
    } else {
      showSnackbar();
      verify = false;
    }
    return verify;
  }

  Future<void> dialogFuture = showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return AlertDialog(
          title: const Text("비밀번호 확인"),
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
                              settingController.verifyPadNum.value.isEmpty
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
                              settingController.verifyPadNum.value.length < 2
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
                              settingController.verifyPadNum.value.length < 3
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
                              settingController.verifyPadNum.value.length < 4
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
                          if (settingController.verifyPadNum.value.isNotEmpty) {
                            settingController.verifyPadNum.value =
                                settingController.verifyPadNum.value.substring(
                                    0,
                                    settingController
                                            .verifyPadNum.value.length -
                                        1);
                            print(
                                "verifyPadNum: ${settingController.verifyPadNum}");
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
                              settingController.verifyPadNum.value +=
                                  setKeypadShape()[index].toString();

                              if (settingController.verifyPadNum.value.length ==
                                  4) {}

                              _timer =
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
  dialogFuture.then((value) {
    dialogClosed = true;
    settingController.resetNumber();
    if (settingController.verifyPadNum.value.length < 4) {
      settingController.passwordValue.value = false;
    }
  });
}
