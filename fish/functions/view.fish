function view
	for a in $argv
		if test -e $a
			set MIME (file --brief --mime-type $a)
			set MIME_CATE (echo $MIME  | cut -d '/' -f 1)
			set MIME_TYPE (echo $MIME  | cut -d '/' -f 2)

			switch (echo $MIME_CATE)
				case 'text'
					bat $a
				case 'inode'
					if test "$MIME_TYPE" = "symlink"
						set F (realpath $a)
						view $F
					else if test "$MIME_TYPE" = "directory"
						set t "(dired \"$a\")"
						emacsclient -c --eval "$t"
					end
				case 'audio'
					mpv --no-video $a
				case 'application'
					bat $a
				case 'video'
					mpv $a
				case 'image'
					feh $a
				case ''
				case '*'
					echo "<$MIME> is unknown, which is scary."
			end
		end
	end

end
