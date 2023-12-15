import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guardians_of_health_project/Model/database_handler.dart';
import 'package:guardians_of_health_project/Model/my_record_data.dart';
import 'package:guardians_of_health_project/Model/record_count_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyRecordView extends StatefulWidget {
  const MyRecordView({super.key});

  @override
  State<MyRecordView> createState() => _MyRecordViewState();
}

class _MyRecordViewState extends State<MyRecordView> {
  late List recordData;                       // 사용자 기록 불러와 저장할 변수
  late TooltipBehavior tooltipBehavior;       // 차트 패키지
  late int segChoice;                        // segment 선택된 번호
  late DatabaseHandler handler;               // DataBase
  late List<bool> _selectedVariable;          // toggle button 선택 여부 리스트
  late List<String> recordVariable;           // record DB column명들
  late int selectedIndex;                     // toggle button 선택된 인덱스 ()
  late List savedDateList;                    // 저장 날짜 형태 데이터
  late List<MyRecordData> chartData;
  late List<RecordCountModel> recordCountList;   // 일, 주, 월 별 기록 횟수
  late List ratingList;                       // 만족도 기록 데이터

  late List varData;                          // 변수별 데이터 
  late List yearList;
  late List monthList;
  late List dayList;
  late List colorList;
  late List dateList;
  String formattedDate = "";

  // Segment Widget
  Map<int, Widget> segmentWidget = {
    0: SizedBox(
      width: 80.w,
      // height: 100,
      child: Text(
        '일',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.sp),
      ),
    ),
    1: SizedBox(
      child: Text(
        '주',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.sp),
      ),
    ),
    2: SizedBox(
      child: Text(
        '월',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.sp),
      ),
    ),
  };

  // Toggle Button Widget
  List<Widget> recordVar = <Widget> [
    const SizedBox(
      child: Text(
        "횟수"
      ),
    ),
    const SizedBox(
      child: Text(
        "만족도"
      ),
    ),
    const SizedBox(
      child: Text(
        "소요시간"
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    tooltipBehavior = TooltipBehavior(enable: true);
    segChoice = 0;
    handler = DatabaseHandler();
    _selectedVariable = <bool>[true, false, false];
    recordVariable = <String>['횟수', '만족도', '소요시간'];
    selectedIndex = 0;
    savedDateList = [];
    chartData = [];
    recordCountList = [];
    ratingList = [];

    varData = [];
    recordData = [];
    yearList = [];
    monthList =[];
    dayList = [];
    colorList = [];
    dateList = [];
    
    print("여긴 오나1");
    getCountData("per day");
    print("여긴 오나2");
    // _fetchData();
    print("에러 확인 날짜3 : ${DateTime.parse(recordCountList[0].perDateType)}");
  }



  _fetchData() async{
    var temp = await handler.queryRecord();
    for(var i in temp){
      dateList.add(i.currentTime!.substring(0, 10));
      ratingList.add(i.rating);
    }

    for (int i=0; i < dateList.length; i++) {
      DateTime dateTime = DateTime.parse(dateList[i]);
      print("dateTime: $dateTime");
      int tempYear = dateTime.year;
      int tempMonth = dateTime.month;
      int tempDay = dateTime.day;
      yearList.add(tempYear);
      monthList.add(tempMonth);
      dayList.add(tempDay);
    }

    // savedDateList = dayList;
    savedDateList = dateList;
    // var tlist = [1, 2, 3, 5, 2, 1, 2, 3, 4];
    // addChartData(tlist);
    print("rating List data : $ratingList");
    print("dateList : $dateList");
    // print("yearList : $yearList");
    // print("monthList : $monthList");
    // print("dayList : $dayList");
    
    print("fetched");

  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 기록'),
      ),
      // body: savedDateList.isEmpty 
      // ? const Center(
      //     child: Text("기록이 없습니다."),
      //   )
      // : Center(
      body: Center(
        child: Column(
          children: [
            CupertinoSegmentedControl(
              groupValue: segChoice,
              children: segmentWidget, 
              onValueChanged: (value){
                segChoice = value;
                if (segChoice == 0) {
                  // DateTime.now().month;
                  getCountData("per day");
                  // savedDateList = dayList;
                  // print("day : $savedDateList");
                } else if (segChoice == 1) {
                  getCountData("per week");
                  // savedDateList = monthList;
                  // print("month : $savedDateList");
                } else {
                  getCountData("per month");
                  // savedDateList = yearList;
                  // print("year : $savedDateList");
                }
                setState(() {
                  
                });
              },
            ),
            SizedBox(
              width: 400.w,
              height: 500.h,
              child: ((selectedIndex == 0) | (selectedIndex == 2))
              ? SfCartesianChart(
                title: ChartTitle(
                  text: recordVariable[selectedIndex]
                ),
                tooltipBehavior: tooltipBehavior,
                primaryXAxis: DateTimeAxis(
                  // intervalType: DateTimeIntervalType.auto,
                  // dateFormat: dateFormat,
                  minimum: 
                  // DateTime.parse("${DateTime.parse(recordCountList[0].perDateType).year}-${DateTime.parse(recordCountList[0].perDateType).month}-${DateTime.parse(recordCountList[0].perDateType).day}"),
                  DateTime.parse(recordCountList[0].perDateType),
                  maximum: DateTime.now()
                ),
                series: [
                  selectedIndex == 0        // 횟수 : Bar Chart
                  ? ColumnSeries<RecordCountModel, DateTime>(
                    color: Theme.of(context).colorScheme.primary,
                    dataSource: recordCountList, 
                    xValueMapper: (RecordCountModel records, _) 
                      => segChoice == 2? DateTime.parse("${records.perDateType}-${DateTime.now().day}") : DateTime.parse(records.perDateType), 
                    yValueMapper: (RecordCountModel records, _) => records.totalCount,
                    xAxisName: "날짜",
                    // spacing: 0.2
                  )
                  : ColumnSeries<MyRecordData, DateTime>(
                      color: Theme.of(context).colorScheme.primary,
                      dataSource: chartData, 
                      xValueMapper: (MyRecordData records, _) => DateTime.parse(records.savedDate),
                      // DateTime.parse("${DateTime.now().year}-${DateTime.now().month}-${records.savedDate}"), 
                      yValueMapper: (MyRecordData records, _) => records.toShowVar,
                      xAxisName: "날짜",
                      // spacing: 0.2
                    )
                ],
              )
              : SfCircularChart(
                title: ChartTitle(
                  text: recordVariable[selectedIndex]
                ),
                tooltipBehavior: tooltipBehavior,
                series: <CircularSeries<MyRecordData, DateTime>>[
                  PieSeries(
                    dataSource: chartData,
                    selectionBehavior: SelectionBehavior(enable: true),
                    xValueMapper: (MyRecordData records, _) => DateTime.parse(records.savedDate),
                    yValueMapper: (MyRecordData records, _) => records.toShowVar.toDouble(),
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    enableTooltip: true
                  )
                ],                
              )
            ),
            ToggleButtons(
              isSelected: _selectedVariable,
              onPressed: (int newIndex){
                setState(() {
                  for (int buttonIndex=0; buttonIndex<_selectedVariable.length; buttonIndex++) {
                    _selectedVariable[buttonIndex] = buttonIndex == newIndex;
                    selectedIndex = newIndex;
                    if (selectedIndex == 1) {
                      addChartData(ratingList);
                    }
                  }
                  // print(dayList);
                  // addChartData(dayList);

                });
              },
              selectedBorderColor: Theme.of(context).colorScheme.primary,
              selectedColor: Theme.of(context).colorScheme.tertiary,
              fillColor: Theme.of(context).colorScheme.onPrimary,
              children: recordVar,
            ),
          ],
        ),
      ),
    );
  }

  getCountData(String perDateType) async{
    var temp = await handler.queryRecordCountPerDateType(perDateType);
    for (var i in temp) {
        recordCountList.add(RecordCountModel(perDateType: i.perDateType, totalCount: i. totalCount));
    }
  }

  addChartData(varList){
    for (int i=0; i<savedDateList.length; i++){
      chartData.add(MyRecordData(savedDate: savedDateList[i].toString(), toShowVar: varList[i]));
    }
    // print("저장된 날짜 : $savedDateList");
    // print("입력된 데이터 : ${chartData[0].toShowVar}");
    // chartData.add(MyRecordData(savedDate: savedDateList, varName: varList));
    // 저장 날짜 별 변수에 대한 그래프 그려줘야 함. 
    // 횟수는 DB에서 count 해서 return 받고 보여줘야 할 거 같고
    // 다른 데이터들을 <저장날짜(x축), 변수(숫자 - y축)> 형태로 빈 리스트에 추가 한 뒤 그때그때 x, y 그래프에 넣어줘야 할듯.
    // 횟수 - bar, 만족도, 모양, 색상, 냄새 - 비율 그래프, 소요시간 : 평균 시간과 비교하는 bar 차트
    // 특이사항은 자주 등장하는 단어 빈도수로 word cloud 그려주면 좋을듯.
    // 
  }


  // /// 모양 선택 버튼 index
  // changeShapeToInt() {
  //   for (int i = 0; i < shapeList.length; i++) {
  //     switch (shapeList[i]) {
  //       case "바나나 모양":
  //         // shapeInt = 0;
  //         shapeIntList.add(0);
  //         break;
  //       case "포도알 모양":
  //         // shapeInt = 1;
  //         shapeIntList.add(1);
  //         break;
  //       case "설사":
  //         // shapeInt = 2;
  //         shapeIntList.add(2);
  //         break;
  //     }
  //   }
  //   print("after Mapping: $shapeIntList");
  //   // if (selectedIndex == 2){
  //   //   addChartData(shapeIntList);
  //   // }
  //   addChartData(shapeIntList);
  //   print("after add to chartData: $shapeIntList");
  // }  


  
}   // END