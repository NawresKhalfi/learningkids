import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/auth_controller.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  String? _errorText;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _errorText = null);
    final failure = await ref
        .read(authControllerProvider.notifier)
        .sendPasswordResetEmail(_emailController.text.trim());
    if (!mounted) return;
    if (failure == null) {
      setState(() => _emailSent = true);
    } else {
      setState(() => _errorText = l10n.commonSomethingWentWrong);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.login),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.forgotPasswordTitle, style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.forgotPasswordSubtitle, style: AppTextStyles.bodyMuted),
              const SizedBox(height: AppSpacing.lg),
              if (_emailSent)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.cardGreen.surface,
                    borderRadius: BorderRadius.circular(AppRadii.card),
                  ),
                  child: Text(
                    l10n.forgotPasswordSuccess,
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                )
              else ...[
                AppTextField(
                  hintText: l10n.forgotPasswordEmailLabel,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  errorText: _errorText,
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: l10n.forgotPasswordSubmit,
                  isLoading: isLoading,
                  onPressed: _submit,
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.login),
                  child: Text(l10n.forgotPasswordBackToLogin),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
