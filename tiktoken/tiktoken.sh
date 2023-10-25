#!/usr/bin/env bash

printf "Documentation for tiktoken-go/tokenizer"

printf "\n## Codecs:"
oak go consts tiktoken-go/tokenizer/tokenizer.go

printf "\n## Definitions:"
oak go definitions tiktoken-go/tokenizer/tokenizer.go

print "\ncodec.Encode(str) returns tokenIds, tokenStrings, err\n"