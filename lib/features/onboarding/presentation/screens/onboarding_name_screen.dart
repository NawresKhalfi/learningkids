import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/onboarding_controller.dart';
import '../widgets/onboarding_scaffold.dart';

class OnboardingNameScreen extends ConsumerStatefulWidget {
  const OnboardingNameScreen({super.key});

  @override
  ConsumerState<OnboardingNameScreen> createState() =>
      _OnboardingNameScreenState();
}

class _OnboardingNameScreenState extends ConsumerState<OnboardingNameScreen> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = ref.read(onboardingControllerProvider).name ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    ref.read(onboardingControllerProvider.notifier).setName(name);
    context.go(AppRoutes.onboardingLevel);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return OnboardingScaffold(
      message: l10n.onboardingAskName,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            hintText: l10n.onboardingNameHint,
            controller: _nameController,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(label: l10n.commonContinue, onPressed: _submit),
        ],
      ),
    );
  }
}
