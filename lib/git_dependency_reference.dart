import 'package:pubspec/pubspec.dart';

/// A reference to a git dependency
class GitDependencyReference {
  /// THe package name
  final String name;

  /// The location of the dependency in the pubspec
  final DependencyLocation location;

  /// The git reference
  final GitReference reference;

  /// Constructor
  GitDependencyReference(this.name, this.location, this.reference);
}

/// The location of a dependency in a pubspec
enum DependencyLocation {
  /// The dependencies section
  dependencies,

  /// The dev_dependencies section
  devDependencies,

  /// The dependency_overrides section
  dependencyOverrides;

  /// The yaml key for this location
  String get yamlKey {
    switch (this) {
      case DependencyLocation.dependencies:
        return 'dependencies';
      case DependencyLocation.devDependencies:
        return 'dev_dependencies';
      case DependencyLocation.dependencyOverrides:
        return 'dependency_overrides';
    }
  }
}
