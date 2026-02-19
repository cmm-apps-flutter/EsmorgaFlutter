abstract class EsmorgaClock {
  DateTime now();
}

class SystemClock implements EsmorgaClock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}
