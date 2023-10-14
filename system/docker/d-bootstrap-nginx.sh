#!/bin/bash
set -e

directory="/etc/nginx"

while IFS= read -r file; do

  for e in "${!NGINX_@}"; do

      sed -i -e 's!__'"$e"'__!'"$(printenv "$e")"'!g' "$file"

  done

done < <(find "$directory" -name "*.conf")
