import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guardians_of_health_project/Model/toilets_model.dart';
import 'package:latlong2/latlong.dart' as latlng; 
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

class NearToiletView extends StatefulWidget {
  const NearToiletView({super.key});

  @override
  State<NearToiletView> createState() => _NearToiletViewState();
}

class _NearToiletViewState extends State<NearToiletView> {
  // property
  late Position currentPosition;
  late double latData;
  late double longData;

  late MapController mapController;
  late TextEditingController searchBarController;
  late bool canRun;
  late List location;
  late List data;       // 전국 화장실 지도 받아올 데이터


  @override
  void initState() {
    super.initState();
    mapController = MapController();
    searchBarController = TextEditingController();
    canRun = false;
    checkLocationPermission();      // 위치 권한 사용 동의 여부
    data = [];
    getToiletsJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getToiletsJsonData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<ToiletsModel> toilets = snapshot.data as List<ToiletsModel>;
            return Stack(
              children: [         
                canRun
                  ? flutterMap(toilets)
                  : const Center(
                    child: CircularProgressIndicator(),
                  ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SearchBar(
                    controller: searchBarController,
                    hintText: '내 근처 공중화장실 찾기',
                    elevation: const MaterialStatePropertyAll(15),    
                    shape: const MaterialStatePropertyAll(
                      ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      )
                    ),
                    shadowColor: const MaterialStatePropertyAll(Colors.blueGrey),     // 시드컬러 따라 바꾸기
                    trailing: [
                      IconButton(
                        onPressed: (){
                          // bottom sheet로 근처 화장실 가까운 거리 순서로 띄워주기 (영업시간 꼭 확인하라는 문구와 함께)
                        }, 
                        icon: const Icon(
                          Icons.search_outlined
                        ),
                      ),
                    ]
                  ),
                ),  
                Positioned(
                  bottom: 100,
                  right: 20,
                  child: FloatingActionButton(
                    backgroundColor: Colors.blueGrey,     // seedColor에 맞춰 바꾸기
                    onPressed: (){
                      getCurrentLocation();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: const Icon(
                      Icons.location_searching_outlined
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget flutterMap(List<ToiletsModel> toilets){
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: latlng.LatLng(latData, longData),
        initialZoom: 17.0
      ), 
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        ),
        MarkerLayer(           // 전국 화장실 데이터
          markers: toilets.map((toilets) {
            return Marker(    
              width: 120,
              height: 120,
              point: latlng.LatLng(toilets.x, toilets.y), 
              child: Column(
                children: [
                  Text(toilets.name),
                  Text(toilets.address),
                  const Icon(
                    Icons.location_pin,
                    size: 50,
                    color: Colors.blue,
                  ),
                ],
              ),
            );
          }).toList(),
          //   // 반경 내 1km 거리 계산한 뒤 list로 받아서 뿌려주면 되려나?
          //   // 현재 내 위치를 넣고 거리 계산한 뒤 1km 반경 내 화장실 return 해주는 모델 만들기?
        ),
        MarkerLayer(          // 현재 내위치 데이터
          markers: [ 
            Marker(   
              width: 120,
              height: 120,
              point: latlng.LatLng(latData, longData), 
              child: const Icon(
                Icons.location_pin,
                size: 50,
                color: Colors.red,
              ),
            ),
          ],
        )
      ],
    );
  }

  // ---------- functions ----------
  ///// 위치 사용 권한 확인 
  checkLocationPermission() async{      // permission 받을때 까지 await를 통해 대기해야함. 사용자의 선택에 따라 활동이 정해지거나 대기해야 하면 무조건 async await
    LocationPermission permission = await Geolocator.checkPermission();     // 사용자의 허용을 받았는지 여부에 따라 조건문 작성
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      getCurrentLocation();           // 허용하면 현재 위치 가져오는 함수 실행 
    }
  }

  ////// 내 위치 불러오기
  getCurrentLocation() async{
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true).then((position) {
        currentPosition = position;
        canRun = true;
        latData = currentPosition.latitude;
        longData = currentPosition.longitude;
        setState(() {});
        print("현재위치 위도 : 경도 = " + latData.toString() + " : " + longData.toString());
      }).catchError((e){
        print(e);
      });
  }

  ////// 전국 화장실 (toilets.json) 데이터 불러오기
  Future<List<ToiletsModel>> getToiletsJsonData() async {
    var routeFromJsonFile = await rootBundle.loadString('assets/json/toilets.json');
    List<dynamic> listFromJson = json.decode(routeFromJsonFile);
    return listFromJson.map((json) => ToiletsModel.fromMap(json)).toList();
  }


}   // END