import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

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
  ) {}
}
