-- Keep the Mihomo core on persistent storage while small-flash mode keeps GEO data in /tmp.
-- This patch targets OpenClash v0.47.156 and fails closed when the expected source differs.

local init_path, controller_path, updater_path = ...

if not init_path or not controller_path or not updater_path then
    error("usage: patch-persistent-core.lua <init> <controller> <core-updater>")
end

local marker = "openclash-persistent-core-compat"

local function read_all(path)
    local file, err = io.open(path, "rb")
    if not file then error("cannot read " .. path .. ": " .. tostring(err)) end
    local content = file:read("*a")
    file:close()
    return content
end

local function write_all(path, content)
    local file, err = io.open(path, "wb")
    if not file then error("cannot write " .. path .. ": " .. tostring(err)) end
    assert(file:write(content))
    assert(file:close())
end

local function replace_once(content, old, new, label)
    local first, last = content:find(old, 1, true)
    if not first then error("unexpected " .. label .. " source structure") end
    return content:sub(1, first - 1) .. new .. content:sub(last + 1)
end

local function patch_init(path)
    local content = read_all(path)
    if content:find(marker, 1, true) then return end

    local old_disabled = "      # mv core disabled"
    if content:find(old_disabled, 1, true) then
        content = replace_once(
            content,
            old_disabled,
            "      mv \"/tmp/etc/openclash/core/\" \"/etc/openclash\"",
            "previous init non-small-flash patch"
        )
        content = replace_once(
            content,
            old_disabled,
            "      # " .. marker .. ": keep the core on /overlay",
            "previous init small-flash patch"
        )
    else
        content = replace_once(
            content,
            "      meta_core_path=\"/tmp/etc/openclash/core/clash_meta\"",
            "      meta_core_path=\"/etc/openclash/core/clash_meta\"",
            "init small-flash core path"
        )
        content = replace_once(
            content,
            "      mv \"/etc/openclash/core/\" \"/tmp/etc/openclash\"",
            "      # " .. marker .. ": keep the core on /overlay",
            "init small-flash core move"
        )
    end

    if content:find("   ln -sf /etc/openclash/core/clash_meta /etc/openclash/clash", 1, true) then
        content = replace_once(
            content,
            "   ln -sf /etc/openclash/core/clash_meta /etc/openclash/clash",
            "   ln -sf \"$meta_core_path\" /etc/openclash/clash",
            "previous init core link"
        )
    elseif content:find("   ln -s \"$meta_core_path\" /etc/openclash/clash", 1, true) then
        content = replace_once(
            content,
            "   ln -s \"$meta_core_path\" /etc/openclash/clash",
            "   ln -sf \"$meta_core_path\" /etc/openclash/clash",
            "init core link"
        )
    end

    if not content:find(marker, 1, true)
        or not content:find('ln -sf "$meta_core_path" /etc/openclash/clash', 1, true) then
        error("init patch validation failed")
    end
    write_all(path, content)
end

local function patch_controller(path)
    local content = read_all(path)
    if content:find(marker, 1, true) then return end

    content = replace_once(
        content,
        'meta_core_path="/tmp/etc/openclash/core/clash_meta"',
        '-- openclash-persistent-core-compat: use the persistent core in small-flash mode.\n' ..
            '        meta_core_path="/etc/openclash/core/clash_meta"',
        "controller core path"
    )
    write_all(path, content)
end

local function patch_updater(path)
    local content = read_all(path)
    if content:find(marker, 1, true) then return end

    content = replace_once(
        content,
        'meta_core_path="/tmp/etc/openclash/core/clash_meta"',
        '# openclash-persistent-core-compat: update the persistent core in small-flash mode.\n' ..
            '   meta_core_path="/etc/openclash/core/clash_meta"',
        "core updater path"
    )
    content = replace_once(
        content,
        "mkdir -p /tmp/etc/openclash/core",
        "mkdir -p /etc/openclash/core",
        "core updater directory"
    )
    write_all(path, content)
end

patch_init(init_path)
patch_controller(controller_path)
patch_updater(updater_path)
