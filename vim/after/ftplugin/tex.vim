setlocal wrap
setlocal tabstop=4
setlocal makeprg=latexmk\ -pdf\ %
setlocal spell

if g:AutoPairsLoaded
  let b:AutoPairs = AutoPairsDefine({}, ['"', ''''])
end
