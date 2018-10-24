ASM = nasm
QEMU = qemu
LD = ld86

all: bootimg

bootimg: bootloader.s
	$(ASM) -o $@ $<
	#$(LD) -0 -s -o $@ boot.o

run: bootimg
	$(QEMU) -boot a -fda $<

debug: bootimg  
	$(QEMU) -boot a -hda $< -gdb tcp::1234 -S


clean:
	rm -rf *.o bootimg
