#! /usr/bin/env fish

function sync
	set DATE (date --iso-8601=hours)
	set MSG "Automatically added on <$DATE>"
	git pull
	git add *
	git commit -m "$MSG"
	git push -u origin main
end

function link
	set DIRS (fd --type directory --exact-depth 1 '.' "$HOME/.dotty")
	for D in $DIRS
		set B (basename $D)
		set C "$HOME/.config/$B"
		if test -d "$C"; and not test -h "$C" # Not in dotty
			mv $C "$HOME/.dotty/.old/$B"
			ln -s $D $C
		else if test -d "$C"; and test -h "$C" # In dotty already
			trash-put $C
			ln -s $D $C
		else # In dotty, but not yet linked
			ln -s $D $C
		end
	end
	if test -f starship.toml
		ln -s starship.toml "$HOME/.config/starship.toml"
	end
end

function main
	link
	sync
end

main $argv
