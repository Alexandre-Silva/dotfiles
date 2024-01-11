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
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

return {
  s("influx_write", {
    unpack(fmta(
      [[
    # TODO: move me to proper place
    INFLUX_URL = os.environ['<>_INFLUX_URL']
    INFLUX_ORG = os.environ['<>_INFLUX_ORG']
    INFLUX_BUCKET = os.environ['<>_INFLUX_BUCKET']
    INFLUX_TOKEN = os.environ['<>_INFLUX_TOKEN']

    root = INFLUX_URL
    url = f'{root}/api/v2/write'
    args = {'org': INFLUX_ORG, 'bucket': INFLUX_BUCKET}

    # TODO: complete me
    lines = [
        'airSensors,sensor_id=TLM0201 temperature=73.97038159354763,humidity=35.23103248356096,co=0.48445310567793615 1630424257000000000',
        'airSensors,sensor_id=TLM0202 temperature=75.30007505999716,humidity=35.651929918691714,co=0.5141876544505826 1630424257000000000',
    ]

    data = '\n'.join(lines).encode("UTF-8")

    resp = requests.post(
        url,
        params=args,
        data=data,
        headers={
            'Authorization': f'Token {INFLUX_TOKEN}',
            "Content-Type": "text/plain; charset=utf-8",
            "Accept": "application/json",
        },
    )

    if not resp:
        print('failed')
]],
      {
        i(1),
        rep(1),
        rep(1),
        rep(1),
      }
    )),
  }),


  s("csv_write", {
    unpack(fmta(
      [[
import csv

# TODO: use proper data
headers = ['a', 'b', 'c']
rows = [
    {'a':1, 'b':1, 'c':1},
    {'a':2, 'b':2, 'c':2},
    {'a':3, 'b':3, 'c':3},
]

with open('<>', 'w') as f:
    writer = csv.DictWriter(f, fieldnames=headers)
    writer.writeheader()
    for row in rows:
        writer.writerow(row)
]],
      {
        i(1),
      }
    )),
  }),

  s("qcompile", {
    t("q.compile(compile_kwargs={\"literal_binds\": True})"),
  }),
}
