import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../domain/project_category.dart';

/// The category picker for US41. Returns `null` if the learner cancelled.
Future<ProjectCategory?> showSelectCategoryDialog(BuildContext context, {required ProjectCategory initial}) {
  return showDialog<ProjectCategory>(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      return SimpleDialog(
        title: Text(l10n.projectCategoryPickerTitle),
        children: [
          for (final category in ProjectCategory.values)
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(category),
              child: Row(
                children: [
                  Icon(
                    category == initial ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: AppColors.brandBlue,
                  ),
                  const SizedBox(width: 12),
                  Text(projectCategoryLabel(category)),
                ],
              ),
            ),
        ],
      );
    },
  );
}
