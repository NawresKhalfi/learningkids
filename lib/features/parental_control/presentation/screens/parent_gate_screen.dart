import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/parental_control_controller.dart';
import '../../application/screen_time_controller.dart';
import '../../domain/parent_pin.dart';
import '../widgets/pin_input.dart';

/// What to do once the parent has proven themselves via the PIN.
enum ParentGateAction { openDashboard, grantExtraTime }

/// The Espace Parent PIN gate (US07): creates a PIN the first time, then
/// asks for it on every later visit. No separate parent account — see the
/// single-account model agreed for this epic.
class ParentGateScreen extends ConsumerStatefulWidget {
  const ParentGateScreen({
    super.key,
    this.action = ParentGateAction.openDashboard,
    this.forceCreatePin = false,
  });

  final ParentGateAction action;

  /// Reuses the create/confirm PIN flow even though a PIN already exists —
  /// used by the dashboard's "Changer le code PIN" action.
  final bool forceCreatePin;

  @override
  ConsumerState<ParentGateScreen> createState() => _ParentGateScreenState();
}

class _ParentGateScreenState extends ConsumerState<ParentGateScreen> {
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _awaitingConfirmation = false;
  String? _errorText;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _onProceed() async {
    switch (widget.action) {
      case ParentGateAction.openDashboard:
        if (mounted) context.go(AppRoutes.parentDashboard);
      case ParentGateAction.grantExtraTime:
        await ref.read(screenTimeControllerProvider.notifier).grantExtraTimeToday();
        if (mounted) context.go(AppRoutes.home);
    }
  }

  Future<void> _submitCreate() async {
    final l10n = AppLocalizations.of(context);
    final pin = _pinController.text;
    if (!isValidParentPin(pin)) {
      setState(() => _errorText = l10n.parentGateErrorInvalidFormat);
      return;
    }
    if (!_awaitingConfirmation) {
      setState(() {
        _awaitingConfirmation = true;
        _errorText = null;
      });
      return;
    }
    if (_confirmController.text != pin) {
      setState(() => _errorText = l10n.parentGateErrorMismatch);
      return;
    }
    await ref.read(parentalControlControllerProvider.notifier).createOrChangePin(pin);
    await _onProceed();
  }

  Future<void> _submitVerify() async {
    final l10n = AppLocalizations.of(context);
    final isCorrect = ref
        .read(parentalControlControllerProvider.notifier)
        .verifyPin(_pinController.text);
    if (!isCorrect) {
      setState(() => _errorText = l10n.parentGateErrorWrongPin);
      _pinController.clear();
      return;
    }
    await _onProceed();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settingsAsync = ref.watch(parentalSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.parentGateTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: settingsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => Center(child: Text(l10n.commonSomethingWentWrong)),
            data: (settings) {
              final hasPin = settings.hasPin && !widget.forceCreatePin;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    hasPin
                        ? l10n.parentGateEnterPinPrompt
                        : (_awaitingConfirmation
                            ? l10n.parentGateConfirmPinPrompt
                            : l10n.parentGateCreatePinPrompt),
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (!hasPin && _awaitingConfirmation)
                    PinInput(
                      controller: _confirmController,
                      hintText: l10n.parentGatePinHint,
                      errorText: _errorText,
                      autofocus: true,
                      onSubmitted: (_) => _submitCreate(),
                    )
                  else
                    PinInput(
                      controller: _pinController,
                      hintText: l10n.parentGatePinHint,
                      errorText: _errorText,
                      autofocus: true,
                      onSubmitted: (_) => hasPin ? _submitVerify() : _submitCreate(),
                    ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: l10n.parentGateSubmit,
                    onPressed: hasPin ? _submitVerify : _submitCreate,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
