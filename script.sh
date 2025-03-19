#!/bin/bash
set -e

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
fi

mkdir -p "${INPUT_OUTPUT_DIR}"
OUTPUT_FILE_NAME="reviewdog-${INPUT_TOOL_NAME}"
if [[ "${INPUT_REPORTER}" == "sarif" ]]; then
  OUTPUT_FILE_NAME="${OUTPUT_FILE_NAME}.sarif"
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo '::group::🐶 Installing rails_best_practices ... https://github.com/flyerhzm/rails_best_practices'
# if 'gemfile' rails_best_practices version selected
if [ "${INPUT_RAILS_BEST_PRACTICES_VERSION}" = "gemfile" ]; then
  # if Gemfile.lock is here
  if [ -f 'Gemfile.lock' ]; then
    # grep for rails_best_practices version
    RAILS_BEST_PRACTICES_GEMFILE_VERSION=$(ruby -ne 'print $& if /^\s{4}rails_best_practices\s\(\K.*(?=\))/' Gemfile.lock)

    # if rails_best_practices version found, then pass it to the gem install
    # left it empty otherwise, so no version will be passed
    if [ -n "$RAILS_BEST_PRACTICES_GEMFILE_VERSION" ]; then
      RAILS_BEST_PRACTICES_VERSION=$RAILS_BEST_PRACTICES_GEMFILE_VERSION
    else
      printf "Cannot get the rails_best_practices's version from Gemfile.lock. The latest version will be installed."
    fi
  else
    printf 'Gemfile.lock not found. The latest version will be installed.'
  fi
else
  # set desired rails_best_practices version
  RAILS_BEST_PRACTICES_VERSION=$INPUT_RAILS_BEST_PRACTICES_VERSION
fi

gem install --no-document rails_best_practices --version "${RAILS_BEST_PRACTICES_VERSION}"
echo '::endgroup::'

echo '::group:: Running rails_best_practices with reviewdog 🐶 ...'
# shellcheck disable=SC2086
rails_best_practices --without-color --silent . ${INPUT_RAILS_BEST_PRACTICES_FLAGS} |
  reviewdog -efm="%f:%l - %m" -efm="%-G%.%#" \
    -name="${INPUT_TOOL_NAME}" \
    -reporter="${INPUT_REPORTER}" \
    -filter-mode="${INPUT_FILTER_MODE}" \
    -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
    -level="${INPUT_LEVEL}" \
    ${INPUT_REVIEWDOG_FLAGS} |
  tee "${INPUT_OUTPUT_DIR}/${OUTPUT_FILE_NAME}"

exit_code=${PIPESTATUS[1]}
echo '::endgroup::'
exit "$exit_code"
