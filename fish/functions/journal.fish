function journal
	set D "/notes/journals"
	set T "$D/template.org"
	set N (date --iso-8601)
	set F "$D/$N.org"
	if test -f $F
		edit $F
	else
		cp $T $F
		edit $F
	end
end
