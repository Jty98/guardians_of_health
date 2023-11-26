import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Model/result_rating_model.dart';
import 'package:guardians_of_health_project/VM/timer_ctrl.dart';

class InsertButtomsheet extends StatelessWidget {
const InsertButtomsheet({super.key});


  @override
  Widget build(BuildContext context) {
    return showButtomSheet(context);
  }

  // --- Functions ---

  showButtomSheet(context) {
    // final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    TimerController timerController = Get.find();
    Get.bottomSheet(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      GestureDetector(
        onTap: () {
          // iOS에서만 키보드 강제로 내리기
          if (Platform.isIOS) {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          }
          // FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: const EdgeInsets.all(20.0),
          // color: Theme.of(context).colorScheme.tertiaryContainer,
          height: MediaQuery.of(context).size.height * 0.9,
          // height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "쾌변기록",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text("만족도"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    starRatingbar(),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text("기록"),
                ),
                SizedBox(
                  height: 150,
                  width: 300,
                  child: TextField(
                    controller: timerController.resultTextController,
                    maxLines: 3, // 여러 줄을 쓰기위해 null
                    maxLength: 60,
                    decoration: const InputDecoration(
                      hintText: "배변 중 특이사항을 기록해주세요.",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    // SQLite에 insrt하는거
                    Get.back();
                  },
                  child: const Text("저장하기"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

} // End