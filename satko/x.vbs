Set Wnet = Wscript.CreateObject("Wscript.Network")
On error resume next
Wnet.EnumNetworkDrives()
Wnet.RemoveNetworkDrive("X:")
Wnet.MapNetworkDrive "X:", "\\dc-002\ADM"