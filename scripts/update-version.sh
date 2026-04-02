#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
package_file="${repo_root}/package.nix"

tmp_json="$(mktemp)"
trap 'rm -f "$tmp_json"' EXIT

curl -fsSL "https://api.github.com/repos/bitwarden/clients/releases?per_page=100" > "$tmp_json"

latest_tag="$(
  jq -r '
    map(select(.tag_name | startswith("desktop-v"))) |
    .[0].tag_name
  ' "$tmp_json"
)"

if [[ -z "${latest_tag}" || "${latest_tag}" == "null" ]]; then
  echo "Kon geen desktop release vinden in Bitwarden GitHub releases." >&2
  exit 1
fi

version="${latest_tag#desktop-v}"
asset_name="Bitwarden-${version}-x86_64.AppImage"

asset_json="$(
  jq -r --arg tag "$latest_tag" --arg asset "$asset_name" '
    map(select(.tag_name == $tag)) |
    .[0].assets[] |
    select(.name == $asset) |
    @base64
  ' "$tmp_json"
)"

if [[ -z "${asset_json}" ]]; then
  echo "Kon asset ${asset_name} niet vinden voor ${latest_tag}." >&2
  exit 1
fi

decode() {
  printf '%s' "$1" | base64 -d
}

download_url="$(decode "$asset_json" | jq -r '.browser_download_url')"
digest_hex="$(decode "$asset_json" | jq -r '.digest | sub("^sha256:"; "")')"

if [[ -z "${download_url}" || "${download_url}" == "null" ]]; then
  echo "Release asset heeft geen download URL." >&2
  exit 1
fi

if [[ -z "${digest_hex}" || "${digest_hex}" == "null" ]]; then
  echo "Release asset heeft geen SHA-256 digest in GitHub metadata." >&2
  exit 1
fi

sri_hash="$(nix hash convert --hash-algo sha256 --to sri "${digest_hex}")"

perl -0pi -e 's/version = "[^"]+";/version = "'"${version}"'";/' "$package_file"
perl -0pi -e 's#url = "https://github.com/bitwarden/clients/releases/download/desktop-v\$\{version\}/Bitwarden-\$\{version\}-x86_64\.AppImage";#url = "'"${download_url}"'";#' "$package_file"
perl -0pi -e 's/hash = "sha256-[^"]+";/hash = "'"${sri_hash}"'";/' "$package_file"

echo "Bijgewerkt: ${package_file}"
echo "version=${version}"
echo "url=${download_url}"
echo "hash=${sri_hash}"
