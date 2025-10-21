import 'dart:async';

import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_loader.dart';
import 'package:esmorga_flutter/ds/esmorga_text.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/registration/verify_account/cubit/verify_account_cubit.dart';
import 'package:esmorga_flutter/view/registration/verify_account/cubit/verify_account_effect.dart';
import 'package:esmorga_flutter/view/registration/verify_account/cubit/verify_account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyAccountScreen extends StatefulWidget {
  final VoidCallback onAccountVerified;

  const VerifyAccountScreen({Key? key, required this.onAccountVerified}) : super(key: key);

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  late final VerifyAccountCubit _cubit;
  StreamSubscription<VerifyAccountEffect>? _effectSub;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<VerifyAccountCubit>();
    _effectSub = _cubit.effectStream.listen((effect) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (effect is NavigateToHomeEffect) {
          widget.onAccountVerified();
        }
      });
    });
    _cubit.verifyAccount();
  }

  @override
  void dispose() {
    _effectSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = getIt<LocalizationService>().current;
    return BlocBuilder<VerifyAccountCubit, VerifyAccountState>(builder: (context, state) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/activate_account_image.png',
                  width: double.infinity,
                  height: 320.0,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 320.0,
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.image_outlined,
                        size: 64.0,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: EsmorgaText(
                    text: l10n.activateAccountTitle,
                    style: EsmorgaTextStyle.heading1,
                    key: const Key(RegistrationConfirmationScreenTestTags.ACTIVATE_ACCOUNT_TITLE),
                  ),
                ),
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: EsmorgaText(
                    text: l10n.activateAccountDescription,
                    style: EsmorgaTextStyle.body1,
                    key: const Key(RegistrationConfirmationScreenTestTags.ACTIVATE_ACCOUNT_SUBTITLE),
                  ),
                ),
                if (state is VerifyAccountLoading) ...[
                  const SizedBox(height: 24.0),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: EsmorgaLinearLoader(),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }
}

class RegistrationConfirmationScreenTestTags {
  static const String ACTIVATE_ACCOUNT_TITLE = 'activate account screen title';
  static const String ACTIVATE_ACCOUNT_IMAGE = 'activate account screen image';
  static const String ACTIVATE_ACCOUNT_SUBTITLE = 'activate account screen subtitle';
}
