import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Model/database_handler.dart';
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
  late DatabaseHandler handler;
  late List yearList;
  late List monthList;
  late List dayList;
  late List colorList;
  late List dateList;
  String formattedDate = "";

  // Segment Widget
  Map<int, Widget> segmentWidget = {
    0: const SizedBox(
      width: 80,
      // height: 100,
      child: Text(
        '일',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    ),
    1: const SizedBox(
      child: Text(
        '월',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    ),
    2: const SizedBox(
      child: Text(
        '년',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    ),
  };

  @override
  void initState() {
    super.initState();
    tooltipBehavior = TooltipBehavior(enable: true);
    kindchoice = 0;
    handler = DatabaseHandler();
    recordData = [];
    yearList = [];
    monthList =[];
    dayList = [];
    colorList = [];
    dateList = [];
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 쾌변 기록'),
      ),
      body: FutureBuilder<List<RecordModel>>(
        future: handler.queryRecord(), 
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data!.length; i++) {
              // 날짜 포멧
              formattedDate = DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(snapshot.data![i].currentTime!));              
              dateList.add(formattedDate);
              // DateTime dateTime = DateTime.parse(snapshot.data![0].currentTime!);
              // int tempYear = dateTime.year;
              // yearList.add(tempYear);
              // int tempMonth = dateTime.month;
              // monthList.add(tempMonth);
              // int tempDay = dateTime.day;
              // dayList.add(tempDay);
              // colorList.add(snapshot.data![0].color);
              // print(snapshot.data![0].currentTime);
              // // recordData.add(snapshot.data![i]);
            }
            print(dateList);

            return Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    CupertinoSegmentedControl(
                      groupValue: kindchoice,
                      children: segmentWidget, 
                      onValueChanged: (value){
                        kindchoice = value;
                        if (kindchoice == 0) {
                
                        } else if (kindchoice == 1) {
                
                        } else {
                
                        }
                        setState(() {
                          
                        });
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: SfCartesianChart(
                        title: ChartTitle(
                          text: '횟수'
                        ),
                        tooltipBehavior: tooltipBehavior,
                        series: [
                          ColumnSeries(
                            color: Theme.of(context).colorScheme.primary,
                            dataSource: recordData, 
                            xValueMapper: (_, dateList) => int.parse(dateList.toString()), 
                            yValueMapper: (_, recordData) => double.parse(snapshot.data![0].rating.toString()),
                            xAxisName: "날짜",
                            spacing: 0.2
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text("기록이 없습니다."),
            );
          }
        },
      )
    );
  }


// splitData() async {
//   recordData.add(await handler.queryRecord());
//   recordData
// }



  
}   // END