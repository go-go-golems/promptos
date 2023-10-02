#!/usr/bin/env bash

oak go definitions --definition-type function,interface charmbracelet/mods/mods.go

for i in Update receiveCompletionStreamCmd; do
    oak go definitions charmbracelet/mods/mods.go --with-body --function-name "$i"
done
