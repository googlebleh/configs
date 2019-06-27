setlocal makeprg=latexmk\ -pdf\ %
setlocal spell
setlocal tabstop=4
setlocal textwidth=78
setlocal wrap

if g:AutoPairsLoaded
  let b:AutoPairs = AutoPairsDefine({}, ['"', ''''])
end
