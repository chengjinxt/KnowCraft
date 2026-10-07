#!/bin/sh

set -eu

MERGER="${1:?usage: test-merge-custom-rules.sh <merge-custom-rules.awk>}"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT HUP INT TERM

cat >"$WORK_DIR/input.yaml" <<'EOF'
rules:
## keep this comment
- DOMAIN,example.com,Proxy
- DOMAIN,www.5k40.com,DIRECT
EOF

awk -f "$MERGER" "$WORK_DIR/input.yaml" >"$WORK_DIR/once.yaml"
awk -f "$MERGER" "$WORK_DIR/once.yaml" >"$WORK_DIR/twice.yaml"

cmp -s "$WORK_DIR/once.yaml" "$WORK_DIR/twice.yaml" || {
    printf '%s\n' "merge is not idempotent" >&2
    exit 1
}

EXPECTED_RULES='- DOMAIN,www.5k40.com,DIRECT
- DOMAIN,555kp40.com,DIRECT
- DOMAIN,www.555dyx9.com,DIRECT'
ACTUAL_RULES="$(sed -n '2,4p' "$WORK_DIR/once.yaml")"
[ "$ACTUAL_RULES" = "$EXPECTED_RULES" ] || {
    printf '%s\n' "required rules are missing or not at the top" >&2
    exit 1
}

for RULE in \
    'DOMAIN,www.5k40.com,DIRECT' \
    'DOMAIN,555kp40.com,DIRECT' \
    'DOMAIN,www.555dyx9.com,DIRECT'
do
    COUNT="$(grep -Fxc -- "- $RULE" "$WORK_DIR/once.yaml")"
    [ "$COUNT" = "1" ] || {
        printf '%s\n' "rule count is not one: $RULE" >&2
        exit 1
    }
done

grep -Fqx -- '## keep this comment' "$WORK_DIR/once.yaml"
grep -Fqx -- '- DOMAIN,example.com,Proxy' "$WORK_DIR/once.yaml"

printf '%s\n' "merge custom rules: PASS"
