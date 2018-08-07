#!/bin/bash
#hevea article.hva build_log.tex
./optimize_media
pandoc -s build_log.tex -o build_log.html
