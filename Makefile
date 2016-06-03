# $< first dep
# $^ all dep

SRC = src/curses.c src/include/_helpers.c src/curses/chstr.c src/curses/window.c

INC = -Isrc -Isrc/include

ifdef LUAPATH
	INC += -I$(LUAPATH)
endif

CC = gcc

CFLAGS = -std=c99 -fPIC
CFLAGS += -O2
CFLAGS += -g
CFLAGS += -Wextra #-Wall
CFLAGS += $(INC)

LIB = -lncursesw

.PHONY : clean all doc test

all : curses_c.so

test : curses_c.so inspect.lua
	lua53 test.lua

inspect.lua :
	wget https://raw.githubusercontent.com/kikito/inspect.lua/master/inspect.lua

curses_c.so : $(SRC)
	$(CC) -shared -o $@ $(CFLAGS) $< $(LIB)

doc : doc/index.html

doc/index.html : $(SRC)
	ldoc .

clean :
	rm -f curses_c.so
