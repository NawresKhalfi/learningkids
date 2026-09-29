/// Converts the small, beginner-friendly Dart subset used by the mobile
/// projects into JavaScript so it can run in the existing local WebView
/// runtime. It deliberately keeps the editor's source in Dart.
String transpileDartForPlayground(String source) {
  var code = source;
  final classNames = <String>[];

  // Compact data classes used by the supplied mobile templates, e.g.
  // `class Question { const Question(this.prompt); final String prompt; }`.
  code = code.replaceAllMapped(
    RegExp(r'class\s+(\w+)\s*\{\s*(?:const\s+)?\1\(([^)]*)\);[\s\S]*?\}'),
    (match) {
      final className = match.group(1)!;
      classNames.add(className);
      final fields = match
          .group(2)!
          .split(',')
          .map((value) => value.trim().replaceFirst('this.', ''))
          .where((value) => value.isNotEmpty)
          .toList();
      final assignments = fields.map((field) => 'this.$field = $field;').join();
      return 'class $className { constructor(${fields.join(', ')}) { $assignments } }';
    },
  );

  final main = RegExp(
    r'void\s+main\s*\(\s*\)\s*\{([\s\S]*)\}\s*$',
  ).firstMatch(code);
  if (main != null) {
    code = code.replaceRange(main.start, main.end, main.group(1)!);
  }

  for (final className in classNames) {
    code = code.replaceAll('$className(', 'new $className(');
  }

  return code
      .replaceAll('print(', 'console.log(')
      .replaceAllMapped(
        RegExp(r'\btrue\b|\bfalse\b'),
        (match) => match.group(0)!,
      );
}
