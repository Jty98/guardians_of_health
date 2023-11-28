import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/VM/timer_ctrl.dart';
import 'package:guardians_of_health_project/home.dart';

// AppBar를 위젯으로 쓰기 위해서는 사이즈 문제 때문에 implements PreferredSizeWidget를 해줘야함
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    TimerController timerController = Get.put(TimerController());

    return AppBar(
      title: const Text("골든타임"),
    );
  }

  @override
  // preferredSize 지정
  Size get preferredSize => const Size.fromHeight(56);
}
