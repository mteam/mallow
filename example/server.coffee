express = require('express')
mallow = require('../src')

app = express()
bundle = mallow.new(__dirname)

app.use express.static('public')
app.use app.router

app.get '/app.js', bundle.server

app.listen 3000
