// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get buttonCreateAccount => 'Regístrate';

  @override
  String get buttonGuest => 'Entrar como invitado';

  @override
  String get buttonLogin => 'Iniciar sesión';

  @override
  String get buttonLoginRegister => 'Login / Registro';

  @override
  String get buttonNavigate => 'Navegar';

  @override
  String get buttonRegister => 'Registrarme';

  @override
  String get buttonRetry => 'Reintentar';

  @override
  String get contentDescriptionBackIcon => 'Icon atrás';

  @override
  String get contentDescriptionForwardIcon => 'Icono adelante';

  @override
  String contentDescriptionEventImage(String eventName) {
    return 'Imagen del evento $eventName';
  }

  @override
  String get defaultErrorBody => 'Inténtalo de nuevo más tarde';

  @override
  String get defaultErrorTitle => 'Algo ha fallado';

  @override
  String get defaultErrorTitleExpanded =>
      'Algo ha fallado, por favor inténtalo de nuevo más tarde';

  @override
  String get fieldTitleEmail => 'Email';

  @override
  String get fieldTitleLastName => 'Apellido';

  @override
  String get fieldTitleName => 'Nombre';

  @override
  String get fieldTitlePassword => 'Contraseña';

  @override
  String get fieldTitleRepeatPassword => 'Repetir contraseña';

  @override
  String get inlineErrorEmail =>
      'Formato no válido, sólo letras, números y _ - están disponibles';

  @override
  String get inlineErrorEmailAlreadyUsed => 'Email ya ha sido usado';

  @override
  String get inlineErrorEmptyField => 'Campo requerido';

  @override
  String get inlineErrorLastName =>
      'Sólo letras, espacios y \' - están disponibles';

  @override
  String get inlineErrorName =>
      'Sólo letras, espacios y \' - están disponibles';

  @override
  String get inlineErrorPassword => 'Contraseña inválida';

  @override
  String get inlineErrorPasswordInvalid =>
      'Mínimo 8 caracteres, debe incluir al menos 1 dígito, 1 letra y 1 símbolo';

  @override
  String get inlineErrorPasswordMismatch =>
      '¡Las contraseñas no coinciden, inténtalo de nuevo!';

  @override
  String get placeholderConfirmPassword => 'Confirma tu contraseña';

  @override
  String get placeholderEmail => 'Ingresa tu email';

  @override
  String get placeholderLastName => 'Ingresa tu apellido';

  @override
  String get placeholderName => 'Ingresa tu nombre';

  @override
  String get placeholderPassword => 'Ingresa tu contraseña';

  @override
  String get screenEventDetailsDescription => 'Detalles del evento';

  @override
  String get screenEventDetailsLocation => 'Localización';

  @override
  String get screenEventListEmptyText =>
      'No hay eventos disponibles. Por favor vuelve más tarde.';

  @override
  String get screenEventListLoading => 'Cargando eventos…';

  @override
  String get screenEventListTitle => 'Listado de eventos';

  @override
  String get screenHomescreenTitle => '¡Hola!';

  @override
  String get screenLoginTitle => 'Hola de nuevo!';

  @override
  String get screenRegistrationTitle => 'Regístrate';

  @override
  String get snackbarNoInternet => 'No hay conexión a internet.';

  @override
  String get bottomBarExplore => 'Explorar';

  @override
  String get bottomBarMyevents => 'Mis Eventos';

  @override
  String get bottomBarMyprofile => 'Perfil';

  @override
  String get buttonJoinEvent => 'Apuntarse';

  @override
  String get buttonLeaveEvent => 'Rajarse';

  @override
  String get buttonLoginToJoin => 'Identifícate para apuntarte';

  @override
  String get snackbarEventJoined => 'Bravo! Te has unido al evento!';

  @override
  String get screenMyEventsEmptyText =>
      'Todavía no estás apuntado a ningún evento. Anímate para el siguiente!';

  @override
  String get screenMyEventsTitle => 'Tus eventos';

  @override
  String get screenNoConnectionTitle => 'No hay conexión';

  @override
  String get screenNoConnectionBody =>
      'Por favor, revisa tu conexión e inténtelo de nuevo';

  @override
  String get buttonOk => 'OK';

  @override
  String get snackbarEventLeft => 'Buuuuu! Rajao!';

  @override
  String get myProfileTitle => 'Perfil';

  @override
  String get myProfileName => 'Nombre';

  @override
  String get myProfileEmail => 'Email';

  @override
  String get myProfileOptions => 'Opciones';

  @override
  String get myProfileChangePassword => 'Cambiar contraseña';

  @override
  String get myProfileLogout => 'Cerrar sesion';

  @override
  String get myProfileLogoutPopUpTitle => '¿Seguro que quieres cerrar sesión?';

  @override
  String get myProfileLogoutPopUpConfirm => 'Sí, cerrar sesión';

  @override
  String get myProfileLogoutPopUpCancel => 'No, cancelar';

  @override
  String get unauthenticatedErrorMessage => 'Ups… ¡No estás logueado!';

  @override
  String get unauthenticatedErrorLoginButton => 'Login';

  @override
  String get registerConfirmationEmailTitle => 'Confirma tu cuenta';

  @override
  String get registerConfirmationEmailSubtitle =>
      'Hemos enviado un enlace de confirmación a tu correo electrónico. Por favor, revisa tu bandeja de entrada y sigue el enlace para activar tu cuenta.';

  @override
  String get registerConfirmationEmailButtonEmailApp => 'Abrir app de correo';

  @override
  String get registerConfirmationEmailButtonResend => 'Reenviar correo';

  @override
  String get registerResendCodeSuccess =>
      'Un nuevo email de confirmación ha sido enviado';

  @override
  String get registerResendCodeError =>
      'No se ha podido enviar un nuevo email de confirmación';

  @override
  String get loginForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get forgotPasswordScreenTitle => 'Recupera tu contraseña';

  @override
  String get forgotPasswordButton => 'Enviar';

  @override
  String get forgotPasswordSnackbarSuccess => 'Email de recuperación enviado';

  @override
  String get invalidCredentialsError =>
      '¡Datos incorrectos, inténtalo de nuevo!';

  @override
  String get resetPasswordScreenTitle => 'Cambio de Contraseña';

  @override
  String get resetPasswordButton => 'Cambiar contraseña';

  @override
  String get passwordSetSnackbar => '¡Nueva contraseña establecida!';

  @override
  String get placeholderNewPassword => 'Introduce la nueva contraseña';

  @override
  String get resetPasswordNewPasswordField => 'Nueva contraseña';

  @override
  String get resetPasswordRepeatPasswordField => 'Repetir contraseña';

  @override
  String get activateAccountTitle => 'Ya casi estamos…';

  @override
  String get activateAccountDescription =>
      'Estamos verificando tu cuenta. Por favor, espera un momento.';

  @override
  String get activateAccountContinue => 'Continuar';

  @override
  String get registerConfirmationErrorTitle => '¡Código expirado o no válido!';

  @override
  String get registerConfirmationButtonRetry => 'Probar otra vez';

  @override
  String get registerConfirmationButtonCancel => 'Cancelar';

  @override
  String get registrationPasswordMismatchError =>
      '¡Las contraseñas no coinciden, inténtalo de nuevo!';

  @override
  String get registrationReusedPasswordError =>
      'La nueva contraseña debe ser distinta a la actual';

  @override
  String get screenCreateEventTitle => 'Crea tu evento';

  @override
  String get stepContinueButton => 'Siguiente';

  @override
  String get fieldTitleEventName => 'Nombre de evento';

  @override
  String get fieldTitleEventDescription => 'Descripcion';

  @override
  String get placeholderEventName => 'Introduce el nombre del evento';

  @override
  String captionEventDescription(int count) {
    return '$count/5000';
  }

  @override
  String get inlineErrorInvalidLengthName =>
      'El texto debe tener entre 3 y 100 caracteres';

  @override
  String get inlineErrorInvalidLengthDescription =>
      'El texto debe tener entre 4 y 5000 caracteres';

  @override
  String get step2OptionParty => 'Fiesta';

  @override
  String get step2OptionSport => 'Deportes';

  @override
  String get step2OptionFood => 'Comida';

  @override
  String get step2OptionCharity => 'Caridad';

  @override
  String get step2OptionGames => 'Juegos';

  @override
  String get step2ScreenTitle => 'Tipo de Evento';

  @override
  String get placeholderEventDescription =>
      'Introduce una descripción del evento';

  @override
  String get step3ScreenTitle => 'Fecha del evento';

  @override
  String get step3ScreenRowTime => 'Hora del evento';

  @override
  String get confirmButtonDialog => 'Confirmar';

  @override
  String get cancelButtonDialog => 'Cancelar';
}
