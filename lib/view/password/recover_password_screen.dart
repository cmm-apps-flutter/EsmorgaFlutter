import 'dart:async';

import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/ds/esmorga_text_field.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';
import 'package:esmorga_flutter/view/password/recover_password_cubit.dart';
import 'package:esmorga_flutter/view/password/recover_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RecoverPasswordScreen extends StatelessWidget {
  const RecoverPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => getIt<RecoverPasswordCubit>(param1: ctx),
      child: const _RecoverPasswordForm(),
    );
  }
}

class _RecoverPasswordForm extends StatefulWidget {
  const _RecoverPasswordForm();

  @override
  State<_RecoverPasswordForm> createState() => _RecoverPasswordFormState();
}

class _RecoverPasswordFormState extends State<_RecoverPasswordForm> {
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();
  late RecoverPasswordCubit _cubit;
  StreamSubscription? _successSub;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<RecoverPasswordCubit>();
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus) _cubit.onEmailUnfocused();
    });
    _initialized = true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    _successSub?.cancel();
    super.dispose();
  }

  void _submit() {
    _cubit.submit();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    return BlocConsumer<RecoverPasswordCubit, RecoverPasswordState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l.forgotPasswordSnackbarSuccess)),
          );
          context.go('/login');
        } else if (state.status == RecoverPasswordStatus.failure) {
          final msg = state.networkFailure
              ? l.snackbarNoInternet
              : l.defaultErrorTitle;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(msg)));
        }
      },
      builder: (context, state) {
        final emailError = (state.emailBlurred || state.attemptedSubmit)
            ? state.emailError
            : null;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
              key: const Key('recover_password_back_button'),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EsmorgaText(
                  text: l.forgotPasswordScreenTitle,
                  style: EsmorgaTextStyle.heading1,
                  key: const Key('recover_password_title'),
                ),
                const SizedBox(height: 32),
                EsmorgaTextField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  title: l.fieldTitleEmail,
                  placeholder: l.placeholderEmail,
                  errorText: emailError,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onChanged: (v) => _cubit.onEmailChanged(v),
                  onSubmitted: (_) => _submit(),
                  key: const Key('recover_password_email_input'),
                ),
                const SizedBox(height: 32),
                EsmorgaButton(
                  text: l.forgotPasswordButton,
                  isLoading: state.isSubmitting,
                  isEnabled: !state.isSubmitting &&
                      emailError == null &&
                      state.email.isNotEmpty,
                  onClick: _submit,
                  key: const Key('recover_password_send_button'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
