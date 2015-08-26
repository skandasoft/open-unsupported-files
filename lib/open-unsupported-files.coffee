shell = require('shell')
{requirePackages} = require 'atom-utils'
module.exports =
  config:
    extensions:
      title: 'extensions'
      type: 'string'
      default: 'doc,docx,xls,pdf,exe'

  activate: ->
    @extensions = atom.config.get('open-unsupported-files.extensions')?.split(',')
    requirePackages('tree-view').then ([treeView]) =>
      if tv = treeView.treeView
        @originalEntryClicked = tv.entryClicked
        tv.entryClicked =  (e) =>
          entry = e.currentTarget
          return @originalEntryClicked.call(tv,e) unless entry.constructor.name is 'tree-view-file'
          filepath = e.target.firstChild.attributes['data-path']?.nodeValue
          return @originalEntryClicked.call(tv,e) unless filepath
          filename = e.target.firstChild.attributes['data-name']?.nodeValue
          if filename?.substring(filename.indexOf('.') + 1 ) in @extensions
            shell.openExternal(filepath)
            return false
          else
            @originalEntryClicked.call(tv,e)
