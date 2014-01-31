require('sugar')
jade = require('jade')

module.exports = class AangTemplateCompiler
  brunchPlugin: yes
  type: 'template'
  extension: 'html'
  pattern: /\.(html|jade)$/

  constructor: (config) ->
    @options = Object.create(config.plugins?.angularTemplate ? null)
    @options.moduleName ?= 'app'
    @options.pathToSrc ?= (path) -> path
    @options.jadeOptions ?= {}
    @options.ignore ?= []
    unless Object.isArray(@options.ignore)
      @options.ignore = [@options.ignore]

  compile: (data, path, callback) ->
    try
      if not @ignoreFile(path)
        html = if isJade(path) then jade.compile(data)(@options.jadeOptions) else data
        src = @formattedPath(path)
        result = @wrapper(html, src)
      else
        result = ''
    catch err
      error = err
    finally
      callback(error, result)

  wrapper: (html, src) ->
    """
    angular.module(#{JSON.stringify(@options.moduleName)}).run(["$templateCache", function($templateCache) {
      $templateCache.put(#{JSON.stringify(src)}, #{JSON.stringify(html)});
    }]);
    """

  formattedPath: (path) ->
    path = /(?:app\/)?(.+)/.exec(path.replace(/\\/g, '/'))[1]
    try
      path = @options.pathToSrc(path)
    catch
    path

  ignoreFile: (path) ->
    for condition in @options.ignore
      if Object.isString(condition)
        return true if condition is path
      else if Object.isFunction(condition)
        return true if condition(path)
      else if Object.isRegExp(condition)
        return true if condition.test(path)
    false

isJade = (path) ->
  /.jade$/.test(path)
