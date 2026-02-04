#!/usr/bin/env bash

response=$(curl -s "https://dummyjson.com/quotes/random")
echo "$response" | jq -r '.quote'
echo "$response" | jq -r '.author'
