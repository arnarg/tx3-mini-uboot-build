$(FIP_DIR)/bl30_new.bin.enc: $(CURDIR)/fip $(FIP_DIR)/bl30_new.bin
	$(CURDIR)/fip/gxl/aml_encrypt_gxl --bl3enc --input $(FIP_DIR)/bl30_new.bin

$(FIP_DIR)/bl31.img.enc: $(CURDIR)/fip $(FIP_DIR)/bl31.img
	$(CURDIR)/fip/gxl/aml_encrypt_gxl --bl3enc --input $(FIP_DIR)/bl31.img

$(FIP_DIR)/bl33.bin.enc: $(CURDIR)/fip $(FIP_DIR)/bl33.bin
	$(CURDIR)/fip/gxl/aml_encrypt_gxl --bl3enc --input $(FIP_DIR)/bl33.bin

$(FIP_DIR)/bl2.n.bin.sig: $(CURDIR)/fip $(FIP_DIR)/bl2_new.bin
	$(CURDIR)/fip/gxl/aml_encrypt_gxl --bl2sig --input $(FIP_DIR)/bl2_new.bin \
	--output $(FIP_DIR)/bl2.n.bin.sig

$(FIP_DIR)/u-boot.bin $(FIP_DIR)/u-boot.bin.sd.bin: $(CURDIR)/fip $(FIP_DIR)/bl30_new.bin.enc $(FIP_DIR)/bl31.img.enc $(FIP_DIR)/bl33.bin.enc $(FIP_DIR)/bl2.n.bin.sig
	$(CURDIR)/fip/gxl/aml_encrypt_gxl --bootmk \
	--output $(FIP_DIR)/u-boot.bin \
	--bl2 $(FIP_DIR)/bl2.n.bin.sig \
	--bl30 $(FIP_DIR)/bl30_new.bin.enc \
	--bl31 $(FIP_DIR)/bl31.img.enc \
	--bl33 $(FIP_DIR)/bl33.bin.enc

$(FIP_DIR)/bl2_new.bin: $(CURDIR)/fip $(FIP_DIR)/bl2_acs.bin $(FIP_DIR)/bl21.bin
	$(CURDIR)/fip/blx_fix.sh \
	$(FIP_DIR)/bl2_acs.bin \
	$(FIP_DIR)/zero_tmp \
	$(FIP_DIR)/bl2_zero.bin \
	$(FIP_DIR)/bl21.bin \
	$(FIP_DIR)/bl21_zero.bin \
	$(FIP_DIR)/bl2_new.bin \
	bl2

$(FIP_DIR)/bl2_acs.bin: $(CURDIR)/fip $(FIP_DIR)/bl2.bin $(FIP_DIR)/acs.bin
	python2 $(CURDIR)/fip/acs_tool.pyc \
	$(FIP_DIR)/bl2.bin \
	$(FIP_DIR)/bl2_acs.bin \
	$(FIP_DIR)/acs.bin \
	0

$(FIP_DIR)/bl30_new.bin: $(CURDIR)/fip $(FIP_DIR)/bl30.bin $(FIP_DIR)/bl301.bin
	$(CURDIR)/fip/blx_fix.sh \
	$(FIP_DIR)/bl30.bin \
	$(FIP_DIR)/zero_tmp \
	$(FIP_DIR)/bl30_zero.bin \
	$(FIP_DIR)/bl301.bin \
	$(FIP_DIR)/bl301_zero.bin \
	$(FIP_DIR)/bl30_new.bin \
	bl30

$(FIP_DIR): $(UBOOT_OUTPUT_DIR)/u-boot.bin
	mkdir -p $(FIP_DIR)
$(FIP_DIR)/bl2.bin: $(CURDIR)/fip $(FIP_DIR)
	cp $(CURDIR)/fip/gxl/bl2.bin $(FIP_DIR)/
$(FIP_DIR)/acs.bin: $(CURDIR)/fip $(FIP_DIR)
	cp $(CURDIR)/fip/gxl/acs.bin $(FIP_DIR)/
$(FIP_DIR)/bl21.bin: $(CURDIR)/fip $(FIP_DIR)
	cp $(CURDIR)/fip/gxl/bl21.bin $(FIP_DIR)/
$(FIP_DIR)/bl30.bin: $(CURDIR)/fip $(FIP_DIR)
	cp $(CURDIR)/fip/gxl/bl30.bin $(FIP_DIR)/
$(FIP_DIR)/bl301.bin: $(CURDIR)/fip $(FIP_DIR)
	cp $(CURDIR)/fip/gxl/bl301.bin $(FIP_DIR)/
$(FIP_DIR)/bl31.img: $(CURDIR)/fip $(FIP_DIR)
	cp $(CURDIR)/fip/gxl/bl31.img $(FIP_DIR)/
$(FIP_DIR)/bl33.bin: $(UBOOT_OUTPUT_DIR)/u-boot.bin $(CURDIR)/fip $(FIP_DIR)
	cp $(UBOOT_OUTPUT_DIR)/u-boot.bin $(FIP_DIR)/bl33.bin
