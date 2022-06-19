function services
	function service_status
		set IS_USER $argv[1]
		set DIR $argv[2]
		set SERVICE_NAME $argv[3]
		if $IS_USER
			sv status $DIR/*
		else
			sudo sv status $DIR/*
		end
    end

    function add
		set IS_USER $argv[1]
		set DIR $argv[2]
		set NAME $argv[3]
		set D "$DIR/$NAME/"
		echo $D
		if test -d "$D"
			echo exists
			return
		else
			if $IS_USER
				mkdir $D
				echo -e "#! /usr/bin/env fish\n\n" > "$D/run"
				chmod +x "$D/run"
				if status is-interactive
					read -P "Edit service script right now? " EDIT_N
				end
				if test "$EDIT_N" = "y"; or test "$EDIT_N" = "yes"
					edit "$D/run"
				end
			else
				sudo mkdir $D
				sudo echo -e "#! /usr/bin/env fish\n\n" > "$D/run"
				sudo chmod +x "$D/run"
				if status is-interactive
					read -P "Edit service script right now? " EDIT_N
				end
				if test "$EDIT_N" = "y"; or test "$EDIT_N" = "yes"
					sudo edit "$D/run"
				end
			end
			echo "<$NAME> created"
		end
    end

    function up
		set IS_USER $argv[1]
		set ACTIVATED_DIR $argv[2]
		set NAME $argv[3]
		set D "$ACTIVATED_DIR/$NAME"
		echo $D
		if test -h "$D"
			if $IS_USER
				sv up $D
			else
				sudo sv up $D
			end
		end
    end

    function down
		set IS_USER $argv[1]
		set ACTIVATED_DIR $argv[2]
		set NAME $argv[3]
		set D "$ACTIVATED_DIR/$NAME"
		echo $D
		if test -h "$D"
			if $IS_USER
				sv down $D
			else
				sudo sv down $D
			end
		end
    end

	function enable
		set IS_USER $argv[1]
		set ACTIVATED_DIR $argv[2]
		set DISABLED_DIR $argv[3]
		set NAME $argv[4]
		set SRC_D "$DISABLED_DIR/$NAME"
		set DEST_D "$ACTIVATED_DIR/$NAME"
		if test -d "$DEST_D"
			echo "$NAME is already enabled"
			return
		else if test -d "$SRC_D"
			if $IS_USER
				ln -s "$SRC_D" "$DEST_D"
			else
				sudo ln -s "$SRC_D" "$DEST_D"
			end
			echo "<$NAME> enabled"
		else
			echo "??"
		end
	end
	function disable
		set IS_USER $argv[1]
		set ACTIVATED_DIR $argv[2]
		set DISABLED_DIR $argv[3]
		set NAME $argv[4]
		set SRC_D "$DISABLED_DIR/$NAME"
		set DEST_D "$ACTIVATED_DIR/$NAME"
		if not test -e $SRC_D; and not test -e $DEST_D
			echo "<$NAME> isn't even a service."
		else if not test -d "$DEST_D"
			echo "$NAME is already disabled"
			return
		else if test -d "$SRC_D"
			if $IS_USER
				rm "$DEST_D"
			else
				sudo rm "$DEST_D"
			end
		else
			echo "??"
		end
		echo "<$NAME> disabled"
	end

	function _help
		echo "Services script"
		echo
		echo "add: add new init script(s)"
		echo "up: "
		echo "down: "
		echo "enable: "
		echo "disable"
		echo "status: "
	end

    function main
        getopts $argv[2..] | while read -l key value
            switch $key
                case u user
					set NAME $value
					set IS_USER true
					set DISABLED_DIR "$HOME/.dotty/sv"
					set ACTIVATED_DIR "$HOME/service"
				case _
					set NAME $value
				case '*'
					echo "<$key> is unknown"
            end
        end
		if test -z $IS_USER
			set IS_USER false
			set DISABLED_DIR "/etc/sv"
			set ACTIVATED_DIR "/var/service"
			echo root
		else
			echo user
		end
        switch (echo $argv[1])
			case add
				add $IS_USER $DISABLED_DIR $NAME
			case del
				del $IS_USER $DISABLED_DIR $NAME
			case up
				up $IS_USER $ACTIVATED_DIR $NAME
			case down
				down $IS_USER $ACTIVATED_DIR $NAME
			case status
				service_status $IS_USER $ACTIVATED_DIR $NAME
			case enable
				enable $IS_USER $ACTIVATED_DIR $DISABLED_DIR $NAME
			case disable
				disable $IS_USER $ACTIVATED_DIR $DISABLED_DIR $NAME
            case '' help
				_help
            case '*'
        end
    end
    main $argv
end
