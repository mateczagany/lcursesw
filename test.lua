#!/usr/bin/env lua53

os.setlocale("en_US.UTF-8", 'ctype')

local assert = assert
local print = print
local table = table
local string = string

local curses = require "curses"
local window = require "curses.window"
local chstr  = require "curses.chstr"

local inspect = require 'inspect'

local function printf (fmt, ...)
  return print (string.format (fmt, ...))
end

local function main ()
  local stdscr = curses.initscr ()

  curses.cbreak ()
  curses.echo (false)
  curses.nl (false)
  curses.curs_set(0)

  stdscr:clear ()

  stdscr:mvaddstr (15, 20, "hello 世界!")

  local cs = chstr "hello world"
  cs:set_ch(1, 'H', curses.A_BOLD, 1)
  cs:set_ch(2, 'e', curses.A_BLINK, 1)
  cs:set_ch(6, ',')
  cs:set_ch(10, '中')
  cs:set_ch(11, utf8.codepoint('文'))
  stdscr:mvaddchstr (0, 0, cs)

  local chs2 = curses.new_chstr('hello 世界!', curses.A_BLINK)
  stdscr:mvaddchstr (1, 0, chs2)

  local chs3 = chs2:dup()
  stdscr:mvaddchstr (2, 0, chs3)

  local cs2 = chstr(5)
  cs2:set_ch(1, 'H', curses.A_BOLD, 1)
  cs2:set_ch(2, 'e', curses.A_BLINK, 1)
  cs2:set_ch(3, ',')
  cs2:set_ch(5, '!', curses.A_NORMAL)
  --cs2:set_ch(6, '!', curses.A_NORMAL) -- error!
  stdscr:mvaddchstr (3, 0, cs2)

  local csi = stdscr:mvwinchnstr(3, 0, 3)
  stdscr:mvaddchstr (4, 1, csi)

  stdscr:move(0, 0)
  local csi2 = stdscr:winchnstr(19)
  csi2:set_ch(15, '!', curses.A_NORMAL)
  stdscr:mvaddchstr (6, 0, csi2)

  --local cs3 = chstr(8, curses.A_BOLD)
  local cs3 = chstr('123中文45678', curses.A_BOLD)

  stdscr:mvaddstr (8, 0, cs3:len() .. ' ' .. cs3:size())

  cs3:set_str(5, '好', curses.A_BLINK, 15)
  cs3:set_ch(2, 'e', curses.A_BLINK, 1)

  stdscr:mvaddchstr (9, 0, cs3)
  stdscr:mvaddstr (10, 0, cs3:len() .. ' ' .. cs3:size())

  stdscr:refresh ()

  stdscr:getch ()

  curses.endwin ()
end

if not arg[1] then
  xpcall(main, function (err)
    curses.endwin ()

    print "Caught an error:"
    print(debug.traceback (err, 2))
    os.exit(2)
  end)
else
  -- init curses constants
  local stdscr = curses.initscr ()
  curses.endwin ()

  local s = "hello 世界"
  local cs = chstr(s, curses.A_BOLD + curses.A_BLINK)
  cs:set_ch(1, 'H', curses.A_BOLD, 1)
  cs:set_ch(2, 'e', curses.A_BLINK, 1)
  cs:set_ch(3, ',')
  cs:set_ch(4, '4', curses.A_NORMAL)
  for i = 1, cs:len() do
    local cp, attr, color = cs:get(i)
    print(i, utf8.char(cp), attr, color)
  end
end
