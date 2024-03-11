Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force -ErrorAction SilentlyContinue

#remove the dcmImg folder even if it is full
Remove-Item -LiteralPath "dcmImgsFolder" -Recurse 
Remove-Item -LiteralPath ".\output.txt"
Remove-Item -LiteralPath ".\outputDCMt.txt"
Remove-Item -LiteralPath ".\CompiledXrays.pdf"