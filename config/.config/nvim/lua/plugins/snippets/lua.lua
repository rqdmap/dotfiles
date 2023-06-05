return {
	s({
		trig = "snip",
		name = "create-luasnip-template",
		dscr = [[ 创建一个简单的luasnip模板 ]],
	},{
		t({[[s({]], "\t"}),
		t({"trig = \""}),	i(1, "trig"),			t({"\",", "\t"}),
		t({"name = \""}),	i(2, "trig-name"),		t({"\",", "\t"}),
		t({"dscr = [[ "}),	i(3, "trig-describe"),	t({"", "\t]]", "},", "{", "\t"}),
		i(0, "t(\"Hello World!\"),"),
		t({"", "}),"})
	}),

	s({
		trig = "print",
		name = "print-tables-in-lua",
		dscr = [[ for k, v in pairs(...) do print(k, v) done
		]]
	},
	{
		t({"for k, v in pairs("}), i(1, "table"), t({") do", "\t"}),
		t({"print(k, v)"}), t({"", "end"})
	}),
}
