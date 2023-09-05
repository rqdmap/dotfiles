return {
	s({
		trig = "enc",
		name = "Encript-with-hugo-shortcode",
		dscr = [[ 文档加密
		]]
	},
	{
		t({[[<!--more-->]], [[{{% hugo-encryptor "]]}),
		i(1, "change_this_to_actual_P@ssW0rd"),
		t({[[" %}}]], ""}),
		i(2),
		t({"", [[{{% /hugo-encryptor %}}]]})
	}),

	s({
		trig = "code",
		name = "Import code file",
		dscr = [[ 引入外部代码
		]]
	},
	{
		t("```"), i(3, "c"),
		f(function(args, snip)
			local start = string.match(args[1][1], "^(%d+)")
			if(start ~= nil) then
				return "{linenostart=" .. start .. "}"
			end

		end, {2}),
		t({"", "{{% code file="}), i(1, "path/to/file"),
		t(" line="), i(2, "-1,-1"),
		t({" %}}", "```", ""})
	}),

	-- s({
	-- 	trig = "fig",
	-- 	name = "figure",
	-- 	dscr = [[ 以HTML格式居中图片
	-- 	]]
	-- },
	-- {
	-- 	t({[[<div align="center">]], ""}),
	-- 	t([[<img src=./images/]]), i(1, "path-to-image"), t([[ style="width:]]),
	-- 	i(2, "100"), t([[%; max-width:]]),
	-- 	i(3, "600"), t([[px;">]]),
	-- 	t({"",  [[</div>]], ""}),
	-- }),


	s("fig", fmt([==[
		<div align="center">
		<img src=./images/{} style="width:{}%; max-width:{}px;">
		<div class="img-caption">{}</div>
		</div>

	]==], {
		i(1), i(2, "100"), i(3, "600"), i(4, "")
	}, {
		delimiters = "{}"
	})),

	s("svg", fmt([==[
		<div align="center">
		<object data=./images/{} type="image/svg+xml" style="width:{}%; max-width:{}px;"></object>
		<div class="img-caption">{}</div>
		</div>

	]==], {
		i(1), i(2, "100"), i(3, "600"), i(4, "")
	}, {
		delimiters = "{}"
	})),

	s({
		trig = "more",
		name = "HTML more",
		dscr = [[ Expand to HTML more
		]]
	},
	{
		t({[[<!--more-->]], ""})
	}),	

	s({
		trig = "`",
		name = "code-block-default",
		dscr = [[ 
		Default Language is C.
		]]
	},
	{
		t({[[```c]] , ""}),
		i(1, "Insert your code here"),
		t({"", [[```]], ""}),
	}),

	s({
		trig = "```",
		name = "code-block",
		dscr = [[ 
		]]
	},
	{
		t([[```]]), i(1, "bash"), t({"", ""}),
		i(2, "Insert your code here"),
		t({"", [[```]], ""}),
	}),

	s({
		trig = "blue",
		name = "blue-font",
		dscr = [[ Colorful text with Embedded HTML
		]]
	},
	{
		t([[<font color="blue">]]), i(1), t([[</font>]])
	}),

	s({
		trig = "red",
		name = "red-font",
		dscr = [[ Colorful text with Embedded HTML
		]]
	},
	{
		t([[<font color="red">]]), i(1), t([[</font>]])
	}),

	s({
		trig = "green",
		name = "green-font",
		dscr = [[ Colorful text with Embedded HTML
		]]
	},
	{
		t([[<font color="green">]]), i(1), t([[</font>]])
	}),

	s({
		trig = "BLUE",
		name = "blue-bold-font",
		dscr = [[ Colorful & Bold **text** with Embedded HTML
		]]
	},
	{
		t([[<b><font color="blue">]]), i(1), t([[</font></b>]])
	}),

	s({
		trig = "RED",
		name = "red-bold-font",
		dscr = [[ Colorful & Bold **text** with Embedded HTML
		]]
	},
	{
		t([[<b><font color="red">]]), i(1), t([[</font></b>]])
	}),

	s({
		trig = "GREEN",
		name = "green-bold-font",
		dscr = [[ Colorful & Bold **text** with Embedded HTML
		]]
	},
	{
		t([[<b><font color="green">]]), i(1), t([[</font></b>]])
	}),

	s("info", fmt([==[
		{{% info %}}
		<>
		{{% /info %}}
	]==], {
		i(1, "Title of the box is the first line."),
	}, {
		delimiters = "<>"
	})),

	s("warn", fmt([==[
		{{% warn %}}
		<>
		{{% /warn %}}
	]==], {
		i(1, "Title of the box is the first line."),
	}, {
		delimiters = "<>"
	})),

	s("error", fmt([==[
		{{% error %}}
		<>
		{{% /error %}}
	]==], {
		i(1, "Title of the box is the first line."),
	}, {
		delimiters = "<>"
	})),
}
