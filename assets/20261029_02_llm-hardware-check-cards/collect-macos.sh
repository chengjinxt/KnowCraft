#!/usr/bin/env bash

set -u
export LC_ALL=C

timestamp="$(date '+%Y%m%d-%H%M%S')"
output_path="${1:-./llm-hardware-report-macos-${timestamp}.txt}"

clean() {
    printf '%s' "$*" | tr '\r\n' '  ' | sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//'
}

section() {
    printf '\n[%s]\n' "$1" >> "$output_path"
}

kv() {
    printf '%s=%s\n' "$1" "$(clean "${2:-}")" >> "$output_path"
}

sysctl_value() {
    sysctl -n "$1" 2>/dev/null || true
}

bytes_to_gib() {
    awk -v bytes="${1:-0}" 'BEGIN { if (bytes > 0) printf "%.2f", bytes / 1073741824; }'
}

command_status() {
    if command -v "$1" >/dev/null 2>&1; then
        kv "$1" 'found'
    else
        kv "$1" 'not_found'
    fi
}

: > "$output_path"
printf 'LLM_HARDWARE_REPORT_V1\n' >> "$output_path"

section 'meta'
kv 'os_family' 'macOS'
kv 'collected_at_utc' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
kv 'privacy' 'No hostname, username, serial number, IP (Internet Protocol) address, MAC (Media Access Control) address, Wi-Fi network name, or process list is collected.'

section 'system'
kv 'product_name' "$(sw_vers -productName 2>/dev/null || true)"
kv 'product_version' "$(sw_vers -productVersion 2>/dev/null || true)"
kv 'build_version' "$(sw_vers -buildVersion 2>/dev/null || true)"
kv 'kernel_name' "$(uname -s)"
kv 'kernel_release' "$(uname -r)"
kv 'architecture' "$(uname -m)"
kv 'hardware_model' "$(sysctl_value hw.model)"

hardware_profile="$(system_profiler SPHardwareDataType 2>/dev/null || true)"
chip_name="$(printf '%s\n' "$hardware_profile" | awk -F: '/^[[:space:]]*(Chip|Processor Name):/ { sub(/^[[:space:]]+/, "", $2); print $2; exit }')"
kv 'chip_or_processor' "$chip_name"

section 'cpu'
kv 'brand_string' "$(sysctl_value machdep.cpu.brand_string)"
kv 'physical_cores' "$(sysctl_value hw.physicalcpu)"
kv 'logical_cores' "$(sysctl_value hw.logicalcpu)"
kv 'performance_cores' "$(sysctl_value hw.perflevel0.physicalcpu)"
kv 'efficiency_cores' "$(sysctl_value hw.perflevel1.physicalcpu)"
kv 'cache_line_bytes' "$(sysctl_value hw.cachelinesize)"

memory_bytes="$(sysctl_value hw.memsize)"
section 'memory'
kv 'installed_unified_or_system_memory_gib' "$(bytes_to_gib "$memory_bytes")"
kv 'swap_usage' "$(sysctl_value vm.swapusage)"

section 'gpu_and_metal'
display_profile="$(system_profiler SPDisplaysDataType 2>/dev/null || true)"
profile_index=0
while IFS= read -r line; do
    [ -z "$line" ] && continue
    kv "display_line_${profile_index}" "$line"
    profile_index=$((profile_index + 1))
done <<EOF
$(printf '%s\n' "$display_profile" | awk '/Chipset Model:|Total Number of Cores:|VRAM|Metal Support:|Metal Family:/ { gsub(/^[[:space:]]+/, ""); print }')
EOF

section 'storage_root'
df_line="$(df -kP / 2>/dev/null | awk 'NR==2 {print $2, $4, $6}')"
kv 'df_kib_total_available_mount' "$df_line"
disk_profile="$(diskutil info / 2>/dev/null || true)"
kv 'solid_state' "$(printf '%s\n' "$disk_profile" | awk -F: '/Solid State:/ { sub(/^[[:space:]]+/, "", $2); print $2; exit }')"
kv 'protocol' "$(printf '%s\n' "$disk_profile" | awk -F: '/Protocol:/ { sub(/^[[:space:]]+/, "", $2); print $2; exit }')"

section 'backend_tools'
for tool in ollama llama-cli llama-server python3 brew; do
    command_status "$tool"
done

section 'tool_versions'
if command -v ollama >/dev/null 2>&1; then
    kv 'ollama' "$(ollama --version 2>&1 | head -n 1)"
fi
if command -v llama-cli >/dev/null 2>&1; then
    kv 'llama_cli' "$(llama-cli --version 2>&1 | head -n 1)"
fi
if command -v llama-server >/dev/null 2>&1; then
    kv 'llama_server' "$(llama-server --version 2>&1 | head -n 1)"
fi

section 'manual_inputs_needed'
kv 'model_file' '<填写完整模型文件名>'
kv 'model_file_size' '<填写实际文件大小>'
kv 'context_length' '<填写计划使用的上下文长度>'
kv 'multimodal' '<填写是否使用图片/音频输入>'
kv 'concurrency' '<填写同时运行的会话数>'

printf 'Report written to: %s\n' "$output_path"
printf 'Please fill in the [manual_inputs_needed] section before sending the report for analysis.\n'
