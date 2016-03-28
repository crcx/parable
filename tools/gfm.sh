#!/bin/bash

curl --data-binary @$1 -H "Content-Type:text/plain" -s https://api.github.com/markdown/raw
