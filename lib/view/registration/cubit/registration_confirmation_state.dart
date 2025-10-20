// Finite state classes for Registration Confirmation flow (Strategy A)
// Simple linear + side-effect states; no Equatable needed because UI branches by type.

abstract class RegistrationConfirmationState {}

class RegistrationConfirmationInitial extends RegistrationConfirmationState {}
class RegistrationConfirmationResending extends RegistrationConfirmationState {}
class RegistrationConfirmationResendSuccess extends RegistrationConfirmationState {}
class RegistrationConfirmationResendFailure extends RegistrationConfirmationState {}
class RegistrationConfirmationOpenEmailApp extends RegistrationConfirmationState {}
