#!/usr/bin/env bash
#
# Publish script used inside a circleci workflow.
# Steps:
#   1. create a git tag
#   2. pack the npm module
#   3. create a git release using Github v3 Api
#
#

set -x -u -e -o pipefail

readonly DIST_RELEASE="${PWD}/dist-to-rel"
readonly DIST="${PWD}/dist"

# Publish rel to github
# 1. create npm packed tar.gz
# 2. upload to github using v3 api
function publish_rel() {
    printf "Start publish release flow \n"
    pack_npm_module
    publish_tag
    publish_npm
    printf "Ended publish release flow\n"
}

# Pack the module in npm pack format
function pack_npm_module() {
    printf "Start npm pack flow"
    mkdir -p ${DIST_RELEASE}
    rm -rf ${DIST_RELEASE}/*

    yarn --cwd ${DIST} pack
    mv ${DIST}/*.tgz ${DIST_RELEASE}/
    printf "Ended npm pack flow\n"
}

function publish_tag(){
    printf "Start publish tag flow\n"
    node ${PWD}/scripts/release/publish-rel.js ${DIST_RELEASE}
    printf "Ended publish tag flow\n"
}


function publish_npm(){
    printf "Start publish to npm \n"
    tarball=$(basename $DIST_RELEASE/*.tgz)
    npm publish $DIST_RELEASE/$tarball --access public --tag latest
    printf "Ended publish to npm \n"
}

publish_rel