import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/pubspec.dart';
import 'package:analyzer/error/error.dart';

/// Git dependencies should be in dependency_overrides
class GdpPlacement extends AnalysisRule {
  /// gdp_placement
  static const code = LintCode('gdp_placement', 'Not in dependency_overrides');

  /// Constructor
  GdpPlacement() : super(name: code.name, description: code.problemMessage);

  @override
  LintCode get diagnosticCode => code;

  @override
  PubspecVisitor get pubspecVisitor => _Visitor(this);
}

class _Visitor extends PubspecVisitor<void> {
  final AnalysisRule rule;

  _Visitor(this.rule);

  void enforceNotGitDependency(PubspecDependency dependency) {
    final name = dependency.name;
    if (name == null || dependency.git == null) return;

    rule.reportAtPubNode(name);
  }

  @override
  void visitPackageDependency(PubspecDependency dependency) {
    enforceNotGitDependency(dependency);
  }

  @override
  void visitPackageDevDependency(PubspecDependency dependency) {
    enforceNotGitDependency(dependency);
  }

  @override
  void visitPackageName(PubspecEntry name) {
    rule.reportAtPubNode(name.value);
  }
}
