import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/domain/poll/model/poll.dart';

abstract class HomeTabEffect {}

class NavigateToEventDetailsEffect extends HomeTabEffect {
  final Event event;
  NavigateToEventDetailsEffect({required this.event});
}

class NavigateToPollDetailsEffect extends HomeTabEffect {
  final Poll poll;
  NavigateToPollDetailsEffect({required this.poll});
}
