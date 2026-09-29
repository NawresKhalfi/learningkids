import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

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
  Uint8List? _selectedPhoto;
  String? _selectedPhotoBase64;
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
    final failure = await ref
        .read(profileControllerProvider.notifier)
        .updateProfile(
          pseudo: pseudo,
          avatar: _selectedAvatar ?? Avatar.fox,
          avatarImageBase64: _selectedPhotoBase64,
        );
    if (!mounted) return;
    if (failure == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.editProfileSaved)));
      Navigator.of(context).pop();
    } else {
      setState(() => _errorText = l10n.commonSomethingWentWrong);
    }
  }

  Future<void> _pickPhoto() async {
    final photo = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 360,
      maxHeight: 360,
      imageQuality: 78,
    );
    if (photo == null) return;
    final bytes = await photo.readAsBytes();
    if (!mounted) return;
    setState(() {
      _selectedPhoto = bytes;
      _selectedPhotoBase64 = base64Encode(bytes);
    });
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
        _selectedPhotoBase64 = profile.avatarImageBase64;
        if (_selectedPhotoBase64 != null) {
          _selectedPhoto = base64Decode(_selectedPhotoBase64!);
        }
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
                      isSelected:
                          _selectedPhoto == null && _selectedAvatar == avatar,
                      onTap: () => setState(() {
                        _selectedAvatar = avatar;
                        _selectedPhoto = null;
                        _selectedPhotoBase64 = null;
                      }),
                    ),
                  _PhotoOption(
                    photo: _selectedPhoto,
                    isSelected: _selectedPhoto != null,
                    onTap: _pickPhoto,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _pickPhoto,
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: const Text('Importer une photo'),
                ),
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

class _PhotoOption extends StatelessWidget {
  const _PhotoOption({
    required this.photo,
    required this.isSelected,
    required this.onTap,
  });

  final Uint8List? photo;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.cardBlue.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.ink, width: isSelected ? 3.5 : 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: photo == null
          ? const Icon(Icons.add_a_photo_outlined, color: AppColors.ink)
          : Image.memory(photo!, fit: BoxFit.cover),
    ),
  );
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
