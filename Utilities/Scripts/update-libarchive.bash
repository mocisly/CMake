#!/usr/bin/env bash

set -e
set -x
shopt -s dotglob

readonly name="LibArchive"
readonly ownership="LibArchive Upstream <libarchive-discuss@googlegroups.com>"
readonly subtree="Utilities/cmlibarchive"
readonly repo="https://github.com/libarchive/libarchive.git"
readonly tag="v3.7.9"
readonly shortlog=false
readonly paths="
  CMakeLists.txt
  COPYING
  CTestConfig.cmake
  build/cmake
  build/pkgconfig
  build/utils
  build/version
  libarchive/*.*
"

extract_source () {
    git_archive
    pushd "${extractdir}/${name}-reduced"
    fromdos build/cmake/Find*.cmake
    echo "* -whitespace" > .gitattributes
    echo "" >> libarchive/archive_read_open_file.c
    popd
}

. "${BASH_SOURCE%/*}/update-third-party.bash"
