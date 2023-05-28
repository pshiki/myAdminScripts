#!/bin/bash
#version 0.1
for i in $(cat "./itemsFromVmWareIM.txt"); 
	do 
		grep -i "$i" "./ktsgssw.txt"; 
done
