import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/ds/esmorga_text_field.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/login/cubit/login_cubit.dart';
import 'package:esmorga_flutter/view/login/cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  final String? snackbarMessage; // initial message already passed to cubit
  final VoidCallback onRegisterClicked;
  final VoidCallback onForgotPasswordClicked;
  final VoidCallback onLoginSuccess;
  final VoidCallback onLoginError;
  final VoidCallback onBackClicked;

  const LoginScreen({
    super.key,
    this.snackbarMessage,
    required this.onRegisterClicked,
    required this.onForgotPasswordClicked,
    required this.onLoginError,
    required this.onLoginSuccess,
    required this.onBackClicked,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => getIt<LoginCubit>(param1: ctx, param2: snackbarMessage),
      child: _LoginForm(
        onRegisterClicked: onRegisterClicked,
        onForgotPasswordClicked: onForgotPasswordClicked,
        onLoginSuccess: onLoginSuccess,
        onLoginError: onLoginError,
        onBackClicked: onBackClicked,
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  final VoidCallback onRegisterClicked;
  final VoidCallback onForgotPasswordClicked;
  final VoidCallback onLoginSuccess;
  final VoidCallback onLoginError;
  final VoidCallback onBackClicked;

  const _LoginForm({
    required this.onRegisterClicked,
    required this.onForgotPasswordClicked,
    required this.onLoginSuccess,
    required this.onLoginError,
    required this.onBackClicked,
  });

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  late final LoginCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<LoginCubit>();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        _cubit.blurEmail();
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        _cubit.blurPassword();
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() {
    _cubit.submit();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = getIt<LocalizationService>().current;
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.initMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.initMessage!)),
          );
          _cubit.consumeInitMessage();
        }
        if (state.isSuccess) {
          widget.onLoginSuccess();
        } else if (state.isFailure && state.failureMessage != null) {
          widget.onLoginError();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.failureMessage!)),
          );
        }
        if (state.attemptedSubmit && !state.isFormValid) {
          if (state.emailError != null) {
            _emailFocusNode.requestFocus();
          } else if (state.passwordError != null) {
            _passwordFocusNode.requestFocus();
          }
        }
      },
      builder: (context, state) {
        final showEmailError = (state.emailBlurred || state.attemptedSubmit) ? state.emailError : null;
        final showPasswordError = (state.passwordBlurred || state.attemptedSubmit) ? state.passwordError : null;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onBackClicked,
              key: const Key('login_back_button'),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/img_login_header.jpg',
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.3,
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.image_outlined,
                        size: 64.0,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EsmorgaText(
                        text: l10n.screenLoginTitle,
                        style: EsmorgaTextStyle.heading1,
                        key: const Key('login_title'),
                      ),
                      const SizedBox(height: 16.0),
                      EsmorgaTextField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        title: l10n.fieldTitleEmail,
                        placeholder: l10n.placeholderEmail,
                        errorText: showEmailError,
                        isEnabled: !state.isSubmitting,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onChanged: (v) => _cubit.changeEmail(v),
                        key: const Key('login_email_input'),
                      ),
                      const SizedBox(height: 16.0),
                      EsmorgaTextField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        title: l10n.fieldTitlePassword,
                        placeholder: l10n.placeholderPassword,
                        errorText: showPasswordError,
                        isEnabled: !state.isSubmitting,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        onChanged: (v) => _cubit.changePassword(v),
                        onSubmitted: (_) => _submit(),
                        key: const Key('login_password_input'),
                      ),
                      const SizedBox(height: 16.0),
                      EsmorgaButton(
                        text: l10n.buttonLogin,
                        isLoading: state.isSubmitting,
                        onClick: _submit,
                        key: const Key('login_login_button'),
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: InkWell(
                          onTap: state.isSubmitting ? null : widget.onForgotPasswordClicked,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: EsmorgaText(
                              text: l10n.loginForgotPassword,
                              style: EsmorgaTextStyle.body1Accent,
                              key: const Key('login_forgot_password_button'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      EsmorgaButton(
                        text: l10n.buttonCreateAccount,
                        primary: false,
                        isEnabled: !state.isSubmitting,
                        onClick: widget.onRegisterClicked,
                        key: const Key('login_register_button'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
