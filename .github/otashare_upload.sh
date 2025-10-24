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

echo "==============================================="
echo "=== OTAShare Upload Debug Info ==="
echo "==============================================="
echo "File: $file"
echo "File size: $(ls -lh "$file" | awk '{print $5}')"
echo "Name: $name"
echo "Version: $versionName"
echo "Build Number: $BUILD_NUMBER"
echo "Build Type: $buildType"
echo "Build Hash: $buildHash"
echo "Project ID: $PROJECT_ID"
echo "API URL: https://otashare-api.mobgen.com/v1/builds/registernewbuild/${PROJECT_ID}/[APIKEY]/[APIKEY_BUILD]"
echo "User: $BUIUSER"
echo "==============================================="

for i in 1 2 3; do
  echo ""
  echo "Attempt $i uploading $file"
  echo "Executing curl command..."

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

  echo "=== Response Details ==="
  echo "HTTP Code: $http_code"
  echo "Response Body:"
  echo "$body"
  echo "======================="
  if [ "$http_code" = "200" ] || [ "$http_code" = "201" ]; then
    echo ""
    echo "✅ Upload successful!"
    echo "response=$body" >> "$GITHUB_OUTPUT"
    echo "http_code=$http_code" >> "$GITHUB_OUTPUT"
    url=$(echo "$body" | grep -o 'https://[^\" ]*' || true)
    if [ -n "$url" ]; then
      echo "Download URL: $url"
      echo "url=$url" >> "$GITHUB_OUTPUT"
    else
      echo "⚠️  Warning: No URL found in response body"
      echo "url=" >> "$GITHUB_OUTPUT"
    fi
    exit 0
  fi
  echo "❌ Upload failed (code=$http_code), retrying in 5s..."
  sleep 5
done

# All attempts failed
echo ""
echo "❌ Upload failed after all retries"
echo "Final HTTP Code: $http_code"
echo "Final Response Body:"
echo "$body"
echo ""
echo "response=$body" >> "$GITHUB_OUTPUT"
echo "http_code=$http_code" >> "$GITHUB_OUTPUT"
url=$(echo "$body" | grep -o 'https://[^\" ]*' || true)
echo "url=$url" >> "$GITHUB_OUTPUT"
exit 1

