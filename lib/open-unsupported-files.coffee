{BufferedProcess} = require 'atom'
{requirePackages} = require 'atom-utils'
module.exports =
  config:
    extensions:
      title: 'extensions'
      type: 'string'
      default: 'doc,docx,xls,pdf'

  activate: ->
    @cmd = if process.platform is 'win32' then 'cmd' else 'open'
    @extensions = atom.config.get('open-unsupported-files.extensions')?.split(',')
    requirePackages('tree-view').then ([treeView]) =>
      if tv = treeView.treeView
        @originalEntryClicked = tv.entryClicked
        tv.entryClicked =  (e) =>
          entry = e.currentTarget
          return @originalEntryClicked.call(tv,e) unless entry.constructor.name is 'tree-view-file'
          filepath = e.target.attributes['data-path'].nodeValue
          filename = e.target.attributes['data-name'].nodeValue
          if filename?.substring(filename.indexOf('.') + 1 ) in @extensions
            args = [filepath]
            new BufferedProcess({@cmd,args})
            return false
          else
            @originalEntryClicked.call(tv,e)
