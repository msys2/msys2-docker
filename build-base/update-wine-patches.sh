#!/usr/bin/env bash

set -euo pipefail

upstream_tag=wine-11.15
upstream_url=https://gitlab.winehq.org/wine/wine.git
fork_url=https://gitlab.winehq.org/jhol/wine.git
fork_branch=msys2-hacks-25
fork_commit=bdcee9e75bd0d98c0330c47242ae71ce209ef3b0

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
patch_dir="$script_dir/patches"
work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT

git clone --filter=blob:none --no-checkout --branch "$fork_branch" \
    "$fork_url" "$work_dir/wine"
git -C "$work_dir/wine" fetch --filter=blob:none "$upstream_url" \
    "refs/tags/$upstream_tag:refs/tags/$upstream_tag"

mkdir -p "$patch_dir"
rm -f "$patch_dir"/*.patch
git -C "$work_dir/wine" format-patch --output-directory "$patch_dir" \
    "$upstream_tag..$fork_commit"
