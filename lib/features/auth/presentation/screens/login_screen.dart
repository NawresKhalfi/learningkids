import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/comic_title.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/auth_controller.dart';
import '../widgets/auth_error_messages.dart';
import '../widgets/social_sign_in_buttons.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _errorText = null);
    final failure = await ref.read(authControllerProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    if (!mounted || failure == null) return;
    setState(() => _errorText = loginFailureMessage(l10n, failure));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Center(child: ComicTitle(l10n.loginTitle, fontSize: 34)),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                hintText: l10n.loginEmailLabel,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                hintText: l10n.loginPasswordLabel,
                controller: _passwordController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                errorText: _errorText,
                onSubmitted: (_) => _submit(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.forgotPassword),
                  child: Text(l10n.loginForgotPassword),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: l10n.loginSubmit,
                isLoading: isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: AppSpacing.lg),
              SocialSignInButtons(
                isLoading: isLoading,
                onGooglePressed: () async {
                  final failure = await ref
                      .read(authControllerProvider.notifier)
                      .signInWithGoogle();
                  if (!mounted || failure == null) return;
                  setState(() => _errorText = loginFailureMessage(l10n, failure));
                },
                onApplePressed: () async {
                  final failure = await ref
                      .read(authControllerProvider.notifier)
                      .signInWithApple();
                  if (!mounted || failure == null) return;
                  setState(() => _errorText = loginFailureMessage(l10n, failure));
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.loginNoAccount),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.signUp),
                    child: Text(l10n.loginSignUpLink),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
