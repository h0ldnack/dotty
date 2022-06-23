function install
	function xbps
	end
	function pacman
	end
	function apt
	end
	function nix
	end
	function poetry
	end

	function do
		echo "hi"
		if set -q $argv[1]
			set SUBCMD $argv[1]
		end
		if set -q $argv[2]
			set PKG_MAN $argv[2]
		else
			if which xbps-install &> /dev/null
				echo xbps
			else if which pacman &> /dev/null
				return pacman
			else if which apt &> /dev/null
				return apt
			else if which poetry &> /dev/null
				return poetry
			else if which nix &> /dev/null
				return nix
			else
				echo "No known package manager found"
				exit 1
			end
		end
	end
	function _help
		echo "Install: Generic install wrapping cmd"
		echo
	end

	function _subcmd
		switch $argv[1]
			case 'install' 'i'
				echo install
			case 'update' 'ud'
				echo update
			case 'upgrade' 'up'
				echo upgrade
			case 'delete' 'remove' 'del'
				echo delete
			case 'query' 'q'
				echo query
			case '*'
		end
	end

	function main
		set LEN_ARGV (count $argv)

		if test $LEN_ARGV -eq 0
			echo no args
			do
		else if test $LEN_ARGV -eq 1
			echo subcmd
			do $argv[1]
		end

		set ARGS upgrade $argv[2..]
		echo multiple
		getopts $ARGS | while read -l key value
			switch $key
				case m manager
					set PACKAGE_MANAGER $value
				case _
					set NAME $value
				case '*'
					echo "<$key> is unknown"
			end
		end
		do $ARGS[1] $PACKAGE_MANAGER

	end
	main $argv
end
