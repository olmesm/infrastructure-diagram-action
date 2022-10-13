#!/bin/bash -l

DIR_INPUT=${INPUT_INPUT_DIR}
COMMIT_MSG=${INPUT_COMMIT_MESSAGE}
FORCE_REGENERATE=${INPUT_FORCE_REGENERATE}

function debug(){
  if [[ "${INPUT_DEBUG}" = "true" ]]; then
    echo "[DEBUG] $1"
  fi
}

function info(){
  echo "[INFO] $1"
}

function error(){
  echo "[ERROR] $1"
  exit 1
}

debug "Start script"

debug "Start Validation"
# Validation
if [[ ! "${GITHUB_BASE_REF}" ]]; then
  error "This action is only for pull-request events."
fi

if [[ "${INPUT_DISABLE_REVIEW_COMMENT}" != "true" && ! "${INPUT_GITHUB_TOKEN}" ]]; then
  error "Please set inputs.github_token"
fi
debug "End Validation"

debug "Start Generate"
# Generate
git config --global --add safe.directory ${GITHUB_WORKSPACE}
cd ${GITHUB_WORKSPACE}/${DIR_INPUT}

debug "GITHUB_WORKSPACE/DIR_INPUT: ${GITHUB_WORKSPACE}/${DIR_INPUT}"
git fetch -q

SRC_FILES=$(git diff origin/${GITHUB_BASE_REF} --name-only | grep -E "${DIR_INPUT}.*\.(py)$" | sed "s|${DIR_INPUT}/||")

if [[ "${FORCE_REGENERATE}" = "true" ]]; then
  info ${pwd}
  info `find /**/*.py`
  SRC_FILES=$(find ${DIR_INPUT} "*.py" | grep -E "${DIR_INPUT}.*\.(py)$" | sed "s|${DIR_INPUT}/||")
fi

if [[ -z "${SRC_FILES}" && "${FORCE_REGENERATE}" != "true" ]]; then
  info "No changes detected in ${DIR_INPUT}"

  info "Force re-generate all by adding 
  uses: olmesm/infrastructure-diagram-action@v1
  with:
    force_regenerate: true
    ...
    "
fi

if [[ -z "$SRC_FILES" ]]; then
  info "No files found in ${DIR_INPUT}"
fi

debug "SRC_FILES: $SRC_FILES"

for SRC_FILE in ${SRC_FILES}; do
    python "$SRC_FILE"
    info "Processed $DIR_INPUT/$SRC_FILE"
done

debug "End generate"

debug "Start Commit"
# Commit
if [[ ! $(git status --porcelain) ]]; then
  exit 0
fi

git config --global user.name "${INPUT_USER_NAME:-GITHUB_USER_NAME}"
git config --global user.email "${INPUT_USER_EMAIL}"

git checkout "${GITHUB_HEAD_REF}"
git add .
git commit -m "${COMMIT_MSG}"
git push origin HEAD:"${GITHUB_HEAD_REF}"
info "Committed diagrams"

debug "End Commit"

debug "Start Add review comment"
# Add review comment
if [[ "${INPUT_DISABLE_REVIEW_COMMENT}" = "true" ]]; then
  exit 0
fi

git fetch
GITHUB_SHA_AFTER=$(git rev-parse origin/${GITHUB_HEAD_REF})
DIFF_FILES=`git diff ${GITHUB_SHA} ${GITHUB_SHA_AFTER} --name-only | grep -E "${DIR_INPUT}.*\.(png|svg|jpg)$"`
info "$DIFF_FILES"

BODY="## Diagrams changed\n"
for DIFF_FILE in ${DIFF_FILES}; do
  TEMP=`cat << EOS
### [${DIFF_FILE}](https://github.com/${GITHUB_REPOSITORY}/blob/${GITHUB_SHA_AFTER}/${DIFF_FILE})\n
<details><summary>Before</summary>\n
\n
![before](https://github.com/${GITHUB_REPOSITORY}/blob/${GITHUB_SHA}/${DIFF_FILE}?raw=true)\n
\n
</details>\n
\n
![after](https://github.com/${GITHUB_REPOSITORY}/blob/${GITHUB_SHA_AFTER}/${DIFF_FILE}?raw=true)\n
\n
EOS
  `
  BODY=${BODY}${TEMP}
done

BODY=`echo ${BODY} | sed -e "s/\:/\\\:/g"`
PULL_NUM=`echo ${GITHUB_REF} | sed -r "s/refs\/pull\/([0-9]+)\/merge/\1/"`
info "Body: ${BODY}"
info "Pull-num: ${PULL_NUM}"
curl -sS -X POST \
  -H "Content-Type: application/json" \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token ${INPUT_GITHUB_TOKEN}" \
  -d "{\"event\": \"COMMENT\", \"body\": \"${BODY}\"}" \
  "${GITHUB_API_URL}/repos/${GITHUB_REPOSITORY}/pulls/${PULL_NUM}/reviews"
info "Added review comments"

debug "End Add review comment"
debug "End script"
