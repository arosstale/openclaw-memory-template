#!/bin/bash
# OpenClaw V2.1 Elite - Thermal Safety Check
# Strict thermal thresholds for Pi 5 during heavy compute (LLM mutation cycles)

set -e

# Thermal thresholds (in millidegrees Celsius)
TEMP_WARNING=68000   # 68°C - Start cool down
TEMP_HARD_LIMIT=72000  # 72°C - Hard abort
TEMP_RESUME=65000      # 65°C - Safe to resume

COOL_DOWN_SECONDS=60
THERMAL_ZONE="${1:-thermal_zone0}"

echo "🌡️  OpenClaw V2.1 Elite - Thermal Safety Check"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Warning threshold: $((TEMP_WARNING / 1000))°C"
echo "Hard limit:      $((TEMP_HARD_LIMIT / 1000))°C"
echo "Cool down:       ${COOL_DOWN_SECONDS}s"
echo ""

# Function to read CPU temperature
read_temp() {
    cat "/sys/class/thermal/$THERMAL_ZONE/temp" 2>/dev/null || echo "0"
}

# Function to display thermal status
display_status() {
    local temp=$1
    local temp_c=$((temp / 1000))

    if [ "$temp" -ge "$TEMP_HARD_LIMIT" ]; then
        echo "🔴 CRITICAL: ${temp_c}°C - Above hard limit!"
    elif [ "$temp" -ge "$TEMP_WARNING" ]; then
        echo "🟠 WARNING:  ${temp_c}°C - Above warning threshold"
    else
        echo "🟢 OK:       ${temp_c}°C - Within safe range"
    fi
}

# Main thermal check loop
thermal_check() {
    local temp=$(read_temp)
    local temp_c=$((temp / 1000))

    display_status "$temp"

    # Hard limit check
    if [ "$temp" -ge "$TEMP_HARD_LIMIT" ]; then
        echo ""
        echo "❌ THERMAL HARD LIMIT EXCEEDED!"
        echo "Current: ${temp_c}°C | Limit: $((TEMP_HARD_LIMIT / 1000))°C"
        echo "Aborting operation immediately."
        echo ""
        echo "To resume: Wait for CPU to cool below $((TEMP_RESUME / 1000))°C"
        exit 1
    fi

    # Warning threshold check
    if [ "$temp" -ge "$TEMP_WARNING" ]; then
        echo ""
        echo "⚠️  THERMAL WARNING: CPU at ${temp_c}°C"
        echo "Initiating ${COOL_DOWN_SECONDS}-second cool down period..."
        echo ""

        local start_time=$(date +%s)
        local end_time=$((start_time + COOL_DOWN_SECONDS))

        while [ "$(date +%s)" -lt "$end_time" ]; do
            local remaining=$((end_time - $(date +%s)))
            local current_temp=$(read_temp)
            local current_temp_c=$((current_temp / 1000))

            echo -ne "\r⏳ Cooling: ${remaining}s remaining | Current: ${current_temp_c}°C | Target: <$((TEMP_RESUME / 1000))°C"
            sleep 1
        done

        echo ""
        echo ""

        # Re-check after cool down
        local post_cool_temp=$(read_temp)
        local post_cool_temp_c=$((post_cool_temp / 1000))

        echo "📊 Post-cool down temperature: ${post_cool_temp_c}°C"

        if [ "$post_cool_temp" -le "$TEMP_RESUME" ]; then
            echo "✅ Temperature safe for operation"
            return 0
        else
            echo "⚠️  Temperature still elevated: ${post_cool_temp_c}°C"
            echo "Recommendation: Extend cool down or reduce workload"
            return 1
        fi
    fi

    return 0
}

# Main execution
if thermal_check; then
    echo ""
    echo "✅ Thermal check passed. Proceeding with operation."
    exit 0
else
    echo ""
    echo "❌ Thermal check failed. Operation aborted."
    exit 1
fi
