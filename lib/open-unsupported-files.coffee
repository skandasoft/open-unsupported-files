module.exports =
  config:
    extensions:
      title: 'extensions'
      type: 'string'
      default: 'doc,xls,ppt,docx,xlsx,pptx,pdf,rtf,zip,7z,rar,tar,gz,bz2,exe,bat'

  activate: ->
    @extensions = atom.config.get('open-unsupported-files.extensions')?.toLowerCase().split(',')
    {requirePackages} = require 'atom-utils'

    requirePackages('tree-view').then ([treeView]) =>
      if tv = treeView.treeView
        @originalFileViewEntryClicked = tv.fileViewEntryClicked

        tv.fileViewEntryClicked = (e) =>
          path = e.currentTarget.getPath()
          filename = e.currentTarget.file.name
          extension = filename?.substring(filename.lastIndexOf('.') + 1).toLowerCase()

          if extension in @extensions
            if e.originalEvent?.detail is 2
              shell = require('shell')
              shell.openItem(path)
            return false
          else
            @originalFileViewEntryClicked.call(tv, e)
