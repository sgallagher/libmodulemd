#!/bin/bash

#Exit on failures
set -e

set -x

export LC_ALL="en_US.utf8"

JOB_NAME=${TRAVIS_JOB_NAME:-CentOS 6}

arr=($JOB_NAME)
os_name=${arr[0]:-CentOS}
release=${arr[1]:-6}

# CentOS 7 doesn't have autopep8, so we'll drop the requirement for it
# This implementation will still allow it to occur if autopep8 still shows
# up later.
COMMON_MESON_ARGS="-Dtest_dirty_git=false -Ddeveloper_build=false -Dskip_introspection=true"

pushd /builddir/

# Build the v2 code under GCC and run standard tests
meson --buildtype=debug \
      -Dbuild_api_v1=false \
      -Dbuild_api_v2=true \
      $COMMON_MESON_ARGS \
      travis

set +e
ninja-build -C travis test
ret=$?
if [ $ret != 0 ]; then
    cat travis/meson-logs/testlog.txt
    exit $ret
fi
set -e

popd #builddir
