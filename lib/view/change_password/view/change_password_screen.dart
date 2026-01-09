// view/change_password/change_password_screen.dart

import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/ds/esmorga_text_field.dart';
import 'package:esmorga_flutter/view/change_password/cubit/change_password_cubit.dart';
import 'package:esmorga_flutter/view/change_password/cubit/change_password_effect.dart';
import 'package:esmorga_flutter/view/change_password/cubit/change_password_state.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => getIt<ChangePasswordCubit>(param1: ctx),
      child: const _ChangePasswordForm(),
    );
  }
}

class _ChangePasswordForm extends StatefulWidget {
  const _ChangePasswordForm();

  @override
  State<_ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<_ChangePasswordForm> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _repeatCtrl = TextEditingController();
  final _currentFocus = FocusNode();
  final _newFocus = FocusNode();
  final _repeatFocus = FocusNode();
  late final ChangePasswordCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ChangePasswordCubit>();
    _currentFocus.addListener(() {
      if (!_currentFocus.hasFocus) _cubit.onCurrentUnfocused();
    });
    _newFocus.addListener(() {
      if (!_newFocus.hasFocus) _cubit.onNewUnfocused();
    });
    _repeatFocus.addListener(() {
      if (!_repeatFocus.hasFocus) _cubit.onRepeatUnfocused();
    });
  }

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _repeatCtrl.dispose();
    _currentFocus.dispose();
    _newFocus.dispose();
    _repeatFocus.dispose();
    super.dispose();
  }

  void _submit() => _cubit.submit();

  @override
  Widget build(BuildContext context) {
    final l10n = getIt<LocalizationService>().current;

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () => context.pop()),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: StreamBuilder<ChangePasswordEffect>(
                stream: _cubit.effects,
                builder: (_, snapshot) {
                  if (snapshot.hasData && snapshot.data is ShowSnackbarEffect) {
                    final effect = snapshot.data as ShowSnackbarEffect;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(effect.message)));
                      if (effect.success) context.go(AppRoutes.login);
                    });
                  }
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EsmorgaText(
                          text: l10n.resetPasswordScreenTitle,
                          style: EsmorgaTextStyle.heading1,
                        ),
                        const SizedBox(height: 32),
                        BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                          builder: (ctx, state) {
                            final editing = state is ChangePasswordEditing ? state : const ChangePasswordEditing();
                            // Update controllers with state values
                            if (_currentCtrl.text != editing.currentPassword) {
                              _currentCtrl.text = editing.currentPassword;
                            }
                            if (_newCtrl.text != editing.newPassword) {
                              _newCtrl.text = editing.newPassword;
                            }
                            if (_repeatCtrl.text != editing.repeatPassword) {
                              _repeatCtrl.text = editing.repeatPassword;
                            }
                            return Column(children: [
                              EsmorgaTextField(
                                controller: _currentCtrl,
                                focusNode: _currentFocus,
                                title: l10n.fieldTitlePassword,
                                placeholder: l10n.placeholderPassword,
                                isPasswordField: true,
                                errorText: editing.currentErrorKey,
                                isEnabled: !editing.isSubmitting,
                                textInputAction: TextInputAction.next,
                                onChanged: _cubit.onCurrentChanged,
                              ),
                              const SizedBox(height: 16),
                              EsmorgaTextField(
                                controller: _newCtrl,
                                focusNode: _newFocus,
                                title: l10n.resetPasswordNewPasswordField,
                                placeholder: l10n.placeholderNewPassword,
                                isPasswordField: true,
                                errorText: editing.newErrorKey,
                                isEnabled: !editing.isSubmitting,
                                textInputAction: TextInputAction.next,
                                onChanged: _cubit.onNewChanged,
                              ),
                              const SizedBox(height: 16),
                              EsmorgaTextField(
                                controller: _repeatCtrl,
                                focusNode: _repeatFocus,
                                title: l10n.resetPasswordRepeatPasswordField,
                                placeholder: l10n.placeholderConfirmPassword,
                                isPasswordField: true,
                                errorText: editing.repeatErrorKey,
                                isEnabled: !editing.isSubmitting,
                                textInputAction: TextInputAction.done,
                                onChanged: _cubit.onRepeatChanged,
                                onSubmitted: (_) => _submit(),
                              ),
                              const SizedBox(height: 32),
                              EsmorgaButton(
                                text: l10n.resetPasswordButton,
                                isLoading: editing.isSubmitting,
                                isEnabled: editing.isValid && !editing.isSubmitting,
                                onClick: _submit,
                              ),
                            ]);
                          },
                        ),
                      ],
                    ),
                  );
                })));
  }
}
