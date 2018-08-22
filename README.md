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

Profit &nbsp;$$$

Now you're ready to pop open ngrok (http://localhost:4040) and start montitoring some requests.


### Breakdown of script
1. kills any currently running instances of Sinatra and/or ngork
- starts Sinatra server in background
- starts ngrok tunnel in background
- automatically creates and/or updates an `$NGROK_URL` environment variable for your leisure.
  - **note**: the script attempts to modify your `.bashrc`, `.zshrc`, or `.bash_profile` (whichever it may find it) in place to keep the environment variable up-to-date with the current ngrok url.
- 💵
