lcursesw
========

this is a fork of [lcurses project][Lcurses] which remove complex build system,
and add wide char support, it current only support for Lua 5.3.

[![License](http://img.shields.io/:license-mit-blue.svg)](http://mit-license.org)

lcurses is a curses binding for [Lua] ~~5.1, 5.2 and~~ 5.3 ~~(including LuaJIT)~~.

lcurses is released under the MIT license, like Lua (see [COPYING];
it's basically the same as the BSD license). There is no warranty.

Unfortunately, there's currently no documentation other than
lcurses.c. It's fairly straightforward, though.

Please report bugs and make suggestions by opening an issue on the
github tracker.

Installation
------------

The simplest way to install lcurses is with [LuaRocks]. To install the
latest release (recommended):

    luarocks install lcurses

To install current git master (for testing):

    luarocks install https://raw.github.com/lcurses/lcurses/release/lcurses-git-1.rockspec

To install without LuaRocks, check out the sources from the
[repository][GitHub] and run the following commands:

    cd lcurses
    ./bootstrap
    ./configure --prefix=INSTALLATION-ROOT-DIRECTORY
    make all check install

Dependencies are listed in the dependencies entry of the file
`rockspec.conf`. You will also need Autoconf and Automake.

See [INSTALL] for `configure` instructions and `configure --help`
for details of available command-line switches.


Bugs reports & patches
----------------------

Bug reports and patches are most welcome. Please use the github issue
tracker (see URL at top). There is no strict coding style, but please
bear in mind the following points when writing new code:

0. Follow existing code. There are a lot of useful patterns and
   avoided traps there.

1. 8-character indentation using TABs in C sources; 2-character
   indentation using SPACEs in Lua sources.


[Lua]: http://www.lua.org/
[GitHub]: https://github.com/DavidFeng/lcursesw
[Lcurses]: https://github.com/lcurses/lcurses
[LuaRocks]: http://www.luarocks.org "Lua package manager"
[LDoc]: https://github.com/stevedonovan/LDoc "Lua documentation generator"
[COPYING]: https://raw.github.com/lcurses/lcurses/release/COPYING
[INSTALL]: https://raw.github.com/lcurses/lcurses/release/INSTALL
