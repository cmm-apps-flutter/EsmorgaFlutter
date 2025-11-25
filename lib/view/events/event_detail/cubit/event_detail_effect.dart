// filepath: lib/view/events/event_detail/cubit/event_detail_effect.dart

abstract class EventDetailEffect {}

class NavigateBackEffect extends EventDetailEffect {}
class NavigateToLoginEffect extends EventDetailEffect {}
class ShowJoinSuccessEffect extends EventDetailEffect {}
class ShowLeaveSuccessEffect extends EventDetailEffect {}
class ShowNoNetworkEffect extends EventDetailEffect {}
class ShowGenericErrorEffect extends EventDetailEffect {}
class OpenMapsEffect extends EventDetailEffect {
  final double lat;
  final double lng;
  final String name;
  OpenMapsEffect({required this.lat, required this.lng, required this.name});
}
class ShowEventFullSnackbarEffect extends EventDetailEffect {}
class ShowJoinClosedEffect extends EventDetailEffect {}