# GSFORTH (ROM)
Generic Subroutine Thread FORTH for the BBC Micro
=================================================

This was my first large assembly program. I wrote it the summer of 1983 (at the age of 16)

The origional program is written in BBC BASIC using the build-in assembler. Because the source has to be in memory to assemble, this limits the maximum size of any assembly program built using BBC BASIC. As work around I split the code into modules each chain-loaded as overlays.

This new version is the modern re-work of that original code. My ambition all those years ago was to turn my forth into a rom image, sadly I never achieved this at the time. My hope now, is that this project will achieve that goal.

Quick Start Guide
=================

GSForth uses a block file system similar to Acornsoft FORTH and FIG FORTH. You are however, able to break your block storage into separate files.

To create a new block file called TEST with 8 blocks:

**8 create-screens TEST**

To open a block file and start using it:

**use TEST**

To close the current block file:

**disuse**

To see the block file cache:

**.buffers**

To see how much memory you have free:

**.freemem**

To load from block 0 in another block file, while keeping position the current block file:
(you can nest loadusing as much as you like)

**0 loadusing TEST**

To execute a BBC Micro Star Command:

**os' \*cat'**

