Pac-Mania.trd: boot.$$B
	createtrd Pac-Mania.trd
	hobeta2trd boot.\$$B Pac-Mania.trd
	hobeta2trd hob/screenz.\$$C Pac-Mania.trd
	hobeta2trd hob/data.\$$C Pac-Mania.trd
	hobeta2trd hob/music.\$$C Pac-Mania.trd

loader.bin: src/loader.asm
	pasmo --bin src/loader.asm loader.bin

boot.stub.bas: src/boot.bas loader.bin
	sed "s/__LOADER__/$(shell head -c $(shell stat --printf="%s" loader.bin) /dev/zero | tr '\0' -)/" src/boot.bas > boot.stub.bas

boot.stub.tap: boot.stub.bas
	bas2tap -sboot.stub boot.stub.bas boot.stub.tap

boot_stu.000: boot.stub.tap
	tapto0 -f boot.stub.tap

boot_stu.bas: boot_stu.000
	0tobin boot_stu.000

boot.bin: boot_stu.bas loader.bin
	cp boot_stu.bas boot.bin
	# 60 is the offset of the loader placeholder in compiled BASIC boot binary
	breplace 60 loader.bin boot.bin

boot.000: boot.bin
	binto0 boot.bin 0 10

boot.$$B: boot.000
	0tohob boot.000

clean:
	rm -f \
		*.000 \
		*.\$$B \
		*.\$$C \
		*.bas \
		*.bin \
		*.scr \
		*.tap \
		*.trd \
		*.tzx \
		*.zip
