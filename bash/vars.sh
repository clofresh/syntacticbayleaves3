 #!/bin/bash -x

. $1
# https://gist.github.com/oneohthree/f528c7ae1e701ad990e6
export BLOG_SLUG=$(echo "$BLOG_TITLE" \
                    | iconv -t ascii//TRANSLIT \
                    | sed -r s/[^a-zA-Z0-9]+/-/g \
                    | sed -r s/^-+\|-+$//g \
                    | tr A-Z a-z)
