enable-computerrestore -drive "C:\"
vssadmin Resize ShadowStorage /For=C: /On=C: /Maxsize=10%
checkpoint-computer -description "System Restore"