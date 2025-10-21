abstract class ChangePasswordEffect {}

class ShowSnackbarEffect extends ChangePasswordEffect {
  final String message;
  final bool success;

  ShowSnackbarEffect(this.message, {this.success = false});
}
