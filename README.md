Link PRs to git dependencies. Generate update timelines and enforce compliance.

## Installation

```console
$ dart pub global activate git_dependency_prs
```

## Usage

### Print the update timeline

```console
$ git_dependency_prs check
package (dependency_overrides)
- 11 months ago: https://github.com/owner/repository/pull/503 was merged
- 11 months ago: https://github.com/owner/repository/pull/504 was merged
- 10 months ago: https://github.com/owner/repository/pull/511 was closed
- 10 months ago: https://github.com/owner/repository/pull/521 was created
- 10 months ago: https://github.com/owner/repository/pull/522 was created
- 7 months ago: Version 2.2.0 released
- 3 months ago: https://github.com/owner/repository/pull/610 was created
package (dependency_overrides)
- 27 days ago: Version 5.2.4 released
- 7 hours ago: https://github.com/owner/repository/pull/10317 was created
```

### Lint

```console
$ git_dependency_prs lint
The following git dependencies specify no PRs:
- package (dependencies)

The following git dependencies are not in dependency_overrides:
- package (dependencies)
```

This will exit with status code 1 for use in CI

## Ignoring lint issues

```yaml
dependencies:
  package:
    git:
      ignore_lint: true
      url: ...
```

## Troubleshooting

### API rate limit exceeded

If you see this, you need to pass a GitHub token:

```console
$ git_dependency_prs check -t <token>
```

Generate a token here: https://github.com/settings/personal-access-tokens/new