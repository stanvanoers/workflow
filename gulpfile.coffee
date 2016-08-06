# Depencies
gulp = require("gulp")
sass = require("gulp-sass")
autoprefixer = require("gulp-autoprefixer")
minify = require("gulp-minify-css")
uglify = require("gulp-uglify")
concat = require("gulp-concat")
browerify = require("gulp-browserify")
plumber = require("gulp-plumber")
pug = require("gulp-pug")
server = require("gulp-develop-server")
livereload = require("gulp-livereload")

# Gulp -> Jade pages
gulp.task "pages", ->
  gulp.src "./structure/pages/**/*.pug"
    .pipe plumber()
    .pipe pug()
    .pipe gulp.dest("./static")
    .pipe(livereload())

# Gulp -> SASS
gulp.task "styles", ->
    gulp.src "./styles/main.sass"
      .pipe plumber()
      .pipe sass({indentedSyntax: true})
      .pipe autoprefixer({ browsers: ["> 1%"]})
      .pipe minify()
      .pipe concat("bundle.css")
      .pipe gulp.dest("./static")
      .pipe(livereload())

# Gulp -> Coffeescript
gulp.task "scripts", ->
  gulp.src "./scripts/main.coffee", {read: false}
    .pipe plumber()
    .pipe browerify({transform: ["coffeeify", "pugify"]})
    .pipe concat("bundle.js")
    .pipe uglify()
    .pipe gulp.dest("./static")
    .pipe(livereload())

# Gulp -> Watchers
gulp.task "watch", ->
  gulp.watch "./styles/**/*.sass", ["styles"]
  gulp.watch "./scripts/**/*.coffee", ["scripts"]
  gulp.watch "./structure/pages/**/*.pug", ["pages"]

# Gulp -> Server
gulp.task "server", ->

  # Start and restart server
  server.listen({path: "./server.js"})

  # Livereload
  livereload({start: true})

# Gulp -> Default
gulp.task "default", ["watch", "server"]
