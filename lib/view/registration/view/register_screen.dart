// filepath: /Users/p.martinez.grela/AndroidStudioProjects/EsmorgaFlutter/lib/view/registration/view/register_screen_v2.dart

import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/ds/esmorga_text_field.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/navigation/app_routes.dart';
import 'package:esmorga_flutter/view/registration/cubit/register_cubit.dart';
import 'package:esmorga_flutter/view/registration/cubit/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => getIt<RegisterCubit>(param1: ctx),
      child: const _RegisterForm(),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _repeatPasswordFocusNode = FocusNode();

  late final RegisterCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<RegisterCubit>();

    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) _cubit.onNameUnfocused();
    });
    _lastNameFocusNode.addListener(() {
      if (!_lastNameFocusNode.hasFocus) _cubit.onLastNameUnfocused();
    });
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) _cubit.onEmailUnfocused();
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) _cubit.onPasswordUnfocused();
    });
    _repeatPasswordFocusNode.addListener(() {
      if (!_repeatPasswordFocusNode.hasFocus) _cubit.onRepeatPasswordUnfocused();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _nameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _repeatPasswordFocusNode.dispose();
    super.dispose();
  }

  void _onSubmit() => _cubit.submit();

  @override
  Widget build(BuildContext context) {
    final l10n = getIt<LocalizationService>().current;

    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.isSuccess && state.successEmail != null) {
          context.go('${AppRoutes.registrationConfirmation}?email=${Uri.encodeComponent(state.successEmail!)}');
        } else if (state.isFailure && state.failureMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.failureMessage!)));
        }

        if (state.attemptedSubmit) {
          if (state.nameError != null)
            _nameFocusNode.requestFocus();
          else if (state.lastNameError != null)
            _lastNameFocusNode.requestFocus();
          else if (state.emailError != null)
            _emailFocusNode.requestFocus();
          else if (state.passwordError != null)
            _passwordFocusNode.requestFocus();
          else if (state.repeatPasswordError != null) _repeatPasswordFocusNode.requestFocus();
        }
      },
      builder: (context, state) {
        final isLoading = state.isSubmitting;

        String? nameError = (state.nameBlurred || state.attemptedSubmit) ? state.nameError : null;
        String? lastNameError = (state.lastNameBlurred || state.attemptedSubmit) ? state.lastNameError : null;
        String? emailError = (state.emailBlurred || state.attemptedSubmit) ? state.emailError : null;
        String? passwordError = (state.passwordBlurred || state.attemptedSubmit) ? state.passwordError : null;
        String? repeatPasswordError = (state.repeatPasswordBlurred || state.attemptedSubmit) ? state.repeatPasswordError : null;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EsmorgaText(text: l10n.screenRegistrationTitle, style: EsmorgaTextStyle.heading1, key: const Key('registration_title')),
                    const SizedBox(height: 16.0),
                    EsmorgaTextField(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      title: l10n.fieldTitleName,
                      placeholder: l10n.placeholderName,
                      isEnabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      errorText: nameError,
                      onChanged: _cubit.onNameChanged,
                      key: const Key('registration_name_input'),
                    ),
                    const SizedBox(height: 16.0),
                    EsmorgaTextField(
                      controller: _lastNameController,
                      focusNode: _lastNameFocusNode,
                      title: l10n.fieldTitleLastName,
                      placeholder: l10n.placeholderLastName,
                      isEnabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      errorText: lastNameError,
                      onChanged: _cubit.onLastNameChanged,
                      key: const Key('registration_last_name_input'),
                    ),
                    const SizedBox(height: 16.0),
                    EsmorgaTextField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      title: l10n.fieldTitleEmail,
                      placeholder: l10n.placeholderEmail,
                      isEnabled: !isLoading,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      errorText: emailError,
                      onChanged: _cubit.onEmailChanged,
                      key: const Key('registration_email_input'),
                    ),
                    const SizedBox(height: 16.0),
                    EsmorgaTextField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      title: l10n.fieldTitlePassword,
                      placeholder: l10n.placeholderPassword,
                      isEnabled: !isLoading,
                      isPasswordField: true,
                      textInputAction: TextInputAction.next,
                      errorText: passwordError,
                      onChanged: _cubit.onPasswordChanged,
                      key: const Key('registration_password_input'),
                    ),
                    const SizedBox(height: 16.0),
                    EsmorgaTextField(
                      controller: _repeatPasswordController,
                      focusNode: _repeatPasswordFocusNode,
                      title: l10n.fieldTitleRepeatPassword,
                      placeholder: l10n.placeholderConfirmPassword,
                      isEnabled: !isLoading,
                      isPasswordField: true,
                      textInputAction: TextInputAction.done,
                      errorText: repeatPasswordError,
                      onChanged: _cubit.onRepeatPasswordChanged,
                      onSubmitted: (_) => _onSubmit(),
                      key: const Key('registration_repeat_password_input'),
                    ),
                    const SizedBox(height: 24.0),
                    EsmorgaButton(
                      text: l10n.buttonRegister,
                      isLoading: isLoading,
                      isEnabled: !isLoading,
                      onClick: _onSubmit,
                      key: const Key('registration_register_button'),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
