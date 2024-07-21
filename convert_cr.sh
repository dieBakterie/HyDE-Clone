#!/bin/env bash

# Schleife durch alle .sh, .md, .conf, .dcol, .theme, .zsh, .jsonc, .json, t1, t2 und t3 Dateien im aktuellen Verzeichnis und in allen Unterverzeichnissen
find . \( -name "*.sh" -o -name "*.md" -o -name "*.conf" -o -name "*.dcol" -o -name "*.theme" -o -name "*.zsh" -o -name "*.jsonc" -o -name "*.json" -o -name "*.t1" -o -name "*.t2" -o -name "*.t3" \) -type f | while read -r file; do
    # CR (Carriage Return) entfernen und die Datei überschreiben
    tr -d '\r' <"$file" >temp_file && mv temp_file "$file"
    echo "Bearbeitet: $file"
done

echo "Alle angegebenen Dateien wurden bearbeitet."
