#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${ROOT_DIR}/build"
DERIVED_DATA_DIR="${BUILD_DIR}/DerivedData"
PAYLOAD_DIR="${BUILD_DIR}/Payload"
APP_PATH="${DERIVED_DATA_DIR}/Build/Products/Release-iphoneos/ChatGPTWeb.app"
IPA_PATH="${BUILD_DIR}/ChatGPTWeb-unsigned.ipa"
ICON_JPG="${ROOT_DIR}/Artwork/UserAppIcon.jpg"
ICON_CROPPED="${BUILD_DIR}/UserAppIcon-cropped.png"
ICON_PNG="${ROOT_DIR}/ChatGPTWeb/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png"

if [[ ! -f "${ICON_JPG}" ]]; then
    echo "User-provided app icon is missing: ${ICON_JPG}" >&2
    exit 1
fi

mkdir -p "${BUILD_DIR}"
# Crop the supplied rounded white canvas in a separate pass, then resize.
sips --cropToHeightWidth 428 428 --cropOffset 42 42 -s format png "${ICON_JPG}" --out "${ICON_CROPPED}" >/dev/null
sips --resampleHeightWidth 1024 1024 "${ICON_CROPPED}" --out "${ICON_PNG}" >/dev/null
test "$(sips -g pixelWidth "${ICON_PNG}" | awk '/pixelWidth/ {print $2}')" = "1024"
test "$(sips -g pixelHeight "${ICON_PNG}" | awk '/pixelHeight/ {print $2}')" = "1024"

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
echo "Unsigned IPA: ${IPA_PATH}"
