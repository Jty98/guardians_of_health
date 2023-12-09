import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Components/first_numberpad_view.dart';
import 'package:guardians_of_health_project/VM/setting_ctrl.dart';
import 'package:guardians_of_health_project/home.dart';
import 'package:guardians_of_health_project/my_theme.dart';

void main() async {
  // main 함수 비동기 처리 위해서 꼭 적어야 함. (landscpae 막기 하기위함)
  WidgetsFlutterBinding.ensureInitialized();
  SettingController settingController = Get.put(SettingController());

  await dotenv.load(fileName: ".env"); // 앱 시작시 .env파일 로드
  await settingController.initPasswordValue(); // 앱 시작시 password 읽어오거나 password status 읽어오기

  // landscpae 막기
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  runApp(const MyApp());

}

class MyApp extends StatefulWidget {

  const MyApp({super.key});
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


  @override
  Widget build(BuildContext context) {
    final settingController = Get.find<SettingController>();

    if (settingController.passwordValue.value == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // MyWidgets의 Build가 끝난 후 실행 (이렇게 안하면 순서상 오류가 생겨서 localizationsDelegates에서 오류남)
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
