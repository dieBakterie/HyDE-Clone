#!/usr/bin/env bash

# Schleife durch alle .sh, .zsh, .zshrc, .py, .md, .conf, .kvconfig, .svg, .css, .dcol, .theme, .json, .jsonc, .lst, .t1, .t2 und .t3 Dateien im aktuellen Verzeichnis und in allen Unterverzeichnissen
find . \( -name "*.sh" -o -name "*.zsh" -o -name "*.zshrc" -o -name "*.py" -o -name "*.md" -o -name "*.conf" -o -name "*.kvconfig" -o -name "*.svg" -o -name "*.css" -o -name "*.dcol" -o -name "*.theme" -o -name "*.json" -o -name "*.jsonc" -o -name "*.lst" -o -name "*.t1" -o -name "*.t2" -o -name "*.t3" \) -type f | while read -r file; do
    # CR (Carriage Return) entfernen und die Datei überschreiben
    tr -d '\r' <"$file" >temp_file && mv temp_file "$file"

    # Wenn die Datei eine .sh, .zsh, .zshrc oder .py Datei ist, setze die Ausführungsberechtigung
    if [[ "${file##*.}" = "sh" || "${file##*.}" = "zsh" || "${file##*.}" = "zshrc" || "${file##*.}" = "py" ]]; then
        chmod +x "$file"
        echo "Ausführungsberechtigung gesetzt: $file"
    fi

    echo "Bearbeitet: $file"
done

echo "Alle angegebenen Dateien wurden bearbeitet."
