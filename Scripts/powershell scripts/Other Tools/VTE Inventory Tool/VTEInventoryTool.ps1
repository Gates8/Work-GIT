##############################################
# Austin Hamrick                             #
# Ver: 1.0                                   #
# Date: July 14th, 2021                      #
# Description: Provides a GUI for adding     #
#   items to an inventory CSV.               #
##############################################

######################################################################
# Bugs:                                                              #
# 	* When trying to input a CSV path, path is blank.                #
#	* Need to add in a revert path function, in case of path error   #
######################################################################

######################################################################
#ToDo:                                                               #
#  * Add some sort of confirmation that information has been added   #
#    that is not too intrusive                                       #
#  * Figure out a way to put a browse button instead of user setting #
#    path                                                            #
######################################################################

Add-Type -AssemblyName System.Windows.Forms

#Some font styling stuff
$Font = "Microsoft Sans Serif"
$FontSize = 8
$Font_Properties = [System.Drawing.Font]::new($Font, $FontSize, [System.Drawing.FontStyle]::Underline)

#Path Variables
$CSV_Path = $CSV_TB.Text

#Functions
Function Clear-TBs{
    $D_TB.Clear()
    $T_TB.Clear()
    $Mfr_TB.Clear()
    $Mod_TB.Clear()
    $Ser_TB.Clear()
    $IP_TB.Clear()
    $Mac_TB.Clear()
    $Quant_TB.Clear()
}

#Begin Main Form Settings
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text = 'VTE Inventory Tool'
$main_form.Width = 600
$main_form.Height = 400
#End Main Form Settings

#Description Label
$D_Label = New-Object System.Windows.Forms.Label
$D_Label.Text = "Description"
$D_Label.Location = New-Object System.Drawing.Point(5,10)
$D_Label.AutoSize = $true
$D_Label.Font = $Font_Properties

#Description Textbox
$D_TB = New-Object System.Windows.Forms.TextBox
$D_TB.Location = New-Object System.Drawing.Point(5,30)
$D_TB.Width = 300
$D_TB.Height = 150

#CSV Path Label
$CSV_Label = New-Object System.Windows.Forms.Label
$CSV_Label.Text = "CSV Save Location"
$CSV_Label.Location = New-Object System.Drawing.Point(320,60)
$CSV_Label.AutoSize = $true
$CSV_Label.Font = $Font_Properties

#CSV Textbox
$CSV_TB = New-Object System.Windows.Forms.TextBox
$CSV_TB.Location = New-Object System.Drawing.Point(320,84)
$CSV_TB.Width = 200

#Type Label
$T_Label = New-Object System.Windows.Forms.Label
$T_Label.Text = "Type"
$T_Label.Location = New-Object System.Drawing.Point(5,60)
$T_Label.Font = $Font_Properties

#Type Textbox
$T_TB = New-Object System.Windows.Forms.TextBox
$T_TB.Location = New-Object System.Drawing.Point(5,84)
$T_TB.Width = 300
$T_TB.Height = 150

#Manufacture Label
$Mfr_Label = New-Object System.Windows.Forms.Label
$Mfr_Label.Text = "Manufacture"
$Mfr_Label.Location = New-Object System.Drawing.Point(5, 110)
$Mfr_Label.Font = $Font_Properties

#Manufacture Textbox
$Mfr_TB = New-Object System.Windows.Forms.TextBox
$Mfr_TB.Location = New-Object System.Drawing.Point(5, 135)
$Mfr_TB.Width = 300
$Mfr_TB.Height = 150

#Model Label
$Mod_Label = New-Object System.Windows.Forms.Label 
$Mod_Label.Text = "Model"
$Mod_Label.Location = New-Object System.Drawing.Point(5, 165)
$Mod_Label.Font = $Font_Properties

#Model Textbox
$Mod_TB = New-Object System.Windows.Forms.TextBox
$Mod_TB.Location = New-Object System.Drawing.Point(5, 190)
$Mod_TB.Width = 300
$Mod_TB.Height = 150


#Serial Number Label
$Ser_Label = New-Object System.Windows.Forms.Label
$Ser_Label.Text = "Serial Number"
$Ser_Label.Location = New-Object System.Drawing.Point(5, 215)
$Ser_Label.Font = $Font_Properties

#Serial Number Textbox
$Ser_TB = New-Object System.Windows.Forms.TextBox
$Ser_TB.Location = New-Object System.Drawing.Point(5, 240)
$Ser_TB.Width = 300
$Ser_TB.Height = 150

#IP Label
$IP_Label = New-Object System.Windows.Forms.Label
$IP_Label.Text = "IP Address"
$IP_Label.Location = New-Object System.Drawing.Point(5,265)
$IP_Label.Font = $Font_Properties

#IP Textbox
$IP_TB = New-Object System.Windows.Forms.TextBox
$IP_TB.Location = New-Object System.Drawing.Point(5, 290)
$IP_TB.Width = 300
$IP_TB.Height = 150

#MAC Address Label
$MAC_Label = New-Object System.Windows.Forms.Label
$MAC_Label.Text = "MAC Address"
$MAC_Label.Location = New-Object System.Drawing.Point(5, 312)
$MAC_Label.Font = $Font_Properties

#MAC Address textbox
$MAC_TB = New-Object System.Windows.Forms.TextBox
$MAC_TB.Location = New-Object System.Drawing.Point(5, 335)
$MAC_TB.Width = 300
$MAC_TB.Height = 150

#Quantity Label
$Quant_Label = New-Object System.Windows.Forms.Label
$Quant_Label.Text = "Quantity"
$Quant_Label.Location = New-Object System.Drawing.Point(320, 10)
$Quant_Label.Font = $Font_Properties
$Quant_Label.AutoSize = $True

#Quantity textbox
$Quant_TB = New-Object System.Windows.Forms.Textbox
$Quant_TB.Location = New-Object System.Drawing.Point(320, 30)
$Quant_TB.Width = 200


#Buttons
#CSV Path Button

$CSV_Button = New-Object System.Windows.Forms.Button
$CSV_Button.Location = New-Object System.Drawing.Size(320,110)
$CSV_Button.Text = "Set Save Path"
$CSV_Button.AutoSize = $true

$CSV_Button.Add_Click({
    $CSV_Label.Text = "Currently saving to: $CSV_Path"
    $CSV_TB.Hide()
    $CSV_Button.Hide()
})

#Add To CSV Button
$Add_Button = New-Object System.Windows.Forms.Button
$Add_Button.Location = New-Object System.Drawing.Size(350,334)
$Add_Button.Text = "Add to CSV"


$Add_Button.Add_Click({

    $Table = @{ 'Description' = $D_TB.Text; 'Type' = $T_TB.Text; 'Manufacture' = $Mfr_TB.Text; 'Model' = $Mod_TB.Text; 'Serial' = $Ser_TB.Text; 'IP' = $IP_TB.Text; 'MAC' = $MAC_TB.Text; 'Quantity' = $Quant_TB.Text}
    $Obj = [pscustomobject]$Table

    $Obj | Select @{N="Description";E={$Obj.Description}},
    @{N="Type";E={$Obj.Type}}, 
    @{N="Manufacture";E={$Obj.Manufacture}},
    @{N="Model";E={$Obj.Model}},
    @{N="Serial";E={$Obj.Serial}},
    @{N="IP";E={$Obj.IP}},
    @{N="MAC";E={$Obj.MAC}},
    @{N="Quantity";E={$Obj.Quantity}} | Export-CSV $CSV_Path -Append    

    Clear-TBs
})


#Quit Button
$Quit_Button = New-Object System.Windows.Forms.Button
$Quit_Button.Location = New-Object System.Drawing.Size(450,334)
$Quit_Button.Text = "Quit"

$Quit_Button.Add_Click({

    $main_form.Close()

})

#End Buttons
#Form Stuff
$main_form.Controls.Add($D_Label)
$main_form.Controls.Add($D_TB)
$main_form.Controls.Add($CSV_Label)
$main_form.Controls.Add($CSV_TB)
$main_form.Controls.Add($T_Label)
$main_form.Controls.Add($T_TB)
$main_form.Controls.Add($Mfr_Label)
$main_form.Controls.Add($Mfr_TB)
$main_form.Controls.Add($Mod_Label)
$main_form.Controls.Add($Mod_TB)
$main_form.Controls.Add($Ser_Label)
$main_form.Controls.Add($Ser_TB)
$main_form.Controls.Add($IP_Label)
$main_form.Controls.Add($IP_TB)
$main_form.Controls.Add($MAC_Label)
$main_form.Controls.Add($MAC_TB)
$main_form.Controls.Add($Quant_Label)
$main_form.Controls.Add($Quant_TB)

$main_form.Controls.Add($Add_Button)
$main_form.Controls.Add($Quit_Button)
$main_form.Controls.Add($CSV_Button)
#End Form Stuff

#Show Me
$main_form.ShowDialog()