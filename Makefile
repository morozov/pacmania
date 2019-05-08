Pac-Mania.scl: Pac-Mania.trd
	trd2scl Pac-Mania.trd Pac-Mania.scl

Pac-Mania.trd: boot.$$B p.$$C m.$$C
	# Create a temporary file first in order to make sure the target file
	# gets created only after the entire job has succeeded
	$(eval TMPFILE=$(shell tempfile))

	createtrd $(TMPFILE)
	hobeta2trd boot.\$$B $(TMPFILE)
	hobeta2trd hob/screenz.\$$C $(TMPFILE)
	hobeta2trd p.\$$C $(TMPFILE)
	hobeta2trd m.\$$C $(TMPFILE)

	# Write the correct length to the first file (offset 13)
	# The length is 1 (boot) + 15 (loading screen) + 160 (data) + 24 (music) = 200
	# Got to use the the octal notation since it's the only format of binary data POSIX printf understands
	# https://pubs.opengroup.org/onlinepubs/9699919799/utilities/printf.html#tag_20_94_13
	printf '\310' | dd of=$(TMPFILE) bs=1 seek=13 conv=notrunc status=none

	# Remove three other files (fill 3×16 bytes starting offset 16 with zeroes)
	dd if=/dev/zero of=$(TMPFILE) bs=1 seek=16 count=48 conv=notrunc status=none

	# Rename the temporary file to target name
	mv $(TMPFILE) Pac-Mania.trd

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
	tapto0 -f Pac-Mania.tap

p.$$C: p.000
	0tohob p.000

m.$$C: m.000
	0tohob m.000

loader.bin: src/loader.asm
	pasmo --bin src/loader.asm loader.bin

boot.bas: src/boot.bas loader.bin
	# Replace the __LOADER__ placeholder with the machine codes with bytes represented as {XX}
	sed "s/__LOADER__/$(shell hexdump -e '1/1 "{%02x}"' loader.bin)/" src/boot.bas > boot.bas

boot.tap: boot.bas
	bas2tap -sboot -a10 boot.bas boot.tap

boot.000: boot.tap
	tapto0 -f boot.tap

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
