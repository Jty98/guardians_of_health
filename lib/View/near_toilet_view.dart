import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    searchBarController = TextEditingController();
    canRun = false;
    checkLocationPermission();      // 위치 권한 사용 동의 여부
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [         
          canRun
            ? flutterMap()
            : const Center(
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SearchBar(
              controller: searchBarController,
              hintText: '내 근처 화장실 찾기',
              shadowColor: const MaterialStatePropertyAll(Colors.blueGrey),     // 시드컬러 따라 바꾸기
              trailing: [
                IconButton(
                  onPressed: (){
            
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
      ),
    );
  }

  Widget flutterMap(){
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
        MarkerLayer(
          markers: [
            Marker(     // 현재 데이터
              width: 120,
              height: 120,
              point: latlng.LatLng(latData, longData), 
              child: const Icon(
                Icons.location_pin,
                size: 50,
                color: Colors.red,
              ),
            ),
            // 반경 내 1km 거리 계산한 뒤 list로 받아서 뿌려주면 되려나?
          ]
        ),
      ],
    );
  }

    // ---------- functions ----------
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


}   // END