#!/bin/bash
set -Eeo pipefail

rsync_options="--perms --times --links  --compress --human-readable --verbose --stats --progress"

# (A trailing slash on the source avoids creating an additional directory level at the destination)
rsync $rsync_options -r --include='personal*' --exclude='*' repo-server:/var/www/arch-package-repo/x86_64/ repo

pushd repo
cp ../*.pkg.tar.zst* .
repo-add --verify --sign personal.db.tar.gz *.pkg.tar.zst
popd

rsync $rsync_options -r repo/ repo-server:/var/www/arch-package-repo/x86_64
