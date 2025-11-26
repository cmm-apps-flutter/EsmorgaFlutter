import 'package:esmorga_flutter/domain/event/model/event.dart';

abstract class HomeTabEffect {}

class NavigateToEventDetailsEffect extends HomeTabEffect {
  final Event event;
  NavigateToEventDetailsEffect({required this.event});
}
