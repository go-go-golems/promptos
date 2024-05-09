#!/usr/bin/env bash

pwd
printf "Documentation for tiktoken-go/tokenizer"

printf "\n## Codecs:"
oak go consts tiktoken-go/tokenizer/tokenizer.go

printf "\n## Definitions:"
oak go definitions tiktoken-go/tokenizer/tokenizer.go

printf "\ncodec.Encode(str) returns tokenIds, tokenStrings, err\n"