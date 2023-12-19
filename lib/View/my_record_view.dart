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
    takenTimeList = [];

    getCountData(segChoice);
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
                  text: recordVariable[selectedIndex]
                ),
                tooltipBehavior: tooltipBehavior,
                primaryXAxis: DateTimeAxis(
                  labelFormat: "MMM dd, yyyy",
                  intervalType: DateTimeIntervalType.auto,
                  // dateFormat: DateFormat.yMd(),
                  // minimum: DateTime.parse(recordCountList[0].perDateType),
                  //segChoice == 2? DateTime.parse("${recordCountList[0].perDateType}-${DateTime.now().day}") : DateTime.parse(recordCountList[0].perDateType),
                  // DateTime.parse(recordCountList[0].perDateType),
                  maximum: DateTime.now()
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  interval: 1,
                  rangePadding: ChartRangePadding.auto,
                  autoScrollingMode: AutoScrollingMode.end,
                ),
                series: [
                  selectedIndex == 0        // 횟수 : Bar Chart
                  ? ColumnSeries<RecordCountModel, DateTime>(
                    color: Theme.of(context).colorScheme.primary,
                    dataSource: recordCountList, 
                    xValueMapper: (RecordCountModel records, _) 
                      => (segChoice == 2) & (selectedIndex == 0) ? DateTime.parse("${records.perDateType}-${DateTime.now().day}") : DateTime.parse(records.perDateType), 
                      // =>  (DateTime.parse(records.perDateType)), 
                    yValueMapper: (RecordCountModel records, _) => records.totalCount,
                    xAxisName: "날짜",
                    // spacing: 0.2 
                  )
                  : ColumnSeries<TakenTimeModel, DateTime>(
                      color: Theme.of(context).colorScheme.primary,
                      dataSource: takenTimeList, 
                      xValueMapper: (TakenTimeModel records, _) 
                      => (segChoice == 2) & (selectedIndex == 2) ? DateTime.parse("${records.perDateType}-${DateTime.now().day}") : DateTime.parse(records.perDateType), 
                      // => DateTime.parse(records.perDateType),
                      // DateTime.parse("${DateTime.now().year}-${DateTime.now().month}-${records.savedDate}"), 
                      yValueMapper: (TakenTimeModel records, _) => records.takenTime,
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
      // print("날짜 : ${i.perDateType}");
      // print("개수 : ${i.totalCount}");
      recordCountList.add(RecordCountModel(perDateType: i.perDateType.toString(), totalCount: i. totalCount));
    }

    // 확인
    for (int i=0; i<recordCountList.length; i++){
      print("날짜 타입별 : ${recordCountList[i].perDateType}");
      print("데이터 개수 : ${recordCountList[i].totalCount}");
    }
    print("------------------------");

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
      // print("날짜 : ${i.perDateType}");
      // print("개수 : ${i.totalCount}");
      segChoice == 0 ? ratingList.add(RatingCountModelPerDay(perDateType: i.perDateType, rating: i.rating, countPerCategory: i.countPerCategory))
      : segChoice == 1 ? ratingList.add(RatingCountModelPerDay(perDateType: "${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 14)))} ~ ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}", rating: i.rating, countPerCategory: i.countPerCategory))
      : ratingList.add(RatingCountModelPerDay(perDateType: "${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 91)))} ~ ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}", rating: i.rating, countPerCategory: i.countPerCategory));
    }

    // 확인
    for (int i=0; i<ratingList.length; i++){
      print("날짜 타입별 : ${ratingList[i].perDateType}");
      print("rating 범주별 : ${ratingList[i].rating}");
      print("데이터 개수 : ${ratingList[i].countPerCategory}");
      print("리스트의 데이터 개수 : ${ratingList.length}");
    }
    // print("${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 14)))} ~ ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}");
    print("--------------------");

    setState(() {
      
    });
  }



  getTakenTimeCountData(int perDateType) async{
    // perDateType == 0 : per day, == 1 : per week, else : per month
    takenTimeList = [];
    var temp = await handler.queryTakenTimeDataPerDateType(perDateType);
    for (var i in temp) {
      // print("날짜 : ${i.perDateType}");
      // print("개수 : ${i.totalCount}");
      // var timeString = i.takenTime;

      // tempResult.add(double.parse(result));
      // double averageMinutes = tempResult.isNotEmpty ? tempResult.reduce((a, b) => a + b) / tempResult.length : 0;
      // reduce() : 리스트의 모든 요소를 하나의 값으로 축소(reduce). 모든 tempResult 값들을 합산. a는 누적값, b는 현재 요소값

      // 일별 데이터는 그대로 보여주고, 주 or 월별 데이터는 해당 기간동안의 데이터 평균으로 보여주기
      // 일별 데이터에서 만약 횟수가 1회 이상이면 소요시간의 평균으로 보여주기
      takenTimeList.add(TakenTimeModel(perDateType: i.perDateType, takenTime: i.takenTime));
    }

    // 확인
    for (int i=0; i<takenTimeList.length; i++){
      print("날짜 타입별 : ${takenTimeList[i].perDateType}");
      print("소요시간(분) : ${takenTimeList[i].takenTime}");
    }
    print("------------");

    setState(() {
      
    });
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
}   // END