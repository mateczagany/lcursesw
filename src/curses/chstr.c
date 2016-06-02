/* */

/***
Curses attributed string buffers.

An array of characters, plus associated curses attributes and
colors at each position.

Although marginally useful alone, the constants used to set colors
and attributes in `chstr` buffers are not defined until **after**
`curses.initscr ()` has been called.

@classmod curses.chstr
*/

#ifndef LCURSES_CHSTR_C
#define LCURSES_CHSTR_C 1

#include "_helpers.c"


static const char *CHSTR_META = "curses:chstr";


#if 0
typedef struct
{
	unsigned int len;
	chtype str[1];
} chstr;
#define CHSTR_SIZE(len) (sizeof(chstr) + len * sizeof(chtype))

#else
#define chstr chwstr
#define CHSTR_SIZE CHWSTR_SIZE
#endif


typedef struct
{
	unsigned int len; // element num
  unsigned int size; // buffer size
	cchar_t str[1];
} chwstr;
#define CHWSTR_SIZE(len) (sizeof(chwstr) + len * sizeof(cchar_t))


static chwstr *
chwstr_new(const char * str, size_t len, int attr) {
  if (!str || len < 1) return NULL;

  chwstr * cs = malloc(CHWSTR_SIZE(len));
  if (!cs) return NULL;

  cs->size = len;

  int i = 0;

  for (const char * str_end = str + len; str < str_end;) {
    int code;
    str = utf8_decode(str, &code);

    if (str == NULL) return free(cs), NULL; // 参数不是有效的utf8序列

    cs->str[i].attr       = attr;
    cs->str[i].chars[1]   = '\0';
    cs->str[i++].chars[0] = code;
  }

  cs->len = i;

  return cs;
}

static void
delete_chwstr(chwstr * cs) {
  free(cs);
}

static void test() {
  const char * s = "hello world, 你好世界!";

#if 0
  chwstr * cs = chwstr_new(s, strlen(s), 2);
  if (cs) {
    printf("len is %d\n", cs->len);
    for (size_t i = 0; i < cs->len; i++) {
      int c = cs->str[i].chars[0];
      printf("%d : %lc %d \n", i, c, c);
    }
    delete_chwstr(cs);
  }
#endif

}


/* create new chstr object and leave it in the lua stack */
static chstr *
chstr_new(lua_State *L, int len)
{
	chstr *cs;

	if (len < 1)
		return luaL_error(L, "invalid chstr length"), NULL;

	cs = lua_newuserdata(L, CHSTR_SIZE(len));
	luaL_getmetatable(L, CHSTR_META);
	lua_setmetatable(L, -2);
	cs->len = len;
	return cs;
}


/* get chstr from lua (convert if needed) */
static chstr **
checkchstr(lua_State *L, int narg)
{
  chstr **cs = (chstr**)luaL_checkudata(L, narg, CHSTR_META);
  if (!cs)
    luaL_argerror(L, narg, "bad curses chstr");

  return cs;
}


/***
Change the contents of the chstr.
@function set_str
@int o offset to start of change
@string s characters to insert into *cs* at *o*
@int[opt=A_NORMAL] attr attributes for changed elements
@int[opt=1] rep repeat count
@usage
  cs = curses.chstr (10)
  cs:set_str(0, "0123456789", curses.A_BOLD)
*/
static int
Cset_str(lua_State *L)
{
	chstr *cs = *checkchstr(L, 1);
  // TODO
	return 0;
}


/***
Set a character in the buffer.
*ch* can be a one-character string, or an integer from `string.byte`
@function set_ch
@int o offset to start of change
@param int|string ch character to insert
@int[opt=A_NORMAL] attr attributes for changed elements
@int[opt=1] rep repeat count
@usage
  -- Write a bold 'A' followed by normal 'a' chars to a new buffer
  size = 10
  cs = curses.chstr (size)
  cs:set_ch(0, 'A', curses.A_BOLD)
  cs:set_ch(1, 'a', curses.A_NORMAL, size - 1)
*/
static int
Cset_ch(lua_State *L)
{
	chstr* cs = *checkchstr(L, 1);
	int offset = checkint(L, 2);
	chtype ch = checkch(L, 3); // codepoint
	int attr = optint(L, 4, A_NORMAL);
	int rep = optint(L, 5, 1);
  // TODO

	return 0;
}


/***
Get information from the chstr.
@function get
@int o offset from start of *cs*
@treturn int character at offset *o* in *cs*
@treturn int bitwise-OR of attributes at offset *o* in *cs*
@treturn int colorpair at offset *o* in *cs*
@usage
  cs = curses.chstr (10)
  cs:set_ch(0, 'A', curses.A_BOLD, 10)
  --> 65 2097152 0
  print (cs:get (9))
*/
static int
Cget(lua_State *L)
{
	chstr* cs = *checkchstr(L, 1);
	int offset = checkint(L, 2);
	chtype ch;

	if (offset < 0 || offset >= (int) cs->len)
		return 0;

  // TODO

	lua_pushinteger(L, 0);
	lua_pushinteger(L, 0);
	lua_pushinteger(L, 0);
	return 3;
}


/***
Retrieve chstr length.
@function len
@tparam chstr cs buffer to act on
@treturn int length of *cs*
@usage
  cs = curses.chstr ('hi,世界')
  --> 5
  print (cs:len ())
*/
static int
Clen(lua_State *L)
{
	chstr *cs = *checkchstr(L, 1);
	return pushintresult(cs->len);
}

/***
Retrieve chstr size.
@function size
@tparam chstr cs buffer to act on
@treturn int size of *cs*
@usage
  cs = curses.chstr ('hi,世界')
  --> 9
  print (cs:len ())
*/
static int
Csize(lua_State *L)
{
	chstr *cs = *checkchstr(L, 1);
	return pushintresult(cs->size);
}


/***
Duplicate chstr.
@function dup
@treturn chstr duplicate of *cs*
@usage
  dup = cs:dup ()
*/
static int
Cdup(lua_State *L)
{
  chstr **cs = checkchstr(L, 1);
  chstr ** ncs = lua_newuserdata(L, sizeof(chstr *));

  size_t rlen = (*cs)->len;

  *ncs = malloc(CHWSTR_SIZE(rlen));
  if (!*ncs)
    luaL_error(L, "malloc failed for chstr:dup");

  memcpy(*ncs, *cs, CHWSTR_SIZE(rlen));

  (*ncs)->size = rlen;

  luaL_getmetatable(L, CHSTR_META);
  lua_setmetatable(L, -2);
  return 1;
}


/***
Initialise a new chstr.
@function __call
@int len buffer length
@treturn chstr a new chstr filled with spaces
@usage
  cs = curses.chstr (10)
*/
static int
C__call(lua_State *L)
{
	int len = checkint(L, 2);
	chstr* ncs = chstr_new(L, len);
	memset(ncs->str, ' ', len * sizeof(chtype));
	return 1;
}


static const luaL_Reg curses_chstr_fns[] =
{
	LCURSES_FUNC( Clen		),
	LCURSES_FUNC( Csize		),
	LCURSES_FUNC( Cset_ch		),
	LCURSES_FUNC( Cset_str		),
	LCURSES_FUNC( Cget		),
	LCURSES_FUNC( Cdup		),
	{ NULL, NULL }
};



LUALIB_API int
luaopen_curses_chstr(lua_State *L)
{
	int t, mt;

	luaL_newlib(L, curses_chstr_fns);
	t = lua_gettop(L);

	lua_createtable(L, 0, 1);		/* u = {} */
	lua_pushcfunction(L, C__call);
	lua_setfield(L, -2, "__call");		/* u.__call = C__call */
	lua_setmetatable(L, -2);		/* setmetatable (t, u) */

	luaL_newmetatable(L, CHSTR_META);
	mt = lua_gettop(L);

	lua_pushvalue(L, mt);
	lua_setfield(L, -2, "__index");		/* mt.__index = mt */
	lua_pushliteral(L, "CursesChstr");
	lua_setfield(L, -2, "_type");		/* mt._type = "CursesChstr" */

	/* for k,v in pairs(t) do mt[k]=v end */
	for (lua_pushnil(L); lua_next(L, t) != 0;)
		lua_setfield(L, mt, lua_tostring(L, -2));

	lua_pop(L, 1);				/* pop mt */

	/* t.version = "curses.chstr..." */
	lua_pushliteral(L, "curses.chstr for " LUA_VERSION " / " PACKAGE_STRING);
	lua_setfield(L, t, "version");

	return 1;
}

#endif /*!LCURSES_CHSTR_C*/
