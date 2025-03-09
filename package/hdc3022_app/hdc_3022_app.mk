# package/hdc3022_app/hdc_3022_app.mk

HDC3022_APP_VERSION = 0.1
HDC3022_APP_SITE =  # Leave empty if the source is local
HDC3022_APP_LICENSE = GPL-2.0-or-later  # Example license
HDC3022_APP_LICENSE_FILES =  # Leave empty if no separate license file
HDC3022_APP_INSTALL_TARGET = YES

define HDC3022_APP_BUILD_CMDS
    $(TARGET_CC) $(TARGET_CFLAGS) -o $(@D)/hdc3022_app $(@D)/main.c $(TARGET_LDFLAGS)
endef

define HDC3022_APP_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/hdc3022_app $(TARGET_DIR)/usr/bin/hdc3022_app
endef

$(eval $(generic-package))
