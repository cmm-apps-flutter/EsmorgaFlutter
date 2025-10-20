import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/ds/esmorga_text_field.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';
import 'package:esmorga_flutter/view/password/reset_password_cubit.dart';
import 'package:esmorga_flutter/view/password/reset_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:esmorga_flutter/view/navigation/app_routes.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? code;
  const ResetPasswordScreen({super.key, required this.code});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _newController = TextEditingController();
  final _repeatController = TextEditingController();
  final _newFocus = FocusNode();
  final _repeatFocus = FocusNode();
  late ResetPasswordCubit _cubit;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _cubit = BlocProvider.of<ResetPasswordCubit>(context);
      _newFocus.addListener(() {
        if (!_newFocus.hasFocus) _cubit.onNewUnfocused();
      });
      _repeatFocus.addListener(() {
        if (!_repeatFocus.hasFocus) _cubit.onRepeatUnfocused();
      });
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _newController.dispose();
    _repeatController.dispose();
    _newFocus.dispose();
    _repeatFocus.dispose();
    // Cubit is provided by BlocProvider in the route and will be closed by it.
    super.dispose();
  }

  void _submit() {
    _cubit.submit();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state.isSuccess) {
            final encoded = Uri.encodeComponent(l.passwordSetSnackbar);
            context.go('${AppRoutes.login}?message=$encoded');
          } else if (state.status == ResetPasswordStatus.failure) {
            final msg = state.networkFailure
                ? l.snackbarNoInternet
                : l.defaultErrorTitle;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(msg)));
          }
        },
        builder: (context, state) {
          final newErr = (state.newBlurred || state.attemptedSubmit)
              ? state.newError
              : null;
          final repeatErr = (state.repeatBlurred || state.attemptedSubmit)
              ? state.repeatError
              : null;
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
                key: const Key('reset_password_back_button'),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EsmorgaText(
                    text: l.resetPasswordScreenTitle,
                    style: EsmorgaTextStyle.heading1,
                    key: const Key('reset_password_title'),
                  ),
                  if (state.codeInvalid) ...[
                    const SizedBox(height: 16),
                    EsmorgaText(
                      text: l.defaultErrorTitle,
                      style: EsmorgaTextStyle.body1Accent,
                      key: const Key('reset_password_invalid_code'),
                    ),
                  ],
                  const SizedBox(height: 32),
                  EsmorgaTextField(
                    controller: _newController,
                    focusNode: _newFocus,
                    title: l.resetPasswordNewPasswordField,
                    placeholder: l.placeholderNewPassword,
                    obscureText: true,
                    errorText: newErr,
                    textInputAction: TextInputAction.next,
                    onChanged: (v) => _cubit.onNewChanged(v),
                    key: const Key('reset_password_new_input'),
                  ),
                  const SizedBox(height: 16),
                  EsmorgaTextField(
                    controller: _repeatController,
                    focusNode: _repeatFocus,
                    title: l.resetPasswordRepeatPasswordField,
                    placeholder: l.placeholderConfirmPassword,
                    obscureText: true,
                    errorText: repeatErr,
                    textInputAction: TextInputAction.done,
                    onChanged: (v) => _cubit.onRepeatChanged(v),
                    onSubmitted: (_) => _submit(),
                    key: const Key('reset_password_repeat_input'),
                  ),
                  const SizedBox(height: 32),
                  EsmorgaButton(
                    text: l.resetPasswordButton,
                    isLoading: state.isSubmitting,
                    isEnabled: !state.isSubmitting &&
                        state.isFormValid &&
                        !state.codeInvalid,
                    onClick: _submit,
                    key: const Key('reset_password_change_button'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
