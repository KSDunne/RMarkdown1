#!/bin/bash -xe

CURRENT_REPO=$(git config --get remote.origin.url)
DOCS_VERSION=$(git describe --tags --always)
CLONE_TMP_DIR=$(mktemp -d)
DOCS_TMP_DIR=$(mktemp -d)
# PUBLISHED_URL=$( echo "$CURRENT_REPO" | sed 's#^git@\(.*\):\(.*\)\.git#https://\1/pages/\2/#' )
CUSTOM_DOMAIN=r.ksdunne.com
# PUBLISHED_URL=$( echo "$CURRENT_REPO" | sed 's#^git@\(.*\):\(.*\)/\(.*\)\.git#https://\2.\1/\3/#' )

# sphinx-build -b html source "${DOCS_TMP_DIR}/build"
# cp -r _site "${DOCS_TMP_DIR}"

git clone --depth=1 "$CURRENT_REPO" "$CLONE_TMP_DIR"
cp -r _site/* "${CLONE_TMP_DIR}/"

cd "${CLONE_TMP_DIR}"
git checkout --orphan tmp_branch_for_docs
# git rm -rf .

# mv "${DOCS_TMP_DIR}/build"/* .
touch .nojekyll
echo "$CUSTOM_DOMAIN" > CNAME
git add --all
git commit --message "documentation built from $DOCS_VERSION"
git push --force origin HEAD:gh-pages

# Clean up
rm -rf "$CLONE_TMP_DIR"
rm -rf "$DOCS_TMP_DIR"

cat <<EOF

Documentation published at:

    https://${CUSTOM_DOMAIN}

EOF
