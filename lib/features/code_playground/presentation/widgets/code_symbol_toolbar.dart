import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';

/// A "keyboard adapted to code" (US29): a row of symbols that are painful
/// to reach on a mobile keyboard, inserted at the cursor on tap.
class CodeSymbolToolbar extends StatelessWidget {
  const CodeSymbolToolbar({super.key, required this.controller});

  final CodeController controller;

  static const _symbols = ['  ', '(', ')', '{', '}', '[', ']', '"', "'", ':', ';', '=', '_'];

  void _insert(String symbol) {
    final selection = controller.selection;
    final text = controller.text;
    final start = selection.start < 0 ? text.length : selection.start;
    final end = selection.end < 0 ? text.length : selection.end;
    final newText = text.replaceRange(start, end, symbol);
    controller.value = controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: start + symbol.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _symbols.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          final symbol = _symbols[index];
          return GestureDetector(
            onTap: () => _insert(symbol),
            child: Container(
              width: symbol == '  ' ? 56 : 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadii.chip),
                border: Border.all(color: AppColors.ink, width: 1.5),
              ),
              child: Text(
                symbol == '  ' ? 'Tab' : symbol,
                style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
