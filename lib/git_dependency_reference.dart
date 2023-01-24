/// A reference to a git dependency
class GitDependencyReference {
  /// The location of the dependency in the pubspec
  final String location;

  /// THe package name
  final String name;

  /// The git reference
  final List<String> prs;

  /// Constructor
  GitDependencyReference(this.location, this.name, this.prs);
}
