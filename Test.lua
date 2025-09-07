if not _G["AlreadyRun"] then
    _G["AlreadyRun"] = true
else
    return
end

local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")

local player = Players["LocalPlayer"]
local channel1 = TextChatService["TextChannels"]["RBXGeneral"]
local channel2 = TextChatService["Server Message"]

-- Webhooks
local BiomeURL = _G["BiomeWebhook"]
local AuraURL = _G["AuraWebhook"]
local MerchantURL = _G["MerchantWebhook"]

-- Ping Roles
local SandStormPing = _G["SandStorm"]
local HellPing = _G["Hell"]
local StarfallPing = _G["Starfall"]
local CorruptionPing = _G["Corruption"]
local NullPing = _G["Null"]
local GlitchedPing = _G["Glitched"]
local DreamspacePing = _G["Dreamspace"]
local JesterPing = _G["Jester"]
local GlobalPing = _G["Globals"]
local BillionPing = _G["OneBillion"]
local EdenPing = _G["Eden"]

-- Webhook Functions (เอารูปออก)
local function SendBiomeWebhook(title, desc, color, anothermessage, webhookURL, spawnTime, despawnTime, contentmsg)
    request({
        ["Url"] = webhookURL,
        ["Method"] = "POST",
        ["Headers"] = {["Content-Type"] = "application/json"},
        ["Body"] = HttpService:JSONEncode({
            ["content"] = contentmsg,
            ["embeds"] = {{
                ["title"] = title,
                ["description"] = desc,
                ["image"] = {["url"] = ""},
                ["type"] = "rich",
                ["color"] = tonumber(color),
                ["fields"] = {
                    {["name"]="Spawn Time", ["value"]=spawnTime, ["inline"]=true},
                    {["name"]="Despawn Time", ["value"]=despawnTime, ["inline"]=true},
                    {["name"]="Original Message", ["value"]=anothermessage, ["inline"]=true}
                }
            }}
        })
    })
end

local function SendAuraWebhook(title, desc, color, anothermessage, webhookURL, GotTime, contentmsg)
    request({
        ["Url"] = webhookURL,
        ["Method"] = "POST",
        ["Headers"] = {["Content-Type"] = "application/json"},
        ["Body"] = HttpService:JSONEncode({
            ["content"] = contentmsg,
            ["embeds"] = {{
                ["title"] = title,
                ["description"] = desc,
                ["image"] = {["url"] = ""},
                ["type"] = "rich",
                ["color"] = tonumber(color),
                ["fields"] = {{["name"]="Time", ["value"]=GotTime, ["inline"]=true}}
            }}
        })
    })
end

local function SendMerchantWebhook(title, desc, color, anothermessage, webhookURL, spawnTime, despawnTime, contentmsg)
    request({
        ["Url"] = webhookURL,
        ["Method"] = "POST",
        ["Headers"] = {["Content-Type"] = "application/json"},
        ["Body"] = HttpService:JSONEncode({
            ["content"] = contentmsg,
            ["embeds"] = {{
                ["title"] = title,
                ["description"] = desc,
                ["image"] = {["url"] = ""},
                ["type"] = "rich",
                ["color"] = tonumber(color),
                ["fields"] = {
                    {["name"]="Spawn Time", ["value"]=spawnTime, ["inline"]=true},
                    {["name"]="Despawn Time", ["value"]=despawnTime, ["inline"]=true},
                    {["name"]="Original Message", ["value"]=anothermessage, ["inline"]=false}
                }
            }}
        })
    })
end

-- Keyword Cache
local keywordCache = {
    ["windy"]       = {["color"]=0xFFFFFF, ["display"]="Windy", ["despawn"]=120},
    ["snowy"]       = {["color"]=0xFFFFFF, ["display"]="Snowy", ["despawn"]=120},
    ["rainy"]       = {["color"]=0xADD8E6, ["display"]="Rainy", ["despawn"]=120},
    ["blazing sun"] = {["color"]=0xFFA500, ["display"]="Blazing Sun", ["despawn"]=140},
    ["sand storm"]  = {["color"]=0xDAA520, ["display"]="Sand Storm", ["despawn"]=660, ["ping"]=_G["SandStorm"]},
    ["hell"]        = {["color"]=0x8B0000, ["display"]="Hell", ["despawn"]=660, ["ping"]=_G["Hell"]},
    ["starfall"]    = {["color"]=0x1E90FF, ["display"]="Starfall", ["despawn"]=600, ["ping"]=_G["Starfall"]},
    ["corruption"]  = {["color"]=0x800080, ["display"]="Corruption", ["despawn"]=660, ["ping"]=_G["Corruption"]},
    ["null"]        = {["color"]=0x000000, ["display"]="Null", ["despawn"]=99, ["ping"]=_G["Null"]},
    ["manager"]     = {["color"]=0x228B22, ["display"]="Glitched", ["despawn"]=124, ["ping"]=_G["Glitched"]},
    ["dreamspace"]  = {["color"]=0xFF70D9, ["display"]="Dreamspace", ["despawn"]=128, ["ping"]=_G["Dreamspace"]},
    ["mari"]        = {["color"]=0xFFFFFF, ["display"]="Mari", ["despawn"]=180},
    ["jester"]      = {["color"]=0x800080, ["display"]="Jester", ["despawn"]=180, ["ping"]=_G["Jester"]},
    ["eden"]        = {["color"]=0x000000, ["display"]="Eden", ["despawn"]=1800, ["ping"]=_G["Eden"]},
}

-- AntiAFK
task.spawn(function()
    player["Idled"]:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(0,0))
    end)
end)

-- Channel2: Aura (ตัวเลข + keywords)
task.spawn(function()
    channel2["MessageReceived"]:Connect(function(message)
        if not message["Text"] then return end
        local text = message["Text"]
        text = text:gsub("<.->","")
        local numberStr = string.match(text, "CHANCE OF 1 IN ([%d,]+)")
        if numberStr then
            numberStr = numberStr:gsub(",", "")
            local number = tonumber(numberStr)
            local color = 0xFFFFFF
            local contentmsg = ""

            if number < 9999 then
                color = 0x800080
            elseif number < 99999 then
                color = 0xFFA500
            elseif number < 999999 then
                color = 0x00BFFF
            elseif number < 9999999 then
                color = 0xFF69B4
            elseif number < 99999999 then
                color = 0x0000FF
            elseif number >= 99999998 then
                color = 0xFF0000
                contentmsg = "<" .. _G["Globals"] .. ">"
            end

            local time = os.time()
            local discordTime = "<t:" .. time .. ":F>"
            SendAuraWebhook("**Aura Detected**", text, color, text, _G["AuraWebhook"], discordTime, contentmsg)
        else
            local lowerText = text:lower()
            if string.match(lowerText,"pixelated") then
                SendAuraWebhook("**Aura Detected**", text, 0xFF70D9, text, _G["AuraWebhook"], "<t:" .. os.time() .. ":F>", "<" .. _G["OneBillion"] .. ">")
            elseif string.match(lowerText,"blinding") then
                SendAuraWebhook("**Aura Detected**", text, 0xFFFFFF, text, _G["AuraWebhook"], "<t:" .. os.time() .. ":F>", "<" .. _G["OneBillion"] .. ">")
            elseif string.match(lowerText,"positive") then
                SendAuraWebhook("**Aura Detected**", text, 0x000000, text, _G["AuraWebhook"], "<t:" .. os.time() .. ":F>", "<" .. _G["OneBillion"] .. ">")
            elseif string.match(lowerText,"glorious") then
                SendAuraWebhook("**Aura Detected**", text, 0xFF0000, text, _G["AuraWebhook"], "<t:" .. os.time() .. ":F>", "<" .. _G["Globals"] .. ">")
            elseif string.match(lowerText,"exalted") then
                SendAuraWebhook("**Aura Detected**", text, 0x0000FF, text, _G["AuraWebhook"], "<t:" .. os.time() .. ":F>", "<" .. _G["Globals"] .. ">")
            end
        end
    end)
end)

-- Channel1: Biome / Merchant / Eden
task.spawn(function()
    channel1["MessageReceived"]:Connect(function(message)
        if not message["Text"] or message["TextSource"] ~= nil then return end
        local text = message["Text"]:lower()
        local keyword, data
        for k, v in pairs(keywordCache) do
            if string.find(text, k) then
                keyword = k
                data = v
                break
            end
        end
        if not keyword or not data then return end

        local cleanMsg = message["Text"]:gsub('<font color=".-">', ""):gsub("</font>", "")
        local despawnTime = data["despawn"]
        local contentmsg = data["ping"] and ("<" .. data["ping"] .. ">") or ""

        local time = os.time()
        local discordTime = "<t:" .. time .. ":F>"
        local discordDespawnTime = "<t:" .. (time + despawnTime) .. ":F>"

        if keyword == "mari" or keyword == "jester" then
            SendMerchantWebhook(
                "**Merchant Detected**",
                data["display"] .. " Has Spawned!",
                data["color"],
                cleanMsg,
                _G["MerchantWebhook"],
                discordTime,
                discordDespawnTime,
                contentmsg
            )
        elseif keyword == "eden" then
            SendBiomeWebhook(
                "**Eden Detected**",
                "Eden Has Spawned On " .. player["Name"] .. " Side!",
                data["color"],
                cleanMsg,
                _G["AuraWebhook"],
                discordTime,
                discordDespawnTime,
                contentmsg
            )
        else
            SendBiomeWebhook(
                "**Biome Detected**",
                data["display"] .. " Has Spawned!",
                data["color"],
                cleanMsg,
                _G["BiomeWebhook"],
                discordTime,
                discordDespawnTime,
                contentmsg
            )
        end
    end)
end)

StarterGui:SetCore("SendNotification", {
    ["Title"] = "Macro Script",
    ["Text"] = "Made by Chosen and Sega",
    ["Duration"] = 5
})

print("Script Loaded")
