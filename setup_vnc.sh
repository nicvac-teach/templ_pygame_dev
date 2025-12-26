#!/bin/bash

# =============================================================================
# Configurazione VNC per Pygame su GitHub Codespaces
# Esegui con: bash config_vnc.sh
# =============================================================================

echo "🔧 Configurazione VNC..."

# -----------------------------------------------------------------------------
# 1. Crea cartella .vnc
# -----------------------------------------------------------------------------
mkdir -p ~/.vnc

# -----------------------------------------------------------------------------
# 2. Crea file xstartup per fluxbox
# -----------------------------------------------------------------------------
cat > ~/.vnc/xstartup << 'EOF'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XDG_CURRENT_DESKTOP=fluxbox
export DISPLAY=:1

# Avvia dbus se necessario
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax)
fi

# Avvia fluxbox in foreground
exec startfluxbox
EOF
chmod +x ~/.vnc/xstartup

# -----------------------------------------------------------------------------
# 3. Crea script per avviare VNC + noVNC
# -----------------------------------------------------------------------------
echo "📝 Creazione script di avvio..."
cat > ~/start_desktop.sh << 'EOF'
#!/bin/bash

# Ferma eventuali istanze precedenti
vncserver -kill :1 2>/dev/null || true
pkill -f "websockify" 2>/dev/null || true
sleep 1

# Avvia VNC server (senza password)
echo "🖥️ Avvio VNC server sulla porta 5901..."
vncserver :1 -geometry 1280x720 -depth 24 -localhost no -SecurityTypes None --I-KNOW-THIS-IS-INSECURE

# Attendi che VNC sia pronto
sleep 2

# Verifica che VNC sia attivo
if ! pgrep -f "Xtigervnc :1" > /dev/null; then
    echo "❌ Errore: VNC server non avviato"
    echo "Controlla il log: ~/.vnc/*.log"
    exit 1
fi

# Avvia noVNC (websockify) in background
echo "🌐 Avvio noVNC sulla porta 6080..."
nohup /usr/share/novnc/utils/novnc_proxy --vnc localhost:5901 --listen 6080 > /tmp/novnc.log 2>&1 &

sleep 1

echo ""
echo "=============================================="
echo "✅ Desktop pronto!"
echo "=============================================="
echo "👉 Apri la porta 6080 dalla tab PORTS"
echo ""
echo "Per fermare: stop_desktop.sh"
echo ""
EOF
chmod +x ~/start_desktop.sh

# -----------------------------------------------------------------------------
# 4. Crea script per fermare VNC
# -----------------------------------------------------------------------------
cat > ~/stop_desktop.sh << 'EOF'
#!/bin/bash
echo "Fermando VNC e noVNC..."
vncserver -kill :1 2>/dev/null || true
pkill -f "websockify" 2>/dev/null || true
echo "✅ Desktop fermato."
EOF
chmod +x ~/stop_desktop.sh

# Link per esecuzione diretta
sudo ln -sf ~/start_desktop.sh ~/.local/bin/
sudo ln -sf ~/stop_desktop.sh ~/.local/bin/


# -----------------------------------------------------------------------------
# Completato!
# -----------------------------------------------------------------------------
echo ""
echo "=============================================="
echo "✅ Configurazione VNC completata!"
echo "=============================================="
echo ""
echo "Per avviare il desktop grafico:"
echo "  start_desktop.sh"
echo ""
echo "Per fermarlo:"
echo "  stop_desktop.sh"
echo ""