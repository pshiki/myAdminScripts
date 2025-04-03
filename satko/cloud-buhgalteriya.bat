@echo off

rem DISK x, w

if exist x: net use z: /delete
net use x: \\dc-002\ADM

if exist w: net use w: /delete
net use w: \\192.168.200.5\buhgalteriya password /User:buhgalteriya

