import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectScreenMode extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;      // main page에 있는 home: Home(onChangeTheme: _changeThemeMode) 형태에 맞춰 수정
  final Function(Color) onChangeThemeColor;      // main page에 있는 home: Home(onChangeTheme: _changeThemeMode) 형태에 맞춰 수정
  const SelectScreenMode({super.key, required this.onChangeTheme, required this.onChangeThemeColor});   
  // const SelectScreenMode({super.key});   

  @override
  State<SelectScreenMode> createState() => _SelectScreenModeState();
}

class _SelectScreenModeState extends State<SelectScreenMode> {
  late bool isDarkMode;
  late int themeColor;
  
  @override
  void initState() {
    super.initState();
    isDarkMode = false;
    themeColor = 0;               // 0: white, 1: red, 2: yellow, 3: green, 4: blue, 5: purple
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
            child: Text(
              "색상",
              style: TextStyle(
                fontSize: 35.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    // light mode / dark mode 선택시 스위치처럼 값 하나씩 선택해서 바뀌도록 하기
                    isDarkMode ? widget.onChangeTheme(ThemeMode.dark)
                                : widget.onChangeTheme(ThemeMode.light);
                    isDarkMode = !isDarkMode;
                    saveThemeInfo();
                    setState(() {
                      
                    });
                  },
                  child: Column(     // 라이트모드 선택지 
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
                        child: Image.asset(
                          isDarkMode ? "assets/images/darkmode.png"
                                      : "assets/images/lightmode.png",
                          width: 100.w,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            isDarkMode ? "다크 모드    " : "라이트 모드    ",
                            style: TextStyle(
                              fontSize: 20.sp
                            ),
                          ),
                          Switch(
                            activeColor: Theme.of(context).colorScheme.primary,
                            inactiveTrackColor: Theme.of(context).colorScheme.primaryContainer,
                            value: isDarkMode, 
                            onChanged: (value) {
                              isDarkMode = value;
                              value ? widget.onChangeTheme(ThemeMode.dark)
                                : widget.onChangeTheme(ThemeMode.light);
                              saveThemeInfo();
                              setState(() {
                                
                              });
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  widget.onChangeThemeColor(Colors.red);
                  themeColor = 1;
                  saveThemeInfo();
                  setState(() {
                    
                  });
                  // print("터치 됐당 ");
                  // print(MyAppState().seedColor.toString());                  
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  widget.onChangeThemeColor(Colors.yellow);
                  themeColor = 2;
                  saveThemeInfo();
                  setState(() {
                    
                  });
                  // print("터치 됐당 ");
                  // print(MyTheme.seedColor.toString());                  
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.yellow
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  widget.onChangeThemeColor(Colors.green);
                  themeColor = 3;
                  saveThemeInfo();
                  setState(() {
                    
                  });
                  // print("터치 됐당 ");
                  // print(MyTheme.seedColor.toString());                  
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  widget.onChangeThemeColor(Colors.blue);
                  themeColor = 4;
                  saveThemeInfo();
                  setState(() {
                    
                  });
                  // print("터치 됐당 ");
                  // print(MyTheme.seedColor.toString());                  
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  // print("터치 전이당");
                  widget.onChangeThemeColor(Colors.purple);
                  themeColor = 5;
                  saveThemeInfo();
                  setState(() {
                    
                  });
                  // print("터치 됐당 ");
                  // print(MyTheme.seedColor.toString());
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          ElevatedButton(
            onPressed: (){
              widget.onChangeThemeColor(Colors.white);
              themeColor = 0;
              saveThemeInfo();
              setState(() {
                
              });
            }, 
            child: const Text("기본 스타일로 변경"),
          )
        ],
      ),
    );
  }

  saveThemeInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("ThemeMode", isDarkMode);       // ThemeMode == 0 : lightMode | ThemeMode == 1 : darkMode
    prefs.setInt("ThemeColor", themeColor);       // themeColor == 0: white, 1: red, 2: yellow, 3: green, 4: blue, 5: purple
  }


}   // END
