#!/bin/sh
# bump.sh — point the book-mockup formula at a tagged release.
#
# Usage: ./bump.sh VERSION      (for example: ./bump.sh 0.1.1)
#
# Run from the root of the tap repository after pushing tag vVERSION to the
# book-mockup repository. Rewrites the formula's url and sha256 in place.

set -eu

version=${1:?usage: ./bump.sh VERSION (for example 0.1.1)}
formula=Formula/book-mockup.rb

user=$(sed -n 's|.*github\.com/\([^/]*\)/book-mockup/archive.*|\1|p' "$formula")
# The placeholder is split so personalize.sh never rewrites this check.
placeholder=YOUR_GITHUB_""USER
if [ -z "$user" ] || [ "$user" = "$placeholder" ]; then
  echo "bump.sh: run ../personalize.sh with your GitHub user name first" >&2
  exit 1
fi

url="https://github.com/$user/book-mockup/archive/refs/tags/v$version.tar.gz"
sha=$(curl -fsSL "$url" | shasum -a 256 | cut -d ' ' -f 1)

# perl -pi works the same with macOS and GNU tools, unlike sed -i.
perl -pi -e "s|^  url \".*\"|  url \"$url\"|; s|^  sha256 \".*\"|  sha256 \"$sha\"|" \
  "$formula"

echo "book-mockup $version"
echo "  url    $url"
echo "  sha256 $sha"
