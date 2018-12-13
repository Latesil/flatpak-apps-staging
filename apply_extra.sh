#!/bin/bash
APP_ID="com.adobe.Reader"

tar -xjf AdbeRdr.tar.bz2 --strip-components=1
tar -xf ILINXR.TAR
tar -xf COMMON.TAR

resource="Adobe/Reader9/Resource"

# App desktop entry
install -Dm644 "$resource/Support/AdobeReader.desktop" "export/share/applications/${APP_ID}.desktop"
desktop-file-edit --remove-key="Caption" \
    "export/share/applications/${APP_ID}.desktop"
desktop-file-edit --set-key="Icon" --set-value="${APP_ID}" \
    "export/share/applications/${APP_ID}.desktop"
desktop-file-edit --set-key="X-Flatpak-RenamedFrom" --set-value="AdobeReader.desktop;" \
    "export/share/applications/${APP_ID}.desktop"

# App icon
icon_sizes=($(ls -1 "$resource/Icons"))
for s in "${icon_sizes[@]}"; do
    install -Dm644 "$resource/Icons/${s}/AdobeReader9.png" "export/share/icons/hicolor/${s}/apps/${APP_ID}.png"
done

# Mimetypes
install -Dm644 "$resource/Support/AdobeReader.xml" "export/share/mime/packages/${APP_ID}.xml"
for m in "pdf" "vnd.fdf" "vnd.adobe.pdx" "vnd.adobe.xdp+xml" "vnd.adobe.xfdf"; do
    if [ "$m" = "pdf" ]; then
        i="adobe.pdf"
    else
        i="$m"
    fi
    sed "s|\(<mime-type type=\"application/${m}\">\)|\1\n    <icon name=\"${APP_ID}-${m}\"/>|g" \
        -i "export/share/mime/packages/${APP_ID}.xml"
    for s in "${icon_sizes[@]}"; do
        install -Dm644 "$resource/Icons/${s}/${i}.png" "export/share/icons/hicolor/${s}/mimetypes/${APP_ID}-${m}.png"
    done
done

# Cleanup
rm AdbeRdr.tar.bz2 ILINXR.TAR COMMON.TAR INSTALL
