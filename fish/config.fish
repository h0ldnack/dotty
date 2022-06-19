if status is-interactive
    # Commands to run in interactive sessions can go here
	direnv hook fish | source
	zoxide init fish --cmd c --hook pwd | source
	starship init fish | source
end


function fish_command_not_found
	/code/voidy/pkgs-search.py $argv[1]
end

set -ax PATH /code/scripts
set -ax PATH ~/.local/bin
set -ax PATH /usr/local/cuda-11.7/bin
set -x SVDIR "$HOME/service"
set -x ALTERNATE_EDITOR ""
set -x EDITOR "emacsclient -t"
set -x VISUAL "emacsclient -c -a emacs"
set -x CUDA_VISIBLE_DEVICES 0
set -ax LD_LIBRARY_PATH /usr/local/cuda-11.7/lib64
