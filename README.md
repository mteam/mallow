# Mallow

Mallow is a javascript bundler like [hem](https://github.com/brunch/brunch) or [brunch](https://github.com/maccman/hem). It compiles CoffeeScript files (if it's necessary) and concatenates compiled files.

## Installation

via npm:
```bash
$ npm install mallow
```

## Configuration

```coffeescript
module.exports = ->

  @package 'app.js', ->
    @add prefix: 'example', path: __dirname + '/hello'
    @add prefix: 'foo', path: __dirname + '/foo'
```

We create a package called `app.js` and add to it directories `hello` and `foo`. The prefix means that modules from these directories will have those prefixes before their names. For example, if there was a file called `world.coffee` in the `hello` directory, its name would be example/world.

If you don't want any prefix, we can just pass the directory as an argument:

```coffeescript
    @add __dirname + '/hello'
```

## Usage

Currenty Mallow doesn't support cli interface, but you can use it with [express](https://github.com/visionmedia/express).

```coffeescript
app = require('express').createServer()
config = require('./config')
mallow = require('../lib')(config)

app.get '/scripts/app.js', mallow['app.js'].server

app.listen 3000
```

`mallow['app.js'].server` is a function that returns compiled and bundled code.

You can get the bundled code through `compile` method:

```coffeescript
mallow['app.js'].compile (err, code) ->
  console.log code
```

In browser, you can `require` like on server:

```
<script>
  var foo = require("bar");
</script>
```

More examples can be found in the `example` directory.

