import 'package:git_dependency_prs/src/git_dependency_reference.dart';
import 'package:git_dependency_prs/src/lints.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

final _span = SourceSpan(SourceLocation(0), SourceLocation(0), '');

void main() {
  group('lint', () {
    test('no issues', () {
      final lints = GdpLints.fromDependency(
        GitDependencyReference(
          location: 'dependency_overrides',
          name: 'foo',
          prs: ['https://github.com/owner/repo/pull/1'],
          ref: '927cdc061cc611d2c4c02633e1d0559b69604029',
          ignore: {},
          span: _span,
        ),
      );
      expect(lints, isEmpty);
    });

    test('all issues', () {
      final lints = GdpLints.fromDependency(
        GitDependencyReference(
          location: 'dependencies',
          name: 'foo',
          prs: [],
          ref: null,
          ignore: {},
          span: _span,
        ),
      );
      expect(lints.length, 3);
      expect(lints, contains(GdpLints.placement));
      expect(lints, contains(GdpLints.specifyPrs));
      expect(lints, contains(GdpLints.specifyHash));
    });

    test('ignore all issues', () {
      final lints = GdpLints.fromDependency(
        GitDependencyReference(
          location: 'dependencies',
          name: 'foo',
          prs: [],
          ref: null,
          ignore: {
            GdpLints.placement,
            GdpLints.specifyPrs,
            GdpLints.specifyHash,
          },
          span: _span,
        ),
      );
      expect(lints, isEmpty);
    });

    test('placement', () {
      final lints = GdpLints.fromDependency(
        GitDependencyReference(
          location: 'dependencies',
          name: 'foo',
          prs: ['https://github.com/owner/repo/pull/1'],
          ref: '927cdc061cc611d2c4c02633e1d0559b69604029',
          ignore: {},
          span: _span,
        ),
      );
      expect(lints.length, 1);
      expect(lints.first, GdpLints.placement);
    });

    test('placement ignore', () {
      final lints = GdpLints.fromDependency(
        GitDependencyReference(
          location: 'dependencies',
          name: 'foo',
          prs: ['https://github.com/owner/repo/pull/1'],
          ref: '927cdc061cc611d2c4c02633e1d0559b69604029',
          ignore: {GdpLints.placement},
          span: _span,
        ),
      );
      expect(lints, isEmpty);
    });

    test('specifyPrs', () {
      final lints = GdpLints.fromDependency(
        GitDependencyReference(
          location: 'dependency_overrides',
          name: 'foo',
          prs: [],
          ref: '927cdc061cc611d2c4c02633e1d0559b69604029',
          ignore: {},
          span: _span,
        ),
      );
      expect(lints.length, 1);
      expect(lints.first, GdpLints.specifyPrs);
    });

    test('specifyPrs ignore', () {
      final lints = GdpLints.fromDependency(
        GitDependencyReference(
          location: 'dependency_overrides',
          name: 'foo',
          prs: [],
          ref: '927cdc061cc611d2c4c02633e1d0559b69604029',
          ignore: {GdpLints.specifyPrs},
          span: _span,
        ),
      );
      expect(lints, isEmpty);
    });

    test('specifyHash missing', () {
      final lints = GdpLints.fromDependency(
        GitDependencyReference(
          location: 'dependency_overrides',
          name: 'foo',
          prs: ['https://github.com/owner/repo/pull/1'],
          ref: null,
          ignore: {},
          span: _span,
        ),
      );
      expect(lints.length, 1);
      expect(lints.first, GdpLints.specifyHash);
    });

    test('specifyHash not a hash', () {
      final lints = GdpLints.fromDependency(
        GitDependencyReference(
          location: 'dependency_overrides',
          name: 'foo',
          prs: ['https://github.com/owner/repo/pull/1'],
          ref: 'not-a-hash',
          ignore: {},
          span: _span,
        ),
      );
      expect(lints.length, 1);
      expect(lints.first, GdpLints.specifyHash);
    });

    test('specifyHash ignore', () {
      final lints = GdpLints.fromDependency(
        GitDependencyReference(
          location: 'dependency_overrides',
          name: 'foo',
          prs: ['https://github.com/owner/repo/pull/1'],
          ref: null,
          ignore: {GdpLints.specifyHash},
          span: _span,
        ),
      );
      expect(lints, isEmpty);
    });
  });
}
