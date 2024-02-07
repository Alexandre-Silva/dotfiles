-- imports copy-pasted from https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- local ls = require("luasnip")
-- local s = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
-- local t = ls.text_node
-- local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require("luasnip.util.events")
-- local ai = require("luasnip.nodes.absolute_indexer")
-- local fmt = require("luasnip.extras.fmt").fmt
-- local extras = require("luasnip.extras")
-- local m = extras.m
-- local l = extras.l
-- local rep = extras.rep
-- local postfix = require("luasnip.extras.postfix").postfix

local s = s
local t = t

return {
	s("ifm", {
		t({ 'if __name__ == "__main__":', "    main()" }),
	}),

	s("pt-param", {
		t({ "@pytest.mark.parametrize(" }),
		t({ '"in_,out_"' }),
		t({ "[" }),
		t({ '    ("0x00", b"\\x00")' }),
		t({ '    ("asddsa", b"asddsa")' }),
		t({ "]" }),
	}),
}
