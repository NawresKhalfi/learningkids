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

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _errorText;

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!_emailRegex.hasMatch(email)) {
      setState(() => _errorText = l10n.signUpErrorInvalidEmail);
      return;
    }
    if (password.length < 6) {
      setState(() => _errorText = l10n.signUpErrorWeakPassword);
      return;
    }
    if (password != _confirmPasswordController.text) {
      setState(() => _errorText = l10n.signUpErrorPasswordMismatch);
      return;
    }

    setState(() => _errorText = null);
    final failure = await ref
        .read(authControllerProvider.notifier)
        .signUp(email: email, password: password);
    if (!mounted || failure == null) return;
    setState(() => _errorText = signUpFailureMessage(l10n, failure));
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
              Center(child: ComicTitle(l10n.signUpTitle, fontSize: 34)),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                hintText: l10n.signUpEmailLabel,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                hintText: l10n.signUpPasswordLabel,
                controller: _passwordController,
                obscureText: true,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                hintText: l10n.signUpConfirmPasswordLabel,
                controller: _confirmPasswordController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                errorText: _errorText,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: l10n.signUpSubmit,
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
                  setState(() => _errorText = signUpFailureMessage(l10n, failure));
                },
                onApplePressed: () async {
                  final failure = await ref
                      .read(authControllerProvider.notifier)
                      .signInWithApple();
                  if (!mounted || failure == null) return;
                  setState(() => _errorText = signUpFailureMessage(l10n, failure));
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.signUpAlreadyHaveAccount),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.login),
                    child: Text(l10n.signUpLoginLink),
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
