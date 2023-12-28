  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/VM/security_ctrl.dart';

  /// 비밀번호가 틀리거나 처음 들어왔을때 띄워주는 스낵바
  showSnackbar(
      {required String result,
      required String resultText,
      required Color resultbackColor,
      required Color resultTextColor,
      required SecurityController securityController,
      required SnackPosition snackPosition,
      }) {
    Get.showSnackbar(
      GetSnackBar(
        titleText: Text(
          result,
          style: TextStyle(
              color: resultTextColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        messageText: Text(
          resultText,
          style: TextStyle(
              color: resultTextColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        duration: const Duration(milliseconds: 1000),
        backgroundColor: resultbackColor,
        snackPosition: snackPosition,
        borderRadius: 50.r, // 둥글게하기
        margin: EdgeInsets.fromLTRB(60.w, 10.h, 60.w, 10.h), // 마진값으로 사이즈 조절
      ),
    );
    securityController.padNum = "".obs; // 비밀번호 확인 리스트 초기화
  }
