#!/usr/bin/env bash

set -u
export LC_ALL=C

timestamp="$(date '+%Y%m%d-%H%M%S')"
output_path="${1:-./llm-hardware-report-linux-${timestamp}.txt}"

clean() {
    printf '%s' "$*" | tr '\r\n' '  ' | sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//'
}

section() {
    printf '\n[%s]\n' "$1" >> "$output_path"
}

kv() {
    printf '%s=%s\n' "$1" "$(clean "${2:-}")" >> "$output_path"
}

command_status() {
    if command -v "$1" >/dev/null 2>&1; then
        kv "$1" 'found'
    else
        kv "$1" 'not_found'
    fi
}

os_release_value() {
    local key="$1"
    awk -F= -v wanted="$key" '$1 == wanted { value=$0; sub(/^[^=]*=/, "", value); gsub(/^"|"$/, "", value); print value; exit }' /etc/os-release 2>/dev/null || true
}

lscpu_value() {
    local key="$1"
    lscpu 2>/dev/null | awk -F: -v wanted="$key" '$1 == wanted { value=$2; sub(/^[[:space:]]+/, "", value); print value; exit }'
}

meminfo_kib() {
    local key="$1"
    awk -v wanted="$key" '$1 == wanted ":" { print $2; exit }' /proc/meminfo 2>/dev/null || true
}

kib_to_gib() {
    awk -v kib="${1:-0}" 'BEGIN { if (kib > 0) printf "%.2f", kib / 1048576; }'
}

: > "$output_path"
printf 'LLM_HARDWARE_REPORT_V1\n' >> "$output_path"

section 'meta'
kv 'os_family' 'Linux'
kv 'collected_at_utc' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
kv 'privacy' 'No hostname, username, serial number, IP (Internet Protocol) address, MAC (Media Access Control) address, Wi-Fi network name, or process list is collected.'

section 'system'
kv 'distribution' "$(os_release_value PRETTY_NAME)"
kv 'distribution_id' "$(os_release_value ID)"
kv 'distribution_version' "$(os_release_value VERSION_ID)"
kv 'kernel_name' "$(uname -s)"
kv 'kernel_release' "$(uname -r)"
kv 'architecture' "$(uname -m)"
if command -v systemd-detect-virt >/dev/null 2>&1; then
    kv 'virtualization' "$(systemd-detect-virt 2>/dev/null || true)"
fi

section 'cpu'
if command -v lscpu >/dev/null 2>&1; then
    kv 'architecture' "$(lscpu_value 'Architecture')"
    kv 'model_name' "$(lscpu_value 'Model name')"
    kv 'logical_cpus' "$(lscpu_value 'CPU(s)')"
    kv 'cores_per_socket' "$(lscpu_value 'Core(s) per socket')"
    kv 'sockets' "$(lscpu_value 'Socket(s)')"
    kv 'threads_per_core' "$(lscpu_value 'Thread(s) per core')"
    kv 'max_mhz' "$(lscpu_value 'CPU max MHz')"
    kv 'l2_cache' "$(lscpu_value 'L2 cache')"
    kv 'l3_cache' "$(lscpu_value 'L3 cache')"
fi
cpu_features="$(grep -m1 -E '^(flags|Features)[[:space:]]*:' /proc/cpuinfo 2>/dev/null | cut -d: -f2- || true)"
for feature in avx2 avx512f neon asimd sve; do
    if printf ' %s ' "$cpu_features" | grep -qw "$feature"; then
        kv "feature_$feature" 'yes'
    else
        kv "feature_$feature" 'no_or_not_reported'
    fi
done

section 'memory'
kv 'mem_total_gib' "$(kib_to_gib "$(meminfo_kib MemTotal)")"
kv 'mem_available_gib' "$(kib_to_gib "$(meminfo_kib MemAvailable)")"
kv 'swap_total_gib' "$(kib_to_gib "$(meminfo_kib SwapTotal)")"
kv 'swap_free_gib' "$(kib_to_gib "$(meminfo_kib SwapFree)")"
if [ -r /sys/fs/cgroup/memory.max ]; then
    kv 'cgroup_memory_max' "$(cat /sys/fs/cgroup/memory.max)"
elif [ -r /sys/fs/cgroup/memory/memory.limit_in_bytes ]; then
    kv 'cgroup_memory_limit_bytes' "$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes)"
fi

section 'memory_firmware_optional'
if [ "$(id -u)" -eq 0 ] && command -v dmidecode >/dev/null 2>&1; then
    dmi_index=0
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        kv "dmi_line_${dmi_index}" "$line"
        dmi_index=$((dmi_index + 1))
    done <<EOF
$({ dmidecode --type 16; dmidecode --type 17; } 2>/dev/null | awk '/Maximum Capacity:|Number Of Devices:|Size:|Locator:|Type:|Speed:|Configured Memory Speed:/ { gsub(/^[[:space:]]+/, ""); print }')
EOF
else
    kv 'status' 'not_collected; rerun with sudo only if memory slots and firmware maximum are needed'
fi

section 'gpu_pci'
if command -v lspci >/dev/null 2>&1; then
    gpu_index=0
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        kv "gpu_${gpu_index}" "$line"
        gpu_index=$((gpu_index + 1))
    done <<EOF
$(lspci 2>/dev/null | grep -Ei 'VGA|3D|Display' || true)
EOF
else
    kv 'status' 'lspci_not_found'
fi

section 'gpu_nvidia_smi'
if command -v nvidia-smi >/dev/null 2>&1; then
    nvidia_index=0
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        kv "gpu_${nvidia_index}" "$line"
        nvidia_index=$((nvidia_index + 1))
    done <<EOF
$(nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader,nounits 2>/dev/null || true)
EOF
else
    kv 'status' 'not_found'
fi

section 'gpu_other_backends'
if command -v rocminfo >/dev/null 2>&1; then
    rocm_index=0
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        kv "rocm_line_${rocm_index}" "$line"
        rocm_index=$((rocm_index + 1))
    done <<EOF
$(rocminfo 2>/dev/null | grep -E '^[[:space:]]*(Name:|Marketing Name:)' | head -n 20 || true)
EOF
else
    kv 'rocminfo' 'not_found'
fi
if command -v vulkaninfo >/dev/null 2>&1; then
    vulkan_index=0
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        kv "vulkan_line_${vulkan_index}" "$line"
        vulkan_index=$((vulkan_index + 1))
    done <<EOF
$(vulkaninfo --summary 2>/dev/null | grep -E 'deviceName|driverName|driverInfo|apiVersion' | head -n 30 || true)
EOF
else
    kv 'vulkaninfo' 'not_found'
fi

section 'storage_root'
kv 'df_kib_total_available_mount' "$(df -kP / 2>/dev/null | awk 'NR==2 {print $2, $4, $6}')"
if command -v lsblk >/dev/null 2>&1; then
    storage_index=0
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        kv "device_${storage_index}" "$line"
        storage_index=$((storage_index + 1))
    done <<EOF
$(lsblk -b -d -n -o NAME,SIZE,ROTA,TYPE,MODEL 2>/dev/null || true)
EOF
fi

section 'backend_tools'
for tool in nvidia-smi rocm-smi rocminfo vulkaninfo clinfo ollama llama-cli llama-server python3 docker; do
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
