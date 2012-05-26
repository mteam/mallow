app = require("express").createServer()
mallow = require("../lib").middleware

app.use mallow require("./config"), '/scripts/'
