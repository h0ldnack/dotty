function alarm
	set T $argv[1]
	while true
		echo $T time
		if test $T -eq 0
			mpv /datum/sound-effects/gong.opus
			dunstify "Alarm" "$T timer has went off"
			break
		else
			set R (math $T "*" 60)
			echo $R
			sleep $R
			echo "$T mins left"
			set T (math $T - 1)
			echo $T new time
			continue
		end
	end

end
