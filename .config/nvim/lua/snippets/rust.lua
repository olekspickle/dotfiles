-- TJ tip: clear snippets before sourcing, so that it cleanly redeclares them
require("luasnip.session.snippet_collection").clear_snippets "rust"

local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
ls.add_snippets("rust", {
    s({
        trig = "#der",
        namr = "Derive",
        dscr = "Derive main traits"
    }, {
            t({"#[derive(Debug, Clone, Default)]"}),
        }),
    s({
        trig = "#ser",
        namr = "Derive",
        dscr = "Derive serde traits"
    }, {
            t({"#[derive(Debug, Clone, Default, Serialize, Deserialize)]"}),
        })
})

