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

local msg = {
  'hello, world',
  'this is a test, 中文.',
  'three, line text',
  '123456789012345678901234567890',
}

local function print_list(win, list, y, x)
  for i, v in ipairs(list) do
    win:mvaddstr(y, x, list[i])
    y, _ = win:getyx()
    y = y + 1
  end
end

local function main ()
  local stdscr = curses.initscr ()
  curses.echo (false)
  curses.nl (false)
  curses.curs_set(0)
  --curses.cbreak ()
  curses.halfdelay(10)

  stdscr:keypad(true)

  local msg_win = curses.newwin(10, 32, 5, 1)
  msg_win:keypad(true)


  while true do

    stdscr:clear ()
    msg_win:clear ()

    msg_win:box(curses.ACS_VLINE, curses.ACS_HLINE)
    print_list(msg_win, msg, 1, 1)

    stdscr:refresh()
    msg_win:refresh()

    local c = stdscr:getch ()
    if c == nil then
    else
      if 0 <= c and c < 256 then
        local ch = string.char(c):lower()
        if ch == 'q' then
          break
        end
      end
    end
  end

  curses.endwin ()
end

if not arg[1] then
  xpcall(main, function (err)
    if not curses.isendwin() then
      curses.endwin ()
    end

    print "Caught an error:"
    print(debug.traceback (err, 2))
    os.exit(2)
  end)
else
  -- init curses constants
  local stdscr = curses.initscr ()
  curses.endwin ()
end
