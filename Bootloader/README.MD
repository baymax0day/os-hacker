
## 命令程序相关

#### qemu

> 使用gdb调试内核

	qemu -boot a -fda bootimg -gdb tcp::1234 -S			;-gdb 即使用gdb调试,1234是监听端口,-S表示挂起gdbserver;然后在gdb中使用 target remote localhost:1234 即可断下内核

#### objdump

#### hexdump
	
#### dgb
