#!/usr/bin/env bash
# Runs the same steps as .github/workflows/build.yaml (build + test jobs)
# locally, for a single OS/arch, instead of the full CI matrix.
#
# Usage: ./build-local.sh [wrapper] [nfpm] [version]
#   wrapper - DotnetToolWrapper release tag (default: 1.3.0)
#   nfpm    - nFPM release version, no leading 'v' (default: 2.47.0)
#   version - NuGet package version to produce (default: 0.0.0-local)
set -euo pipefail

WRAPPER="${1:-1.3.0}"
NFPM="${2:-2.47.0}"
VERSION="${3:-0.0.0-local}"

cd "$(dirname "$0")"

echo "== Restore Tools =="
dotnet tool restore

echo "== Insert Wrapper =="
wget -q "https://github.com/demaconsulting/DotnetToolWrapper/releases/download/${WRAPPER}/manifest.spdx.json"
wget -q "https://github.com/demaconsulting/DotnetToolWrapper/releases/download/${WRAPPER}/DotnetToolWrapper.zip"
unzip -o DotnetToolWrapper.zip -d DotnetToolWrapper
cp DotnetToolWrapper/net10.0/*.* pack/tools/net10.0/any

echo "== Insert nFPM win-x64 =="
wget -q "https://github.com/goreleaser/nfpm/releases/download/v${NFPM}/nfpm_${NFPM}_Windows_x86_64.zip" -O nfpm-win-x64.zip
mkdir -p nfpm-win-x64
unzip -o nfpm-win-x64.zip -d nfpm-win-x64
mkdir -p pack/win-x64
cp nfpm-win-x64/nfpm.exe pack/win-x64

echo "== Insert nFPM win-arm64 =="
wget -q "https://github.com/goreleaser/nfpm/releases/download/v${NFPM}/nfpm_${NFPM}_Windows_arm64.zip" -O nfpm-win-arm64.zip
mkdir -p nfpm-win-arm64
unzip -o nfpm-win-arm64.zip -d nfpm-win-arm64
mkdir -p pack/win-arm64
cp nfpm-win-arm64/nfpm.exe pack/win-arm64

echo "== Insert nFPM linux-x64 =="
wget -q "https://github.com/goreleaser/nfpm/releases/download/v${NFPM}/nfpm_${NFPM}_Linux_x86_64.tar.gz" -O nfpm-linux-x64.tar.gz
mkdir -p nfpm-linux-x64
tar -xzf nfpm-linux-x64.tar.gz -C nfpm-linux-x64
mkdir -p pack/linux-x64
cp nfpm-linux-x64/nfpm pack/linux-x64
chmod +x pack/linux-x64/nfpm
mkdir -p pack/docs
cp nfpm-linux-x64/LICENSE.md pack/docs

echo "== Insert nFPM linux-arm64 =="
wget -q "https://github.com/goreleaser/nfpm/releases/download/v${NFPM}/nfpm_${NFPM}_Linux_arm64.tar.gz" -O nfpm-linux-arm64.tar.gz
mkdir -p nfpm-linux-arm64
tar -xzf nfpm-linux-arm64.tar.gz -C nfpm-linux-arm64
mkdir -p pack/linux-arm64
cp nfpm-linux-arm64/nfpm pack/linux-arm64
chmod +x pack/linux-arm64/nfpm

echo "== Create Dotnet Tool =="
(
  cd pack
  dotnet pack SamSarette.NfpmTool.csproj -p:Version="${VERSION}" -o .
)

echo "== Test: create test directory =="
rm -rf test-dir
cp -r test/fixtures test-dir

echo "== Test: create tool manifest =="
(
  cd test-dir
  dotnet new tool-manifest
)

echo "== Test: install NfpmTool =="
(
  cd test-dir
  dotnet tool install SamSarette.NfpmTool --add-source ../pack --version "${VERSION}"
)

echo "== Test: run nfpm --help =="
(
  cd test-dir
  dotnet tool run nfpm -- --help
)

echo "== Test: verify nfpm version =="
(
  cd test-dir
  dotnet tool run nfpm -- --version
)

echo "== Test: build deb package from fixture =="
(
  cd test-dir
  dotnet tool run nfpm -- package --config ./nfpm.yaml --target ./selftest.deb --packager deb
  test -s ./selftest.deb
)

echo "== Test: build rpm package from fixture =="
(
  cd test-dir
  dotnet tool run nfpm -- package --config ./nfpm.yaml --target ./selftest.rpm --packager rpm
  test -s ./selftest.rpm
)

echo "All steps completed successfully."
