Pac-Mania.scl: Pac-Mania.trd
	trd2scl Pac-Mania.trd Pac-Mania.scl

Pac-Mania.trd: boot.$$B p.$$C m.$$C
	createtrd Pac-Mania.trd
	hobeta2trd boot.\$$B Pac-Mania.trd
	hobeta2trd hob/screenz.\$$C Pac-Mania.trd
	hobeta2trd p.\$$C Pac-Mania.trd
	hobeta2trd m.\$$C Pac-Mania.trd

	# Write the correct length to the first file (offset 13)
	# The length is 1 (boot) + 15 (loading screen) + 160 (data) + 24 (music) = 200
	# Got to use the the octal notation since it's the only format of binary data POSIX printf understands
	# https://pubs.opengroup.org/onlinepubs/9699919799/utilities/printf.html#tag_20_94_13
	printf '\310' | dd of=Pac-Mania.trd bs=1 seek=13 conv=notrunc status=none

	# Remove three other files (fill 3×16 bytes starting offset 16 with zeroes)
	dd if=/dev/zero of=Pac-Mania.trd bs=1 seek=16 count=48 conv=notrunc status=none

Pac-Mania.tzx.zip:
	wget http://www.worldofspectrum.org/pub/sinclair/games/p/Pac-Mania.tzx.zip

Pac-Mania.tzx: Pac-Mania.tzx.zip
	unzip -u Pac-Mania.tzx.zip && touch Pac-Mania.tzx

Pac-Mania-Fixed.tzx: Pac-Mania.tzx
	# Remove the 2A block which doesn't contain relevant data and is not
	# supported by tzx2tap. Otherwise, we'll lose the music file.
	# https://www.worldofspectrum.org/TZXformat.html#STOP48K
	(head -c 48501 Pac-Mania.tzx && tail -c +48507 Pac-Mania.tzx) > Pac-Mania-Fixed.tzx

Pac-Mania.tap: Pac-Mania-Fixed.tzx
	tzx2tap Pac-Mania-Fixed.tzx Pac-Mania.tap

p.000 m.000: Pac-Mania.tap
	tapto0 Pac-Mania.tap

p.$$C: p.000
	0tohob p.000

m.$$C: m.000
	0tohob m.000

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
