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
    final issues = gitDependencies.where((e) => !e.ignore && e.prs.isEmpty);
    if (issues.isNotEmpty) {
      print(redPen('The following git dependencies specify no PRs:'));
      for (final issue in issues) {
        print('- ${redPen('${issue.name} (${issue.location})')}');
      }

      print('''

Link PRs to pubspec.yaml git dependencies to ensure they do not get lost:

dependencies:
  package_name:
    git:
      prs:
        - https://github.com/owner/repo/pull/123
      url: https://github.com/owner/repo

Or ignore this issue if there are no relevant PRs available:

dependencies:
  package_name:
    git:
      prs: ignore
      url: https://github.com/owner/repo''');
      exit(1);
    } else {
      print(greenPen('No issues found'));
    }
  }
}
