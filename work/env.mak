ifndef LOCAL
PROFILE_ARCH		:= $(CPU_ARCH)
export TMPDIR		:= /tmp
export TMPETC		:= /etc
ifndef DEBUG
export USRETC		:= /usr/etc
export ETCDIR		:= $(PREFIX)/usr/etc
export BINDIR		:= $(PREFIX)/usr/sbin
export APPDIR		:= $(BINDIR)/rc_app
export SCRDIR		:= $(BINDIR)/scripts
export LIBDIR		:= $(PREFIX)/lib
export MODDIR		:= $(LIBDIR)/modules
export WWWDIR		:= $(PREFIX)/www.eng
else
export USRETC		:= $(RECEIVE_DIR)
export ETCDIR		:= $(PREFIX)
export BINDIR		:= $(PREFIX)
export APPDIR		:= $(PREFIX)
export SCRDIR		:= $(PREFIX)
export LIBDIR		:= $(PREFIX)
export MODDIR		:= $(PREFIX)
export WWWDIR		:= $(PREFIX)
endif
else
PROFILE_ARCH		:= I386
export TMPDIR		:= $(PREFIX)/tmp
export TMPETC		:= $(TMPDIR)/etc
export USRETC		:= $(PREFIX)/usr/etc
export ETCDIR		:= $(TMPDIR)/etc
export BINDIR		:= $(PREFIX)/usr/sbin
export APPDIR		:= $(BINDIR)/rc_app
export SCRDIR		:= $(BINDIR)/scripts
export LIBDIR		:= $(PREFIX)/lib
export MODDIR		:= $(LIBDIR)/modules
export WWWDIR		:= $(PREFIX)/www.eng
endif

export SHARED_DIR 	:= $(SOURCE_PATH)/Source/shared
export KERNEL_DIR 	:= $(SOURCE_PATH)/Source/kernel
export KERNEL_INC 	:= $(KERNEL_DIR)/include
export KERNEL_BIN	:= $(KERNEL_DIR)/../../bin
export KERNEL_SRC 	:= $(KERNEL_DIR)

ifeq ($(PROFILE_ARCH),MIPS)
export ARCH		:= mips
export ARCH_ENDIAN	:= big
export ENDIAN_FLAGS	:= -b
export TOOLCHAIN	:= $(TCHAIN_MIPS_DIR)
export TARGET_NAME	:= $(TARGET_MIPS)
export CROSS		:= $(PREFIX_MIPS)
endif

ifeq ($(PROFILE_ARCH),ARM)
export ARCH		:= arm
export ARCH_ENDIAN	:= little
export ENDIAN_FLAGS	:= -l
export TOOLCHAIN	:= $(TCHAIN_ARM_DIR)
export TARGET_NAME	:= $(TARGET_ARM)
export CROSS		:= $(PREFIX_ARM)
endif

ifeq ($(PROFILE_ARCH),MIPSEL)
export ARCH		:= mips
export ARCH_ENDIAN	:= little
export ENDIAN_FLAGS	:= -l
export TOOLCHAIN	:= $(TCHAIN_MIPSEL_DIR)
export TARGET_NAME	:= $(TARGET_MIPSEL)
export CROSS		:= $(PREFIX_MIPSEL)
endif

ifeq ($(PROFILE_ARCH),I386)
export ARCH		:= i386
export ARCH_ENDIAN	:= little
export ENDIAN_FLAGS	:= -l
export TOOLCHAIN	:= $(TCHAIN_I386_DIR)
export TARGET_NAME	:= $(TARGET_I386)
export CROSS		:= $(PREFIX_I386)
endif

export PATH 		:= $(PATH):$(TOOLCHAIN)
export BUILD_HOST	:= x86_64-unknown-linux-gnu

export CROSS_COMPILE	:= $(CROSS)
export AR		:= $(CROSS)ar
export AS		:= $(CROSS)as
export LD		:= $(CROSS)ld
export CC		:= $(CROSS)gcc
export CXX		:= $(CROSS)g++
export CPP		:= $(CROSS)cpp
export NM		:= $(CROSS)nm
export STRIP		:= $(CROSS)strip
export OBJCOPY		:= $(CROSS)objcopy
export OBJDUMP		:= $(CROSS)objdump
export RANLIB		:= $(CROSS)ranlib
ifndef LOCAL
export SSTRIP		:= $(CROSS)sstrip
else
export SSTRIP		:= $(STRIP)
endif

export STRIPFLAGS 	:= -x -R .note -R .comment -R .version --strip-unneeded

ifeq ($(ARCH),mips)
export CFLAGS 		:= -mips32 -march=mips32 -mtune=mips32 -Wa,-mips32 -G 0 -pipe -funit-at-a-time -fomit-frame-pointer -fno-strict-aliasing -fno-common -mno-shared -mabi=32 -msoft-float
endif

ifeq ($(ARCH),arm)
export CFLAGS 		:= -marm -march=armv7-a -mcpu=cortex-a9 -mtune=cortex-a9 -mfpu=neon-fp16 -pipe -funit-at-a-time -fomit-frame-pointer -ffixed-r8 -fno-common -mno-thumb-interwork -mabi=aapcs-linux -mfloat-abi=soft
#CFLAGS 		+= -mfloat-abi=softfp
endif

ifeq ($(ARCH),i386)
export CFLAGS 		:= -fomit-frame-pointer
endif
