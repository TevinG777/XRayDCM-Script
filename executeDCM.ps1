Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force -ErrorAction SilentlyContinue

# Delete the two files  
Remove-Item -Path ".\output.txt", ".\CompiledXrays.pdf", '.\outputDCM.txt' -ErrorAction SilentlyContinue
  
# Run the PowerShell scripts  
.\executeDCM.ps1   
  
# Run the Python script  
python .\dcm-png.py
python .\pdfexport.py  
