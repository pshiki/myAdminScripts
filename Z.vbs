Set Wnet = Wscript.CreateObject("Wscript.Network")
On error resume next
Wnet.EnumNetworkDrives()
Wnet.RemoveNetworkDrive("Q:")
Wnet.RemoveNetworkDrive("W:")
Wnet.MapNetworkDrive "Q:", "\\192.168.0.56\company"
Wnet.MapNetworkDrive "W:", "\\192.168.0.239\InfoBases", , "user", "pass"