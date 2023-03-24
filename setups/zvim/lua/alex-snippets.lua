local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet


-- Arduino w/ genoa lib

ls.add_snippets('cpp', {
  s("every", {
    unpack(fmt([[
    static time_ms_t {} = 0;
    time_ms_t now = os_timems();
    if (time_is_after(_last, {}, now)) {{
      {} = now;

      {}
    }}
    ]], {
      i(1),
      i(2, "1000"),
      rep(1),
      i(3),
    })),
  }),
})

ls.add_snippets('cpp', {
  s("mem0", {
    unpack(fmt('memset({}, 0, sizeof({}));', {
      i(1),
      rep(1),
    })),
  }),
})
