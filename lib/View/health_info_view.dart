/*
  기능: 웹뷰로 건강정보를 검색한 화면을 보여주는 뷰
*/

import 'package:flutter/material.dart';
import 'package:guardians_of_health_project/Components/health_info_widget.dart';

const List<String> helthInfoList = [
  "야채, 수분, 식이섬유는 많이! 육류와 기름진건 적게!",
  "술, 담배 NO!, 유산균 YES!",
  "화장실에서 휴대폰, 신문, 독서는 피하기!",
  "정기적인 내시경 검진은 필수!",
  "항문 출혈, 통증, 종괴, 분비물이 있으면\n대장항문외과 전문의에게 진료받기!",
  "1주일 5회 30분씩 중~고강도의 운동 실천하기!",
];

class HealthInfoPage extends StatelessWidget {
  const HealthInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "건강 정보",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: healthInfoWidget(context: context),
    );
  }
}
