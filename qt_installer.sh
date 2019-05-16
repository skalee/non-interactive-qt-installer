#!/bin/bash

set -e

echo "Obtaining Qt official distribution"

# https://stackoverflow.com/a/246128/304175
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

QT_INSTALLERS_ROOT_URL="http://download.qt.io/official_releases/online_installers"
QT_INSTALLER_SCRIPT_FILE="${DIR}/control_script.js"

# Download Qt installer
echo "Downloading the online installer"
QT_INSTALLER_URL="${QT_INSTALLERS_ROOT_URL}/${QT_INSTALLER_DOWNLOAD_NAME}"
curl -vL --remote-name "${QT_INSTALLER_URL}"

# Run installer
echo "Installing Qt"
if [ "$(uname -s)" == "Darwin" ]; then
    QT_MOUNT_POINT="/Volumes/Qt"

    echo "Mounting Qt installer image"
    hdiutil attach "${QT_INSTALLER_DOWNLOAD_NAME}" -mountpoint "${QT_MOUNT_POINT}"
    pushd "${QT_MOUNT_POINT}" > /dev/null

    sudo *.app/Contents/MacOS/* --verbose --script "${QT_INSTALLER_SCRIPT_FILE}"

    popd # "${QT_MOUNT_POINT}"
    hdiutil detach "${QT_MOUNT_POINT}"
fi
