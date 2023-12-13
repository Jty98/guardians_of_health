import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/VM/change_ui_mode.dart';
import 'package:guardians_of_health_project/main.dart';
import 'package:guardians_of_health_project/my_theme.dart';

class SelectScreenMode extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;      // main page에 있는 home: Home(onChangeTheme: _changeThemeMode) 형태에 맞춰 수정
  final Function(Color) onChangeThemeColor;      // main page에 있는 home: Home(onChangeTheme: _changeThemeMode) 형태에 맞춰 수정
  const SelectScreenMode({super.key, required this.onChangeTheme, required this.onChangeThemeColor});   

  @override
  State<SelectScreenMode> createState() => _SelectScreenModeState();
}

class _SelectScreenModeState extends State<SelectScreenMode> {
  late bool isDarkMode;
  
  @override
  void initState() {
    super.initState();
    isDarkMode = false;
  }

  @override
  Widget build(BuildContext context) {
    // MyAppState? myAppState = context.findRootAncestorStateOfType<MyAppState>();

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
                  setState(() {
                    
                  });
                  print("터치 됐당 ");
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
                  setState(() {
                    
                  });
                  print("터치 됐당 ");
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
                  setState(() {
                    
                  });
                  print("터치 됐당 ");
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
                  setState(() {
                    
                  });
                  print("터치 됐당 ");
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
                  print("터치 전이당");
                  widget.onChangeThemeColor(Colors.purple);
                  setState(() {
                    
                  });
                  print("터치 됐당 ");
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
              // MyTheme.seedColor = Colors.white;
            }, 
            child: const Text("기본 스타일로 변경"),
          )
        ],
      ),
    );
  }
}




// void selectScreenMode (BuildContext context){
//   Get.bottomSheet(
//   // isScrollControlled: true,
//   backgroundColor: Colors.white,      // 라이트/다크모드에 따라 바뀌게 하기
//   Column(
//     children: [
//       Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Text(
//           "색상",
//           style: TextStyle(
//             fontSize: 35,
//             // color:       // 테마 색상 선택에 따라 변경되도록
//             fontWeight: FontWeight.bold,
            
//           ),
//         ),
//       ),
//       const SizedBox(height: 50),
//       Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: (){
//                 // light mode / dark mode 선택시 스위치처럼 값 하나씩 선택해서 바뀌도록 하기
//                 widget.onChangeTheme(ThemeMode.dark);
//                 ChangeUIMode(onChangeTheme: _changeThemeMode)
//               },
//               child: Column(     // 라이트모드 선택지 
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Image.asset(
//                       "assets/images/lightmode.png",
//                       width: 100,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       const Text(
//                         "라이트 모드    "
//                       ),
//                       Image.asset(
//                         "assets/images/lightSwitch.png",
//                         width: 50,
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // ToggleButtons(
//           //   children: children, 
//           //   isSelected: isSelected,
//           // )
//         ],

//       )
//     ],
//   )
// );

// }