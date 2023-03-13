#!/bin/bash

assets_url="https://github.com/${{ github.repository }}/releases/expanded_assets/${{ steps.latesttag.outputs.tag }}"
download_url="https://github.com/$(curl $assets_url | grep "<a href" | grep -oP 'a href="\K.+?(?=" rel)' | grep 'x64_Release' | grep -v '.txt')"
file_name=$(basename $download_url)

sed -i "s#{URL64}#${download_url}#g" "choco/tools/chocolateyinstall.ps1"

checksum_name="$file_name.sha256"
checksum_data=$(curl -qO - "https://github.com/${{ github.repository }}/releases/download/${{ steps.latesttag.outputs.tag }}/${checksum_name}")

sha256=$(echo $checksum_data | cut -d " " -f 1 )
sed -i "s/{SHA256CHECKSUM64}/${sha256:0:64}/g" "choco/tools/chocolateyinstall.ps1"