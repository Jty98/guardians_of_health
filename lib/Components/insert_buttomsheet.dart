import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Model/database_handler.dart';
import 'package:guardians_of_health_project/Model/record_model.dart';
import 'package:guardians_of_health_project/Model/result_rating_model.dart';
import 'package:guardians_of_health_project/VM/timer_ctrl.dart';

// class InsertButtomsheet extends StatelessWidget {
// const InsertButtomsheet({super.key});

void insertBottomSheet(BuildContext context) {
  TimerController timerController = Get.find();

  Get.bottomSheet(
    isScrollControlled: true, // 바텀시트 높이 조절할려면 이 옵션이 필수
    backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
    GestureDetector(
      onTap: () {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: IconButton(
                        onPressed: () => Get.back(), 
                        icon: const Icon(Icons.cancel,
                        size: 15,
                        ),
                        ),
                    ),
                    const SizedBox(width: 10,),
                  ],
                ),
                const Text(
                  "쾌변기록",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "만족도",
                  style: TextStyle(fontSize: 18),
                ),
                starRatingbar(),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "변 모양",
                  style: TextStyle(fontSize: 18),
                ),
                ToggleButtons(
                  onPressed: (int index) {
                    timerController.shapeFunc(index);
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
                  children: timerController.shape,
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
                    timerController.colorsFunc(index);
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
                  children: timerController.colors,
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
                    timerController.smellsFunc(index);
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
                  children: timerController.smells,
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
                    Get.back();
                  },
                  child: const Text("저장하기"),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

  _insertAction(context) async {
    DatabaseHandler handler = DatabaseHandler();

    TimerController timerController = Get.find();
    int result = 0;

    // double rating = timerController.resultRating.valuel;
    String shape = timerController.resultShape;
    String color = timerController.resultColor;
    String smell = timerController.resultSmell;
    String review = timerController.resultTextController.text;

    print("shape: $shape");
    print("color: $color");
    print("smell: $smell");
    print("review: $review");

    var recordInsert = RecordModel(
      rating: ResultRatingModel.resultRating, 
      shape: shape, 
      color: color, 
      smell: smell, 
      review: review, 
      takenTime: timerController.formattedTime(), 
      // currentTime: currentTime,
      );
    result = await handler.insertAction(recordInsert);
    // if(result == 1){
      _showDialog();
    // } else {
      // _showSnackbar(context);
    // }
  }

    _showDialog() {
    Get.defaultDialog(
        title: "입력 결과",
        middleText: "입력이 완료 되었습니다.",
        barrierDismissible: false,
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("OK"),
          ),
        ]);
  }

    // _showSnackbar(context){
    //   Get.snackbar(
    //     "입력 결과", 
    //     "입력에 실패했습니다.",
    //     duration: const Duration(seconds: 1),
    //     backgroundColor: Theme.of(context).colorScheme.error,
    //     colorText: Theme.of(context).colorScheme.onError,
    //     );
    // }


  // ratingbar
  Widget starRatingbar() {
    return RatingBar.builder(
      initialRating: ResultRatingModel.resultRating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        ResultRatingModel.resultRating = rating;
        // timerController.resultRating.value = rating;
        print(rating);
        print(ResultRatingModel.resultRating);
      },
    );
  }
// } // End
