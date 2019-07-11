kill -9 $(cat pid/server.pid) || pkill -9 -f "fake_api"
ruby api.rb >> api.log 2>&1 &
echo $! > pid/server.pid