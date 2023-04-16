#!/bin/bash

# Source: https://gist.github.com/rattletat/4a1098d5c1e7c8db1fe52d4740076808
# This is heavily based on this code here:
# https://gist.github.com/maikeldotuk/54a91c21ed9623705fdce7bab2989742
# Which is heavily based on this code here:
# https://gist.github.com/enpassant/0496e3db19e32e110edca03647c36541
# Special thank you to the user enpassant for starting it https://github.com/enpassant

# ARGUMENT PARSING
# Do not overwrite (0) or overwrite (1)
OVERWRITE="${1}"
# Syntax chosen for the wiki
SYNTAX="${2}"
# File extension for the wiki
EXTENSION="${3}"
# Full path of the output directory
OUTPUTDIR="${4}"
# Full path of the wiki page
INPUT="${5}"
# Full path of the css file for this wiki
CSSFILENAME="$(basename "$6")"
# Full path to the wiki's template
TEMPLATE_PATH="${7}"
# The default template name
TEMPLATE_DEFAULT="${8}"
# The extension of template files
TEMPLATE_EXT="${9}"
# Count of '../' for pages buried in subdirs up to wiki md root
ROOT_PATH="${10}"

# If file is in vimwiki base dir, the root path is '-'
[[ "${ROOT_PATH}" = "-" ]] && ROOT_PATH=''

# Example: index
FILE="$(basename "$INPUT")"
# Example: index.md
FILENAME="$(basename "$INPUT" ."$EXTENSION")"
# Example: /home/rattletat/wiki/text/uni/
FILEPATH="${INPUT%$FILE}"
# Example: /home/rattletat/wiki/html/uni/index
OUTPUT="${OUTPUTDIR}${FILENAME}"

# PANDOC ARGUMENTS

# PREPANDOC PROCESSING AND PANDOC

# cd to output directory for pandoc filter resources images
cd "${OUTPUTDIR}"

pandoc_template="pandoc \
    --katex \
    --template=${TEMPLATE_PATH}${TEMPLATE_DEFAULT}${TEMPLATE_EXT} \
    --from=${SYNTAX}+emoji \
    --to=html \
    --include-before-body ${ROOT_PATH}../nav \
    --table-of-contents \
    --toc-depth=4 \
    --standalone \
    --resource-path=${OUTPUTDIR} \
    --metadata=root_path:${ROOT_PATH}"

# Searches for markdown anchor links and append '.html' or replace
# '.md' if exist after the filename
# Sample anchor links:
# [Some Text](filename#anchor-name)
# [Some Text](filename.md#anchor-name)
regex1='s/(\[?(.|\n|\t)+\])\((.+?)(\.md)?#([^#)]+)\)/\1(\3.html#\5)/g'

# Searches for markdown links (with or without extension or .md) and appends a
# .html at the end of filename
# Sample links:
# [Some Text](filename.md)
# [Some Text](../../filename)
regex2='s/(\[.+\])\((((\.\.\/)+)?([^.#)]+))(\.md\)|\))/\1(\2.html)/g'

# Removes placeholder title from vimwiki markdown file
regex3='s/^%title (.+)$/---\ntitle: \1\n---/'

pandoc_input=$(cat "$INPUT" | perl -pe "${regex1}" | sed -r "${regex2};${regex3}")
pandoc_output=$(echo "${pandoc_input}" | ${pandoc_template})

# POSTPANDOC PROCESSING

# Removes "vfile" and "file" from links
# e.g., ![pic of sharks](file:../sharks.jpg) -> ![pic of sharks](../sharks.jpg)
regex4='s/vfile://g'
regex5='s/file://g'

echo "${pandoc_output}" | sed -r "${regex4};${regex5}" > "${OUTPUT}.html"
