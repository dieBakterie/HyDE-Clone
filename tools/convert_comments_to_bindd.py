# Dateipfad der zu lesenden Konfigurationsdatei
input_dateipfad = "C:\\Users\\Bakterie\\GitHub\\hyde\\tools\\legacy\\old_silo_keybindings.conf"
# Dateipfad der geschriebenen Konfigurationsdatei
output_dateipfad = "C:\\Users\\Bakterie\\GitHub\\hyde\\tools\\legacy\\neue_keybindings.conf"

# Öffnen der Eingabedatei zum Lesen
with open(input_dateipfad, 'r') as eingabe_datei:
    # Öffnen der Ausgabedatei zum Schreiben
    with open(output_dateipfad, 'w') as ausgabe_datei:
        # Durchlaufen jeder Zeile in der Eingabedatei
        for zeile in eingabe_datei:
            # Überprüfen, ob die Zeile einen Kommentar enthält
            if 'exec' in zeile and '#' in zeile:
                # Teilen der Zeile an der Stelle des Kommentars
                befehlsteil, kommentarteil = zeile.split('#', 1)
                kommentarteil = kommentarteil.strip()  # Entfernen von Leerzeichen am Anfang/Ende
                # Einfügen des Kommentars vor 'exec'
                modifizierte_zeile = befehlsteil.replace('exec', f'{kommentarteil}, exec')
                # Schreiben der modifizierten Zeile in die Ausgabedatei
                ausgabe_datei.write(modifizierte_zeile + '\n')
            else:
                # Schreiben der unveränderten Zeile in die Ausgabedatei
                ausgabe_datei.write(zeile)