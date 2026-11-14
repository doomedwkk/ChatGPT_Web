#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${ROOT_DIR}/build"
DERIVED_DATA_DIR="${BUILD_DIR}/DerivedData"
PAYLOAD_DIR="${BUILD_DIR}/Payload"
APP_PATH="${DERIVED_DATA_DIR}/Build/Products/Release-iphoneos/ChatGPTWeb.app"
IPA_PATH="${BUILD_DIR}/ChatGPTWeb-unsigned.ipa"
ICON_JPG="${ROOT_DIR}/Artwork/UserAppIcon.jpg"
ICON_PNG="${ROOT_DIR}/ChatGPTWeb/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png"

rm -rf "${DERIVED_DATA_DIR}" "${PAYLOAD_DIR}" "${IPA_PATH}"

# Convert the exact user-provided artwork into the 1024x1024 PNG required by the iOS asset catalog.
if [[ ! -f "${ICON_JPG}" ]]; then
    echo "User-provided app icon is missing: ${ICON_JPG}" >&2
    exit 1
fi
sips -s format png -z 1024 1024 "${ICON_JPG}" --out "${ICON_PNG}" >/dev/null

xcodebuild \
    -project "${ROOT_DIR}/ChatGPTWeb.xcodeproj" \
    -scheme ChatGPTWeb \
    -configuration Release \
    -sdk iphoneos \
    -derivedDataPath "${DERIVED_DATA_DIR}" \
    CODE_SIGNING_ALLOWED=NO \
    CODE_SIGNING_REQUIRED=NO \
    clean build

if [[ ! -d "${APP_PATH}" ]]; then
    echo "Build succeeded but the app bundle was not found: ${APP_PATH}" >&2
    exit 1
fi

mkdir -p "${PAYLOAD_DIR}"
cp -R "${APP_PATH}" "${PAYLOAD_DIR}/"
(
    cd "${BUILD_DIR}"
    /usr/bin/zip -qry "${IPA_PATH}" Payload
)
rm -rf "${PAYLOAD_DIR}"

echo "Unsigned IPA: ${IPA_PATH}"
