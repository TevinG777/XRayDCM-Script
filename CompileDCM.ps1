$linkStructure = "\\ad101.siemens-energy.net\dfs\EnergyFS\NAM\GST_Application Data\NDT\DR\WAX DCM"

#define location list
$locationList = @()

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

    if ($files.Count -eq 0) {
        #"$_ = \\ad101.siemens-energy.net\dfs\EnergyFS\NAM\GST_Application Data\NDT\DR\WAX PNG\NotFound.jpg" | Out-File -FilePath 'outputDCM.txt' -Append
    }
    else {     
        # Take the folder location as a string and split it by \ to get the last folder name
        $folderSection = $files.FullName.Split("\")[-1].Replace(",","").Split(" ")
        # location
        $location = 1
        # print each folder name as a set to console
        $folderSection | ForEach-Object {
            # if $_ is equal to $num then leave location at current value, else update location by 1
            if($_ -eq $num){
                # append value of location to location list
                $locationList += $location
            }
            else{
                $location++
            }
        }
    }
}

$count = 0
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

    # output all files found
    if ($files.Count -eq 0) {
        # output not found to outputDCM.txt
        "$_ = \\ad101.siemens-energy.net\dfs\EnergyFS\NAM\GST_Application Data\NDT\DR\WAX PNG\NotFound.jpg" | Out-File -FilePath 'outputDCMt.txt' -Append
    }
    else {

        $directoryPath = $files.FullName
        # get the location from the location list
        $location = $locationList[$count]
        # get the file with the name "Core" + location
        $coreFile = Get-ChildItem -Path $directoryPath -Filter "Core $location*"
        # output all files found to outputDCM.txt
        $coreFile | ForEach-Object {
            "$part$num = " +$_.FullName | Out-File -FilePath 'outputDCMt.txt' -Append
        }
        $count++
        

    }
        
}