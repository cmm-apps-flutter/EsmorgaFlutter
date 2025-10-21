
import 'package:esmorga_flutter/domain/event/model/event.dart';

abstract class EventListEffect {}

class NavigateToEventDetailsEffect extends EventListEffect {
  final Event event;
  NavigateToEventDetailsEffect({required this.event});
}