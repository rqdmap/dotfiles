function _blog(){
	local -a commands
    commands=(
        'new'
        'remove'
		'ls'
		'edit'
        'server'
        'stop'
		'help'
    )
    if (( CURRENT == 2 )); then
        # 当前输入位置在第二个参数时，即 blog 后一个参数时
        compadd "${commands[@]}"
    elif [[ "$words[2]" == "remove" || "$words[2]" == "new" || "$words[2]" == "edit" ]] && (( CURRENT == 3 )); then
        # 当前输入位置在第三个参数时，并且第二个参数是 特定字符串 时
        _files -W ~/hugo-blog/content/ -/
    fi
}
compdef _blog blog
