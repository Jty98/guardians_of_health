import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(
                Icons.description_outlined
              ),
              title: const Text("내 쾌변 기록"),
              onTap: (){

              },
            ),
            ListTile(
              leading: const Icon(
                Icons.key_outlined
              ),
              title: const Text("비밀번호 설정"),
              onTap: (){

              },
            ),
            ListTile(
              leading: const Icon(
                Icons.medical_information_outlined
              ),
              title: const Text("건강 정보"),
              onTap: (){

              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings_suggest
              ),
              title: Text("테마 변경"),
            ),
            ListTile(
              title: Row(
                children: [
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red
                      ),
                      onPressed: (){
                        
                      }, 
                      child: const Text(""),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow
                      ),
                      onPressed: (){
                        
                      }, 
                      child: const Text(""),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green
                      ),
                      onPressed: (){
                        
                      }, 
                      child: const Text(""),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue
                      ),
                      onPressed: (){
                        
                      }, 
                      child: const Text(""),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple
                      ),
                      onPressed: (){
                        
                      }, 
                      child: const Text(""),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
  }
}