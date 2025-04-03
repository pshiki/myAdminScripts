Set Wnet = Wscript.CreateObject("Wscript.Network")
On error resume next
Wnet.EnumNetworkDrives()
Wnet.RemoveNetworkDrive("W:")
Wnet.MapNetworkDrive "W:", "\\192.168.200.5\naumova", , "Naumova", "passwd"