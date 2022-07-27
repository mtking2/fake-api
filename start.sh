colors() {
	green="\033[0;32m"
	red="\033[0;31m"
	yellow='\033[0;33m'
	blue='\033[0;34m'
	no_color="\033[0m"
}

init() {
	colors
	if [[ ! -d "pid" ]]; then
		mkdir pid
	fi

	# if [[ -f "pid/server.pid" ]] && [[ -n "$(cat pid/server.pid)" ]]; then
	#   kill -9 $(cat pid/server.pid)
	# fi
	# if [[ -f "pid/ngrok.pid" ]] && [[ -n "$(cat pid/ngrok.pid)" ]]; then
	#   kill -9 $(cat pid/ngrok.pid)
	# fi
	#
	# kill -9 $(cat pid/server.pid) $(cat pid/ngrok.pid)

	pkill -9 -f fake-api ngrok

	ruby api/server.rb >> api/server.log 2>&1 &
	echo "$(pgrep fake-api)" > pid/server.pid
	ngrok http 4567 > /dev/null &
	echo "$(pgrep ngrok)" > pid/ngrok.pid
	disown

	sleep 2 # give sinatra & ngrok some time to start
	new_url="$(curl -s localhost:4040/api/tunnels | grep -oE "(https:\/\/(\w+-?)+\.ngrok\.io)")"
	echo "Fake API started and tunneled through ngrok."
	echo " ↳ ${yellow}$new_url${no_color} --> ${yellow}$(ps -a | grep puma | grep fake-api | grep -oE "localhost:\d+")${no_color}"
}
init

touch_env_var() {
	echo

	if [ -f "$HOME/.bashrc" ] && [ -n "$(grep "NGROK_URL" $HOME/.bashrc)" ]; then
		var_location="$HOME/.bashrc"
	elif [ -f "$HOME/.zshrc" ] && [ -n "$(grep "NGROK_URL" $HOME/.zshrc)" ]; then
		var_location="$HOME/.zshrc"
	elif [ -f "$HOME/.bash_profile" ] && [ -n "$(grep "NGROK_URL" $HOME/.bash_profile)" ]; then
		var_location="$HOME/.bash_profile"
	fi

	if [[ -n "$var_location" ]]; then
		echo "already has ${red}\$NGROK_URL${no_color} environment variable"

		# delete all existing lines containing "NGROK_URL"
		sed -i '' '/NGROK_URL/d' $var_location

		echo " ↳ located at $var_location → modifying..."
		echo "export NGROK_URL=\"$1\"" >> "$var_location"
		
		# old_url="$(grep -oE "export NGROK_URL=\"(https?:\/\/\w+\.ngrok\.io)?\"" $var_location | sed 's/\//\\\//g')"
		# sub_url="export NGROK_URL=\"$(echo $1 | sed 's/\//\\\//g')\""
		# echo "$old_url --> $sub_url"
		# sed -i '' "s/$old_url/$sub_url/g" $var_location
	else
		if [ -f "$HOME/.bashrc" ]; then
			rc_file="$HOME/.bashrc"
		elif [ -f "$HOME/.zshrc" ]; then
			rc_file="$HOME/.zshrc"
		elif [ -f "$HOME/.bash_profile" ]; then
			rc_file="$HOME/.bash_profile"
		fi

		echo 'DOES NOT have NGROK_URL environment variable.'
		echo " ↳ adding to $rc_file"
		echo "export NGROK_URL=\"$1\"" >> $rc_file
	fi
}

# comment this line out if you don't want to have the script automatically
# create & modify the $NGROK_URL environment variable
touch_env_var $new_url

echo "\ndone ${green}✓${no_color}  access ngrok interface via ${blue}http://localhost:4040${no_color}\n"
