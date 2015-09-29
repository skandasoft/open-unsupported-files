shell = require('shell')
{requirePackages} = require 'atom-utils'
module.exports =
  config:
    extensions:
      title: 'extensions'
      type: 'string'
      default: 'doc,docx,xls,pdf,exe,bat'

  activate: ->
    @extensions = atom.config.get('open-unsupported-files.extensions')?.split(',')
    requirePackages('tree-view').then ([treeView]) =>
      if tv = treeView.treeView
        @originalEntryClicked = tv.entryClicked
        tv.entryClicked =  (e) =>
          entry = e.currentTarget
          return @originalEntryClicked.call(tv,e) unless entry.constructor.name is 'tree-view-file'
          filepath = entry.file.path
          return @originalEntryClicked.call(tv,e) unless filepath
          filename = entry.file.name
          if filename?.substring(filename.indexOf('.') + 1 ) in @extensions
            shell.openExternal(filepath)
            return false
          else
            @originalEntryClicked.call(tv,e)
