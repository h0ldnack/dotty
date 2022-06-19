function download
	set URL $argv[1]
	set DOWN_D "/downloads"
	set RAND (head -c 5 /dev/urandom | base32)
	set D "$DOWN_D/$RAND"
	mkdir -p "$D"
	set HEADERS_F "$DOWN_D/$RAND.headers.txt"
	set PROTOCOL (echo $URL | cut -d":" -f 1)
	# TODO: Link to current machines memory size
	# Definetely not more then 50% probably 35% to 40% of total memory
	# Also add in hard limits if memory is less then 4 GBs
	set LIMIT 8589934592 # less then 8 GBs
	#set LIMIT 5000
	switch $PROTOCOL
		case 'http' 'https'

			curl -I "$URL" 1> $HEADERS_F 2> /dev/null
			# THis is completely fucked for some reason
			set FSIZE (grep 'Content-Length: ' $HEADERS_F | cut -c 17-)
			rm $HEADERS_F
			set SIZE (math $FSIZE + 2000)
			if test $SIZE -le $LIMIT
				echo "$D dir $SIZE and $FSIZE"
				sudo mount -t tmpfs -o size=$SIZE,gid=1000,uid=1000,noexec,nodev,nosuid tmpfs $D
				printf '%i bytes file size\n' $SIZE 2> /dev/null
				aria2c --dir=$D \
					--file-allocation='falloc' \
					--max-connection-per-server=8 \
					--max-concurrent-downloads=12 \
					--split=10 $URL &> /dev/null
				clamscan --quiet --no-summary --supress-ok-results $D
			else
				echo Size is greater then $LIMIT
				return
			end
		case 'magnet'
			echo m
		case 'ftp'
			echo f
		case ''
		case '*'
	end
end
