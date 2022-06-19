function create
	function main
		getopts $argv[2..] | while read -l key value
            switch $key
                case u user
					set IS_USER true
				case _
					echo ""
				case '*'
					echo "<$key> is unknown"
            end
		end
	end
end
