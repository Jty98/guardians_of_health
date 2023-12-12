/*
  기능: 배변 타이머가 끝나고 기록을 저장할때 뜨는 바텀시트 위젯
*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
      width: 40.w,
      height: 40.h,
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
      width: 35.w,
      height: 35.w,
      decoration: BoxDecoration(
        color: containerColors[index],
        borderRadius: BorderRadius.circular(10.r),
      ),
    ),
  );

  // 냄새 리스트
  List<String> labels = ["상", "중", "하"];

  // 냄새 리스트 버튼
  List<SizedBox> smellsSizedbox = labels.map((label) {
    return SizedBox(
      width: 40.w,
      height: 40.h,
      child: Text(
        label,
        style: TextStyle(fontSize: 25.sp),
        textAlign: TextAlign.center,
      ),
    );
  }).toList();

  /// 기록 저장하는 바텀시트
  showModalBottomSheet(
    isScrollControlled: true, // 바텀시트 높이 조절할려면 이 옵션이 필수
    context: context,
    builder: (BuildContext context) {
      final bottomInset = MediaQuery.of(context).viewInsets.bottom;
      return
          // backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                if (Platform.isIOS) {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                }
              },
              child: Obx(
                () {
                  return Container(
                    padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
                    height: MediaQuery.of(context).size.height / 1.3.h + bottomInset,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: bottomInset),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
                                    child: Text(
                                      "쾌변기록",
                                      style: TextStyle(
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5.w, 0.h, 5.w, 5.h),
                                    child: SizedBox(
                                      child: IconButton(
                                        onPressed: () {
                                          timerController.resetBottomSheetValues();
                                          Get.back();
                                        },
                                        icon: const Icon(
                                          Icons.cancel,
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              "만족도",
                              style: TextStyle(fontSize: 18.sp),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
                              child: starRatingbar(timerController),
                            ),
                            SizedBox(
                              height: 10.sp,
                            ),
                            Text(
                              "변 모양",
                              style: TextStyle(fontSize: 18.sp),
                            ),
                            ToggleButtons(
                              onPressed: (int index) {
                                timerController.selectedShapeFunc(index);
                              },
                              borderRadius: BorderRadius.all(Radius.circular(8.r)),
                              selectedBorderColor: Colors.grey,
                              selectedColor: Colors.white,
                              fillColor: Colors.blueGrey,
                              color: Colors.black,
                              constraints: BoxConstraints(
                                minHeight: 45.0.h,
                                minWidth: 45.0.w,
                              ),
                              isSelected: timerController.selectedShape,
                              children: shapeContainer,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              "색상",
                              style: TextStyle(fontSize: 18.sp),
                            ),
                            ToggleButtons(
                              onPressed: (int index) {
                                timerController.selectedColorsFunc(index);
                              },
                              borderRadius: BorderRadius.all(Radius.circular(8.r)),
                              selectedBorderColor: Colors.grey,
                              selectedColor: Colors.white,
                              fillColor: Colors.blueGrey,
                              color: Colors.black,
                              constraints: BoxConstraints(
                                minHeight: 45.0.h,
                                minWidth: 45.0.w,
                              ),
                              isSelected: timerController.selectedColors,
                              children: coloredContainers,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              "냄새",
                              style: TextStyle(fontSize: 18.sp),
                            ),
                            ToggleButtons(
                              onPressed: (int index) {
                                timerController.selectedSmellsFunc(index);
                              },
                              borderRadius: BorderRadius.all(Radius.circular(8.r)),
                              selectedBorderColor: Colors.grey,
                              selectedColor: Colors.white,
                              fillColor: Colors.blueGrey,
                              color: Colors.black,
                              constraints: BoxConstraints(
                                minHeight: 45.0.h,
                                minWidth: 45.0.w,
                              ),
                              isSelected: timerController.selectedSmells,
                              children: smellsSizedbox,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              "일지",
                              style: TextStyle(fontSize: 18.sp),
                            ),
                            SizedBox(
                              height: 150.h,
                              width: 300.w,
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
                            ElevatedButton(
                              onPressed: () async {
                                await timerController.insertAction() == true
                                    // ignore: use_build_context_synchronously
                                    ? _showDialog(context)
                                    // ignore: use_build_context_synchronously
                                    : _showSnackbar(context);
                              },
                              child: const Text("저장하기"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
    },
  );
}

/// 입력결과 다이어로그
_showDialog(BuildContext context) {
  final timerController = Get.find<TimerController>();
  Get.defaultDialog(
    backgroundColor: Theme.of(context).colorScheme.tertiary,
    barrierDismissible: false,
    title: "저장 완료",
    middleText: "결과가 저장 되었습니다.",
    titleStyle: TextStyle(
        color: Theme.of(context).colorScheme.onTertiary,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold),
    middleTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onTertiary,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold),
    actions: [
      TextButton(
        onPressed: () {
          Get.offAll(() => const Home(), transition: Transition.noTransition);
          timerController.resetBottomSheetValues();
          Get.back(); // 다이얼로그 닫기
        },
        child: Text(
          "돌아가기",
          style: TextStyle(
              color: Theme.of(context).colorScheme.onTertiary,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}

/// 에러 스낵바
_showSnackbar(BuildContext context) {
  Get.showSnackbar(
    GetSnackBar(
      titleText: Text(
        "실패",
        style: TextStyle(
            color: Theme.of(context).colorScheme.onError,
            fontWeight: FontWeight.bold,
            fontSize: 20),
      ),
      messageText: Text(
        "저장에 실패했습니다.",
        style: TextStyle(
            color: Theme.of(context).colorScheme.onError,
            fontWeight: FontWeight.bold,
            fontSize: 16),
      ),
      duration: const Duration(seconds: 1),
      backgroundColor: Theme.of(context).colorScheme.error,
    ),
  );
}

/// ratingbar 위젯
Widget starRatingbar(controller) {
  return RatingBar.builder(
    initialRating: controller.rating,
    minRating: 0.5,
    direction: Axis.horizontal,
    allowHalfRating: true,
    itemCount: 5,
    itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
    itemBuilder: (context, _) => const Icon(
      Icons.star,
      color: Colors.amber,
    ),
    onRatingUpdate: (rating) {
      controller.rating = rating;
    },
  );
}


// End
