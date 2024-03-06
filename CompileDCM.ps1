$linkStructure = "\\ad101.siemens-energy.net\dfs\EnergyFS\NAM\GST_Application Data\NDT\DR\WAX DCM"  
  
Get-Content -Path 'partsDCM.txt' | ForEach-Object {  
    # Get the first 5 characters as the part variable  
    $part = $_.Substring(0, 5)  
  
    # Get the remaining characters as the num variable  
    $num = $_.Substring(5)  
  
    # Append the part variable to the linkStructure variable as a subdirectory  
    $linkStructurePart = Join-Path -Path $linkStructure -ChildPath ($part + "\")  
  
    # Define the search pattern for files  
    $searchPattern = "*$num*"  
  
    # Look for Directories in the file path with file name matching the search pattern  
    $files = Get-ChildItem -Path $linkStructurePart -Filter $searchPattern -Directory


    #ouput found directories 
    $files | ForEach-Object {  
        $part+$num+ ':'+ $_.FullName  
    }
  
}  
