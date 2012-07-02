Package = require "./package"
compilers = require "./compilers"
Module = require "module"
path = require "path"
fs = require "fs"

findPackageFile = (dir, name) ->
  for modulePath in Module._nodeModulePaths(dir)
    file = path.join(modulePath, name, 'package.json')

    if fs.existsSync(file)
      return file

addToPackage = (json, dir, pkg) ->
  if (not json.engines?) or ('browser' not in Object.keys(json.engines))
    return

  unless dirs = json.directories
    throw new Error("you must specify directories in #{json.name} package.json")

  unless sources = dirs.lib or dirs.src
    throw new Error("you must specify lib or src directory in #{json.name} package.json")

  sources = path.resolve(dir, sources)

  pkg.add(prefix: json.name, path: sources)

  if json.dependencies?
    Object.keys(json.dependencies).forEach (dependency) ->
      unless file = findPackageFile(dir, dependency)
        throw new Error("cannot find package.json for #{dependency}")

      addToPackage(require(file), path.dirname(file), pkg)

module.exports = (file) ->
  file = path.resolve(file)
  dir = path.dirname(file)
  json = require(file)
  pkg = new Package(json.name)
  addToPackage(json, dir, pkg)
  pkg

module.exports.compilers = compilers
