UBOOT_DEFCONFIG ?= tx3-mini_defconfig
UBOOT_DIR ?= u-boot
UBOOT_TAG ?= v2019.10-tx3-mini

RAM_SIZE ?= 2g

TOOLCHAIN ?= aarch64-linux-gnu-

UBOOT_OUTPUT_DIR ?= $(TMP_DIR)/u-boot
OUT_DIR ?= $(CURDIR)/out
TMP_DIR ?= $(CURDIR)/tmp
FIP_DIR ?= $(UBOOT_OUTPUT_DIR)/fip

UBOOT_MAKE ?= make -C $(UBOOT_DIR) KBUILD_OUTPUT=$(UBOOT_OUTPUT_DIR) ARCH=arm CROSS_COMPILE="$(TOOLCHAIN)"

.PHONY: all
all: $(OUT_DIR)/u-boot-$(UBOOT_TAG)-$(RAM_SIZE).bin

$(OUT_DIR)/u-boot-$(UBOOT_TAG)-$(RAM_SIZE).bin: $(OUT_DIR) $(FIP_DIR)/u-boot.bin.sd.bin
	cp $(FIP_DIR)/u-boot.bin.sd.bin $(OUT_DIR)/u-boot-$(UBOOT_TAG)-$(RAM_SIZE).bin

u-boot:
	git clone --branch $(UBOOT_TAG) --single-branch https://github.com/arnarg/u-boot.git $(UBOOT_DIR)

$(UBOOT_OUTPUT_DIR)/u-boot.bin: u-boot
	$(UBOOT_MAKE) $(UBOOT_DEFCONFIG)
	$(UBOOT_MAKE) -j $$(nproc)

$(CURDIR)/fip:
	tar xvf files/gxl-p281-fip-$(RAM_SIZE).tar.gz -C $(CURDIR)

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

$(TMP_DIR):
	mkdir -p $(TMP_DIR)

.PHONY: clean superclean
clean:
	rm -rf out tmp fip

superclean: clean
	rm -rf u-boot

include Makefile.fip.mk
