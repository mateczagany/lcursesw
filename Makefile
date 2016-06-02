

# $< first dep
# $^ all dep

SRC = src/curses.c src/include/_helpers.c src/curses/chstr.c src/curses/window.c

INC = -Isrc -Isrc/include

ifdef LUAPATH
	INC += -I$(LUAPATH)
endif

CC = gcc

CFLAGS = -std=c99 -fPIC
CFLAGS += -Wextra
#CFLAGS += -Wall
CFLAGS += $(INC)

LIB = -lncursesw

.PHONY : clean all

all : curses_c.so

curses_c.so : $(SRC)
	$(CC) -shared -o $@ $(CFLAGS) $< $(LIB)


clean :
	rm -f curses_c.so
