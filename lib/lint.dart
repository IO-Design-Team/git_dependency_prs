import 'package:git_dependency_prs/git_dependency_reference.dart';

/// GDP lint issues
enum GdpLint {
  /// The dependency is not in dependency_overrides
  placement,

  /// The dependency does not specify any PRs
  specifyPrs;

  /// Generate lints for a dependency
  static List<GdpLint> fromDependency(GitDependencyReference dependency) {
    final lints = <GdpLint>[];
    if (!dependency.ignore.contains(GdpLint.placement) &&
        dependency.location != 'dependency_overrides') {
      lints.add(GdpLint.placement);
    }

    if (!dependency.ignore.contains(GdpLint.specifyPrs) &&
        dependency.prs.isEmpty) {
      lints.add(GdpLint.specifyPrs);
    }

    return lints;
  }

  static final _codeMap = {
    'gdp_placement': GdpLint.placement,
    'gdp_specify_prs': GdpLint.specifyPrs,
  };

  /// Get a lint from its code
  static GdpLint? fromCode(String code) => _codeMap[code];

  /// Lint code
  String get code => _codeMap.entries.firstWhere((e) => e.value == this).key;

  /// Lint message
  String get message {
    switch (this) {
      case GdpLint.placement:
        return 'Not in dependency_overrides';
      case GdpLint.specifyPrs:
        return 'No PRs specified';
    }
  }

  @override
  String toString() => '$message ($code)';
}
