import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:git_dependency_prs/pens.dart';
import 'package:pub_update_checker/pub_update_checker.dart';

import 'command/check.dart';
import 'command/lint.dart';

void main(List<String> arguments) async {
  final newVersion = await PubUpdateChecker.check();
  if (newVersion != null) {
    print(
      yellowPen(
        'There is an update available: $newVersion. Run `dart pub global activate git_dependency_prs` to update.',
      ),
    );
  }

  final runner = CommandRunner<int>(
    'git_dependency_prs',
    'Check on the status git dependency PRs',
  )
    ..addCommand(CheckCommand())
    ..addCommand(LintCommand());

  final code = await runner.run(arguments);
  exit(code ?? 1);
}
