Set Wnet = Wscript.CreateObject("Wscript.Network")
On error resume next
Wnet.EnumNetworkDrives()
Wnet.RemoveNetworkDrive("W:")