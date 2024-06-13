return {
	s("input_macro", fmt([==[
		let content = stdin_to_string();
		let mut inp = Parser::new(&content);

	]==], {
	}, {
		delimiters = "<>"
	})),
}
