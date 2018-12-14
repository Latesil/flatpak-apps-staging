#!/usr/bin/env bash
set -x
APP_ID=com.insynchq.Insync

ar x insync.deb
tar -C / -xf data.tar.gz --transform=s,/usr,/app/extra/insync,

install -Dm644 insync/share/applications/insync.desktop "export/share/applications/${APP_ID}.desktop"
install -Dm644 insync/share/applications/insync-helper.desktop "export/share/applications/${APP_ID}-helper.desktop"
desktop-file-edit --set-key="Icon" --set-value="${APP_ID}" "export/share/applications/${APP_ID}.desktop"
desktop-file-edit --set-key="Exec" --set-value="insync start --no-daemon" "export/share/applications/${APP_ID}.desktop"
desktop-file-edit --set-key="X-Flatpak-RenamedFrom" --set-value="insync.desktop" "export/share/applications/${APP_ID}.desktop"
desktop-file-edit --set-key="Exec" --set-value="insync open_gdurl %F" "export/share/applications/${APP_ID}-helper.desktop"
desktop-file-edit --set-key="X-Flatpak-RenamedFrom" --set-value="insync-helper.desktop" "export/share/applications/${APP_ID}-helper.desktop"

install -Dm644 insync/share/icons/hicolor/scalable/apps/insync.svg "export/share/icons/hicolor/scalable/apps/${APP_ID}.svg"

rm insync.deb data.tar.gz control.tar.gz debian-binary
