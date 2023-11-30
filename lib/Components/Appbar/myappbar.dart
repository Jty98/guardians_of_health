import 'package:flutter/material.dart';

// AppBar를 위젯으로 쓰기 위해서는 사이즈 문제 때문에 implements PreferredSizeWidget를 해줘야함
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // TimerController timerController = Get.put(TimerController());

    return AppBar(
      // automaticallyImplyLeading: false, // 뒤로가기 버튼 없애기
      title: const Text("골든타임"),
    );
  }

  @override
  // preferredSize 지정
  Size get preferredSize => const Size.fromHeight(56);
}
