import 'dart:io';

import 'package:args/command_runner.dart';

import 'command/check.dart';
import 'command/lint.dart';

void main(List<String> arguments) async {
  final runner = CommandRunner(
    'git_dependency_prs',
    'Check on the status git dependency PRs',
  )
    ..addCommand(CheckCommand())
    ..addCommand(LintCommand());

  await runner.run(arguments);

  exit(0);
}
