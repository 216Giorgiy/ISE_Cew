Function AlignEquals {
<#
        .SYNOPSIS
        Used to Align text based on the = delimiter - For Splatting
         
        .DESCRIPTION
        Used to Align text based on the = delimiter - For Splatting
        
        .EXAMPLE
        $MyMenu.Submenus.Add("Align = signs in selected text.", { AlignEquals }, 'F6')
                        
        .NOTES
        AUTHOR
        Dave Wyatt
        LICENSE
        MIT 
        
      #>
      [cmdletbinding()]
      param ()
    $psise.CurrentFile.Editor.InsertText((Get-AlignedText -Text $psISE.CurrentFile.Editor.SelectedText -Delimiter '='))

}