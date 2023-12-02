import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/VM/calendar_ctrl.dart';
import 'package:guardians_of_health_project/home.dart';

void main() async {
  // main 함수 비동기 처리 위해서 꼭 적어야 함. (landscpae 막기 하기위함)
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // 앱 시작시 .env파일 로드

  // landscpae 막기
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  static const seedColor = Color.fromARGB(255, 228, 244, 233);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 신선한 녹색
  // CalendarController calendarController = Get.put(CalendarController());

  @override
  Widget build(BuildContext context) {
// for (int i = 1; i <= 12; i++) {
//   // 현재 날짜의 연도를 가져옴
//   int currentYear = calendarController.selectedDay.value!.year;

//   // DateTime의 생성자를 사용하여 연도와 월을 설정
//   DateTime selectedDateTime = DateTime(currentYear, i, 1);

//   // 첫 번째 날을 선택하고 해당 월의 휴일 정보를 가져옴
//   calendarController.changeSelectedDay(selectedDateTime);
//   calendarController.getHolidayData(
//     selectedDateTime.year,
//     selectedDateTime.month,
//   );

//   // 마지막 날을 계산
//   int lastDayOfMonth = DateTime(currentYear, i + 1, 0).day;

//   // 마지막 날을 선택하고 해당 월의 휴일 정보를 가져옴
//   calendarController.changeSelectedDay(DateTime(currentYear, i, lastDayOfMonth));
//   calendarController.getHolidayData(
//     currentYear,
//     i,
//   );
// }
//     setState(() {});
    return GetMaterialApp(
      title: 'Flutter Demo',
      // Localization
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // === Theme 세팅 시작 ===
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: MyApp.seedColor,
        fontFamily: "omyu-pretty",
        // primaryColor: seedColor, // 앱바 및 기본 색상
        scaffoldBackgroundColor: MyApp.seedColor, // Scaffold의 배경 색상
        appBarTheme: const AppBarTheme(
          backgroundColor: MyApp.seedColor, // 앱바 배경 색상
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
                MaterialStateProperty.all(MyApp.seedColor), // 일반 버튼 배경 색상
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
                MaterialStateProperty.all(MyApp.seedColor), // 아웃라인 버튼 배경 색상
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
      ), 
      // === Theme 세팅 끝 ===
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
