/*
  기능: 웹뷰로 건강정보를 검색한 화면을 보여주는 뷰
*/

import 'package:flutter/material.dart';

class HealthInfoPage extends StatelessWidget {
  const HealthInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Property
    List<String> helthInfoList = [
      "야채, 수분, 식이섬유는 많이! 육류와 기름진건 적게!",
      "술, 담배 NO!, 유산균 YES!",
      "화장실에서 휴대폰, 신문, 독서는 피하기!",
      "정기적인 내시경 검진은 필수!",
      "항문 출혈, 통증, 종괴, 분비물이 있으면\n   대장항문외과 전문의에게 진료받기!",
      "1주일 5회 30분씩 중~고강도의 운동 실천하기!",
    ];

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60,),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("대한대장항문협회 대장건강 6계명",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.6,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${(index+1).toString()}. ",
                            style: TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                          Text(helthInfoList[index],
                          style: TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                ),
            ),
          ],
        ),
        ),
    );
  }
}