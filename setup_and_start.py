#!/usr/bin/env python3
"""
Esegue in sequenza: setup.sh, setup_vnc.sh, start_desktop.sh
"""

import subprocess
import sys
import os

# Cambia directory allo script corrente
os.chdir(os.path.dirname(os.path.abspath(__file__)))

scripts = [
    "setup.sh",
    "setup_vnc.sh",
    "start_desktop.sh"
]

for script in scripts:
    print(f"\n{'='*50}")
    print(f"▶️  Esecuzione: {script}")
    print('='*50)
    
    result = subprocess.run(["bash", script])
    
    if result.returncode != 0:
        print(f"❌ Errore durante l'esecuzione di {script} (exit code: {result.returncode})")
        sys.exit(result.returncode)
    
    print(f"✅ {script} completato con successo")

print("\n" + "="*50)
print("🎉 Tutti gli script sono stati eseguiti con successo!")
print("="*50)
