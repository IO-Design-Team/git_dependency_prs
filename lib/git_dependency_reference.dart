/// A reference to a git dependency
class GitDependencyReference {
  /// The location of the dependency in the pubspec
  final String location;

  /// THe package name
  final String name;

  /// The git reference
  final List<String> prs;

  /// Whether to ignore issues with this dependency
  final bool ignoreLints;

  /// Constructor
  GitDependencyReference({
    required this.location,
    required this.name,
    required this.prs,
    this.ignoreLints = false,
  });
}
