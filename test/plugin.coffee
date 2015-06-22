plugin = require '../lib/plugin'
sinon = require 'sinon'
expect = require 'expect.js'

describe 'plugin', ->
  fakeDeferred = undefined
  $page = null

  before ->
    $page = $('<div id="plugin" />')
    $page.appendTo('body')
    fakeDeferred = {}
    fakeDeferred.done = sinon.mock().returns(fakeDeferred)
    fakeDeferred.fail = sinon.mock().returns(fakeDeferred)

    sinon.stub(jQuery,'getScript').returns(fakeDeferred)

  after ->
    jQuery.getScript.restore()
    $page.empty()

  it 'should have default image type', ->
    expect(window.plugins).to.have.property('image')

  it.skip 'should fetch a plugin script from the right location', ->
    plugin.get 'test'
    expect(jQuery.getScript.calledOnce).to.be(true)
    expect(jQuery.getScript.args[0][0]).to.be('/plugins/test/test.js')

  it 'should render a plugin', ->
    item =
      type: 'paragraph'
      text: 'blah [[Link]] asdf'
    plugin.do $('#plugin'), item
    expect($('#plugin').html()).to
      .be('<p>blah <a class="internal" href="/link.html" data-page-name="link" title="view">Link</a> asdf</p>')
