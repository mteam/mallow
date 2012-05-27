app = require("express").createServer()
config = require("./config")
mallow = require("../lib") config

app.get '/scripts/app.js', mallow['app.js'].server

app.listen 3000
