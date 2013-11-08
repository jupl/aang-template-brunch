Plugin = require('../src')

# Stubs
angular = module: (moduleName) ->
  run: ([stub, func]) ->
    ret = null
    func(put: -> ret = [moduleName].concat(Array::slice.call(arguments, 0)))
    ret

#resultMatcher = /angular\("(.+)"\)\.run\(\[/
describe 'Plugin', ->

  beforeEach ->
    @plugin = new Plugin({})

  it 'should be an object', ->
    expect(@plugin).to.be.ok

  it 'should have a #compile method', ->
    expect(@plugin.compile).to.be.an.instanceof(Function)

  it 'should compile HTML', (done) ->
    content = """
      <div>
        Title
      </div>
    """
    @plugin.compile content, 'app/templates/first.html', (error, data) ->
      expect(error).not.to.be.ok
      [moduleName, src, html] = eval(data)
      expect(moduleName).to.equal('app')
      expect(src).to.equal('app/templates/first')
      expect(html).to.equal(content)
      done()

  it 'should compile Jade', (done) ->
    content = 'div Title'
    @plugin.compile content, 'app/templates/first.jade', (error, data) ->
      expect(error).not.to.be.ok
      [moduleName, src, html] = eval(data)
      expect(moduleName).to.equal('app')
      expect(src).to.equal('app/templates/first')
      expect(html).to.equal('<div>Title</div>')
      done()

  it 'can change module name', (done) ->
    content = """
      <div>
        Title
      </div>
    """
    @plugin = new Plugin(angularTemplate: moduleName: 'myApp')
    @plugin.compile content, 'app/templates/second.html', (error, data) ->
      expect(error).not.to.be.ok
      [moduleName, src, html] = eval(data)
      expect(moduleName).to.equal('myApp')
      expect(src).to.equal('app/templates/second')
      expect(html).to.equal(content)
      done()

  it 'can modify src parameters', (done) ->
    content = 'div Title'
    angularTemplate = pathToSrc: (path) ->
      /^app\/(.+)\/template/.exec(path)[1]
    @plugin = new Plugin({angularTemplate})
    @plugin.compile content, 'app/templates/second/template.jade', (error, data) ->
      expect(error).not.to.be.ok
      [moduleName, src, html] = eval(data)
      expect(moduleName).to.equal('app')
      expect(src).to.equal('templates/second')
      expect(html).to.equal('<div>Title</div>')
      done()

  it 'can inject data into Jade templates', (done) ->
    content = 'div= title'
    angularTemplate = jadeOptions:
      title: 'Another Title'
    @plugin = new Plugin({angularTemplate})
    @plugin.compile content, 'app/templates/second.jade', (error, data) ->
      expect(error).not.to.be.ok
      [moduleName, src, html] = eval(data)
      expect(moduleName).to.equal('app')
      expect(src).to.equal('app/templates/second')
      expect(html).to.equal('<div>Another Title</div>')
      done()

  it 'can ignore files', (done) ->
    content = 'div title'
    angularTemplate = ignore: [
      'app/templates/first.jade'
      (path) -> path is 'app/templates/second.jade'
      /third.jade$/
    ]
    @plugin = new Plugin({angularTemplate})
    @plugin.compile content, 'app/templates/first.jade', (error, data) =>
      expect(error).not.to.be.ok
      expect(data).to.be.empty
      @plugin.compile content, 'app/templates/second.jade', (error, data) =>
        expect(error).not.to.be.ok
        expect(data).to.be.empty
        @plugin.compile content, 'app/templates/third.jade', (error, data) =>
          expect(error).not.to.be.ok
          expect(data).to.be.empty
          done()
