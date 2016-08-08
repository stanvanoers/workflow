# Depencies
express = require("express")
app = express()
ip = require("my-local-ip")()
livereload = require("connect-livereload")
path = require("path")
fs = require("fs")

# Setings
config = JSON.parse(fs.readFileSync('./config.json'))

# Middleware -> livereload
app.use livereload({port: 35729})

# Middleware -> static server
app.use(express.static(path.join(config.paths.server)))

# Check if on local network
if !ip? or config.server.localhost then ip = "localhost"

# messageOnServerStart
MessageOnServerStart = ->

  # Show message
  console.log "~~ #{config.name} made by #{config.author}"
  console.log "~~ server started on #{ip}:#{config.server.port}"

# Start express server
app.listen config.server.port, ip, -> MessageOnServerStart()
