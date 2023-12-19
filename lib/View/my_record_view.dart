import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guardians_of_health_project/Model/database_handler.dart';
import 'package:guardians_of_health_project/Model/my_record_data.dart';
import 'package:guardians_of_health_project/Model/rating_count_model_per_day.dart';
import 'package:guardians_of_health_project/Model/record_count_model.dart';
import 'package:guardians_of_health_project/Model/taken_time_model.dart';
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
  late int segChoice;                        // segment 선택된 번호
  late DatabaseHandler handler;               // DataBase
  late List<bool> _selectedVariable;          // toggle button 선택 여부 리스트
  late List<String> recordVariable;           // record DB column명들
  late int selectedIndex;                     // toggle button 선택된 인덱스 ()
  late List savedDateList;                    // 저장 날짜 형태 데이터
  late List<MyRecordData> chartData;
  late List<RecordCountModel> recordCountList;   // 일, 주, 월 별 기록 횟수
  late List<RatingCountModelPerDay> ratingList;                       // 만족도 기록 데이터
  late List<TakenTimeModel> takenTimeList;                       // 만족도 기록 데이터

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
    segChoice = 0;
    handler = DatabaseHandler();
    _selectedVariable = <bool>[true, false, false];
    recordVariable = <String>['횟수', '만족도', '소요시간'];
    selectedIndex = 0;
    savedDateList = [];
    chartData = [];
    recordCountList = [];
    ratingList = [];
    takenTimeList = [];

    tooltipBehavior = TooltipBehavior(
      enable: true,
      header: setTooltipBehavior()
      );
    getCountData(segChoice);
  }

  setTooltipBehavior(){
    return selectedIndex==2? "평균 ${recordVariable[selectedIndex]} (분)" : recordVariable[selectedIndex];
    // setState(() {
      
    // });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 기록'),
      ),
      body: recordCountList.isEmpty 
      ? const Center(
          child: Text("기록이 없습니다."),
        )
      : Center(
        child: Column(
          children: [
            CupertinoSegmentedControl(
              groupValue: segChoice,
              children: segmentWidget, 
              onValueChanged: (value){
                segChoice = value;
                selectedIndex == 0 ? getCountData(segChoice)
                : selectedIndex == 1? getRatingCountData(segChoice)
                : getTakenTimeCountData(segChoice);
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
                  text: selectedIndex==2? "평균 ${recordVariable[selectedIndex]} (분)" : recordVariable[selectedIndex]
                ),
                tooltipBehavior: tooltipBehavior,
                primaryXAxis: DateTimeAxis(
                  labelFormat: '{value}M',
                  intervalType: DateTimeIntervalType.auto,
                  dateFormat: DateFormat.yMd(),
                  maximum: DateTime.now()
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  interval: 1,
                  rangePadding: ChartRangePadding.auto,
                  autoScrollingMode: AutoScrollingMode.end,
                ),
                series: <CartesianSeries>[
                  selectedIndex == 0        // 횟수 : Bar Chart
                  ? ColumnSeries<RecordCountModel, DateTime>(
                    color: Theme.of(context).colorScheme.primary,
                    dataSource: recordCountList, 
                    xValueMapper: (RecordCountModel records, _) 
                      => (segChoice == 2) & (selectedIndex == 0) ? DateTime.parse("${records.perDateType}-${DateTime.now().day}") : DateTime.parse(records.perDateType), 
                    yValueMapper: (RecordCountModel records, _) => records.totalCount,
                    xAxisName: "날짜",
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    enableTooltip: true
                  )
                  : ColumnSeries<TakenTimeModel, DateTime>(
                      color: Theme.of(context).colorScheme.primary,
                      dataSource: takenTimeList, 
                      xValueMapper: (TakenTimeModel records, _) 
                      => (segChoice == 2) & (selectedIndex == 2) ? DateTime.parse("${records.perDateType}-${DateTime.now().day}") : DateTime.parse(records.perDateType), 
                      yValueMapper: (TakenTimeModel records, _) => records.takenTime,
                      xAxisName: "날짜",
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                      enableTooltip: true
                    )
                ],
              )
              : SfCircularChart(
                title: ChartTitle(
                  text: recordVariable[selectedIndex]
                ),
                tooltipBehavior: tooltipBehavior,
                series: <CircularSeries<RatingCountModelPerDay, List>>[
                  PieSeries(
                    dataSource: ratingList,
                    selectionBehavior: SelectionBehavior(enable: true),
                    xValueMapper: (RatingCountModelPerDay records, _) => [records.perDateType, records.rating], 
                    yValueMapper: (RatingCountModelPerDay records, _) => records.countPerCategory,
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
                  }
                  selectedIndex == 0 ? getCountData(segChoice)
                    : selectedIndex == 1 ? getRatingCountData(segChoice)
                    : getTakenTimeCountData(segChoice);
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


  // ---------- Functions -------------

  /// 일, 주, 월 별로 데이터 개수 받아오는 함수
  getCountData(int perDateType) async{
    // perDateType == 0 : per day, == 1 : per week, else : per month
    recordCountList = [];
    var temp = await handler.queryRecordCountPerDateType(perDateType);
    for (var i in temp) {
      recordCountList.add(RecordCountModel(perDateType: i.perDateType.toString(), totalCount: i. totalCount));
    }

    setState(() {
      
    });
  }

  /// 기간별 범주별 데이터 개수 반환
  getRatingCountData(int perDateType) async{
    // perDateType == 0 : per day, == 1 : per week, else : per month
    ratingList = [];
    var temp;
    perDateType == 0 ? temp = await handler.queryRatingCountPerDayType()
                      : temp = await handler.queryRatingCountPerWMType(perDateType);
    for (var i in temp) {
      segChoice == 0 ? ratingList.add(RatingCountModelPerDay(perDateType: i.perDateType, rating: i.rating, countPerCategory: i.countPerCategory))
      : segChoice == 1 ? ratingList.add(RatingCountModelPerDay(perDateType: "${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 14)))} ~ ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}", rating: i.rating, countPerCategory: i.countPerCategory))
      : ratingList.add(RatingCountModelPerDay(perDateType: "${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 91)))} ~ ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}", rating: i.rating, countPerCategory: i.countPerCategory));
    }

    setState(() {
      
    });
  }



  getTakenTimeCountData(int perDateType) async{
    // perDateType == 0 : per day, == 1 : per week, else : per month
    takenTimeList = [];
    var temp = await handler.queryTakenTimeDataPerDateType(perDateType);
    for (var i in temp) {
      takenTimeList.add(TakenTimeModel(perDateType: i.perDateType, takenTime: i.takenTime));
    }

    setState(() {
      
    });
  }
  
}   // END