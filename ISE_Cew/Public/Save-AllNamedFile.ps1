Function Save-AllNamedFile { 
    <#
        .SYNOPSIS
        Saves all Files in a PowerShell ISE Tab that already have a filename
         
        .DESCRIPTION
        This uses $PSISE.CurrentFiles to save all files that have been edited in the session
   
        This will save the file in the location determined by the $PSISE.CurrentFile.FullPath for each open file
        (uses $PSISE.CurrentPowerShellTab.Files to find them all) and then does a where loop
        (Which should be in a PSDrive for ease of access because you do use PSDrives right??)
   
        Also as I would expect that your using Git for Source control (You are using source control right??) 
        this will also commit the file saves to Git on the basis that the files you have been working on are stored
        in either the root of the directory of a Git Repo or is in a subdirectory and will traverse upwards until the 
        function finds the directory that contains the Git Repo Store i.e the folder that contains a hidden subfolder called .git

        If not then you NEED to learn Git and start to use it - this function makes it so much simpler to deal with as well!  
        
        .EXAMPLE
        Save-AllUnnamedFiles
        
        .EXAMPLE
        Place into your Profile the following

        if ($host.Name -eq "Windows PowerShell ISE Host") {
        $MyMenu = $psise.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("PSISE_Addons",$null,$null)
        $MyMenu.Submenus.Add("Save & Commit Current ISE File", { Save-CurrentISEFile }, "Ctrl+Alt+Shift+S") | Out-Null
        $MyMenu.Submenus.Add("Save & Commit all files that have been named", { Save-AllNamedFile }, "Ctrl+Shift+S") | Out-Null
        $MyMenu.Submenus.Add("Save & Commit all unnamed files", { Save-AllUnnamedFile -GeneralModuleDetails $psd1 }, "Ctrl+Alt+S") | Out-Null
        }

        Now you can run this function using Ctrl+Alt+S and the sister function to this one, Save-AllNamedFile with Ctrl+Shift+S and it's other more popular sister
        Save-CurrentISEFile using Ctrl+Alt+Shift+S
        
        .OUTPUTS
        Updated Saved PowerShell scripts/module files and Git Commits
        
        .NOTES
        This Function drastically makes Source control with git much easier to deal with and ensures that you never miss a small 
        change to a script
        AUTHOR
        Ryan Yates - ryan.yates@kilasuit.org
        LICENSE
        MIT 
        CREDITS
        Jeff Hicks Blog about extending the ISE with Addons as can be found at 
        https://www.petri.com/using-addonsmenu-property-powershell-ise-object-model
        TO-DO
        Neaten this up and build a V2 version
    #>
    #Requires -Version 4.0
    [cmdletbinding()]
    param ()
    If ($host.Name -ne 'Windows PowerShell ISE Host')
    { Write-Warning 'Unable to be used in the console please use this in PowerShell ISE'}
    else {
        $oldlocation = Get-Location
        $psise.CurrentPowerShellTab.Files.Where(
        {-Not $_.IsUntitled -and -not $_.IsSaved}).Foreach(
            {$_.save() ; 
            $displayname = $($_.DisplayName.Replace('*','')) ; 
            Set-Location $_.FullPath.Replace($DisplayName,'') ; 
                if((test-path .\.git\) -eq $true) 
                { git add $displayname ; 
                    $CustomCommit = Request-YesOrNo -title 'Pre-Commit Message' -message 'Do you want to provide a Custom Commit Message'
                    if($CustomCommit) {$CustomCommitMessage = Get-CustomCommitMessage -filename $displayname ; git commit -m $CustomCommitMessage }
                    else { git commit -m "Saving file $displayname at $(get-date -Format "dd/MM/yyyy HH:mm") and commiting to Repo"} 
                }
                else {
                do {Set-Location .. } until ((Test-Path .\.git\) -eq $true) } ;
                $gitfolder = Get-Item .\ ; 
                $gitfile = $_.FullPath.Replace("$($gitfolder.FullName)","").TrimStart('\') ; 
                git add $gitfile ;
                $CustomCommit = Request-YesOrNo -title 'Pre-Commit Message' -message 'Do you want to provide a Custom Commit Message'
                if($CustomCommit) {$CustomCommitMessage = Get-CustomCommitMessage -filename $displayname ; git commit -m $CustomCommitMessage }
                else { git commit -m "Saving file $gitfile at $(get-date -Format "dd/MM/yyyy HH:mm") and commiting to Repo"} ;
           })
    #Correct Location for the Set-Location as in the Else loop from the 1st If
    Set-Location $oldlocation
    }

}