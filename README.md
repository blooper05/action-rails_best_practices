# action-rails_best_practices

[![test](https://github.com/blooper05/action-rails_best_practices/workflows/test/badge.svg)](https://github.com/blooper05/action-rails_best_practices/actions?query=workflow%3Atest)
[![reviewdog](https://github.com/blooper05/action-rails_best_practices/workflows/reviewdog/badge.svg)](https://github.com/blooper05/action-rails_best_practices/actions?query=workflow%3Areviewdog)
[![depup](https://github.com/blooper05/action-rails_best_practices/workflows/depup/badge.svg)](https://github.com/blooper05/action-rails_best_practices/actions?query=workflow%3Adepup)
[![release](https://github.com/blooper05/action-rails_best_practices/workflows/release/badge.svg)](https://github.com/blooper05/action-rails_best_practices/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/blooper05/action-rails_best_practices?logo=github&sort=semver)](https://github.com/blooper05/action-rails_best_practices/releases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)

![github-pr-review demo](https://user-images.githubusercontent.com/5299525/171834705-b2517107-e616-4289-8ed9-4e160164701c.png)
![github-pr-check demo](https://user-images.githubusercontent.com/5299525/171834709-130da062-3518-4b28-9a1c-24b58fe686b4.png)

This action runs [rails_best_practices] with [reviewdog] on pull requests to improve
code review experience.

[rails_best_practices]:https://github.com/flyerhzm/rails_best_practices
[reviewdog]:https://github.com/reviewdog/reviewdog

## Input

```yaml
inputs:
  github_token:
    description: GITHUB_TOKEN
    default: ${{ github.token }}
  workdir:
    description: Working directory relative to the root directory.
    default: .
  ### Flags for reviewdog ###
  tool_name:
    description: Tool name to use for reviewdog reporter
    default: rails_best_practices
  level:
    description: Report level for reviewdog [info,warning,error]
    default: error
  reporter:
    description: Reporter of reviewdog command [github-check,github-pr-review,github-pr-check].
    default: github-check
  filter_mode:
    description: |
      Filtering mode for the reviewdog command [added,diff_context,file,nofilter].
      Default is added.
    default: added
  fail_on_error:
    description: |
      Exit code for reviewdog when errors are found [true,false]
      Default is `false`.
    default: 'false'
  reviewdog_flags:
    description: Additional reviewdog flags
    default: ''
  ### Flags for rails_best_practices ###
  rails_best_practices_version:
    description: rails_best_practices version
  rails_best_practices_flags:
    description: |
      rails_best_practices flags (rails_best_practices --without-color --silent . <rails_best_practices_flags>)
    default: ''
```

## Usage

```yaml
name: reviewdog
on: [pull_request]
jobs:
  rails_best_practices:
    name: runner / rails_best_practices
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: blooper05/action-rails_best_practices@v1
        with:
          github_token: ${{ secrets.github_token }}
          # Change reviewdog reporter if you need [github-check,github-pr-review,github-pr-check].
          reporter: github-pr-review
          # Change reporter level if you need.
          # GitHub Status Check won't become failure with warning.
          level: warning
```

## Development

### Release

#### [haya14busa/action-bumpr](https://github.com/haya14busa/action-bumpr)

You can bump version on merging Pull Requests with specific labels (bump:major,bump:minor,bump:patch).
Pushing tag manually by yourself also work.

#### [haya14busa/action-update-semver](https://github.com/haya14busa/action-update-semver)

This action updates major/minor release tags on a tag push.
e.g. Update v1 and v1.2 tag when released v1.2.3.
ref: <https://help.github.com/en/articles/about-actions#versioning-your-action>

### Lint - reviewdog integration

This reviewdog action itself is integrated with reviewdog to run lints
which is useful for [action composition] based actions.

[action composition]:https://docs.github.com/en/actions/creating-actions/creating-a-composite-action

![reviewdog integration](https://user-images.githubusercontent.com/3797062/72735107-7fbb9600-3bde-11ea-8087-12af76e7ee6f.png)

Supported linters:

- [reviewdog/action-shellcheck](https://github.com/reviewdog/action-shellcheck)
- [reviewdog/action-shfmt](https://github.com/reviewdog/action-shfmt)
- [reviewdog/action-actionlint](https://github.com/reviewdog/action-actionlint)
- [reviewdog/action-yamllint](https://github.com/reviewdog/action-yamllint)
- [reviewdog/action-markdownlint](https://github.com/reviewdog/action-markdownlint)
- [reviewdog/action-misspell](https://github.com/reviewdog/action-misspell)
- [reviewdog/action-alex](https://github.com/reviewdog/action-alex)

### Dependencies Update Automation

This repository uses [reviewdog/action-depup] to update reviewdog version.

[reviewdog/action-depup]:https://github.com/reviewdog/action-depup

![reviewdog depup demo](https://user-images.githubusercontent.com/3797062/73154254-170e7500-411a-11ea-8211-912e9de7c936.png)
