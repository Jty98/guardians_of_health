/*
  기능: table_calendar의 상태관리를 하기위한 GetXController
*/

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:guardians_of_health_project/Model/database_handler.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

class CalendarController extends GetxController {
  DatabaseHandler handler = DatabaseHandler();

  // 달력에서 클릭된 날짜의 상태를 관찰하는 변수
  Rx<DateTime?> selectedDay = DateTime.now().obs;
  RxList<String> holidayDateList = <String>[].obs;
  RxList<String> holidayDateNameList = <String>[].obs;

  @override
  void onInit() {
    changeSelectedDay(selectedDay.value!);
    super.onInit();
    // getHolidayData(selectedDay.value!.year, selectedDay.value!.month.toString());
  }

  /// 달력에서 날짜 클릭시 그 날짜라고 알려주는 함수
  void changeSelectedDay(DateTime newDay) {
    selectedDay.value = newDay;
    update();
  }

  /// 이벤트를 가져오는 함수 인자: (이벤트가 있는day,  쿼리문 결과가 저장된 recordList)
  List<DateTime> getEventsForDay(DateTime day, List<dynamic>? recordList) {
    // 날짜를 'yyyy-MM-dd' 형식의 문자열로 변환
    String formattedDate = DateFormat('yyyy-MM-dd').format(day.toLocal());

    // 해당 날짜에 해당하는 이벤트 리스트 필터링
    List<DateTime> eventsForDay = recordList
            ?.where((record) =>
                DateFormat('yyyy-MM-dd')
                    .format(DateTime.parse(record.currentTime)) ==
                formattedDate)
            .map((record) => DateTime.parse(record.currentTime))
            .toList() ??
        [];

    // 데이터베이스에서 해당 날짜의 데이터 가져오기
    handler.getDataForDate(eventsForDay);
    update();
    return eventsForDay;
  }

  /// API로 휴일정보 받아와서 RxList에 휴일 이름과 날짜 넣어주는 함수
  Future<void> getHolidayData(int year, String month) async {
    String apiEndPoint =
        "http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService";
    String holidayOperation = "getRestDeInfo";
    String apiKey = dotenv.get("HOLIDAY_API_KEY");
    String requestUrl =
        "$apiEndPoint/$holidayOperation?solYear=$year&solMonth=$month&ServiceKey=$apiKey";

    try {
      var response = await GetConnect().get(requestUrl);
      var document = XmlDocument.parse(response.body);

      final dateNameElements = document.findAllElements('dateName');
      final holidayDateElements = document.findAllElements('locdate');

      // 휴일 데이터를 담을 임시 리스트
      List<String> tempHolidayDateList = [];
      List<String> tempHolidayDateNameList = [];

      for (var dateNameElement in dateNameElements) {
        final dateName = dateNameElement.innerText;
        tempHolidayDateNameList.add(dateName);
      }
      for (var holidayDateElement in holidayDateElements) {
        final holidayDate = holidayDateElement.innerText;
        tempHolidayDateList.add(holidayDate);
      }

      // RxList에 데이터를 업데이트
      holidayDateNameList.assignAll(tempHolidayDateNameList);
      holidayDateList.assignAll(tempHolidayDateList);

      print(holidayDateNameList);
      print(holidayDateList);
      update();
    } catch (e) {
      update();
      print(e);
    }
  }

  bool holidayPredicate(DateTime day) {
    // holidayDateList에서 각 휴일을 가져와서 비교
    for (String dateString in holidayDateList) {
      DateTime holidayDateTime = DateTime.parse(dateString);

      // holidayDateTime과 day를 비교하여 같으면 true를 반환
      if (holidayDateTime.year == day.year &&
          holidayDateTime.month == day.month &&
          holidayDateTime.day == day.day) {
        return true;
      }
    }
    // 휴일이 아닌 경우 false를 반환
    return false;
  }

  /// record 지우기
  deleteRecord(int id) {
    handler.deleteRecord(id);
  }
}
