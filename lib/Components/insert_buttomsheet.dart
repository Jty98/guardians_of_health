/*
  기능: 배변 타이머가 끝나고 기록을 저장할때 뜨는 바텀시트 위젯
*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Model/database_handler.dart';
import 'package:guardians_of_health_project/Model/record_model.dart';
import 'package:guardians_of_health_project/VM/timer_ctrl.dart';
import 'package:guardians_of_health_project/home.dart';

/// 배변 정보 저장할때 입력하는 바텀시트
void insertBottomSheet(BuildContext context) {
  TimerController timerController = Get.find();

  // 모양
  List<String> imagePaths = [
    "assets/images/banana.png",
    "assets/images/grape.png",
    "assets/images/water.png",
  ];

  // 모양을 담은 Sizedbox 크기
  List<SizedBox> shapeContainer = imagePaths.map((path) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Image.asset(path),
    );
  }).toList();

  // 색상
  List<Color> containerColors = [
    Colors.amber[700]!,
    Colors.brown[700]!,
    Colors.black,
    Colors.red,
    Colors.green,
  ];

  // 컬러들을 담고있는 버튼
  List<Widget> coloredContainers = List.generate(
    containerColors.length,
    (index) => Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: containerColors[index],
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );

  // 냄새 리스트
  List<String> labels = ["상", "중", "하"];

  // 냄새 리스트 버튼
  List<SizedBox> smellsSizedbox = labels.map((label) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Text(
        label,
        style: const TextStyle(fontSize: 25),
        textAlign: TextAlign.center,
      ),
    );
  }).toList();
showModalBottomSheet(
  isScrollControlled: true, // 바텀시트 높이 조절할려면 이 옵션이 필수
  context: context, 
  builder: (BuildContext context) {
    return 
    // backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
    GestureDetector(
      onTap: () {
        // ios플랫폼 기종이라면 GestureDetector로감싼부분 밖을 클릭하면 키보드 내려가는 기능
        if (Platform.isIOS) {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        }
      },
      child: Obx(
        () {
          return Container(
            padding: const EdgeInsets.all(20.0),
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "쾌변기록",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: IconButton(
                          onPressed: () {
                            timerController.resetBottomSheetValues();
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.cancel,
                            size: 20,
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   width: 10,
                      // ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "만족도",
                  style: TextStyle(fontSize: 18),
                ),
                starRatingbar(timerController),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "변 모양",
                  style: TextStyle(fontSize: 18),
                ),
                ToggleButtons(
                  onPressed: (int index) {
                    timerController.selectedShapeFunc(index);
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.grey,
                  selectedColor: Colors.white,
                  fillColor: Colors.blueGrey,
                  color: Colors.black,
                  constraints: const BoxConstraints(
                    minHeight: 45.0,
                    minWidth: 45.0,
                  ),
                  isSelected: timerController.selectedShape,
                  children: shapeContainer,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "색상",
                  style: TextStyle(fontSize: 18),
                ),
                ToggleButtons(
                  onPressed: (int index) {
                    timerController.selectedColorsFunc(index);
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.grey,
                  selectedColor: Colors.white,
                  fillColor: Colors.blueGrey,
                  color: Colors.black,
                  constraints: const BoxConstraints(
                    minHeight: 45.0,
                    minWidth: 45.0,
                  ),
                  isSelected: timerController.selectedColors,
                  children: coloredContainers,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "냄새",
                  style: TextStyle(fontSize: 18),
                ),
                ToggleButtons(
                  onPressed: (int index) {
                    timerController.selectedSmellsFunc(index);
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.grey,
                  selectedColor: Colors.white,
                  fillColor: Colors.blueGrey,
                  color: Colors.black,
                  constraints: const BoxConstraints(
                    minHeight: 45.0,
                    minWidth: 45.0,
                  ),
                  isSelected: timerController.selectedSmells,
                  children: smellsSizedbox,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "일지",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 150,
                  width: 300,
                  child: TextField(
                    controller: timerController.resultTextController,
                    maxLines: 3,
                    maxLength: 60,
                    decoration: const InputDecoration(
                      hintText: "특이사항을 기록해주세요.",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    _insertAction(context);
                    timerController.resetBottomSheetValues();
                    Get.back();
                  },
                  child: const Text("저장하기"),
                ),
              ],
            ),
          );
        },
      ),
    );
  },
  );
  // Get.bottomSheet(
    // isScrollControlled: true, // 바텀시트 높이 조절할려면 이 옵션이 필수
    // // backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
    // GestureDetector(
    //   onTap: () {
    //     // ios플랫폼 기종이라면 GestureDetector로감싼부분 밖을 클릭하면 키보드 내려가는 기능
    //     if (Platform.isIOS) {
    //       SystemChannels.textInput.invokeMethod('TextInput.hide');
    //     }
    //   },
    //   child: Obx(
    //     () {
    //       return Container(
    //         padding: const EdgeInsets.all(20.0),
    //         height: MediaQuery.of(context).size.height * 0.75,
    //         width: MediaQuery.of(context).size.width,
    //         child: Column(
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   const Text(
    //                     "쾌변기록",
    //                     style: TextStyle(
    //                       fontSize: 25,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 20,
    //                     width: 20,
    //                     child: IconButton(
    //                       onPressed: () {
    //                         timerController.resetBottomSheetValues();
    //                         Get.back();
    //                       },
    //                       icon: const Icon(
    //                         Icons.cancel,
    //                         size: 20,
    //                       ),
    //                     ),
    //                   ),
    //                   // const SizedBox(
    //                   //   width: 10,
    //                   // ),
    //                 ],
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             const Text(
    //               "만족도",
    //               style: TextStyle(fontSize: 18),
    //             ),
    //             starRatingbar(timerController),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             const Text(
    //               "변 모양",
    //               style: TextStyle(fontSize: 18),
    //             ),
    //             ToggleButtons(
    //               onPressed: (int index) {
    //                 timerController.selectedShapeFunc(index);
    //               },
    //               borderRadius: const BorderRadius.all(Radius.circular(8)),
    //               selectedBorderColor: Colors.grey,
    //               selectedColor: Colors.white,
    //               fillColor: Colors.blueGrey,
    //               color: Colors.black,
    //               constraints: const BoxConstraints(
    //                 minHeight: 45.0,
    //                 minWidth: 45.0,
    //               ),
    //               isSelected: timerController.selectedShape,
    //               children: shapeContainer,
    //             ),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             const Text(
    //               "색상",
    //               style: TextStyle(fontSize: 18),
    //             ),
    //             ToggleButtons(
    //               onPressed: (int index) {
    //                 timerController.selectedColorsFunc(index);
    //               },
    //               borderRadius: const BorderRadius.all(Radius.circular(8)),
    //               selectedBorderColor: Colors.grey,
    //               selectedColor: Colors.white,
    //               fillColor: Colors.blueGrey,
    //               color: Colors.black,
    //               constraints: const BoxConstraints(
    //                 minHeight: 45.0,
    //                 minWidth: 45.0,
    //               ),
    //               isSelected: timerController.selectedColors,
    //               children: coloredContainers,
    //             ),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             const Text(
    //               "냄새",
    //               style: TextStyle(fontSize: 18),
    //             ),
    //             ToggleButtons(
    //               onPressed: (int index) {
    //                 timerController.selectedSmellsFunc(index);
    //               },
    //               borderRadius: const BorderRadius.all(Radius.circular(8)),
    //               selectedBorderColor: Colors.grey,
    //               selectedColor: Colors.white,
    //               fillColor: Colors.blueGrey,
    //               color: Colors.black,
    //               constraints: const BoxConstraints(
    //                 minHeight: 45.0,
    //                 minWidth: 45.0,
    //               ),
    //               isSelected: timerController.selectedSmells,
    //               children: smellsSizedbox,
    //             ),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             const Text(
    //               "일지",
    //               style: TextStyle(fontSize: 18),
    //             ),
    //             SizedBox(
    //               height: 150,
    //               width: 300,
    //               child: TextField(
    //                 controller: timerController.resultTextController,
    //                 maxLines: 3,
    //                 maxLength: 60,
    //                 decoration: const InputDecoration(
    //                   hintText: "특이사항을 기록해주세요.",
    //                   border: OutlineInputBorder(),
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 20,
    //             ),
    //             ElevatedButton(
    //               onPressed: () {
    //                 _insertAction(context);
    //                 timerController.resetBottomSheetValues();
    //                 Get.back();
    //               },
    //               child: const Text("저장하기"),
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //   ),
    // ),
  // );
}

// SQLite의 record 테이블에 배변 기록을 insert하는 함수
_insertAction(context) async {
  DatabaseHandler handler = DatabaseHandler();
  TimerController timerController = Get.find();

  String shape = timerController.resultShape;
  String color = timerController.resultColor;
  String smell = timerController.resultSmell;
  String review = timerController.resultTextController.text;
  DateTime now = DateTime.now();
  String currentTime = now.toString();

  var recordInsert = RecordModel(
    rating: timerController.rating,
    shape: shape,
    color: color,
    smell: smell,
    review: review,
    takenTime: timerController.formattedTime(),
    currentTime: currentTime,
  );
  await handler.insertAction(recordInsert);
  _showDialog();
}

// 입력결과 다이어로그
_showDialog() {
  Get.defaultDialog(
      title: "입력 결과",
      middleText: "입력이 완료 되었습니다.",
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.offAll(() => const Home());
          },
          child: const Text("OK"),
        ),
      ]);
}

// ratingbar 위젯
Widget starRatingbar(controller) {
  return RatingBar.builder(
    initialRating: controller.rating,
    minRating: 0.5,
    direction: Axis.horizontal,
    allowHalfRating: true,
    itemCount: 5,
    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
    itemBuilder: (context, _) => const Icon(
      Icons.star,
      color: Colors.amber,
    ),
    onRatingUpdate: (rating) {
      controller.rating = rating;
    },
  );
}
// } // End
