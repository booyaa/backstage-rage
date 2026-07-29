#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <repo-url> <output-dir>" >&2
  exit 1
fi

repo_url=$1
output_dir=$2
chart_dir="helm-charts/hello-k8s"

rm -rf "$output_dir"
mkdir -p "$output_dir"

helm lint "$chart_dir"
helm package "$chart_dir" --destination "$output_dir"
helm repo index "$output_dir" --url "$repo_url"

touch "$output_dir/.nojekyll"