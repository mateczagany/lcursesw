SRC = src/curses.c src/include/_helpers.c src/curses/chstr.c src/curses/window.c
INC = -Isrc -Isrc/include -I/usr/include/$(LUAV)

CC = gcc
CFLAGS = -std=c99 -fPIC -O2 -g -Wextra $(INC)


.PHONY: check-luav clean all doc test

all: curses_c.so

curses_c.so: $(SRC) checkenv
	$(CC) -shared -o $@ $(CFLAGS) $< -lncursesw

# Docs
doc: doc/index.html

doc/index.html: $(SRC)
	ldoc .

checkenv:
ifndef LUAV
  $(error $$LUAV environment variable not set, please set it to either lua5.1 lua5.2 or lua5.3 (lua5.1 for LuaJIT))
endif

# Test
test: curses_c.so inspect.lua
	$(LUAV) test.lua

inspect.lua:
	@echo "downloading inspect.lua"
	@wget -q https://raw.githubusercontent.com/kikito/inspect.lua/master/inspect.lua

# Clean
clean:
	rm -f curses_c.so inspect.lua
