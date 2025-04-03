Set Wnet = Wscript.CreateObject("Wscript.Network")
On error resume next
Wnet.EnumNetworkDrives()
Wnet.RemoveNetworkDrive("X:")
Wnet.MapNetworkDrive "X:", "\\dc-002\ADM"
Wnet.RemoveNetworkDrive("Y:")
Wnet.MapNetworkDrive "Y:", "\\dc-002\Revezenskaya"
Wnet.RemoveNetworkDrive("U:")
Wnet.MapNetworkDrive "U:", "\\dc-002\srv-buh-exchange"
Wnet.RemoveNetworkDrive("W:")