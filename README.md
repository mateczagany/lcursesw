lcursesw
========

Forked from [DavidFeng/lcursesw](https://github.com/DavidFeng/lcursesw) and made it compatible with Lua5.1, Lua5.2, Lua5.3 and LuaJIT.

[![License](http://img.shields.io/:license-mit-blue.svg)](http://mit-license.org)

lcurses is a curses binding for [Lua] 5.1, 5.2 and 5.3 (including LuaJIT).

lcurses is released under the MIT license, like Lua (see [COPYING];
it's basically the same as the BSD license). There is no warranty.

Unfortunately, there's currently no documentation other than
lcurses.c. It's fairly straightforward, though.

Please report bugs and make suggestions by opening an issue on the
github tracker.

Installation
------------

You will need Lua headers for the Lua version you wish to build the module for in `/usr/include/$(LUAV)`.  
You can use your package manager to download the headers easily. On Ubuntu:
	
	apt install liblua5.1-dev

You will also need ncursesw library. Easy way to install:

	apt install libncursesw5-dev

Then, to build:

    cd lcursesw
    make test LUAV=lua5.1

Replace `lua5.1` with the Lua version you wish to use. Use `lua5.1` if you wish to use the module with LuaJIT

Bugs reports & patches
----------------------

Please feel free to post any issues/questions in the [GitHub issue tracker](https://github.com/czmate10/lcursesw/issues).


[Lua]: http://www.lua.org/
[COPYING]: https://raw.github.com/lcurses/lcurses/release/COPYING
