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

    #     # If more than one folder is found, select the first occurrence
    #     if ($files.Count -gt 1) {
    #         $files = $files[0]
    #
    #         #Take the folder location as a string and split it by \ to get the last folder name
    #         $folderName = $files.FullName.Split("\")[-1]
    #
    #
    #
    #         # Split that string by space and determine which part of the string matches the number, if it is in the first index assign location variable to 1 and so on up to 3
    #         $location = 0
    #         $partList = $folderName.Split(" ")
    #         $partList | ForEach-Object {
    #             if($_ -eq $num){
    #                 break
    #             }
    #             $location++
    #         }
    #
    #     }
    #
    #     # If no file is found
    #     elseif ($files.Count -eq 0) {
    #         "$_ = \\ad101.siemens-energy.net\dfs\EnergyFS\NAM\GST_Application Data\NDT\DR\WAX PNG\NotFound.jpg" | Out-File -FilePath 'outputDCM.txt' -Append
    #     }
    if ($files.Count -eq 1) {
        $num
        #Take the folder location as a string and split it by \ to get the last folder name
        $folderName = $files.FullName.Split("\")[-1]

        # remove any commas from the folder name
        $folderName = $files.FullName.Replace(",", "")

        # Split that string by space and determine which part of the string matches the number, if it is in the first index assign location variable to 1 and so on up to 3
        $location = 1
        $folderName.Split(" ") | ForEach-Object {
            if($_ -eq $num){
                break
            }
            $location++
        }
         ## Then go into the folder defined by $file.FullName and get all the files that start with "Core " + $location
         #$coreFiles = Get-ChildItem -Path $files.FullName -Filter ("Core " + $location + "*") -File
    
         ## For each one of these files, get the full path and append it to the output file with the beginning part being $part+$num
         #$coreFiles | ForEach-Object {
         #    "$part$num = " + $_.FullName | Out-File -FilePath 'outputDCM.txt' -Append
         #}
    }
    
}