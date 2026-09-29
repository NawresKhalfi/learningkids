import 'programming_language.dart';

/// A plain-language "why" for the most common error types (US28's
/// "explication simplifiée"), on top of the raw interpreter message. `null`
/// when we don't have a canned explanation for that error type — the raw
/// message is still shown either way, this only ever adds context.
String? friendlyErrorExplanation(
  ProgrammingLanguage language,
  String? errorType,
) {
  switch (language) {
    case ProgrammingLanguage.python:
      return switch (errorType) {
        'NameError' =>
          "Tu utilises un nom (variable ou fonction) qui n'a pas été défini avant.",
        'SyntaxError' =>
          "Il y a une erreur d'écriture quelque part : une parenthèse, des deux-points ou une indentation manquante.",
        'IndentationError' =>
          "L'indentation (les espaces au début de la ligne) ne correspond pas à ce qu'attend Python.",
        'TypeError' =>
          "Tu essaies de faire une opération entre deux choses qui ne sont pas compatibles (par exemple additionner un texte et un nombre).",
        'ZeroDivisionError' =>
          "Tu essaies de diviser un nombre par zéro, ce qui n'est pas possible.",
        'IndexError' =>
          "Tu essaies d'accéder à une position qui n'existe pas dans une liste.",
        'KeyError' =>
          "Tu essaies d'accéder à une clé qui n'existe pas dans un dictionnaire.",
        'AttributeError' =>
          "Cet objet ne possède pas cette propriété ou méthode.",
        _ => null,
      };
    case ProgrammingLanguage.javascript:
      return switch (errorType) {
        'ReferenceError' =>
          "Tu utilises une variable qui n'a pas été déclarée avant.",
        'SyntaxError' =>
          "Il y a une erreur d'écriture : une parenthèse, une accolade ou un point-virgule manquant.",
        'TypeError' =>
          "Tu essaies de faire une opération sur une valeur qui n'a pas le bon type.",
        'RangeError' => "Une valeur est en dehors des limites autorisées.",
        _ => null,
      };
    case ProgrammingLanguage.html:
      return null;
    case ProgrammingLanguage.dart:
      return null;
  }
}
