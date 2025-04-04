#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
# SPDX-FileCopyrightText: 2021-2023 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=pipa
VENDOR=xiaomi

# Load extract utilities and do some sanity checks.
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

export TARGET_ENABLE_CHECKELF=true

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

function vendor_imports() {
    cat <<EOF >>"$1"
		"device/xiaomi/pipa",
		"hardware/xiaomi",
		"vendor/qcom/common/vendor/adreno-r",
		"vendor/qcom/common/vendor/display",
		"vendor/qcom/common/vendor/display/4.19",
		"vendor/qcom/common/vendor/media-legacy",
EOF
}

function lib_to_package_fixup_vendor_variants() {
    if [ "$2" != "vendor" ]; then
        return 1
    fi

    case "$1" in
        libOmxCore | \
            libgrallocutils | \
            libwfdaac_vendor)
            ;;
        libmmosal | \
            vendor.display.color@1.0 | \
            vendor.display.color@1.1 | \
            vendor.display.color@1.2 | \
            vendor.display.color@1.3 | \
            vendor.display.color@1.4 | \
            vendor.display.color@1.5 | \
            vendor.display.postproc@1.0 | \
            vendor.qti.hardware.limits@1.0 | \
            vendor.qti.hardware.wifidisplaysession@1.0)
            echo "$1_vendor"
            ;;
        *)
            return 1
            ;;
    esac
}

function lib_to_package_fixup() {
    lib_to_package_fixup_clang_rt_ubsan_standalone "$1" ||
        lib_to_package_fixup_proto_3_9_1 "$1" ||
        lib_to_package_fixup_vendor_variants "$@"
}

# Initialize the helper.
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}"

# Warning headers and guards.
write_headers

write_makefiles "${MY_DIR}/proprietary-files.txt" true

# Finish
write_footers
