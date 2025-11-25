import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/domain/event/model/event_location.dart';
import 'package:esmorga_flutter/domain/user/model/role_type.dart';
import 'package:esmorga_flutter/domain/user/model/user.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/events/my_events/cubit/my_events_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockEventRepository extends Mock implements EventRepository {}

class _MockUserRepository extends Mock implements UserRepository {}

class _FakeFormatter implements EsmorgaDateTimeFormatter {
  @override
  String formatEventDate(int epochMillis) => 'date';

  @override
  String formatIsoDateTime(DateTime date, String time) => 'iso';

  @override
  String formatTimeWithMillisUtcSuffix(int hour, int minute) => 'timeZ';
}

void main() {
  late _MockEventRepository eventRepository;
  late _MockUserRepository userRepository;
  const testUser = User(name: 'John', lastName: 'Doe', email: 'john@doe.com', role: RoleType.user);
  final joinedEvent = Event(id: '1', name: 'Joined', date: 0, description: 'desc', joinDeadline: 0 ,location: const EventLocation(name: 'Loc'), userJoined: true, imageUrl: null, tags: const [], currentAttendeeCount: 2, maxCapacity: 10);

  setUp(() {
    eventRepository = _MockEventRepository();
    userRepository = _MockUserRepository();
    if (!getIt.isRegistered<EsmorgaDateTimeFormatter>()) {
      getIt.registerSingleton<EsmorgaDateTimeFormatter>(_FakeFormatter());
    }
  });

  group('MyEventsCubit', () {
    blocTest<MyEventsCubit, MyEventsState>(
      'empty list after auth when no joined events',
      build: () {
        when(() => userRepository.getUser()).thenAnswer((_) async => testUser);
        when(() => eventRepository.getEvents()).thenAnswer((_) async => [joinedEvent.copyWith(userJoined: false)]);
        return MyEventsCubit(eventRepository: eventRepository, userRepository: userRepository);
      },
      act: (c) => c.load(),
      expect: () => [const MyEventsState(loading: true), const MyEventsState(loading: false, error: MyEventsEffectType.emptyList)],
    );
  });
}
