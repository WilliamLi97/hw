# Purpose
This repository is a collection of my various RTL implementations of hardware blocks. The inclusion of hardware blocks does not follow any particular pattern; some are things that I find interesting, some are commonly used blocks, some are (apparently) interview questions, and some are simply used as a part of another hardware block. These implementations are meant to serve as a more practical version of note-taking. Descriptions of how these hardware blocks work or how to derive the design are included in the various directories.

# Prerequistites
I do not have access to lincensed tools used in the industry, so everything is deisgned within the limitations of open-source tools. Additionally, all development was done on Linux (Ubuntu), or more specifically, Windows Subsystem for Linux (WSL). The individual packages needed will be detailed below, but if getting started as quickly as possible is desired, the following command includes all the packages I use for this repository:
`sudo apt-get install iverlog gtkwave build-essential`

## Icarus Verilog
These testbenches were created with the intention to use Icarus Verilog as the simulator. Hence, they are fairly basic and verification of the waveforms were done manually. Icarus Verilog can be installed using the following command:
`sudo apt-get install iverilog`

## GTKWave
GTKWave is used to view the `.vcd` (waveform) files:
`sudo apt-get install gtkwave`

## Build-Essential (Make)
For directories containing a testbench, a makefile is included for convenience when compiling. This build-essential package includes various packages required for C and C++ compilation; it includes libc, gcc, g++, make, and more. We are specifically looking for the ability to use the makefiles, so the bare minimum is simply the make package:
`sudo apt-get install make`

However, I do have the build-essential package installed, so if you encounter any issues running the makefiles, please try installing the build-essential package:
`sudo apt-get install build-essential`
