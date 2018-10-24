; Multiboot 头布局
;Multiboot头的布局必须如下：
;偏移        类型             域名                   注意
;0           u32              magic                  要求
;4           u32              flags                  要求
;8           u32              checksum               要求
;12          u32              header_addr            如果设置了flags[16]
;16          u32              load_addr              如果设置了flags[16]
;20          u32              load_end_addr          如果设置了flags[16]
;24          u32              bss_end_addr           如果设置了flags[16]
;28          u32              entry_addr             如果设置了flags[16]
;32          u32              mode_type              如果设置了flags[2]
;36          u32              width                  如果设置了flags[2]
;40          u32              height                 如果设置了flags[2]
;44          u32              depth                  如果设置了flags[2]



; Multiboot 魔数,必须等于十六进制的 0x1BADB002

MBOOT_HEADER_MAGIC		equ			0x1BADB002

;flags 
;   flags域指出OS映像需要引导程序提供或支持的特性。0-15位指出需求：如果引导程序发现某些值被设置但出于某种原因不理解或不能不能满足相应的需求，它必须告知用户并宣告引导失败。16-31位指出可选的特性：如果引导程序不能支持某些位，它可以简单的忽略它们并正常引导。自然，所有flags字中尚未定义的位必须被置为0。这样，flags域既可以用于版本控制也可以用于简单的特性选择。 
;如果设置了flags字中的0位，所有的引导模块将按页（4KB）边界对齐。有些操作系统能够在启动时将包含引导模块的页直接映射到一个分页的地址空间，因此需要引导模块是页对齐的。
;   如果设置了flags字中的1位，则必须通过Multiboot信息结构（参见引导信息格式）的mem_*域包括可用内存的信息。如果引导程序能够传递内存分布（mmap_*域）并且它确实存在，则也包括它。
;只关注前两位就行了
;   如果设置了flags字中的2位，有关视频模式表（参见引导信息格式）的信息必须对内核有效。
;   如果设置了flags字中的16位，则Multiboot头中偏移量8-24的域有效，引导程序应该使用它们而不是实际可执行头中的域来计算将OS映象载入到那里。如果内核映象为ELF格式则不必提供这样的信息，但是如果映象是a.out格式或者其他什么格式的话就必须提供这些信息。兼容的引导程序必须既能够载入ELF格式的映象也能载入将载入地址信息嵌入Multiboot头中的映象；它们也可以直接支持其他的可执行格式，例如一个a.out的特殊变体，但这不是必须的。
;

; 1 << 0;左移0位,给第0位设置1, 表示引导模块按照4k对齐
MBOOT_PAGE_ALIGH		equ			1 << 0

; 详解见上
MBOOT_MEME_INFO			equ			1 << 1

MBOOT_HEADER_FLAGS		equ			MBOOT_PAGE_ALIGH | MBOOT_MEME_INFO


;checksum 
;     域checksum是一个32位的无符号值，当与其他的magic域（也就是magic和flags）相加时，结果必须是32位的无符号值0（即magic+ flags + checksum = 0）。


MBOOT_CHECKSUM			equ			-(MBOOT_HEADER_FLAGS + MBOOT_HEADER_MAGIC)

[BITS 32]		;所有代码以32位开始编译

section .text	;代码段

dd MBOOT_HEADER_MAGIC
dd MBOOT_HEADER_FLAGS
dd MBOOT_CHECKSUM

[GLOBAL start]
[GLOBAL glb_mboot_ptr]
[EXTERN kern_entry]

start:
	cli

	mov esp,STACK_TOP
	mov ebp,0
	and esp,0FFFFFFF0H
	mov [glb_mboot_ptr],ebx
	call kern_entry

stop:
	hlt
	jmp stop


section .bss
stack:
	resb 32768
glb_mboot_ptr:
	resb 4

STACK_TOP equ $-stack-1




