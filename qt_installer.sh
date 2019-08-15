#!/bin/bash

# Public domain via CC0.

set -e

echo "Obtaining Qt official distribution"

# https://stackoverflow.com/a/246128/304175
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

QT_INSTALLERS_ROOT_URL="http://download.qt.io/official_releases/online_installers"
QT_INSTALLER_SCRIPT_FILE="${DIR}/control_script.js"

# Inject definitions to the installer script
inject_vars()
{
    echo "Injecting variables to installer control script"
    cat "${QT_INSTALLER_VARS}" | tee -a "${QT_INSTALLER_SCRIPT_FILE}"
}

# Download Qt installer
download_installer()
{
    echo "Downloading the online installer"
    local QT_INSTALLER_URL="${QT_INSTALLERS_ROOT_URL}/${QT_INSTALLER_DOWNLOAD_NAME}"
    curl -vL --remote-name "${QT_INSTALLER_URL}"
}

install_qt_on_mac()
{
    local QT_MOUNT_POINT="/Volumes/Qt"

    echo "Mounting Qt installer image"
    hdiutil attach "${QT_INSTALLER_DOWNLOAD_NAME}" -mountpoint "${QT_MOUNT_POINT}"
    pushd "${QT_MOUNT_POINT}" > /dev/null

    sudo *.app/Contents/MacOS/* --verbose --script "${QT_INSTALLER_SCRIPT_FILE}"

    popd # "${QT_MOUNT_POINT}"
    hdiutil detach "${QT_MOUNT_POINT}"
}

install_qt_on_linux()
{
    chmod o+x "${DIR}/${QT_INSTALLER_DOWNLOAD_NAME}"
    sudo "${DIR}/${QT_INSTALLER_DOWNLOAD_NAME}" --verbose --script "${QT_INSTALLER_SCRIPT_FILE}"
}

install_qt_on_windows()
{
    "${DIR}/${QT_INSTALLER_DOWNLOAD_NAME}" --verbose --script "${QT_INSTALLER_SCRIPT_FILE}"
}

# Run installer
install_qt()
{
    echo "Installing Qt"

    case "$OSTYPE" in
        darwin*)
            install_qt_on_mac
            ;;
        linux*)
            install_qt_on_linux
            ;;
        msys*)
            install_qt_on_windows
            ;;
    esac
}

inject_vars
download_installer
install_qt
