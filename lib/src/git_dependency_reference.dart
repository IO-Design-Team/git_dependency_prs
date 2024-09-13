import 'package:custom_lint_builder/custom_lint_builder.dart';

/// A reference to a git dependency
class GitDependencyReference {
  /// The location of the dependency in the pubspec
  final String location;

  /// THe package name
  final String name;

  /// The specified PRs
  final List<String> prs;

  /// The git ref
  final String? ref;

  /// Any ignored lints parsed from comments
  final List<LintCode> ignore;

  /// Constructor
  GitDependencyReference({
    required this.location,
    required this.name,
    required this.prs,
    required this.ref,
    required this.ignore,
  });
}
