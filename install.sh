#!/usr/bin/env sh

set -e

BASEDIR="$(cd "$(dirname "$0")" && pwd)"

cd "$BASEDIR"

if [ "$(uname -s)" == "Darwin" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  brew bundle
fi

rake install
