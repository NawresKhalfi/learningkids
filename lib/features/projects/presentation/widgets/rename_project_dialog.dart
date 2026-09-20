import 'package:flutter/material.dart';

import '../../../../l10n/gen/app_localizations.dart';

/// Returns the new title, or `null` if the learner cancelled.
Future<String?> showRenameProjectDialog(BuildContext context, {required String initialTitle}) {
  final controller = TextEditingController(text: initialTitle);
  return showDialog<String>(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      return AlertDialog(
        title: Text(l10n.projectRenameTitle),
        content: TextField(key: const Key('rename_project_field'), controller: controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.commonCancel)),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text(l10n.commonSave),
          ),
        ],
      );
    },
  );
}
