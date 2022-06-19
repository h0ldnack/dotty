function edit
	for a in $argv
		if test -e $a
			set MIME (file --brief --mime-type $a)
			set MIME_CATE (echo $MIME  | cut -d '/' -f 1)
			set MIME_TYPE (echo $MIME  | cut -d '/' -f 2)

			switch (echo $MIME_CATE)
				case 'text'
					emax $a
				case 'inode'
					if test "$MIME_TYPE" = "symlink"
						set F (realpath $a)
						edit $F
					else if test "$MIME_TYPE" = "directory"
						set t "(dired \"$a\")"
						emacsclient -c --eval "$t"
					else if test "$MIME_TYPE" = "x-empty"
						emax $a
					end
				case 'audio'
					audacity $a
				case 'application'
					emax $a
				case 'video'
					shotcut $a
				case 'image'
					gimp $a
				case ''
				case '*'
					echo "<$MIME> is unknown, which is scary."
			end
		else
			touch $a
		end
	end
end
