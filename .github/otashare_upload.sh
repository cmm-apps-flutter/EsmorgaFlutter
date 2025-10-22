#!/usr/bin/env bash
set -euo pipefail

# Usage: otashare_upload.sh <file> <name> <versionName> <buildHash> <buildType>
file="$1"
name="$2"
versionName="$3"
buildHash="$4"
buildType="$5"

# Required env vars: OTASHARE_APIKEY, OTASHARE_APIKEY_BUILD, BUIUSER, BUIPASSWORD
if [ -z "${OTASHARE_APIKEY:-}" ] || [ -z "${OTASHARE_APIKEY_BUILD:-}" ] || [ -z "${BUIUSER:-}" ] || [ -z "${BUIPASSWORD:-}" ]; then
  echo "Missing OTASHARE required env vars" >&2
  exit 2
fi

PROJECT_ID=${PROJECT_ID:-2793}
BUILD_NUMBER=${BUILD_NUMBER:-0}

for i in 1 2 3; do
  echo "Attempt $i uploading $file"
  OUT=$(curl -s -w "\n%{http_code}" --max-time 300 -F "buiFile=@${file}" \
    -F "buiName=${name}" \
    -F "buiVersion=${versionName}" \
    -F "buiBuildNum=${BUILD_NUMBER}" \
    -F "buiBuildType=${buildType}" \
    -F "buiTemplate=0" \
    -F "buiHash=${buildHash}" \
    -F "buiVisibleClient=true" \
    -F "buiChangeLog=none" \
    -F "buiUser=${BUIUSER}" -F "buiPassword=${BUIPASSWORD}" \
    "https://otashare-api.mobgen.com/v1/builds/registernewbuild/${PROJECT_ID}/${OTASHARE_APIKEY}/${OTASHARE_APIKEY_BUILD}") || true

  http_code=$(echo "$OUT" | tail -n1)
  body=$(echo "$OUT" | sed '$d')
  echo "upload http_code=$http_code"
  if [ "$http_code" = "200" ] || [ "$http_code" = "201" ]; then
    echo "response=$body" >> "$GITHUB_OUTPUT"
    echo "http_code=$http_code" >> "$GITHUB_OUTPUT"
    url=$(echo "$body" | grep -o 'https://[^\" ]*' || true)
    echo "url=$url" >> "$GITHUB_OUTPUT"
    exit 0
  fi
  echo "Upload failed (code=$http_code), retrying in 5s..."
  sleep 5
done

# All attempts failed
echo "response=$body" >> "$GITHUB_OUTPUT"
echo "http_code=$http_code" >> "$GITHUB_OUTPUT"
url=$(echo "$body" | grep -o 'https://[^\" ]*' || true)
echo "url=$url" >> "$GITHUB_OUTPUT"
echo "Upload failed after retries" >&2
exit 1

