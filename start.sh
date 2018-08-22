pkill -f ngrok fake_api

[ -f api.log ] || touch api.log

ruby api.rb >> api.log 2>&1 &
ngrok http 4567 > /dev/null &

disown
sleep 1.5

var_location="$HOME/.bash_profile"

old_url="$(grep -oE "(https:\/\/\w+\.ngrok\.io)" $var_location)"
new_url="$(curl -s localhost:4040/api/tunnels | grep -oE "(https:\/\/\w+\.ngrok\.io)")"
echo "$new_url --> $(ps -a | grep puma | grep fake_api | grep -oE "localhost:\d+")"

old_url="$(echo $old_url | sed 's/\//\\\//g')"
new_url="$(echo $new_url | sed 's/\//\\\//g')"
sed -i '' 's/'"$old_url"'/'"$new_url"'/g' $var_location
