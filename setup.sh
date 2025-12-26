#!/bin/bash

# =============================================================================
# Installazione pacchetti per Pygame + VNC su GitHub Codespaces
# Esegui con: bash install_pygame.sh
# =============================================================================

set -e  # Esce in caso di errore

echo "🚀 Inizio installazione pacchetti..."

# -----------------------------------------------------------------------------
# 1. Aggiorna i pacchetti
# -----------------------------------------------------------------------------
echo "📦 Aggiornamento pacchetti..."
sudo apt-get update

# -----------------------------------------------------------------------------
# 2. Installa dipendenze per VNC e desktop
# -----------------------------------------------------------------------------
echo "🖥️ Installazione VNC e desktop environment..."
sudo apt-get install -y \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    dbus-x11 \
    x11-utils \
    x11-xserver-utils \
    xdg-utils \
    fluxbox \
    lxterminal \
    nano


# -----------------------------------------------------------------------------
# 4. Installa pygame e pymunk
# -----------------------------------------------------------------------------
echo "🎮 Installazione pygame e pymunk..."
pip install --break-system-packages pygame pymunk

# -----------------------------------------------------------------------------
# 5. Configura redirect noVNC
# -----------------------------------------------------------------------------
echo "🔗 Configurazione redirect noVNC..."
sudo ln -sf vnc.html /usr/share/novnc/index.html

# -----------------------------------------------------------------------------
# Personalizza Menu FluxBox (mostra solo il terminale)
# -----------------------------------------------------------------------------

mkdir -p ~/.fluxbox
cat > ~/.fluxbox/menu << 'EOF'
[begin] (Fluxbox)
  [exec] (Terminal) {lxterminal -e bash}
  [separator]
  [restart] (Restart)
  [exit] (Exit)
[end]
EOF

# Configura il terminale grafico
#sed -i 's/^color_preset=.*/color_preset=Tango/' ~/.config/lxterminal/lxterminal.conf


# -----------------------------------------------------------------------------
# 6. Pulizia
# -----------------------------------------------------------------------------
#echo "🧹 Pulizia..."
#sudo apt-get clean
#sudo rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# Completato!
# -----------------------------------------------------------------------------
echo ""
echo "=============================================="
echo "✅ Installazione completata!"
echo "=============================================="
