import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Model/database_handler.dart';
import 'package:guardians_of_health_project/Model/my_record_data.dart';
import 'package:guardians_of_health_project/Model/record_model.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyRecordView extends StatefulWidget {
  const MyRecordView({super.key});

  @override
  State<MyRecordView> createState() => _MyRecordViewState();
}

class _MyRecordViewState extends State<MyRecordView> {
  late List recordData;                       // 사용자 기록 불러와 저장할 변수
  late TooltipBehavior tooltipBehavior;       // 차트 패키지
  late int kindchoice;                        // segment 선택된 번호
  late DatabaseHandler handler;               // DataBase
  late List<bool> _selectedVariable;          // toggle button 선택 여부 리스트
  late List<String> recordVariable;           // record DB column명들
  late int selectedIndex;                     // toggle button 선택된 인덱스 ()
  late List varData;                          // 변수별 데이터 
  late List savedDateList;                    // 저장 날짜 형태 데이터
  late List<MyRecordData> chartData;

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
        '월',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.sp),
      ),
    ),
    2: SizedBox(
      child: Text(
        '년',
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
        "모양"
      ),
    ),
    const SizedBox(
      child: Text(
        "색상"
      ),
    ),
    const SizedBox(
      child: Text(
        "냄새"
      ),
    ),
    const SizedBox(
      child: Text(
        "특이사항"
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
    kindchoice = 0;
    handler = DatabaseHandler();
    _selectedVariable = <bool>[true, false, false, false, false, false, false];
    recordVariable = <String>['횟수', '만족도', '모양', '색상', '냄새', '특이사항', '소요시간'];
    selectedIndex = 0;
    varData = [];
    savedDateList = [];
    chartData = [];

    recordData = [];
    yearList = [];
    monthList =[];
    dayList = [];
    colorList = [];
    dateList = [];

    _fetchData();
  }

  _fetchData() async{
    var temp = await handler.queryRecord();
    for(var i in temp){
      dateList.add(i.currentTime!.substring(0, 10));
    }

    for (int i=0; i < dateList.length; i++) {
      DateTime dateTime = DateTime.parse(dateList[i]);
      int tempYear = dateTime.year;
      int tempMonth = dateTime.month;
      int tempDay = dateTime.day;
      yearList.add(tempYear);
      monthList.add(tempMonth);
      dayList.add(tempDay);
    }

    savedDateList = dayList;
    addChartData([1, 2, 3, 5, 2, 1]);
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 기록'),
      ),
      body: Center(
        child: Column(
          children: [
            CupertinoSegmentedControl(
              groupValue: kindchoice,
              children: segmentWidget, 
              onValueChanged: (value){
                kindchoice = value;
                if (kindchoice == 0) {
                  savedDateList = dayList;
                  print("day : $savedDateList");
                } else if (kindchoice == 1) {
                  savedDateList = monthList;
                  print("month : $savedDateList");
                } else {
                  savedDateList = yearList;
                  print("year : $savedDateList");
                }
                setState(() {
                  
                });
              },
            ),
            SizedBox(
              width: 400.w,
              height: 500.h,
              child: SfCartesianChart(
                title: ChartTitle(
                  text: recordVariable[selectedIndex]
                ),
                tooltipBehavior: tooltipBehavior,
                series: [
                  ColumnSeries<MyRecordData, int>(
                    color: Theme.of(context).colorScheme.primary,
                    dataSource: chartData, 
                    xValueMapper: (MyRecordData records, _) => records.savedDate, 
                    yValueMapper: (MyRecordData records, _) => records.toShowVar,
                    xAxisName: "날짜",
                    // spacing: 0.2
                  )
                ],
              ),
            ),
            ToggleButtons(
              isSelected: _selectedVariable,
              onPressed: (int newIndex){
                setState(() {
                  for (int buttonIndex=0; buttonIndex<_selectedVariable.length; buttonIndex++) {
                    _selectedVariable[buttonIndex] = buttonIndex == newIndex;
                    selectedIndex = newIndex;
                  }
                  print(dayList);
                  addChartData(dayList);
                });
                print(_selectedVariable);
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

  addChartData(List<dynamic> varList){
    for (int i=0; i<savedDateList.length; i++){
      chartData.add(MyRecordData(savedDate: savedDateList[i], toShowVar: varList[i]));
    }
    print("저장된 날짜 : $savedDateList");
    print("입력된 데이터 : ${chartData[0].toShowVar}");
    // chartData.add(MyRecordData(savedDate: savedDateList, varName: varList));
    // 저장 날짜 별 변수에 대한 그래프 그려줘야 함. 
    // 횟수는 DB에서 count 해서 return 받고 보여줘야 할 거 같고
    // 다른 데이터들을 <저장날짜(x축), 변수(숫자 - y축)> 형태로 빈 리스트에 추가 한 뒤 그때그때 x, y 그래프에 넣어줘야 할듯.
    // 횟수 - bar, 만족도, 모양, 색상, 냄새 - 비율 그래프, 소요시간 : 평균 시간과 비교하는 bar 차트
    // 특이사항은 자주 등장하는 단어 빈도수로 word cloud 그려주면 좋을듯.
    // 
  }



  
}   // END