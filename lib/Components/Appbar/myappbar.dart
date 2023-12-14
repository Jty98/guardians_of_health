/*
  기능: 앱바
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// AppBar를 위젯으로 쓰기 위해서는 사이즈 문제 때문에 implements PreferredSizeWidget를 해줘야함
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {

    return AppBar(
      // automaticallyImplyLeading: false, // 뒤로가기 버튼 없애기
      title: Text("골든타임",
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  @override
  // preferredSize 지정
  Size get preferredSize => Size.fromHeight(56.h);
}
