# action-rails_best_practices

[![Test](https://github.com/blooper05/action-rails_best_practices/workflows/Test/badge.svg)](https://github.com/blooper05/action-rails_best_practices/actions?query=workflow%3ATest)
[![reviewdog](https://github.com/blooper05/action-rails_best_practices/workflows/reviewdog/badge.svg)](https://github.com/blooper05/action-rails_best_practices/actions?query=workflow%3Areviewdog)
[![depup](https://github.com/blooper05/action-rails_best_practices/workflows/depup/badge.svg)](https://github.com/blooper05/action-rails_best_practices/actions?query=workflow%3Adepup)
[![release](https://github.com/blooper05/action-rails_best_practices/workflows/release/badge.svg)](https://github.com/blooper05/action-rails_best_practices/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/blooper05/action-rails_best_practices?logo=github&sort=semver)](https://github.com/blooper05/action-rails_best_practices/releases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)

![github-pr-review demo](https://user-images.githubusercontent.com/3797062/73162963-4b8e2b00-4132-11ea-9a3f-f9c6f624c79f.png)
![github-pr-check demo](https://user-images.githubusercontent.com/3797062/73163032-70829e00-4132-11ea-8481-f213a37db354.png)

This is a template repository for
[reviewdog](https://github.com/reviewdog/reviewdog) action with release
automation based on [action composition](https://docs.github.com/en/actions/creating-actions/creating-a-composite-action).
Click `Use this template` button to create your reviewdog action :dog:!

If you want to create your own reviewdog action from scratch without using this
template, please check and copy release automation flow.
It's important to manage release workflow and sync reviewdog version for all
reviewdog actions.

This repo contains a sample action to run [misspell](https://github.com/client9/misspell).

## Input

<!-- TODO: update -->
```yaml
inputs:
  github_token:
    description: 'GITHUB_TOKEN'
    default: '${{ github.token }}'
  workdir:
    description: 'Working directory relative to the root directory.'
    default: '.'
  ### Flags for reviewdog ###
  level:
    description: 'Report level for reviewdog [info,warning,error]'
    default: 'error'
  reporter:
    description: 'Reporter of reviewdog command [github-check,github-pr-review,github-pr-check].'
    default: 'github-check'
  filter_mode:
    description: |
      Filtering mode for the reviewdog command [added,diff_context,file,nofilter].
      Default is added.
    default: 'added'
  fail_on_error:
    description: |
      Exit code for reviewdog when errors are found [true,false]
      Default is `false`.
    default: 'false'
  reviewdog_flags:
    description: 'Additional reviewdog flags'
    default: ''
  ### Flags for rails_best_practices ###
  locale:
    description: '-locale flag of misspell. (US/UK)'
    default: ''
```

## Usage

```yaml
name: reviewdog
on: [pull_request]
jobs:
  # TODO: change `linter_name`.
  linter_name:
    name: runner / rails_best_practices
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
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

This action updates major/minor release tags on a tag push. e.g. Update v1 and v1.2 tag when released v1.2.3.
ref: https://help.github.com/en/articles/about-actions#versioning-your-action

### Lint - reviewdog integration

This reviewdog action rails_best_practices itself is integrated with reviewdog to run lints
which is useful for Docker container based actions.

![reviewdog integration](https://user-images.githubusercontent.com/3797062/72735107-7fbb9600-3bde-11ea-8087-12af76e7ee6f.png)

Supported linters:

- [reviewdog/action-shellcheck](https://github.com/reviewdog/action-shellcheck)
- [reviewdog/action-hadolint](https://github.com/reviewdog/action-hadolint)
- [reviewdog/action-misspell](https://github.com/reviewdog/action-misspell)

### Dependencies Update Automation
This repository uses [reviewdog/action-depup](https://github.com/reviewdog/action-depup) to update
reviewdog version.

![reviewdog depup demo](https://user-images.githubusercontent.com/3797062/73154254-170e7500-411a-11ea-8211-912e9de7c936.png)
