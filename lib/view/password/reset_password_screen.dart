import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/ds/esmorga_text_field.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/password/reset_password_cubit.dart';
import 'package:esmorga_flutter/view/password/reset_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String? code;

  const ResetPasswordScreen({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => getIt<ResetPasswordCubit>(param1: ctx, param2: code),
      child: _ResetPasswordForm(code: code),
    );
  }
}

class _ResetPasswordForm extends StatefulWidget {
  final String? code;

  const _ResetPasswordForm({required this.code});

  @override
  State<_ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<_ResetPasswordForm> {
  final _newController = TextEditingController();
  final _repeatController = TextEditingController();
  final _newFocus = FocusNode();
  final _repeatFocus = FocusNode();
  late ResetPasswordCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ResetPasswordCubit>();
    _newFocus.addListener(() {
      if (!_newFocus.hasFocus) _cubit.onNewUnfocused();
    });
    _repeatFocus.addListener(() {
      if (!_repeatFocus.hasFocus) _cubit.onRepeatUnfocused();
    });
  }

  @override
  void dispose() {
    _newController.dispose();
    _repeatController.dispose();
    _newFocus.dispose();
    _repeatFocus.dispose();
    super.dispose();
  }

  void _submit() {
    _cubit.submit();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = getIt<LocalizationService>().current;

    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state.isSuccess) {
          final encoded = Uri.encodeComponent(l10n.passwordSetSnackbar);
          context.go('/login?message=$encoded');
        } else if (state.status == ResetPasswordStatus.failure) {
          final msg = state.networkFailure ? l10n.snackbarNoInternet : l10n.defaultErrorTitle;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        }
      },
      builder: (context, state) {
        final newErr = (state.newBlurred || state.attemptedSubmit) ? state.newError : null;
        final repeatErr = (state.repeatBlurred || state.attemptedSubmit) ? state.repeatError : null;
        final bool obscureText = !state.showPassword;

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
                  text: l10n.resetPasswordScreenTitle,
                  style: EsmorgaTextStyle.heading1,
                  key: const Key('reset_password_title'),
                ),
                if (state.codeInvalid) ...[
                  const SizedBox(height: 16),
                  EsmorgaText(
                    text: l10n.defaultErrorTitle,
                    style: EsmorgaTextStyle.body1Accent,
                    key: const Key('reset_password_invalid_code'),
                  ),
                ],
                const SizedBox(height: 32),
                EsmorgaTextField(
                  controller: _newController,
                  focusNode: _newFocus,
                  title: l10n.resetPasswordNewPasswordField,
                  placeholder: l10n.placeholderNewPassword,
                  isPasswordField: true,
                  obscureText: obscureText,
                  onSuffixIconClick: _cubit.togglePasswordVisibility,
                  errorText: newErr,
                  textInputAction: TextInputAction.next,
                  onChanged: (v) => _cubit.onNewChanged(v),
                  key: const Key('reset_password_new_input'),
                ),
                const SizedBox(height: 16),
                EsmorgaTextField(
                  controller: _repeatController,
                  focusNode: _repeatFocus,
                  title: l10n.resetPasswordRepeatPasswordField,
                  placeholder: l10n.placeholderConfirmPassword,
                  isPasswordField: true,
                  obscureText: obscureText,
                  onSuffixIconClick: _cubit.togglePasswordVisibility,
                  errorText: repeatErr,
                  textInputAction: TextInputAction.done,
                  onChanged: (v) => _cubit.onRepeatChanged(v),
                  onSubmitted: (_) => _submit(),
                  key: const Key('reset_password_repeat_input'),
                ),
                const SizedBox(height: 32),
                EsmorgaButton(
                  text: l10n.resetPasswordButton,
                  isLoading: state.isSubmitting,
                  isEnabled: !state.isSubmitting && state.isFormValid && !state.codeInvalid,
                  onClick: _submit,
                  key: const Key('reset_password_change_button'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}