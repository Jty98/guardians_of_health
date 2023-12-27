/*
  기능: 타이머가 백그라운드 상태일때의 시간을 리턴해주는 핸들러
*/

class TimerDifferenceHandler {
  static DateTime endingTime = DateTime.now(); // 백그라운드가 끝났을 때의 now
  // static int _initialElapsedSeconds = 0; // 백그라운드에 머무른 시간과 다시 돌아온 시간과의 차이를 저장하는 변수
  static Duration remainingTime = const Duration(seconds: 0); // 

  static final TimerDifferenceHandler _instance = TimerDifferenceHandler();

  static TimerDifferenceHandler get instance => _instance;

  /// 백그라운드에 있을 때를 리턴해주는 int값
  /// 백그라운드에 내려갔을 때의 now와 다시 돌아올때의 now의 차이를 계산해서 초 단위로 리턴하게됨
  int get remainingSeconds {
    final DateTime dateTimeNow = DateTime.now();

    // 현재 경과 시간을 계산하여 저장
    // _initialElapsedSeconds += endingTime.difference(dateTimeNow).inSeconds;
    remainingTime = endingTime.difference(dateTimeNow);
    print("TimerDifferenceHandler 남은 시간 = ${remainingTime.abs()} ");
    print("TimerDifferenceHandler 남은 초 = ${remainingTime.inSeconds.abs()} ");

    // _initialElapsedSeconds를 초기화
    // _initialElapsedSeconds = 0;

    return remainingTime.inSeconds.abs();
  }

  // int get initialElapsedSeconds => _initialElapsedSeconds;

  /// 백그라운드에서 돌아가는 시간 초기화
  void resetInitialElapsedSeconds() {
    // _initialElapsedSeconds = 0;
    endingTime = DateTime.now();
    remainingTime = const Duration(seconds: 0);
  }
}
