import 'package:git_dependency_prs/git_dependency_reference.dart';
import 'package:git_dependency_prs/lint.dart';
import 'package:test/test.dart';

void main() {
  group('lint', () {
    test('no issues', () {
      final lints = GdpLint.fromDependency(
        GitDependencyReference(
          location: 'dependency_overrides',
          name: 'foo',
          prs: ['https://github.com/owner/repo/pull/1'],
          ref: '927cdc061cc611d2c4c02633e1d0559b69604029',
          ignore: [],
        ),
      );
      expect(lints, isEmpty);
    });

    test('all issues', () {
      final lints = GdpLint.fromDependency(
        GitDependencyReference(
          location: 'dependencies',
          name: 'foo',
          prs: [],
          ref: null,
          ignore: [],
        ),
      );
      expect(lints.length, GdpLint.values.length);
      for (final lint in GdpLint.values) {
        expect(lints, contains(lint));
      }
    });

    test('ignore all issues', () {
      final lints = GdpLint.fromDependency(
        GitDependencyReference(
          location: 'dependencies',
          name: 'foo',
          prs: [],
          ref: null,
          ignore: GdpLint.values,
        ),
      );
      expect(lints, isEmpty);
    });

    test('placement', () {
      final lints = GdpLint.fromDependency(
        GitDependencyReference(
          location: 'dependencies',
          name: 'foo',
          prs: ['https://github.com/owner/repo/pull/1'],
          ref: '927cdc061cc611d2c4c02633e1d0559b69604029',
          ignore: [],
        ),
      );
      expect(lints.length, 1);
      expect(lints.first, GdpLint.placement);
    });

    test('placement ignore', () {
      final lints = GdpLint.fromDependency(
        GitDependencyReference(
          location: 'dependencies',
          name: 'foo',
          prs: ['https://github.com/owner/repo/pull/1'],
          ref: '927cdc061cc611d2c4c02633e1d0559b69604029',
          ignore: [GdpLint.placement],
        ),
      );
      expect(lints, isEmpty);
    });

    test('specifyPrs', () {
      final lints = GdpLint.fromDependency(
        GitDependencyReference(
          location: 'dependency_overrides',
          name: 'foo',
          prs: [],
          ref: '927cdc061cc611d2c4c02633e1d0559b69604029',
          ignore: [],
        ),
      );
      expect(lints.length, 1);
      expect(lints.first, GdpLint.specifyPrs);
    });

    test('specifyPrs ignore', () {
      final lints = GdpLint.fromDependency(
        GitDependencyReference(
          location: 'dependency_overrides',
          name: 'foo',
          prs: [],
          ref: '927cdc061cc611d2c4c02633e1d0559b69604029',
          ignore: [GdpLint.specifyPrs],
        ),
      );
      expect(lints, isEmpty);
    });

    test('specifyHash missing', () {
      final lints = GdpLint.fromDependency(
        GitDependencyReference(
          location: 'dependency_overrides',
          name: 'foo',
          prs: ['https://github.com/owner/repo/pull/1'],
          ref: null,
          ignore: [],
        ),
      );
      expect(lints.length, 1);
      expect(lints.first, GdpLint.specifyHash);
    });

    test('specifyHash not a hash', () {
      final lints = GdpLint.fromDependency(
        GitDependencyReference(
          location: 'dependency_overrides',
          name: 'foo',
          prs: ['https://github.com/owner/repo/pull/1'],
          ref: 'not-a-hash',
          ignore: [],
        ),
      );
      expect(lints.length, 1);
      expect(lints.first, GdpLint.specifyHash);
    });

    test('specifyHash ignore', () {
      final lints = GdpLint.fromDependency(
        GitDependencyReference(
          location: 'dependency_overrides',
          name: 'foo',
          prs: ['https://github.com/owner/repo/pull/1'],
          ref: null,
          ignore: [GdpLint.specifyHash],
        ),
      );
      expect(lints, isEmpty);
    });
  });
}
