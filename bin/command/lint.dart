import 'package:args/command_runner.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:git_dependency_prs/src/git_dependency_reference.dart';
import 'package:git_dependency_prs/src/lints.dart';
import 'package:git_dependency_prs/src/pens.dart';
import 'package:git_dependency_prs/src/git_dependencies.dart';

class LintCommand extends Command<int> {
  @override
  final String name = 'lint';

  @override
  final String description = 'Error if any git dependencies have issues';

  LintCommand();

  @override
  int run() {
    final gitDependencies = GitDependencies.fromPubspec();
    if (gitDependencies.isEmpty) {
      print(yellowPen('No git dependencies found'));
      return 0;
    }

    final issues = <GitDependencyReference, List<LintCode>>{};

    for (final dependency in gitDependencies) {
      final lints = GdpLints.fromDependency(dependency);
      if (lints.isNotEmpty) {
        issues[dependency] = lints;
      }
    }

    for (final dependency in issues.keys) {
      print(bluePen('${dependency.name} (${dependency.location})'));
      for (final issue in issues[dependency]!) {
        print('- ${redPen(issue)}');
      }
    }

    if (issues.isEmpty) {
      print(greenPen('No issues found'));
      return 0;
    } else {
      print(
        redPen(
          '\nSee https://pub.dev/packages/git_dependency_prs#ignoring-lint-issues for help',
        ),
      );
      return 1;
    }
  }
}
