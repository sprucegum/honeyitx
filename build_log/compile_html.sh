#!/bin/bash
#hevea article.hva build_log.tex
./optimize_media.js
pandoc --css pandoc.css -s build_log.tex -o index.html
aws s3 cp index.html s3://jade.lacos.se/projects/killa_b/index.html
aws s3 cp pandoc.css s3://jade.lacos.se/projects/killa_b/pandoc.css
aws s3 sync pics/ s3://jade.lacos.se/projects/killa_b/pics/
aws cloudfront create-invalidation --distribution-id ET86LM3P2NS1C --paths "/projects/killa_b/*"
