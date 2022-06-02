#!/bin/sh
set -e

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo '::group::🐶 Installing rails_best_practices ... https://github.com/flyerhzm/rails_best_practices'
gem install --no-document rails_best_practices
echo '::endgroup::'

echo '::group:: Running rails_best_practices with reviewdog 🐶 ...'
# shellcheck disable=SC2086
rails_best_practices --without-color --silent . |
  reviewdog -efm="%f:%l - %m" -efm="%-G%.%#" \
    -name="linter-name (misspell)" \
    -reporter="${INPUT_REPORTER}" \
    -filter-mode="${INPUT_FILTER_MODE}" \
    -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
    -level="${INPUT_LEVEL}" \
    ${INPUT_REVIEWDOG_FLAGS}
exit_code=$?
echo '::endgroup::'
exit $exit_code
