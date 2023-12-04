/*
  기능: 다양한 기능을 가지고있는 Drawer
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

    late int _radioValue = 0;
class SettingView extends StatelessWidget {
  const SettingView({super.key});

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
                  // bottom Sheet 뜨고 색상 선택 가능
                  _showModalBottomSheet(context);
                },
              ),
            ),
          ],
        ),
      );
  }

  // ------------ Functions -------------
  _showModalBottomSheet(BuildContext context) {
    Get.bottomSheet(
      // isScrollControlled: true,
      backgroundColor: Colors.white,      // 라이트/다크모드에 따라 바뀌게 하기
      Column(
        children: [
          Text(
            "색상",
            style: TextStyle(
              fontSize: 35,
              // color:       // 테마 색상 선택에 따라 변경되도록
              fontWeight: FontWeight.bold,
              
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    // light mode / dark mode 선택시 스위치처럼 값 하나씩 선택해서 바뀌도록 하기
                  },
                  child: Column(     // 라이트모드 선택지 
                    children: [
                      Image.asset(
                        "assets/images/lightmode.png",
                        width: 100,
                      ),
                      const Text(
                        "\n라이트 모드"
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                Column(     // 다크 모드 선택지
                  children: [
                    Image.asset(
                      "assets/images/darkmode.png",
                      width: 100,
                    ),
                    const Text(
                      "\n다크 모드"
                    )
                  ],
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Button
              // Radio(
              //   value: 0, 
              //   groupValue: _radioValue, 
              //   onChanged: (value) => _radioChange(value),
              // )
            ],

          )
        ],
      )
    );

  }

  // ---------- functions ----------
    _radioChange(int? value) {        // ? : 선택 될 수도 있고 안 될수도 있으니까
    _radioValue = value!;           // 하나만 선택할 수 있도록
    // setState(() {
      
    // });
  }
} //  END