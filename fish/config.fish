if status is-interactive
    # Commands to run in interactive sessions can go here
	direnv hook fish | source
	zoxide init fish --cmd c --hook pwd | source
	starship init fish | source
end


function fish_command_not_found
	/code/voidy/pkgs-search.py $argv[1]
end

set -a PATH /code/scripts
set -a PATH ~/.local/bin
