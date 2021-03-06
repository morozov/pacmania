# Disk version of Pac-Mania for ZX Spectrum

The purpose of this repository is to document and automate the process of creating a TR-DOS version of the game [Pac-Mania](http://www.worldofspectrum.org/infoseekid.cgi?id=0003583) which was originally distributed on casettes.

<p align="center">
    <img src="https://raw.githubusercontent.com/morozov/pacmania/master/png/screen.png" width="512" height="384" alt="Pac-Mania">
</p>

## Used tools

1. [zxspectrum-utils](https://sourceforge.net/projects/zxspectrumutils/), [bas2tap](https://github.com/speccyorg/bas2tap), [trd2scl](http://www.worldofspectrum.org/pub/sinclair/tools/generic/trd2scl-1.0.0.tar.gz) for conversion of the files between various formats.
2. [SkoolKit](http://skoolkit.ca/) for loader disassembly.
3. [Fuse](https://sourceforge.net/projects/fuse-emulator/) for debugging and testing.

## Key features

1. The tape loader has been disassembled and rewritten for TR-DOS.
2. The loading screen has been compressed to 50% of its original size.
3. The resulting image is a monoblock (one `*.B` file contains all the data).

## Usage

1. Install [zxspectrum-utils](https://sourceforge.net/projects/zxspectrumutils/), [bas2tap](https://github.com/speccyorg/bas2tap) and [trd2scl](http://www.worldofspectrum.org/pub/sinclair/tools/generic/trd2scl-1.0.0.tar.gz).
2. Run `make`.
3. Use the resulting `Pac-Mania.scl`.
