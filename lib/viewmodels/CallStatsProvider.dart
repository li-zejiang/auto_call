import 'package:flutter_riverpod/flutter_riverpod.dart';

// Call Stats Model
class CallStats {
  final int dialedToday;
  final int connectedToday;
  const CallStats({this.dialedToday = 0, this.connectedToday = 0});
  CallStats copyWith({int? dialedToday, int? connectedToday}) => CallStats(
        dialedToday: dialedToday ?? this.dialedToday,
        connectedToday: connectedToday ?? this.connectedToday,
      );
}

// Call Stats Controller
class CallStatsController extends StateNotifier<CallStats> {
  CallStatsController() : super(const CallStats());
  void addDialed() =>
      state = state.copyWith(dialedToday: state.dialedToday + 1);
  void addConnected() =>
      state = state.copyWith(connectedToday: state.connectedToday + 1);
}

final callStatsProvider =
    StateNotifierProvider<CallStatsController, CallStats>((ref) {
  return CallStatsController();
});
