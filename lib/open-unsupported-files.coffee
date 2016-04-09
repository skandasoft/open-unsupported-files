module.exports =
  config:
    extensions:
      title: 'extensions'
      type: 'string'
      default: 'doc,xls,ppt,docx,xlsx,pptx,pdf,rtf,zip,7z,rar,tar,gz,bz2,exe,bat'

  activate: ->
    {requirePackages} = require 'atom-utils'
    requirePackages('tree-view').then ([treeView]) =>
      @extensions = atom.config.get('open-unsupported-files.extensions')?.split(',')
      if tv = treeView.treeView
        @originalEntryClicked = tv.entryClicked
        tv.entryClicked =  (e) =>
          shell = require('shell')
          entry = e.currentTarget
          return @originalEntryClicked.call(tv,e) unless entry.constructor.name is 'tree-view-file'
          filepath = entry.file.path
          return @originalEntryClicked.call(tv,e) unless filepath
          filename = entry.file.name
          if filename?.substring(filename.lastIndexOf('.') + 1 ).toLowerCase() in @extensions
            shell.openItem(filepath)
            return false
          else
            @originalEntryClicked.call(tv,e)
