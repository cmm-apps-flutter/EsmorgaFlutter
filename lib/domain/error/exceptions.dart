class EsmorgaException implements Exception {
  final int code;
  final String message;

  EsmorgaException({required this.code, required this.message});

  @override
  String toString() => 'EsmorgaException(code: $code, message: $message)';
}

class EventFullException extends EsmorgaException {
  EventFullException() : super(code: 422, message: 'Event is full');
}
