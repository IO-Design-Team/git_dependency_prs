import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:git_dependency_prs/git_dependency_reference.dart';
import 'package:git_dependency_prs/pens.dart';

class LintCommand extends Command {
  @override
  final String name = 'lint';

  @override
  final String description = 'Error if any git dependencies specify no PRs';

  final Iterable<GitDependencyReference> gitDependencies;

  LintCommand(this.gitDependencies);

  @override
  Future<void> run() async {
    final issues = gitDependencies.where((e) => !e.ignore && e.prs.isEmpty);
    if (issues.isNotEmpty) {
      print(redPen('The following git dependencies specify no PRs:'));
      for (final issue in issues) {
        print('- ${redPen('${issue.name} (${issue.location})')}');
      }
      exit(1);
    } else {
      print(greenPen('No issues found'));
    }
  }
}
