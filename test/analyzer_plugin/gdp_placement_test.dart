import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:git_dependency_prs/analyzer_plugin/gdp_placement.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';
import 'package:analyzer/src/lint/registry.dart';

@reflectiveTest
class GdpPlacementTest extends AnalysisRuleTest {
  @override
  bool get dumpAstOnFailures => false;

  @override
  String get analysisRule => GdpPlacement.code.name;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(GdpPlacement());
    super.setUp();
  }

  void test_invalid() async {
    await assertPubspecDiagnostics(
      '''
dependencies:
  package:
    git: https://github.com/owner/repo
''',
      [lint(16, 7)],
    );
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(GdpPlacementTest);
  });
}
