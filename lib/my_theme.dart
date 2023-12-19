import 'package:shared_preferences/shared_preferences.dart';

class MyTheme{

  /// SharedPreferences - 테마 변경 저장된 값 있으면 가져오기 (없으면 기본값)
  getThemeInfo() async {
    final prefs = await SharedPreferences.getInstance();
    List themeInfoList = [];
    bool isDarkMode = prefs.getBool('ThemeMode') ?? false;
    int themeColor = prefs.getInt('ThemeColor') ?? 0;
    
    themeInfoList.add(isDarkMode);
    themeInfoList.add(themeColor);
    print(themeInfoList);
    
    return themeInfoList;
  }
}