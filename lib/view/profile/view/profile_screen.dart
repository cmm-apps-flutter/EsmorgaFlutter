import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_dialog.dart';
import 'package:esmorga_flutter/ds/esmorga_loader.dart';
import 'package:esmorga_flutter/ds/esmorga_row.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';
import 'package:esmorga_flutter/view/profile/cubit/profile_cubit.dart';
import 'package:esmorga_flutter/view/profile/cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onNavigateToLogin;
  final VoidCallback onNavigateToChangePassword;

  const ProfileScreen({
    super.key,
    required this.onNavigateToLogin,
    required this.onNavigateToChangePassword,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().start();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (prev, curr) => prev.oneOffAction != curr.oneOffAction || prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        switch (state.oneOffAction) {
          case ProfileAction.navigateToLogin:
            widget.onNavigateToLogin();
            context.read<ProfileCubit>().actionConsumed();
            break;
          case ProfileAction.navigateToChangePassword:
            widget.onNavigateToChangePassword();
            context.read<ProfileCubit>().actionConsumed();
            break;
          case ProfileAction.loggedOut:
            context.read<ProfileCubit>().actionConsumed();
            break;
          case null:
            break;
        }
      },
      child: Scaffold(
        body: SafeArea(child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: EsmorgaCircularLoader());
            }
            if (!state.isLoggedIn) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  EsmorgaText(
                    text: l10n.myProfileTitle,
                    style: EsmorgaTextStyle.heading1,
                    key: const Key('profile_title_logged_out'),
                  ),
                  const SizedBox(height: 32),
                  EsmorgaText(
                    text: l10n.unauthenticatedErrorMessage,
                    style: EsmorgaTextStyle.body1,
                    key: const Key('profile_logged_out_message'),
                  ),
                  const SizedBox(height: 32),
                  EsmorgaButton(
                    text: l10n.buttonLogin,
                    onClick: () => context.read<ProfileCubit>().loginPressed(),
                    key: const Key('profile_login_button'),
                  ),
                ],
              );
            }
            final user = state.user!;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                EsmorgaText(
                  text: l10n.myProfileTitle,
                  style: EsmorgaTextStyle.heading1,
                  key: const Key('profile_title_logged_in'),
                ),
                const SizedBox(height: 32),
                // Name Section
                EsmorgaText(
                  text: l10n.myProfileName,
                  style: EsmorgaTextStyle.heading2,
                  key: const Key('profile_name_label'),
                ),
                const SizedBox(height: 4),
                EsmorgaText(
                  text: '${user.name} ${user.lastName}',
                  style: EsmorgaTextStyle.body1,
                  key: const Key('profile_user_name'),
                ),
                const SizedBox(height: 32),
                // Email Section
                EsmorgaText(
                  text: l10n.myProfileEmail,
                  style: EsmorgaTextStyle.heading2,
                  key: const Key('profile_email_label'),
                ),
                const SizedBox(height: 4),
                EsmorgaText(
                  text: user.email,
                  style: EsmorgaTextStyle.body1,
                  key: const Key('profile_user_email'),
                ),
                const SizedBox(height: 48),
                // Options Section
                EsmorgaText(
                  text: l10n.myProfileOptions,
                  style: EsmorgaTextStyle.heading2,
                  key: const Key('profile_options_title'),
                ),
                const SizedBox(height: 24),
                EsmorgaRow(
                  key: const Key('profile_change_password_row'),
                  title: l10n.myProfileChangePassword,
                  onClick: () => context.read<ProfileCubit>().changePasswordPressed(),
                ),
                EsmorgaRow(
                  key: const Key('profile_logout_row'),
                  title: l10n.myProfileLogout,
                  onClick: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => EsmorgaDialog(
                        title: l10n.myProfileLogoutPopUpTitle,
                        confirmButtonText: l10n.myProfileLogoutPopUpConfirm,
                        dismissButtonText: l10n.myProfileLogoutPopUpCancel,
                        onConfirm: () => Navigator.of(ctx).pop(true),
                        onDismiss: () => Navigator.of(ctx).pop(false),
                      ),
                    );
                    if (confirm == true && mounted) {
                      context.read<ProfileCubit>().logoutPressed();
                    }
                  },
                ),
              ],
            );
          },
        )),
      ),
    );
  }
}
