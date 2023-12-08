import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/VM/calendar_ctrl.dart';
import 'package:guardians_of_health_project/home.dart';
import 'package:guardians_of_health_project/my_theme.dart';

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
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;      // system : 사용자가 정해둔 대로 보여준다. 
  // static var seedColor = Colors.white;

  changeThemeMode(ThemeMode themeMode){     // _ : private 함수
    _themeMode = themeMode;       // home page에서 버튼을 누르면 역으로 올라와 여기서 색상을 바꿔줌. 
    setState(() {
      
    });
  }

  changeSeedColor(Color seedColor) {
    MyTheme.seedColor = seedColor;
    setState(() {
      
    });
  }

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
      // themeMode: _themeMode,
      themeMode: _themeMode,
      darkTheme: MyTheme.darkTheme,
      theme: MyTheme.lightTheme,     
      color: MyTheme.seedColor,

      // === Theme 세팅 끝 ===
      home: const Home(),
      debugShowCheckedModeBanner: false,
      
    );
  }
}
