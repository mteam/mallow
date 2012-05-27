app = require("express").createServer()
config = require("./config")
mallow = require("../lib") config
fs = require "fs"

app.get '/', (req, res) ->
	res.end fs.readFileSync __dirname + '/index.html'

app.get '/scripts/app.js', mallow['app.js'].server

app.listen 3000
