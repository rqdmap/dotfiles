return {
	s({
		trig = "snip",
		name = "simple luasnip template",
		dscr = [[ create simple luasnip template ]]
	},
	fmt([===[
	s("<>", fmt([==[
		<>
	]==], {
		<>
	}, {
		delimiters = "<<>>"
	})),
	]===], {
		i(1, "trig"),
		i(2, "{}"),
		i(3, [[t("Hello, LuaSnip!")]])
	}, {
		delimiters = "<>"
	})),

	s({
		trig = "SNIP",
		name = "full luasnip template",
		dscr = [[ create luasnip template with full name and description ]],
	},
	fmt([===[
	s({
		trig = "<>",
		name = "<>",
		dscr = [==[ <> ]==],
	}, fmt([==[
		<>
	]==], {
		<>
	}, {
		delimiters = "<<>>"
	})),
	]===], {
		i(1, "trig"),
		i(2),
		i(3),
		i(4, "{}"),
		i(5, [[t("Hello, LuaSnip!")]])
	}, {
		delimiters = "<>"
	})),

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
