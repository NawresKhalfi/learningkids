import '../../code_playground/domain/programming_language.dart';
import '../../learning_path/domain/learning_path.dart';
import 'project_category.dart';

/// A learner's project (EP07), started from a [ProjectTemplate] and then
/// edited freely. Kept separate from the Code Playground's per-language
/// scratch snippets (EP05): a project has its own identity, title and
/// category, and can be published to the learner's portfolio (US39).
class Project {
  const Project({
    required this.id,
    required this.title,
    required this.language,
    required this.category,
    required this.code,
    required this.createdAt,
    this.path,
    this.isPublished = false,
    this.thumbnailBase64,
  });

  final String id;
  final String title;
  final ProgrammingLanguage language;
  final ProjectCategory category;
  final String code;
  final DateTime createdAt;
  final LearningPath? path;

  /// Whether this project appears in the learner's portfolio (US39). A
  /// project can be edited freely while unpublished; publishing does not
  /// by itself make it visible to anyone else — see
  /// `UserProfile.portfolioPublic` (US40).
  final bool isPublished;

  /// A small PNG screenshot of the project's output/preview, base64-encoded
  /// so it can live directly in the Firestore document (US39) — see
  /// `docs/FEATURES.md` for why Firebase Storage wasn't used instead.
  final String? thumbnailBase64;

  Project copyWith({
    String? title,
    ProjectCategory? category,
    String? code,
    bool? isPublished,
    String? thumbnailBase64,
  }) => Project(
    id: id,
    title: title ?? this.title,
    language: language,
    category: category ?? this.category,
    code: code ?? this.code,
    createdAt: createdAt,
    path: path,
    isPublished: isPublished ?? this.isPublished,
    thumbnailBase64: thumbnailBase64 ?? this.thumbnailBase64,
  );

  Map<String, dynamic> toMap() => {
    'title': title,
    'language': language.name,
    'category': category.name,
    'code': code,
    'createdAt': createdAt.toIso8601String(),
    if (path != null) 'path': path!.name,
    'isPublished': isPublished,
    if (thumbnailBase64 != null) 'thumbnailBase64': thumbnailBase64,
  };

  static Project fromMap(String id, Map<String, dynamic> map) => Project(
    id: id,
    title: map['title'] as String? ?? '',
    language: ProgrammingLanguage.values.firstWhere(
      (value) => value.name == map['language'],
      orElse: () => ProgrammingLanguage.python,
    ),
    category: ProjectCategory.values.firstWhere(
      (value) => value.name == map['category'],
      orElse: () => ProjectCategory.tool,
    ),
    code: map['code'] as String? ?? '',
    createdAt:
        DateTime.tryParse(map['createdAt'] as String? ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0),
    path: LearningPath.values
        .where((value) => value.name == map['path'])
        .firstOrNull,
    isPublished: map['isPublished'] as bool? ?? false,
    thumbnailBase64: map['thumbnailBase64'] as String?,
  );
}
