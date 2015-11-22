BOOTIMG=boot.img
ZIMAGE=zImage
INITRAMFS=initramfs

TOOLS=./tools
TOOLSSRC=$(TOOLS)/src

MKBOOTIMG=$(TOOLS)/mkbootimg
MKINITRAMFS=$(TOOLS)/mkinitramfs
UNMKBOOTIMG=$(TOOLS)/unmkbootimg

MKBOOTIMGARGS= \
	--kernel $(ZIMAGE) \
	--ramdisk $(INITRAMFS).cpio.gz \
	-o $(BOOTIMG) \
	--base 0x0 \
	--kernel_offset 0x00008000 \
	--ramdisk_offset 0x02000000 \
	--second_offset 0x00F00000 \
	--tags_offset 0x01e00000 \
	--cmdline 'console=tty0,115200 fbcon=rotate:1 fbcon=font:VGA8x8 androidboot.hardware=qcom user_debug=30 msm_rtb.filter=0x3b7 ehci-hcd.park=3'

CC=gcc

all: $(BOOTIMG)

$(BOOTIMG): $(INITRAMFS).cpio.gz $(ZIMAGE)
	$(MKBOOTIMG) $(MKBOOTIMGARGS)

$(ZIMAGE):
	cp vendor/$(ZIMAGE) .

$(INITRAMFS).cpio.gz:
	$(MKINITRAMFS) $(INITRAMFS)

tools: $(MKBOOTIMG) $(MKINITRAMFS) unmkbootimg

unmkbootimg: 
	$(CC) -Wall $(TOOLSSRC)/unmkbootimg.c -o $(UNMKBOOTIMG)

clean:
	rm -f $(BOOTIMG)
	rm -f $(INITRAMFS).cpio.gz
	rm -f $(ZIMAGE)
	rm -f $(TOOLS)/unmkbootimg
