include $(THEOS)/makefiles/common.mk
GO_EASY_ON_ME=1

export ARCHS = armv7 arm64 arm64e
export TARGET = iphone:clang:13.1:9.0
SDKVERSION_armv7 = 11.2
APPLICATION_NAME = MobileHeaders


MobileHeaders_FILES = $(wildcard *.m)
MobileHeaders_FRAMEWORKS = UIKit CoreGraphics
MobileHeaders_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall \"MobileHeaders\"" || true
