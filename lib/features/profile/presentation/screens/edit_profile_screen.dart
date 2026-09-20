import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/profile_controller.dart';
import '../../domain/avatar.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _pseudoController = TextEditingController();
  Avatar? _selectedAvatar;
  String? _errorText;
  bool _initialized = false;

  @override
  void dispose() {
    _pseudoController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final pseudo = _pseudoController.text.trim();
    if (pseudo.isEmpty) {
      setState(() => _errorText = l10n.editProfileErrorEmpty);
      return;
    }
    setState(() => _errorText = null);
    final failure = await ref.read(profileControllerProvider.notifier).updateProfile(
          pseudo: pseudo,
          avatar: _selectedAvatar ?? Avatar.fox,
        );
    if (!mounted) return;
    if (failure == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.editProfileSaved)),
      );
      Navigator.of(context).pop();
    } else {
      setState(() => _errorText = l10n.commonSomethingWentWrong);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(currentProfileProvider);
    final isLoading = ref.watch(profileControllerProvider).isLoading;

    profileAsync.whenData((profile) {
      if (!_initialized && profile != null) {
        _initialized = true;
        _pseudoController.text = profile.pseudo;
        _selectedAvatar = profile.avatar;
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editProfileTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.editProfileChooseAvatar, style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  for (final avatar in Avatar.values)
                    _AvatarOption(
                      avatar: avatar,
                      isSelected: _selectedAvatar == avatar,
                      onTap: () => setState(() => _selectedAvatar = avatar),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.editProfilePseudoLabel, style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                hintText: l10n.editProfilePseudoLabel,
                controller: _pseudoController,
                errorText: _errorText,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: l10n.commonSave,
                isLoading: isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarOption extends StatelessWidget {
  const _AvatarOption({
    required this.avatar,
    required this.isSelected,
    required this.onTap,
  });

  final Avatar avatar;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: avatar.palette.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.ink,
            width: isSelected ? 3.5 : 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(avatar.emoji, style: const TextStyle(fontSize: 30)),
      ),
    );
  }
}
