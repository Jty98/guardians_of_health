import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/VM/change_ui_mode.dart';
import 'package:guardians_of_health_project/main.dart';
import 'package:guardians_of_health_project/my_theme.dart';

class SelectScreenMode extends StatefulWidget {
  const SelectScreenMode({super.key});   
  // final Function(ThemeMode) onChangeTheme;      // main page에 있는 home: Home(onChangeTheme: _changeThemeMode) 형태에 맞춰 수정

  @override
  State<SelectScreenMode> createState() => _SelectScreenModeState();
}

class _SelectScreenModeState extends State<SelectScreenMode> {
  late bool isLightMode;
  
  @override
  void initState() {
    super.initState();
    isLightMode = true;
  }

  @override
  Widget build(BuildContext context) {
    MyAppState? myAppState = context.findRootAncestorStateOfType<MyAppState>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "색상",
            style: TextStyle(
              fontSize: 35,
              // color:       // 테마 색상 선택에 따라 변경되도록
              fontWeight: FontWeight.bold,
              
            ),
          ),
        ),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  // light mode / dark mode 선택시 스위치처럼 값 하나씩 선택해서 바뀌도록 하기
                  isLightMode ? myAppState?.changeThemeMode(ThemeMode.light)
                              : myAppState?.changeThemeMode(ThemeMode.dark);
                  setState(() {
                    
                  });
                },
                child: Column(     // 라이트모드 선택지 
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        isLightMode ? "assets/images/lightmode.png"
                                    : "assets/images/darkmode.png",
                        width: 100,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          isLightMode ? "라이트 모드    " : "다크 모드    ",
                          style: const TextStyle(
                            fontSize: 20
                          ),
                        ),
                        Switch(
                          activeColor: Theme.of(context).colorScheme.primary,
                          inactiveTrackColor: Theme.of(context).colorScheme.primaryContainer,
                          value: isLightMode, 
                          onChanged: (value) {
                            isLightMode = value;
                            value ? myAppState!.changeThemeMode(ThemeMode.light)
                              : myAppState!.changeThemeMode(ThemeMode.dark);
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ToggleButtons(
            //   children: children, 
            //   isSelected: isSelected,
            // )
          ],
        )
      ],
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