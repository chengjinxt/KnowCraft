#!/bin/sh

set -eu

APPLY_UI_FIXES=0
UI_FRAGMENT=""
PRIVATE_CONFIG=""
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
CORE_PATCHER="$SCRIPT_DIR/patch-persistent-core.lua"
CUSTOM_RULE_MERGER="$SCRIPT_DIR/merge-custom-rules.awk"

log() {
    printf '%s\n' "[openclash-recovery] $*"
}

fail() {
    printf '%s\n' "[openclash-recovery] ERROR: $*" >&2
    exit 1
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --apply-ui-fixes)
            APPLY_UI_FIXES=1
            UI_FRAGMENT="${2:-}"
            shift 2
            ;;
        --private-config)
            PRIVATE_CONFIG="${2:-}"
            shift 2
            ;;
        *)
            fail "未知参数：$1"
            ;;
    esac
done

[ "$(id -u)" = "0" ] || fail "必须以 root 运行。"
[ -x /etc/init.d/openclash ] || fail "未安装 OpenClash，缺少 /etc/init.d/openclash。"
[ -x /etc/openclash/core/clash_meta ] || fail "缺少 Meta 核心 /etc/openclash/core/clash_meta。"
[ -c /dev/net/tun ] || fail "系统没有 /dev/net/tun，请先安装或启用 kmod-tun。"
[ -f "$CORE_PATCHER" ] || fail "恢复包缺少 patch-persistent-core.lua。"
[ -f "$CUSTOM_RULE_MERGER" ] || fail "恢复包缺少 merge-custom-rules.awk。"
[ -f /etc/openclash/custom/openclash_custom_rules.list ] || fail "缺少 OpenClash 自定义规则文件。"

STAMP="$(date +%Y%m%d-%H%M%S 2>/dev/null || printf unknown)"
BACKUP_DIR="/root/openclash-tun-recovery-backups/$STAMP"
mkdir -p "$BACKUP_DIR"
ROLLBACK_ARMED=0

rollback_on_exit() {
    EXIT_CODE=$?
    trap - 0
    if [ "$EXIT_CODE" -ne 0 ] && [ "$ROLLBACK_ARMED" = "1" ]; then
        log "恢复过程失败，回滚配置和界面文件。"
        cp "$BACKUP_DIR/openclash.config.before" /etc/config/openclash 2>/dev/null || true
        cp "$BACKUP_DIR/openclash.lua.before" /usr/lib/lua/luci/controller/openclash.lua 2>/dev/null || true
        cp "$BACKUP_DIR/status.htm.before" /usr/lib/lua/luci/view/openclash/status.htm 2>/dev/null || true
        cp "$BACKUP_DIR/openclash.init.before" /etc/init.d/openclash 2>/dev/null || true
        cp "$BACKUP_DIR/openclash_core.sh.before" /usr/share/openclash/openclash_core.sh 2>/dev/null || true
        cp "$BACKUP_DIR/openclash_custom_rules.list.before" /etc/openclash/custom/openclash_custom_rules.list 2>/dev/null || true
        /etc/init.d/openclash restart >/dev/null 2>&1 || true
    fi
    exit "$EXIT_CODE"
}

trap rollback_on_exit 0

log "修改前备份：$BACKUP_DIR"
cp -p /etc/config/openclash "$BACKUP_DIR/openclash.config.before" 2>/dev/null || true
cp -p /usr/lib/lua/luci/controller/openclash.lua "$BACKUP_DIR/openclash.lua.before" 2>/dev/null || true
cp -p /usr/lib/lua/luci/view/openclash/status.htm "$BACKUP_DIR/status.htm.before" 2>/dev/null || true
cp -p /etc/init.d/openclash "$BACKUP_DIR/openclash.init.before" 2>/dev/null || true
cp -p /usr/share/openclash/openclash_core.sh "$BACKUP_DIR/openclash_core.sh.before" 2>/dev/null || true
cp -p /etc/openclash/custom/openclash_custom_rules.list "$BACKUP_DIR/openclash_custom_rules.list.before" 2>/dev/null || true
ROLLBACK_ARMED=1

if [ -n "$PRIVATE_CONFIG" ]; then
    [ -f "$PRIVATE_CONFIG" ] || fail "私密配置文件不存在：$PRIVATE_CONFIG"
    log "恢复完整私密配置。"
    cp "$PRIVATE_CONFIG" /etc/config/openclash
    chmod 600 /etc/config/openclash
fi

log "合并需要直连的自定义域名规则。"
CUSTOM_RULE_FILE="/etc/openclash/custom/openclash_custom_rules.list"
CUSTOM_RULE_TMP="/tmp/openclash_custom_rules.$$.list"
awk -f "$CUSTOM_RULE_MERGER" "$CUSTOM_RULE_FILE" > "$CUSTOM_RULE_TMP" \
    || fail "合并自定义域名规则失败。"
cat "$CUSTOM_RULE_TMP" > "$CUSTOM_RULE_FILE"
rm -f "$CUSTOM_RULE_TMP"

for RULE in \
    'DOMAIN,www.5k40.com,DIRECT' \
    'DOMAIN,555kp40.com,DIRECT' \
    'DOMAIN,www.555dyx9.com,DIRECT'
do
    [ "$(grep -Fxc -- "- $RULE" "$CUSTOM_RULE_FILE")" = "1" ] \
        || fail "自定义规则没有唯一写入：$RULE"
done

log "写入 Fake-IP + TUN + system + 小闪存模式。"
uci set openclash.config.enable='1'
uci set openclash.config.core_type='Meta'
uci set openclash.config.operation_mode='fake-ip'
uci set openclash.config.en_mode='fake-ip-tun'
uci set openclash.config.stack_type='system'
uci set openclash.config.small_flash_memory='1'
uci set openclash.config.enable_custom_clash_rules='1'
uci commit openclash

log "统一小闪存模式的核心检测、启动和更新路径。"
lua "$CORE_PATCHER" \
    /etc/init.d/openclash \
    /usr/lib/lua/luci/controller/openclash.lua \
    /usr/share/openclash/openclash_core.sh \
    || fail "持久化核心兼容补丁应用失败。"
chmod 755 /etc/init.d/openclash /usr/share/openclash/openclash_core.sh
rm -f /tmp/luci-indexcache /tmp/luci-modulecache 2>/dev/null || true

if [ "$APPLY_UI_FIXES" = "1" ]; then
    CONTROLLER="/usr/lib/lua/luci/controller/openclash.lua"
    STATUS_PAGE="/usr/lib/lua/luci/view/openclash/status.htm"

    if grep -Fq 'mode = HTTP.formvalue("run_mode") or ""' "$CONTROLLER"; then
        log "模式切换空值补丁已存在。"
    elif grep -Fq 'mode = HTTP.formvalue("run_mode")' "$CONTROLLER"; then
        sed -i 's/mode = HTTP\.formvalue("run_mode")$/mode = HTTP.formvalue("run_mode") or ""/' "$CONTROLLER"
        grep -Fq 'mode = HTTP.formvalue("run_mode") or ""' "$CONTROLLER" || fail "模式切换补丁写入失败。"
        log "已应用模式切换空值补丁。"
    else
        log "WARNING: 控制器结构与 v0.47.156 不同，跳过模式切换补丁。"
    fi

    if grep -Fq 'oc-fix-status-width' "$STATUS_PAGE"; then
        log "状态文字宽度补丁已存在。"
    elif [ -f "$UI_FRAGMENT" ] && grep -Fq '<head>' "$STATUS_PAGE"; then
        sed -i "/<head>/r $UI_FRAGMENT" "$STATUS_PAGE"
        grep -Fq 'oc-fix-status-width' "$STATUS_PAGE" || fail "状态文字宽度补丁写入失败。"
        log "已应用状态文字宽度补丁。"
    else
        log "WARNING: 缺少 CSS 片段或页面结构不匹配，跳过状态文字补丁。"
    fi

    rm -f /tmp/luci-indexcache /tmp/luci-modulecache 2>/dev/null || true
fi

stop_openclash() {
    log "停止 OpenClash。"
    /etc/init.d/openclash stop >/dev/null 2>&1 || true
}

ensure_core_link() {
    CORE="/etc/openclash/core/clash_meta"
    LINK="/etc/openclash/clash"
    CURRENT=""
    if [ -L "$LINK" ]; then
        CURRENT="$(readlink "$LINK" 2>/dev/null || true)"
    fi
    if [ "$CURRENT" != "$CORE" ]; then
        rm -f "$LINK"
        ln -s "$CORE" "$LINK"
    fi
}

migrate_one() {
    NAME="$1"
    SOURCE="/etc/openclash/$NAME"
    TARGET="/tmp/etc/openclash/$NAME"

    if [ -L "$SOURCE" ]; then
        CURRENT_TARGET="$(readlink "$SOURCE" 2>/dev/null || true)"
        if [ "$CURRENT_TARGET" = "$TARGET" ]; then
            return
        fi
        if [ -f "$SOURCE" ] && [ ! -f "$TARGET" ]; then
            cp -L "$SOURCE" "$TARGET"
        fi
        rm -f "$SOURCE"
    elif [ -f "$SOURCE" ]; then
        rm -f "$TARGET"
        mv "$SOURCE" "$TARGET"
    fi

    [ -L "$SOURCE" ] || ln -s "$TARGET" "$SOURCE"
}

migrate_databases() {
    mkdir -p /tmp/etc/openclash
    for NAME in GeoSite.dat ASN.mmdb; do
        migrate_one "$NAME"
    done
}

regular_database_exists() {
    for NAME in GeoSite.dat ASN.mmdb; do
        SOURCE="/etc/openclash/$NAME"
        if [ -f "$SOURCE" ] && [ ! -L "$SOURCE" ]; then
            return 0
        fi
    done
    return 1
}

start_openclash() {
    log "启动 OpenClash。首次恢复可能需要下载 GEO 数据。"
    /etc/init.d/openclash start >/dev/null 2>&1 || true
}

wait_for_ready() {
    COUNT=0
    while [ "$COUNT" -lt 120 ]; do
        if ps w | grep -q '[c]lash -d /etc/openclash' \
            && ip link show utun >/dev/null 2>&1 \
            && nft list ruleset 2>/dev/null | grep -q 'chain openclash_mangle'; then
            return 0
        fi
        COUNT=$((COUNT + 1))
        sleep 2
    done
    return 1
}

stop_openclash
migrate_databases
ensure_core_link
start_openclash

if ! wait_for_ready; then
    tail -n 80 /tmp/openclash.log 2>/dev/null || true
    fail "等待核心、utun 和 OpenClash 防火墙规则就绪超时。请检查 /tmp/openclash.log。"
fi

# Mihomo 发现旧数据库无效时可能删掉符号链接并重新下载到 /overlay。
# 等第一次下载完成后再迁移一次，可释放被核心占用的旧 inode。
if regular_database_exists; then
    log "检测到核心新下载到 /overlay 的数据库，执行第二次迁移。"
    stop_openclash
    migrate_databases
    ensure_core_link
    start_openclash
    wait_for_ready || fail "第二次迁移后 OpenClash 没有完整启动。"
fi

MODE="$(uci -q get openclash.config.en_mode || true)"
STACK="$(uci -q get openclash.config.stack_type || true)"
SMALL_FLASH="$(uci -q get openclash.config.small_flash_memory || true)"
CUSTOM_RULES_ENABLED="$(uci -q get openclash.config.enable_custom_clash_rules || true)"
[ "$MODE" = "fake-ip-tun" ] || fail "en_mode 验证失败：$MODE"
[ "$STACK" = "system" ] || fail "stack_type 验证失败：$STACK"
[ "$SMALL_FLASH" = "1" ] || fail "small_flash_memory 验证失败：$SMALL_FLASH"
[ "$CUSTOM_RULES_ENABLED" = "1" ] || fail "自定义规则覆写没有启用。"
ps w | grep -q '[c]lash -d /etc/openclash' || fail "Clash 核心进程不存在。"
ip link show utun 2>/dev/null | grep -q 'UP' || fail "utun 网卡没有处于 UP 状态。"
nft list ruleset 2>/dev/null | grep -q 'chain openclash_mangle' || fail "OpenClash nftables 防火墙链不存在。"
grep -Fq 'openclash-persistent-core-compat' /etc/init.d/openclash || fail "启动脚本缺少持久化核心补丁。"
grep -Fq 'openclash-persistent-core-compat' /usr/lib/lua/luci/controller/openclash.lua || fail "LuCI 控制器缺少持久化核心补丁。"
grep -Fq 'openclash-persistent-core-compat' /usr/share/openclash/openclash_core.sh || fail "核心更新器缺少持久化核心补丁。"

RAW_CONFIG_PATH="$(uci -q get openclash.config.config_path || true)"
GENERATED_CONFIG="/etc/openclash/$(basename "$RAW_CONFIG_PATH")"
[ -f "$GENERATED_CONFIG" ] || fail "没有找到生成后的运行配置：$GENERATED_CONFIG"
MATCH_LINE="$(grep -nE '^- MATCH,' "$GENERATED_CONFIG" | head -n 1 | cut -d: -f1)"
[ -n "$MATCH_LINE" ] || fail "运行配置中没有找到 MATCH 规则。"
for RULE in \
    'DOMAIN,www.5k40.com,DIRECT' \
    'DOMAIN,555kp40.com,DIRECT' \
    'DOMAIN,www.555dyx9.com,DIRECT'
do
    RULE_LINE="$(grep -nFx -- "- $RULE" "$GENERATED_CONFIG" | head -n 1 | cut -d: -f1)"
    [ -n "$RULE_LINE" ] || fail "运行配置缺少自定义规则：$RULE"
    [ "$RULE_LINE" -lt "$MATCH_LINE" ] || fail "自定义规则位于 MATCH 之后：$RULE"
done

for NAME in GeoSite.dat ASN.mmdb; do
    SOURCE="/etc/openclash/$NAME"
    [ -L "$SOURCE" ] || fail "$SOURCE 不是符号链接。"
    [ "$(readlink "$SOURCE")" = "/tmp/etc/openclash/$NAME" ] || fail "$SOURCE 链接目标不正确。"
done

AVAILABLE_KB="$(df -Pk /overlay | awk 'NR == 2 {print $4}')"
[ -n "$AVAILABLE_KB" ] || fail "无法读取 /overlay 可用空间。"
[ "$AVAILABLE_KB" -gt 0 ] || fail "/overlay 没有剩余空间。"

check_https_with_retry() {
    LABEL="$1"
    URL="$2"
    ATTEMPT=0
    CONSECUTIVE_OK=0

    while [ "$ATTEMPT" -lt 12 ]; do
        if curl -fsS --connect-timeout 8 --max-time 20 -o /dev/null "$URL"; then
            CONSECUTIVE_OK=$((CONSECUTIVE_OK + 1))
            if [ "$CONSECUTIVE_OK" -ge 2 ]; then
                return 0
            fi
        else
            CONSECUTIVE_OK=0
        fi
        ATTEMPT=$((ATTEMPT + 1))
        sleep 5
    done

    fail "$LABEL HTTPS 连续验证失败。"
}

log "验证路由器自身的国内和境外 HTTPS 连接。"
check_https_with_retry "百度" "https://www.baidu.com/"
check_https_with_retry "Google" "https://www.google.com/"

log "恢复成功。"
log "en_mode=$MODE, stack_type=$STACK, small_flash_memory=$SMALL_FLASH, custom_rules=$CUSTOM_RULES_ENABLED"
log "/overlay 可用空间：${AVAILABLE_KB} KiB"
ip addr show utun | sed -n '1,5p'
df -h /overlay /tmp
ROLLBACK_ARMED=0
