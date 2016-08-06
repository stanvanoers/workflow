# Depencies
express = require("express")
app = express()
ip = require("my-local-ip")()
port = 3030
livereload = require("connect-livereload")

# Middleware -> livereload
app.use livereload({port: 35729})

# Middleware -> static server
app.use(express.static("./static"))

# messageOnServerStart
MessageOnServerStart = ->

  # Check if on local network
  if !ip? then ip = "localhost"

  # Show message
  console.log "~~ jade-sass-coffee-starter made by Stan van Oers (2016)"
  console.log "~~ server started on #{ip}:#{port}"

# Start express server
app.listen port, ip, -> MessageOnServerStart()
