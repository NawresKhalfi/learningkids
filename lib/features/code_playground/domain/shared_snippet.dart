import 'programming_language.dart';

/// A code snippet shared via link/code with a friend or mentor (EP10/US55):
/// a read-only, point-in-time copy of the playground code the owner had at
/// the moment they shared it, stored in a public `sharedSnippets` document
/// rather than under `users/{uid}` so anyone holding the code can read it.
class SharedSnippet {
  const SharedSnippet({
    required this.id,
    required this.ownerUid,
    required this.pseudo,
    required this.language,
    required this.code,
    required this.createdAt,
  });

  final String id;
  final String ownerUid;
  final String pseudo;
  final ProgrammingLanguage language;
  final String code;
  final DateTime createdAt;

  Map<String, dynamic> toMap() => {
    'ownerUid': ownerUid,
    'pseudo': pseudo,
    'language': language.name,
    'code': code,
    'createdAt': createdAt.toIso8601String(),
  };

  static SharedSnippet fromMap(String id, Map<String, dynamic> map) => SharedSnippet(
    id: id,
    ownerUid: map['ownerUid'] as String? ?? '',
    pseudo: map['pseudo'] as String? ?? '',
    language: ProgrammingLanguage.values.firstWhere(
      (language) => language.name == map['language'],
      orElse: () => ProgrammingLanguage.python,
    ),
    code: map['code'] as String? ?? '',
    createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
  );
}
