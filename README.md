# Fake API

### Getting started

Run `bundle install`  
Then simply `ruby api.rb` to start the server. (defaults to http://localhost:4567)

### Advanced options

This requires that you have installed [ngrok](https://ngrok.com) and added it to your `$PATH`

To do that visit https://ngrok.com/download to download ngrok. Then just add a line to your `~/.zshrc`, `~/.bashrc`, or `~/.bash_profile` like so:
```shell
export PATH="$PATH:/path/to/ngrok"
```

After that feel free to run the included script with `./start.sh`.

Now you're ready to pop open ngrok (http://localhost:4040) and start montitoring some requests.

### Example requests

**JSON**
```shell
curl $NGROK_URL/json/some-endpoint -H 'Content-Type: application/json' \
  -d $'{
    "data": {
      "some-attribute": "some data"
    }
  }'

# from file
curl $NGROK_URL/json/some-endpoint -H 'Content-Type: application/json' -d @foo.json
```
<p align="center">
  <img src="https://i.imgur.com/aLP1SPB.png" alt="JSON ngrok example" />
</p>

**XML**
```shell
curl $NGROK_URL/xml/some-endpoint -H 'Content-Type: text/xml' \
  -d $'
  <Parent attribute="some-attribute">
    <Child attribute="another-attribute">
      Hello, world!
    </Child>
  </Parent>'

# from file
curl $NGROK_URL/json/some-endpoint -H 'Content-Type: text/xml' -d @foo.xml
```
<p align="center">
  <img src="https://i.imgur.com/IGqHqvV.png" alt="XML ngrok example" />
</p>



### Breakdown of script
1. kills any currently running instances of Sinatra and/or ngork
2. starts Sinatra server in background
3. starts ngrok tunnel in background
4. automatically creates and/or updates an `$NGROK_URL` environment variable for your leisure.
    - **note**: the script attempts to modify your `.bashrc`, `.zshrc`, or `.bash_profile` (whichever it may find it) in place to keep the environment variable up-to-date with the current ngrok url.
5. 💵💵💵
