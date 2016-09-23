# Depencies
gulp = require("gulp")
sass = require("gulp-sass")
autoprefixer = require("gulp-autoprefixer")
minify = require("gulp-clean-css")
uglify = require("gulp-uglify")
concat = require("gulp-concat")
browerify = require("gulp-browserify")
plumber = require("gulp-plumber-notifier")
pug = require("gulp-pug")
server = require("gulp-develop-server")
livereload = require("gulp-livereload")
path = require("path")
fs = require("fs")

# Setings
config = JSON.parse(fs.readFileSync('./config.json'))

DataCollectionsObject = ->
  data = {}
  data.config = config
  for collection, url of config.data
    data[collection] = JSON.parse(fs.readFileSync(path.join(__dirname, config.paths.data, url)))

  return data

# Gulp -> Jade pages
gulp.task "pages", ->
  gulp.src path.join(__dirname, config.paths.pages, "/**/*.pug")
    .pipe plumber()
    .pipe pug({
      data: DataCollectionsObject()
      })
    .pipe gulp.dest(path.join(__dirname, config.paths.server))
    .pipe(livereload())

# Gulp -> SASS
gulp.task "styles", ->
    gulp.src path.join(__dirname, config.paths.styles, config.entry.styles)
      .pipe plumber()
      .pipe sass({indentedSyntax: true})
      .pipe autoprefixer({ browsers: ["> 1%"]})
      .pipe minify()
      .pipe concat(config.output.styles)
      .pipe gulp.dest(path.join(__dirname, config.paths.server))
      .pipe(livereload())

# Gulp -> Coffeescript
gulp.task "scripts", ->
  gulp.src path.join(__dirname, config.paths.scripts, config.entry.scripts), {read: false}
    .pipe plumber()
    .pipe browerify({transform: ["coffeeify", "pugify"]})
    .pipe concat(config.output.scripts)
    .pipe uglify()
    .pipe gulp.dest(path.join(__dirname, config.paths.server))
    .pipe(livereload())

# Gulp -> Watchers
gulp.task "watch", ->
  gulp.watch path.join(__dirname, config.paths.styles ,"/**/*.sass"), ["styles"]
  gulp.watch path.join(__dirname, config.paths.scripts ,"/**/*.coffee"), ["scripts"]
  gulp.watch path.join(__dirname, config.paths.structure ,"/**/*.pug"), ["pages"]

# Gulp -> Server
gulp.task "server", ->

  # Start and restart server
  server.listen({path: "./server.js"})

  # Livereload
  livereload({start: true})

# Gulp -> Default
gulp.task "default", ["watch", "server"]
