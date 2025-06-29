

#!/bin/bash

clear

cat <<'EOF'
 _   _      _                      _         _   _      _                 
| \ | | ___| |___      _____  _ __| | __    | | | | ___| |_ __   ___ _ __ 
|  \| |/ _ \ __\ \ /\ / / _ \| '__| |/ /____| |_| |/ _ \ | '_ \ / _ \ '__|
| |\  |  __/ |_ \ V  V / (_) | |  |   <_____|  _  |  __/ | |_) |  __/ |   
|_| \_|\___|\__| \_/\_/ \___/|_|  |_|\_\    |_| |_|\___|_| .__/ \___|_|   
                                                         |_|              
EOF

# ─── Input Check ─────────────────────────────
if [ -z "$1" ]; then
    echo "❌ Usage: $0 <IP_or_hostname>"
    exit 1
fi

TARGET="$1"
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
FILENAME="network_report_${TARGET//./_}_$TIMESTAMP.txt"

# ─── Tool Check ──────────────────────────────
for tool in ping mtr traceroute; do
    if ! command -v $tool &> /dev/null; then
        echo "❌ $tool is not installed. Install it first."
        exit 1
    fi
done

# ─── Silent Test Execution ───────────────────
echo "🚀 Starting network diagnostics for $TARGET..."
echo "📡 Step 1: Running ping..."
PING_OUTPUT=$(ping -c 10 "$TARGET" 2>&1)

echo "🔍 Step 2: Running mtr..."
MTR_OUTPUT=$(mtr -rw -c 10 "$TARGET" 2>&1)

echo "🗺️  Step 3: Running traceroute..."
TRACE_OUTPUT=$(traceroute "$TARGET" 2>&1)

# ─── Summarize Ping Results ──────────────────
PACKET_LOSS=$(echo "$PING_OUTPUT" | grep -oP '\d+(?=% packet loss)' | head -1)
AVG_LATENCY=$(echo "$PING_OUTPUT" | grep 'rtt min/avg/max' | cut -d'=' -f2 | cut -d'/' -f2)

# ─── Summarize MTR Results ───────────────────
MTR_LOSS=$(echo "$MTR_OUTPUT" | awk 'NR>2 {loss+=$2; count++} END {if(count>0) printf "%.1f", loss/count; else print "N/A"}')

# ─── Print Summary ───────────────────────────
echo ""
echo "📊 Summary for $TARGET:"
echo "────────────────────────────────────"
echo "📶 Packet Loss (ping):     ${PACKET_LOSS:-N/A}%"
echo "⏱️  Avg Latency (ping):    ${AVG_LATENCY:-N/A} ms"
echo "❗ Avg Loss (mtr):          ${MTR_LOSS:-N/A}%"
echo ""

# ─── User Prompt to Save Report ──────────────
read -p "📁 Do you want to save the full diagnostic report to a text file? (y/n): " SAVE

if [[ "$SAVE" == "y" || "$SAVE" == "Y" ]]; then
    {
        echo "📡 Network Diagnostics Report"
        echo "Target: $TARGET"
        echo "Date: $(date)"
        echo "=================================="

        echo -e "\n📶 PING Output:"
        echo "----------------------------------"
        echo "$PING_OUTPUT"

        echo -e "\n🔍 MTR Output:"
        echo "----------------------------------"
        echo "$MTR_OUTPUT"

        echo -e "\n🗺️ TRACEROUTE Output:"
        echo "----------------------------------"
        echo "$TRACE_OUTPUT"

        echo -e "\n📊 Summary:"
        echo "----------------------------------"
        echo "Packet Loss (ping): $PACKET_LOSS%"
        echo "Avg Latency (ping): $AVG_LATENCY ms"
        echo "Avg Loss (mtr): $MTR_LOSS%"
    } > "$FILENAME"

    echo "✅ Report saved to: $FILENAME"
else
    echo "🚫 Report not saved."
fi
