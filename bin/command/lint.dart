import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:git_dependency_prs/pens.dart';
import 'package:git_dependency_prs/util.dart';

class LintCommand extends Command {
  @override
  final String name = 'lint';

  @override
  final String description = 'Error if any git dependencies specify no PRs';

  LintCommand();

  @override
  Future<void> run() async {
    final gitDependencies = await loadGitDependencies();
    final noPrsIssues =
        gitDependencies.where((e) => !e.ignoreLints && e.prs.isEmpty);
    if (noPrsIssues.isNotEmpty) {
      print(redPen('The following git dependencies specify no PRs:'));
      for (final issue in noPrsIssues) {
        print(redPen('- ${issue.name} (${issue.location})'));
      }
    }

    final placementIssues = gitDependencies.where(
      (e) =>
          !e.ignoreLints &&
          ['dependencies', 'dev_dependencies'].contains(e.location),
    );

    if (placementIssues.isNotEmpty) {
      print(
        redPen(
          'The following git dependencies are not in dependency_overrides:',
        ),
      );
      for (final issue in placementIssues) {
        print(redPen('- ${issue.name} (${issue.location})'));
      }
    }

    if (noPrsIssues.isEmpty && placementIssues.isEmpty) {
      print(greenPen('No issues found'));
    } else {
      print(
        redPen(
          'See https://github.com/IO-Design-Team/git_dependency_prs#ignoring-lint-issues for help',
        ),
      );
      exit(1);
    }
  }
}
