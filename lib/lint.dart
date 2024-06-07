import 'package:git_dependency_prs/git_dependency_reference.dart';

/// GDP lint issues
enum GdpLint {
  /// The dependency is not in dependency_overrides
  placement(
    code: 'gdp_placement',
    message: 'Not in dependency_overrides',
  ),

  /// The dependency does not specify any PRs
  specifyPrs(
    code: 'gdp_specify_prs',
    message: 'No PRs specified',
  ),

  /// The dependency does not specify a commit hash
  specifyHash(
    code: 'gdp_specify_hash',
    message: 'Ref is missing or not a commit hash',
  );

  /// Lint code
  final String code;

  /// Lint message
  final String message;

  const GdpLint({required this.code, required this.message});

  static final _commitHashRegex = RegExp(r'^[0-9a-f]{40}$');

  /// Generate lints for a dependency
  static List<GdpLint> fromDependency(GitDependencyReference dependency) {
    final lints = <GdpLint>[];

    final ignorePlacement = dependency.ignore.contains(GdpLint.placement);
    final correctPlacement = dependency.location == 'dependency_overrides';
    if (!ignorePlacement && !correctPlacement) {
      lints.add(GdpLint.placement);
    }

    final ignoreSpecifyPrs = dependency.ignore.contains(GdpLint.specifyPrs);
    final hasPrs = dependency.prs.isNotEmpty;
    if (!ignoreSpecifyPrs && !hasPrs) {
      lints.add(GdpLint.specifyPrs);
    }

    final ignoreSpecifyHash = dependency.ignore.contains(GdpLint.specifyHash);
    final hasHash = _commitHashRegex.hasMatch(dependency.ref ?? '');
    if (!ignoreSpecifyHash && !hasHash) {
      lints.add(GdpLint.specifyHash);
    }

    return lints;
  }

  static final _codeMap = {
    for (final lint in values) lint.code: lint,
  };

  /// Get a lint from its code
  static GdpLint? fromCode(String code) => _codeMap[code];

  @override
  String toString() => '$message ($code)';
}
