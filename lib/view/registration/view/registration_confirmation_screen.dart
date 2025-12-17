import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_button.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/registration/cubit/registration_confirmation_cubit.dart';
import 'package:esmorga_flutter/view/registration/cubit/registration_confirmation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrationConfirmationScreen extends StatelessWidget {
  final String email;
  final VoidCallback onBackClicked;

  const RegistrationConfirmationScreen({
    super.key,
    required this.email,
    required this.onBackClicked,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegistrationConfirmationCubit>(),
      child: _RegistrationConfirmationForm(email: email, onBackClicked: onBackClicked),
    );
  }
}

class _RegistrationConfirmationForm extends StatefulWidget {
  final String email;
  final VoidCallback onBackClicked;

  const _RegistrationConfirmationForm({required this.email, required this.onBackClicked});

  @override
  State<_RegistrationConfirmationForm> createState() => _RegistrationConfirmationFormState();
}

class _RegistrationConfirmationFormState extends State<_RegistrationConfirmationForm> {
  Future<void> _openEmailApp() async {
    final Uri emailLaunchUri = Uri(scheme: 'mailto', path: '');
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open email app')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = getIt<LocalizationService>().current;

    return BlocConsumer<RegistrationConfirmationCubit, RegistrationConfirmationState>(
      listener: (context, state) {
        if (state is RegistrationConfirmationOpenEmailApp) {
          _openEmailApp();
        } else if (state is RegistrationConfirmationResendSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.registerResendCodeSuccess)),
          );
        } else if (state is RegistrationConfirmationResendFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.registerResendCodeError)),
          );
        }
      },
      builder: (context, state) {
        final isResending = state is RegistrationConfirmationResending;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onBackClicked,
              key: const Key('registration_confirmation_back_button'),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/img_email.png',
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.email_outlined,
                      size: 64.0,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EsmorgaText(
                        text: l10n.registerConfirmationEmailTitle,
                        style: EsmorgaTextStyle.heading1,
                        key: const Key('registration_confirmation_title'),
                      ),
                      const SizedBox(height: 12.0),
                      EsmorgaText(
                        text: l10n.registerConfirmationEmailSubtitle,
                        style: EsmorgaTextStyle.body1,
                      ),
                      const SizedBox(height: 32.0),
                      EsmorgaButton(
                        text: l10n.registerConfirmationEmailButtonEmailApp,
                        onClick: () {
                          context.read<RegistrationConfirmationCubit>().openEmailAppRequested();
                        },
                        key: const Key('registration_confirmation_open_button'),
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: InkWell(
                          onTap: isResending
                              ? null
                              : () {
                                  context.read<RegistrationConfirmationCubit>().resendEmailRequested(widget.email);
                                },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: EsmorgaText(
                              text: l10n.registerConfirmationEmailButtonResend,
                              style: EsmorgaTextStyle.body1Accent,
                              key: const Key('registration_confirmation_resend_button'),
                            ),
                          ),
                        ),
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
