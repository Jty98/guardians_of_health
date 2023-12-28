import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guardians_of_health_project/Model/rating_count_model_per_day.dart';
import 'package:guardians_of_health_project/Model/record_count_model.dart';
import 'package:guardians_of_health_project/Model/taken_time_model.dart';
import 'package:guardians_of_health_project/VM/database_handler.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyRecordView extends StatefulWidget {
  const MyRecordView({super.key});

  @override
  State<MyRecordView> createState() => _MyRecordViewState();
}

class _MyRecordViewState extends State<MyRecordView> {
  late List recordData; // 사용자 기록 불러와 저장할 변수
  late TooltipBehavior tooltipBehavior; // 차트 패키지
  late int segChoice; // segment 선택된 번호
  late DatabaseHandler handler; // DataBase
  late List<bool> _selectedVariable; // toggle button 선택 여부 리스트
  late List<String> recordVariable; // record DB column명들
  late int selectedIndex; // toggle button 선택된 인덱스 ()
  late List<RecordCountModel> recordCountList; // 일, 주, 월 별 기록 횟수
  late List<RatingCountModelPerDay> ratingList; // 만족도 기록 데이터
  late List<TakenTimeModel> takenTimeList; // 소요시간 기록 데이터

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
  List<Widget> recordVar = <Widget>[
    const SizedBox(
      child: Text("횟수"),
    ),
    const SizedBox(
      child: Text("만족도"),
    ),
    const SizedBox(
      child: Text("소요시간"),
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
    recordCountList = [];
    ratingList = [];
    takenTimeList = [];

    getCountData(segChoice);
    getRatingCountData(segChoice);
    getTakenTimeCountData(segChoice);
    setTooltipBehavior();
  }

  setTooltipBehavior() {
    tooltipBehavior = TooltipBehavior(
        enable: true,
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
            int seriesIndex) {
          // 데이터에서 툴팁 내용 동적 생성
          final RecordCountModel recordCountModel = recordCountList[pointIndex];
          final RatingCountModelPerDay ratingCountModel =
              ratingList[seriesIndex];
          final TakenTimeModel takenTimeModel = takenTimeList[pointIndex];

          return SizedBox(
              width: 210.w,
              height: 80.h,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.w, 6.h, 0.w, 0.h),
                    child: Text(
                      (selectedIndex == 0) & (segChoice == 1)
                          ? "${recordCountModel.perDateType} ~ ${DateFormat('yyyy-MM-dd').format(DateTime.parse(recordCountModel.perDateType).add(const Duration(days: 6)))}"
                          : selectedIndex == 0
                              ? recordCountModel.perDateType
                              : selectedIndex == 1
                                  ? ratingCountModel.perDateType
                                  : segChoice == 1
                                      ? "${takenTimeModel.perDateType} ~ ${DateFormat('yyyy-MM-dd').format(DateTime.parse(takenTimeModel.perDateType).add(const Duration(days: 6)))}"
                                      : takenTimeModel.perDateType,
                      style: TextStyle(
                          fontSize: 15.sp,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
                    child: const Divider(),
                  ),
                  selectedIndex == 0
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 10.h),
                          child: Text(
                            " ${recordCountModel.totalCount} (회)  ",
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        )
                      : selectedIndex == 1
                          ? Padding(
                              padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 10.h),
                              child: Text(
                                // " 평점 : ${ratingCountModel.rating} (${  (ratingCountModel.percentageOfTotal % 1 == 0) ? ratingCountModel.percentageOfTotal.toInt().toString() : ratingCountModel.percentageOfTotal} %)  ",
                                " 평점 : ${ratingCountModel.rating} (${(ratingCountModel.percentageOfTotal).toStringAsFixed((ratingCountModel.percentageOfTotal).truncateToDouble() == ratingCountModel.percentageOfTotal ? 0 : 1)}%)  ",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 10.h),
                              child: Text(
                                " 평균 ${takenTimeModel.takenTime} (분)  ",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                            ),
                ],
              ));
        });

    setState(() {});
    return tooltipBehavior;
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
                    onValueChanged: (value) {
                      segChoice = value;
                      selectedIndex == 0
                          ? getCountData(segChoice)
                          : selectedIndex == 1
                              ? getRatingCountData(segChoice)
                              : getTakenTimeCountData(segChoice);
                      setState(() {
                        setTooltipBehavior();
                      });
                    },
                  ),
                  SizedBox(
                      width: 400.w,
                      height: 500.h,
                      child: ((selectedIndex == 0) | (selectedIndex == 2))
                          ? SfCartesianChart(
                              title: ChartTitle(
                                  text: selectedIndex == 2
                                      ? "평균 ${recordVariable[selectedIndex]} (분)"
                                      : recordVariable[selectedIndex]),
                              tooltipBehavior: setTooltipBehavior(),
                              primaryXAxis: DateTimeAxis(
                                  intervalType: segChoice == 2
                                      ? DateTimeIntervalType.months
                                      : segChoice == 0
                                          ? DateTimeIntervalType.days
                                          : DateTimeIntervalType.auto,
                                  dateFormat: DateFormat.yMd(),
                                  maximum: DateTime.now()),
                              primaryYAxis: NumericAxis(
                                minimum: 0,
                                interval: 1,
                                rangePadding: ChartRangePadding.auto,
                                autoScrollingMode: AutoScrollingMode.end,
                              ),
                              series: <CartesianSeries>[
                                selectedIndex == 0 // 횟수 : Bar Chart
                                    ? ColumnSeries<RecordCountModel, DateTime>(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        dataSource: recordCountList,
                                        xValueMapper: (RecordCountModel records, _) =>
                                            (segChoice == 2) & (selectedIndex == 0)
                                                ? DateTime.parse(
                                                    "${records.perDateType}-${DateTime.now().day}")
                                                : DateTime.parse(
                                                    records.perDateType),
                                        yValueMapper:
                                            (RecordCountModel records, _) =>
                                                records.totalCount,
                                        xAxisName: "날짜",
                                        dataLabelSettings: const DataLabelSettings(
                                            isVisible: true),
                                        enableTooltip: true)
                                    : ColumnSeries<TakenTimeModel, DateTime>(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        dataSource: takenTimeList,
                                        xValueMapper: (TakenTimeModel records, _) =>
                                            (segChoice == 2) & (selectedIndex == 2)
                                                ? DateTime.parse("${records.perDateType}-${DateTime.now().day}")
                                                : DateTime.parse(records.perDateType),
                                        yValueMapper: (TakenTimeModel records, _) => records.takenTime,
                                        xAxisName: "날짜",
                                        dataLabelSettings: const DataLabelSettings(isVisible: true),
                                        enableTooltip: true)
                              ],
                            )
                          : SfCircularChart(
                              title: ChartTitle(
                                  text: recordVariable[selectedIndex]),
                              tooltipBehavior: setTooltipBehavior(),
                              // legend: const Legend(isVisible: true),
                              series: <CircularSeries>[
                                PieSeries<RatingCountModelPerDay, double>(
                                  dataSource: ratingList,
                                  selectionBehavior:
                                      SelectionBehavior(enable: true),
                                  xValueMapper:
                                      (RatingCountModelPerDay records, _) =>
                                          records.rating,
                                  yValueMapper:
                                      (RatingCountModelPerDay records, _) =>
                                          records.countPerCategory,
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                  enableTooltip: true,
                                )
                              ],
                            )),
                  SizedBox(
                    height: 50,
                    child: (selectedIndex == 1) & (segChoice == 0)
                        ? const Text('최근 3일간 기록한 만족도의 비율입니다.')
                        : (selectedIndex == 1) & (segChoice == 1)
                            ? const Text('최근 1주간 기록한 만족도의 비율입니다.')
                            : (selectedIndex == 1) & (segChoice == 2)
                                ? const Text('최근 1개월간 기록한 만족도의 비율입니다.')
                                : const Text(""),
                  ),
                  ToggleButtons(
                    isSelected: _selectedVariable,
                    onPressed: (int newIndex) {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < _selectedVariable.length;
                            buttonIndex++) {
                          _selectedVariable[buttonIndex] =
                              buttonIndex == newIndex;
                          selectedIndex = newIndex;
                        }
                        selectedIndex == 0
                            ? getCountData(segChoice)
                            : selectedIndex == 1
                                ? getRatingCountData(segChoice)
                                : getTakenTimeCountData(segChoice);
                        setTooltipBehavior();
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
  getCountData(int perDateType) async {
    // perDateType == 0 : per day, == 1 : per week, else : per month
    recordCountList = [];
    var temp = await handler.queryRecordCountPerDateType(perDateType);
    for (var i in temp) {
      recordCountList.add(RecordCountModel(
          perDateType: i.perDateType.toString(), totalCount: i.totalCount));
    }

    setState(() {});
  }

  /// 기간별 범주별 데이터 개수 반환
  getRatingCountData(int perDateType) async {
    // perDateType == 0 : per day, == 1 : per week, else : per month
    ratingList = [];
    dynamic temp;
    perDateType == 0
        ? temp = await handler.queryRatingCountPerDayType()
        : temp = await handler.queryRatingCountPerWMType(perDateType);
    for (dynamic i in temp) {
      segChoice == 0
          ? ratingList.add(RatingCountModelPerDay(
              perDateType: i.perDateType,
              rating: i.rating,
              countPerCategory: i.countPerCategory,
              percentageOfTotal: i.percentageOfTotal))
          : segChoice == 1
              ? ratingList.add(RatingCountModelPerDay(
                  perDateType:
                      "${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 7)))} ~ ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
                  rating: i.rating,
                  countPerCategory: i.countPerCategory,
                  percentageOfTotal: i.percentageOfTotal))
              : ratingList.add(RatingCountModelPerDay(
                  perDateType:
                      "${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 31)))} ~ ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
                  rating: i.rating,
                  countPerCategory: i.countPerCategory,
                  percentageOfTotal: i.percentageOfTotal));
    }

    setState(() {});
  }

  getTakenTimeCountData(int perDateType) async {
    // perDateType == 0 : per day, == 1 : per week, else : per month
    takenTimeList = [];
    var temp = await handler.queryTakenTimeDataPerDateType(perDateType);
    for (var i in temp) {
      takenTimeList.add(
          TakenTimeModel(perDateType: i.perDateType, takenTime: i.takenTime));
    }

    setState(() {});
  }
}   // END