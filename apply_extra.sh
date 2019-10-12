#!/usr/bin/env bash
set -e
FLATPAK_ID="me.bluemail.desktop"

unsquashfs -d bluemail bluemail.snap

desktop_file="export/share/applications/${FLATPAK_ID}.desktop"
install -Dm644 "bluemail/meta/gui/bluemail.desktop" "${desktop_file}"
desktop-file-edit \
    --set-key="Icon" --set-value="${FLATPAK_ID}" \
    --set-key="X-Flatpak-RenamedFrom" --set-value="bluemail.desktop" \
    "${desktop_file}"
install -Dm644 "bluemail/meta/gui/icon.png" "export/share/icons/hicolor/1024x1024/apps/${FLATPAK_ID}.png"

rm bluemail.snap
rm -r bluemail/{meta,etc,lib,usr,var}
