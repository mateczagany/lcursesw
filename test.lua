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

  stdscr:mvaddchstr (0, 0, chstr "hello world")

  local chs2 = curses.new_chstr('hello 世界!', curses.A_BLINK)
  stdscr:mvaddchstr (1, 0, chs2)

  stdscr:refresh ()

  stdscr:getch ()

  curses.endwin ()
end


local switch = true

if switch then
  xpcall(main, function (err)
    curses.endwin ()

    print "Caught an error:"
    print(debug.traceback (err, 2))
    os.exit(2)
  end)
else
  local chs1 = curses.new_chstr("hello world", curses.A_BOLD)
  local chs1 = curses.new_chstr("hello world", curses.A_BOLD)
  local mt = debug.getregistry()['curses:chstr']
  print(inspect({chstr, mt}))
end
