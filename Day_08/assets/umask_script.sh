#!/bin/bash

# Name: umask_script
# Author: T-Boyke
# Date: 2026.05.13

### <summary>
### Iteriert über umask-Werte und validiert die resultierenden Dateirechte.
### </summary>

# Werte von der Tafel und aus der PDF
readonly UMASK_VALUES=("022" "031" "035" "057" "077" "024" "046" "013" "026" "135" "356" "246")

# Arbeitsverzeichnis
readonly WORK_DIR="umask_test_results"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR" || exit 1

for val in "${UMASK_VALUES[@]}"; do
    ### <description>
    ### Setzt umask und erstellt Testobjekte.
    ### </description>
    umask "$val"
    
    d_name="dir_$val"
    f_name="file_$val"
    
    mkdir "$d_name"
    touch "$f_name"
    
    echo "--- umask: $val ---"
    
    # Korrigierte Argument-Reihenfolge für printf
    # Platzhalter: %-10s (Name), %4s (Oktal), %11s (Symbolisch)
    
    printf "Verzeichnis: %-10s | Oktal: %4s | Symbolisch: %11s\n" \
        "$d_name" \
        "$(stat -c "%a" "$d_name")" \
        "$(stat -c "%A" "$d_name")"
        
    printf "Datei:       %-10s | Oktal: %4s | Symbolisch: %11s\n" \
        "$f_name" \
        "$(stat -c "%a" "$f_name")" \
        "$(stat -c "%A" "$f_name")"
    
    echo ""
done
