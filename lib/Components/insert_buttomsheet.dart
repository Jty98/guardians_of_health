import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
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
      child: Container(
        padding: const EdgeInsets.all(20.0),
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // 바나나 똥 모양 선택
                  },
                  child: const Text("바나나"),
                ),
                TextButton(
                  onPressed: () {
                    // 포도알 똥 모양 선택
                  },
                  child: const Text("포도알"),
                ),
                TextButton(
                  onPressed: () {
                    // 물 똥 모양 선택
                  },
                  child: const Text("물"),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "색상",
              style: TextStyle(fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // 황금 똥색 선택
                  },
                  child: const Text("황금"),
                ),
                TextButton(
                  onPressed: () {
                    // 진갈색 똥색 선택
                  },
                  child: const Text("진갈색"),
                ),
                TextButton(
                  onPressed: () {
                    // 검정색 똥색 선택
                  },
                  child: const Text("검정색"),
                ),
                TextButton(
                  onPressed: () {
                    // 빨간색 똥색 선택
                  },
                  child: const Text("빨간색"),
                ),
                TextButton(
                  onPressed: () {
                    // 녹색 똥색 선택
                  },
                  child: const Text("녹색"),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "냄새",
              style: TextStyle(fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // 고약한 똥 냄새 선택
                  },
                  child: const Text("상"),
                ),
                TextButton(
                  onPressed: () {
                    // 무난한 똥 선택
                  },
                  child: const Text("중"),
                ),
                TextButton(
                  onPressed: () {
                    // 쾌적한 똥 냄새 선택
                  },
                  child: const Text("하"),
                ),
              ],
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
                Get.back();
              },
              child: const Text("저장하기"),
            ),
          ],
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
// } // End
