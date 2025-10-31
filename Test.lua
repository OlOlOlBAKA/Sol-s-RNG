if not _G["AlreadyRun"] then
    _G["AlreadyRun"] = true
else
    return
end

local currentVersion = "1.22.3"

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

local Blacklisted = _G.BlacklistedUsers or loadstring(game:HttpGet("https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/Blacklisted.lua"))()

-- Webhook Functions
local function SendBiomeWebhook(title, desc, color, anothermessage, webhookURL, spawnTime, despawnTime, contentmsg, roll)
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
                ["footer"] = {
                    ["text"] = "Bao Macro (v." .. currentVersion ..")",
                    ["icon_url"] = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/images%20(13).jpeg?raw=true",
                },
                ["fields"] = {
                    {["name"]="Spawn Time", ["value"]=spawnTime, ["inline"]=true},
                    {["name"]="Despawn Time", ["value"]=despawnTime, ["inline"]=true},
                    {["name"]="Original Message", ["value"]=anothermessage, ["inline"]=true}
                }
            }}
        })
    })
end

local function SendAuraWebhook(title, desc, color, anothermessage, webhookURL, GotTime, contentmsg, rolls)
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
                ["footer"] = {
                    ["text"] = "Bao Macro (v." .. currentVersion ..")",
                    ["icon_url"] = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/images%20(13).jpeg?raw=true",
                },
                ["fields"] = {
                    {["name"]="Time Discovered", ["value"]=GotTime, ["inline"]=true},
                    {["name"]="Roll At Around", ["value"]=rolls, ["inline"]=true},
                }
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
                ["footer"] = {
                    ["text"] = "Bao Macro (v." .. currentVersion ..")",
                    ["icon_url"] = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/images%20(13).jpeg?raw=true",
                },
                ["fields"] = {
                    {["name"]="Spawn Time", ["value"]=spawnTime, ["inline"]=true},
                    {["name"]="Despawn Time", ["value"]=despawnTime, ["inline"]=true},
                    {["name"]="Original Message", ["value"]=anothermessage, ["inline"]=false}
                }
            }}
        })
    })
end

local function extractHexColor(input)
    local hex = string.match(input, 'color="[#]?(%x%x%x%x%x%x)"')

    if hex then
        return "0x"..hex
    end

    return "0xFFFFFF"
end

local function formatNumberWithCommas(number)
    local formatted = tostring(number)
    local result = ""
    local isNegative = formatted:sub(1, 1) == "-"
    if isNegative then
        formatted = formatted:sub(2)
    end
    local length = #formatted
    for i = 1, length do
        result = formatted:sub(length - i + 1, length - i + 1) .. result
        if i % 3 == 0 and i ~= length then
            result = "," .. result
        end
    end
    return isNegative and "-" .. result or result
end

-- Keyword Cache
local keywordCache = {
    ["windy"]       = {["display"]="Windy", ["despawn"]=120},
    ["snowy"]       = {["display"]="Snowy", ["despawn"]=120},
    ["rainy"]       = {["display"]="Rainy", ["despawn"]=120},
    ["blazingsun"] = {["display"]="Blazing Sun", ["despawn"]=140},
    ["graveyard"] = {["display"]="Graveyard", ["despawn"]=140},
    ["pumpkinmoon"] = {["display"]="Pumpkin Moon", ["despawn"]=140},
    ["bloodrain"] = {["display"]="Blood Rain", ["despawn"]=600},
    ["sandstorm"]  = {["display"]="Sand Storm", ["despawn"]=660, ["ping"]=_G["SandStorm"]},
    ["hell"]        = {["display"]="Hell", ["despawn"]=660, ["ping"]=_G["Hell"]},
    ["starfall"]    = {["display"]="Starfall", ["despawn"]=600, ["ping"]=_G["Starfall"]},
    ["corruption"]  = {["display"]="Corruption", ["despawn"]=660, ["ping"]=_G["Corruption"]},
    ["null"]        = {["display"]="Null", ["despawn"]=99, ["ping"]=_G["Null"]},
    ["manager"]     = {["display"]="Glitched", ["despawn"]=124, ["ping"]=_G["Glitched"]},
    ["dreamspace"]  = {["display"]="Dreamspace", ["despawn"]=128, ["ping"]=_G["Dreamspace"]},
    ["mari"]        = {["display"]="Mari", ["despawn"]=180},
    ["jester"]      = {["display"]="Jester", ["despawn"]=180, ["ping"]=_G["Jester"]},
    ["eden"]        = {["display"]="Eden", ["despawn"]=1800, ["ping"]=_G["Eden"]},
}

-- AntiAFK
task.spawn(function()
    player["Idled"]:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(0,0))
    end)
end)

-- Channel2: Aura (rarity checks + keywords)
task.spawn(function()
    channel2["MessageReceived"]:Connect(function(message)
        if not message["Text"] then return end
        if string.match(message.Text:lower(), "global") then return end

        local text = message["Text"]
        local playerRolled = nil
        local blacklistedPlayer = nil
                
        -- check player name in message sent
        for _, v in pairs(Players:GetPlayers()) do
            if string.match(text, v.Name) then
                playerRolled = v
                break  -- found, break the loop
            end
        end

        if playerRolled then
            for _,v in pairs(Blacklisted) do
                if string.match(playerRolled.Name, v) then
                    blacklistedPlayer = v
                    break
                end
            end
            if blacklistedPlayer then return end
        end

        local color = extractHexColor(message.Text)
        text = text:gsub("<.->", "")

        local lowerText = text:lower()
        local numberStr = string.match(text, "CHANCE OF 1 IN ([%d,]+)")
                
        local RollAmount = playerRolled and formatNumberWithCommas(playerRolled:GetAttribute("Rolls")) or "[ Unknown ]"
        local contentmsg = ""
        local pingRole = ""

        -- check global aura (1 in 99,999,999+)
        if numberStr then
            numberStr = numberStr:gsub(",", "")
            local number = tonumber(numberStr)
            if number >= 99999999 then
                contentmsg = _G["Globals"]
            end

            local discordTime = "<t:" .. os.time() .. ":F>" .. " Or " .. "<t:" .. os.time() .. ":R>"
            SendAuraWebhook("**Aura Detected**", text, color, text, _G["AuraWebhook"], discordTime, contentmsg, RollAmount)

        else
            -- 1B auras check + special auras
            if string.match(lowerText, "pixelated")
                or string.match(lowerText, "blinding")
                or string.match(lowerText, "positive")
                or string.match(lowerText, "transcendent")
                or string.match(lowerText, "the truth")
                or string.match(lowerText, "neferkhaf")
                or string.match(lowerText, "nightmare")
                or string.match(lowerText, "calamity") then

                pingRole = BillionPing

            elseif string.match(lowerText, "glorious")
                or string.match(lowerText, "memory") then

                pingRole = GlobalPing
            end

            local discordTime = "<t:" .. os.time() .. ":F>" .. " Or " .. "<t:" .. os.time() .. ":R>"
            SendAuraWebhook("**Aura Detected**", text, color, text, _G["AuraWebhook"], discordTime, pingRole, RollAmount)
        end
    end)
end)

-- Channel1: Biome / Merchant / Eden
task.spawn(function()
    channel1["MessageReceived"]:Connect(function(message)
        if not message["Text"] or message["TextSource"] ~= nil then return end
        local text = message["Text"]:lower()
        local gsubText = message.Text:lower():gsub(" ","")
        local color = extractHexColor(message.Text)
        local keyword, data
        for k, v in pairs(keywordCache) do
            if string.find(gsubText, k) then
                keyword = k
                data = v
                break
            end
        end
        if not keyword or not data then return end

        local cleanMsg = message["Text"]:gsub('<font color=".-">', ""):gsub("</font>", "")
        local despawnTime = data["despawn"]
        local contentmsg = data["ping"] or ""

        local time = os.time()
        local discordTime = "<t:" .. time .. ":F>" .. " Or " .. "<t:" .. time .. ":R>"
        local discordDespawnTime = "<t:" .. (time + despawnTime) .. ":F>" .. " Or " .. "<t:" .. (time + despawnTime) .. ":R>"

        if keyword == "mari" or keyword == "jester" then
            SendMerchantWebhook(
                "**Merchant Detected**",
                data["display"] .. " Has Spawned!",
                color,
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
                color,
                cleanMsg,
                _G["AuraWebhook"],
                discordTime,
                discordDespawnTime,
                contentmsg
            )
        else
            if keyword == "manager" then
                if string.match(cleanMsg:lower(), "resolved") then return end
            elseif keyword == "dreamspace" then
                if string.match(cleanMsg:lower(), "waking") then return end
            end
            SendBiomeWebhook(
                "**Biome Detected**",
                data["display"] .. " Has Spawned!",
                color,
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
    ["Title"] = "Macro Script (V. " ..currentVersion ..")",
    ["Text"] = "Made by Chosen and P Joe",
    ["Duration"] = 5
})

print("Script Loaded")
print(currentVersion)
