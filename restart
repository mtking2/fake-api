# kill -9 $(cat pid/server.pid) || 
pkill -9 -f fake-api
ruby api/server.rb >> api/server.log 2>&1 &
echo $! > pid/server.pid
