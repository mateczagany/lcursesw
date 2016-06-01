

# $< first dep
# $^ all dep

SRC = curses.c include/_helpers.c curses/chstr.c curses/window.c

INC = -Iinclude

ifdef LUAPATH
	INC += -I$(LUAPATH)
endif

CFLAGS = -std=c99 -Wall -fPIC
CFLAGS += $(INC)

LIB = -lncursesw
CC = gcc

all : curses_c.so

curses_c.so : $(SRC)
	$(CC) -shared -o $@ $(CFLAGS) $< $(LIB)

.PHONY: clean all

clean :
	rm -f curses_c.so
