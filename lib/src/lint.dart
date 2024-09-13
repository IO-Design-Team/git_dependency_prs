import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:git_dependency_prs/src/git_dependency_reference.dart';

/// GDP lint issues
abstract final class GdpLint {
  /// The dependency is not in dependency_overrides
  static const placement = LintCode(
    name: 'gdp_placement',
    problemMessage: 'Not in dependency_overrides',
  );

  /// The dependency does not specify any PRs
  static const specifyPrs = LintCode(
    name: 'gdp_specify_prs',
    problemMessage: 'No PRs specified',
  );

  /// The dependency does not specify a commit hash
  static const specifyHash = LintCode(
    name: 'gdp_specify_hash',
    problemMessage: 'Ref is missing or not a commit hash',
  );

  static final _commitHashRegex = RegExp(r'^[0-9a-f]{40}$');

  /// Generate lints for a dependency
  static List<GdpLint> fromDependency(GitDependencyReference dependency) {
    final lints = <GdpLint>[];

    final ignorePlacement = dependency.ignore.contains(placement);
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
