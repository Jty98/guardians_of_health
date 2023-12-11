import 'package:flutter/material.dart';

class MyRecordView extends StatelessWidget {
  const MyRecordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 쾌변 기록'),
      ),
      body: Center(
        child: Text("정태영은 입만 열면 구라탱 \n학원만 오면 지각탱\n누나를 우습게 아는 버르장탱이"),
      ),
    );
  }
}