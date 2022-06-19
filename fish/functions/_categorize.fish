function _categorize
	if test -f $argv[1]
		set TYPE file
	else if test -d $argv[1]
		set TYPE dir
	else
		if string match --regex --entire "$http(s)?://[a-z0-9]+(.)+.*" "$argv[1]" &> /dev/null
			echo "http url"
		else if string match --regex --entire "$magnet:\?.*" "$argv[1]" &> /dev/null
			echo "magnet link url"
		else
			echo "not http url"
		end
	end
end
