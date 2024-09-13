import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:git_dependency_prs/src/git_dependency_reference.dart';

/// GDP lint issues
abstract final class GdpLints {
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
  static List<LintCode> fromDependency(GitDependencyReference dependency) {
    final lints = <LintCode>[];

    final ignorePlacement = dependency.ignore.contains(placement);
    final correctPlacement = dependency.location == 'dependency_overrides';
    if (!ignorePlacement && !correctPlacement) {
      lints.add(placement);
    }

    final ignoreSpecifyPrs = dependency.ignore.contains(specifyPrs);
    final hasPrs = dependency.prs.isNotEmpty;
    if (!ignoreSpecifyPrs && !hasPrs) {
      lints.add(specifyPrs);
    }

    final ignoreSpecifyHash = dependency.ignore.contains(specifyHash);
    final hasHash = _commitHashRegex.hasMatch(dependency.ref ?? '');
    if (!ignoreSpecifyHash && !hasHash) {
      lints.add(specifyHash);
    }

    return lints;
  }

  static final _codeMap = {
    placement.name: placement,
    specifyPrs.name: specifyPrs,
    specifyHash.name: specifyHash,
  };

  /// Get a lint from its code
  static LintCode? fromCode(String code) => _codeMap[code];
}
