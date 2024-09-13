import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:git_dependency_prs/src/git_dependencies.dart';
import 'package:git_dependency_prs/src/lints.dart';

/// Create the linter plugin
PluginBase createPlugin() => _GdpLinter();

class _GdpLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [GdpLintRule()];
}

class GdpLintRule extends LintRule {
  /// Constructor
  const GdpLintRule()
      : super(code: const LintCode(name: '', problemMessage: ''));

  @override
  List<String> get filesToAnalyze => const ['**.yaml'];

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final gitDependencies =
        GitDependencies.fromString(resolver.source.contents.data);
    if (gitDependencies.isEmpty) return;

    for (final dependency in gitDependencies) {
      final lints = GdpLints.fromDependency(dependency);
      if (lints.isEmpty) continue;

      for (final lint in lints) {
        reporter.reportErrorForSpan(lint, dependency.span);
      }
    }
  }
}
