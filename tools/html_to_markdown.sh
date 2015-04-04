#!/bin/sh
cat $1 | sed 's/<h1>/# /g' | sed 's/<\/h1>//g' | sed 's/<h2>/## /g' | sed 's/<\/h2>//g' | sed 's/<h3>/### /g' | sed 's/<\/h3>//g' | sed 's/<p>//g' | sed 's/<\/p>//g' | sed 's/<strong>/**/g' | sed 's/<\/strong>/**/g' | sed 's/<em>/*/g' | sed 's/<\/em>/*/g' | sed 's/<code><pre>//g' | sed 's/<\/pre><\/code>//g' | sed 's/<pre><code>//g' | sed 's/<\/code><\/pre>//g'
