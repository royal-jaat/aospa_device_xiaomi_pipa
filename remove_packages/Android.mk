#
# Copyright (C) 2023 Paranoid Android
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := RemovePackages
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_OVERRIDES_PACKAGES := \
   CarrierServices \
   com.google.android.dialer.support \
   Contacts \
   Dialer \
   Drive \
   GoogleCameraGo \
   GoogleContacts \
   GoogleDialer \
   Maps \
   Messages \
   messaging \
   Mms \
   PersonalSafety \
   TeleService
LOCAL_UNINSTALLABLE_MODULE := true
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_SRC_FILES := /dev/null
include $(BUILD_PREBUILT)
