"Export the dictionary into a Markdown formatted file"
"Requires: allegory"
[ ]
{
  [ "s-s"  '## ' swap + ] 'header' :
  [ "s-s"  :s '\ \ \ \ ' swap + ] 'stack' :
  [ "-"    depth 3 eq? [ [ stack ] dip ] [ stack ] if ] 'format' :
  [ "s-..." [ header ] sip ? format ] 'get-strings' :

  'CurrentName' var

  [ "s-" \
    vm.dict<names> 0 over 'Allegory~' index-of subslice \
    [ dup !CurrentName \
      get-strings [ :s display tty.cr tty.cr ] \
      depth 4 eq? [ tri@ ] [ depth 2 eq? [ 'Variable' swap ] if-true bi@ ] if \
      [ 'docs/pieces/' @CurrentName '.example' ] build-string dup \
      file-exists? [ 'Example:\n\n````\n' display slurp-file trim display '````\n' display ] [ drop ] if \
    ] for-each \
    bye \
  ] 'allegory.on-start' :
}

'generate-reference.py' save-as bye
