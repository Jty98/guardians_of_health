// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:get/get.dart';
// import 'package:guardians_of_health_project/Components/Numberpad/first_numberpad_view.dart';
// import 'package:guardians_of_health_project/VM/setting_ctrl.dart';
// import 'package:guardians_of_health_project/home.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// void main() async {
//   // main 함수 비동기 처리 위해서 꼭 적어야 함. (landscpae 막기 하기위함)
//   WidgetsFlutterBinding.ensureInitialized();
//   SettingController settingController = Get.put(SettingController());

//   await settingController.initPasswordValue(); // 앱 시작시 password 읽어오거나 password status 읽어오기

//   // landscpae 막기
//   SystemChrome.setPreferredOrientations(
//     [
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ],
//   );
//   runApp(const MyApp());

// }

// class MyApp extends StatefulWidget {

//   const MyApp({super.key});
//   @override
//   State<MyApp> createState() => MyAppState();
// }

// class MyAppState extends State<MyApp> {
//   ThemeMode _themeMode = ThemeMode.system;      // system : 사용자가 정해둔 대로 보여준다. 
//   static var seedColor = Colors.white;

//   changeThemeMode(ThemeMode themeMode){     // _ : private 함수
//     _themeMode = themeMode;       // home page에서 버튼을 누르면 역으로 올라와 여기서 색상을 바꿔줌. 
//     // setState(() {
      
//     // });
//   }

//   changeSeedColor(Color getSeedColor) {
//     seedColor = getSeedColor;
//     // setState(() {
      
//     // });
//   }


//   @override
//   Widget build(BuildContext context) {

//     return ScreenUtilInit(
//       designSize: const Size(393, 852), // IPhone 14 & 15 Pro 기기 해상도
//       builder: () {
//     final settingController = Get.find<SettingController>();

//     if (settingController.passwordValue.value == true) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         // MyWidgets의 Build가 끝난 후 실행 (이렇게 안하면 순서상 오류가 생겨서 localizationsDelegates에서 오류남)
//         firstNumberpadDialog(Get.context!);
//       });
//     )}}

// }
//       GetMaterialApp(
//         title: 'Flutter Demo',
//         // Localization
//         localizationsDelegates: const [
//           GlobalMaterialLocalizations.delegate,
//           GlobalWidgetsLocalizations.delegate,
//           GlobalCupertinoLocalizations.delegate,
//         ],
//         // === Theme 세팅 시작 ===
//         // themeMode: _themeMode,
//         themeMode: _themeMode,
//         darkTheme: modeDarkTheme(),
//         theme: modeLightTheme(),     
//         // color: _seedColor,
      
//         // === Theme 세팅 끝 ===
//         home: const Home(),
//         debugShowCheckedModeBanner: false,
      
//     );
//   }

//   modeDarkTheme() {
//     ThemeData(
//       brightness: Brightness.dark,
//       useMaterial3: true,
//       colorSchemeSeed: seedColor,
//       fontFamily: "omyu-pretty",
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ButtonStyle(
//           shape: MaterialStateProperty.all(
//             RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(6), // 테두리 모서리 둥글기 설정
//             ),
//           ),
//         ),
//       ),
//     ); 
//   }

//   modeLightTheme() {
//     ThemeData(
//       brightness: Brightness.light,
//       useMaterial3: true,
//       colorSchemeSeed: seedColor,
//       fontFamily: "omyu-pretty",
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ButtonStyle(
//           shape: MaterialStateProperty.all(
//             RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(6), // 테두리 모서리 둥글기 설정
//             ),
//           ),
//         ),
//       ),
//     ); 
//   }



// }   // END


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/Numberpad/first_numberpad_view.dart';
import 'package:guardians_of_health_project/VM/setting_ctrl.dart';
import 'package:guardians_of_health_project/home.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SettingController settingController = Get.put(SettingController());

  await settingController.initPasswordValue();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system; // system : 사용자가 정해둔 대로 보여준다. 
  static var seedColor = Colors.white;

  changeThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;                // home page에서 버튼을 누르면 역으로 올라와 여기서 색상을 바꿔줌. 
  }

  changeSeedColor(Color getSeedColor) {
    seedColor = getSeedColor;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(          // 기기별 Layout 조절
      designSize: const Size(430, 932), // IPhone 14 & 15 ProMax 기기 해상도
      builder: (context, child) {
        final settingController = Get.find<SettingController>();

        if (settingController.passwordValue.value == true) {
           // MyWidgets의 Build가 끝난 후 실행 (이렇게 안하면 순서상 오류가 생겨서 localizationsDelegates에서 오류남)
          WidgetsBinding.instance.addPostFrameCallback((_) {
            firstNumberpadDialog(Get.context!);
          });
        }

        return GetMaterialApp(
          title: 'Flutter Demo',
          // Localization
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // Theme 세팅
          themeMode: _themeMode,
          darkTheme: modeDarkTheme(),
          theme: modeLightTheme(),
          // MediaQuery에 화면 배율을 1배로 고정해서 확대해서 깨지는일 없게하기
          builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!);
        },
          home: const Home(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }

  ThemeData modeDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorSchemeSeed: seedColor,
      fontFamily: "omyu-pretty",
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6), // 테두리 모서리 둥글기 설정
            ),
          ),
        ),
      ),
    );
  }

  ThemeData modeLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorSchemeSeed: seedColor,
      fontFamily: "omyu-pretty",
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6), // 테두리 모서리 둥글기 설정
            ),
          ),
        ),
      ),
    );
  }
} // End
