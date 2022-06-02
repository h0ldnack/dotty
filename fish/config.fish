if status is-interactive
    # Commands to run in interactive sessions can go here
end


function fish_command_not_found
	/code/voidy/pkgs-search.py $argv[1]
end

set -a PATH /code/scripts
set -a PATH ~/.local/bin
