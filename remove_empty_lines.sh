#!/bin/env bash

# Schleife durch alle .sh, .zsh, .zshrc, .py, .md, .conf, .kvconfig, .svg, .css, .dcol, .theme, .json, .jsonc, .lst, .t1, .t2 und .t3 Dateien im aktuellen Verzeichnis und in allen Unterverzeichnissen
find . \( -name "*.sh" -o -name "*.zsh" -o -name "*.zshrc" -o -name "*.py" -o -name "*.md" -o -name "*.conf" -o -name "*.kvconfig" -o -name "*.svg" -o -name "*.css" -o -name "*.dcol" -o -name "*.theme" -o -name "*.lst" -o -name "*.t1" -o -name "*.t2" -o -name "*.t3" \) -type f | while read -r file; do
    # Entferne die letzte leere Zeile, falls vorhanden
    sed -i '${/^$/d}' "$file"

    echo "Bearbeitet: $file"
done

echo "Alle angegebenen Dateien wurden bearbeitet."