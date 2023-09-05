return {
	s("input_macro", fmt([==[
	macro_rules! input {
		($($i:expr), +) =>> {
			let mut buf = String::new();
			std::io::stdin().read_line(&mut buf).unwrap();
			let mut iter = buf.split_whitespace();
			$($i = iter.next().unwrap().parse().unwrap();)*
		};
	 
		($vec:ident ; $n:expr) =>> {
			let mut buf = String::new();
			std::io::stdin().read_line(&mut buf).unwrap();
			$vec = buf.split_whitespace()
				.map(|x| x.parse().unwrap())
				.take($n)
				.collect();
		};
	}

	]==], {
	}, {
		delimiters = "<>"
	})),
}
