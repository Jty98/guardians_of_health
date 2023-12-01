import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/home.dart';

void main() async {
  // main 함수 비동기 처리 위해서 꼭 적어야 함.
  WidgetsFlutterBinding.ensureInitialized();

  // landscpae 막기
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const seedColor = Color.fromARGB(255, 228, 244, 233); // 신선한 녹색

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      // Localization
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Theme 세팅 시작
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: seedColor,
        fontFamily: "omyu-pretty",
        // primaryColor: seedColor, // 앱바 및 기본 색상
        scaffoldBackgroundColor: seedColor, // Scaffold의 배경 색상
        appBarTheme: const AppBarTheme(
          backgroundColor: seedColor, // 앱바 배경 색상
          titleTextStyle: TextStyle(
            color: Colors.black, // 앱바 글자색
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        // ElevatedButton 세팅
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(seedColor), // 일반 버튼 배경 색상
            foregroundColor:
                MaterialStateProperty.all(Colors.black), // 일반 버튼 글자색
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6), // 테두리 모서리 둥글기 설정
                side: const BorderSide(color: Colors.black), // 테두리 선 색상 및 너비 설정
              ),
            ),
          ),
        ),
        // outlineButton 세팅
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(seedColor), // 아웃라인 버튼 배경 색상
            foregroundColor:
                MaterialStateProperty.all(Colors.black), // 아웃라인 버튼 글자색
          ),
        ),
        // textButton 세팅
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all(Colors.black), // 텍스트 버튼 글자색
          ),
        ),
      ), // Theme 세팅 끝
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
