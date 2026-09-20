import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:highlight/languages/javascript.dart' as hl_js;
import 'package:highlight/languages/python.dart' as hl_python;
import 'package:highlight/languages/xml.dart' as hl_xml;

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../domain/programming_language.dart';

/// A syntax-highlighted code editor for one [ProgrammingLanguage] (US26),
/// with the gutter/line numbers, code folding, Tab/Shift-Tab indentation
/// and basic word autocomplete that `flutter_code_editor` provides out of
/// the box (US29).
class CodeEditorField extends StatelessWidget {
  const CodeEditorField({super.key, required this.controller});

  final CodeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      clipBehavior: Clip.antiAlias,
      child: CodeTheme(
        data: CodeThemeData(styles: atomOneDarkTheme),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: CodeField(
            controller: controller,
            textStyle: const TextStyle(fontFamily: 'monospace', fontSize: 14),
          ),
        ),
      ),
    );
  }
}

/// The `highlight` package grammar for a [ProgrammingLanguage] — HTML uses
/// the XML grammar, matching highlight.js's own convention (there is no
/// separate "html" mode).
dynamic highlightModeFor(ProgrammingLanguage language) {
  switch (language) {
    case ProgrammingLanguage.python:
      return hl_python.python;
    case ProgrammingLanguage.javascript:
      return hl_js.javascript;
    case ProgrammingLanguage.html:
      return hl_xml.xml;
  }
}
