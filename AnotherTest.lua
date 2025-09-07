if not _G.AlreadyRun then
    _G.AlreadyRun = true
else
    return
end

-- Services
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

-- Channels
local channel = TextChatService.TextChannels["RBXGeneral"]
local channel2 = TextChatService["Server Message"]

-- Webhooks
local BiomeURL = _G.BiomeWebhook
local AuraURL = _G.AuraWebhook
local MerchantURL = _G.MerchantWebhook

-- Pings
local SandStormPing = _G.SandStorm
local HellPing = _G.Hell
local StarfallPing = _G.Starfall
local CorruptionPing = _G.Corruption
local NullPing = _G.Null
local GlitchedPing = _G.Glitched
local DreamspacePing = _G.Dreamspace
local JesterPing = _G.Jester
local GlobalPing = _G.Globals
local BillionPing = _G.OneBillion
local EdenPing = _G.Eden

-- ===================== Send Functions =====================
local function SendBiomeWebhook(title, desc, imageURL, color, anothermessage, webhookURL, spawnTime, despawnTime, contentmsg, Link)
    request({
        Url = webhookURL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({
            ["content"] = contentmsg,
            ["embeds"] = {{
                ["title"] = title,
                ["description"] = desc,
                ["image"] = {["url"] = imageURL},
                ["type"] = "rich",
                ["color"] = tonumber(color),
                ["fields"] = {
                    {["name"] = "Spawn Time", ["value"] = spawnTime, ["inline"] = true},
                    {["name"] = "Despawn Time", ["value"] = despawnTime, ["inline"] = true},
                    {["name"] = "Original Message", ["value"] = anothermessage, ["inline"] = true},
                }
            }}
        })
    })
end

local function SendAuraWebhook(title, desc, imageURL, color, anothermessage, webhookURL, GotTime, contentmsg)
    request({
        Url = webhookURL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({
            ["content"] = contentmsg,
            ["embeds"] = {{
                ["title"] = title,
                ["description"] = desc,
                ["image"] = {["url"] = imageURL},
                ["type"] = "rich",
                ["color"] = tonumber(color),
                ["fields"] = {
                    {["name"] = "Time", ["value"] = GotTime, ["inline"] = true},
                }
            }}
        })
    })
end

local function SendMerchantWebhook(title, desc, imageURL, color, anothermessage, webhookURL, spawnTime, despawnTime, contentmsg)
    request({
        Url = webhookURL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({
            ["content"] = contentmsg,
            ["embeds"] = {{
                ["title"] = title,
                ["description"] = desc,
                ["image"] = {["url"] = imageURL},
                ["type"] = "rich",
                ["color"] = tonumber(color),
                ["fields"] = {
                    {["name"] = "Spawn Time", ["value"] = spawnTime, ["inline"] = true},
                    {["name"] = "Despawn Time", ["value"] = despawnTime, ["inline"] = true},
                    {["name"] = "Original Message", ["value"] = anothermessage, ["inline"] = false},
                }
            }}
        })
    })
end

-- ===================== Keyword Data =====================
local keywordsToColor = {
    ["windy"] = 0xFFFFFF, ["snowy"] = 0xFFFFFF, ["rainy"] = 0xADD8E6, ["blazing sun"] = 0xFFA500,
    ["sand storm"] = 0xDAA520, ["hell"] = 0x8B0000, ["starfall"] = 0x1E90FF, ["corruption"] = 0x800080,
    ["null"] = 0x000000, ["manager"] = 0x228B22, ["dreamspace"] = 0xFF70D9, ["mari"] = 0xFFFFFF,
    ["jester"] = 0x800080, ["eden"] = 0x000000,
}

local keywordsToDisplayName = {
    ["windy"] = "Windy", ["snowy"] = "Snowy", ["rainy"] = "Rainy", ["blazing sun"] = "Blazing Sun",
    ["sand storm"] = "Sand Storm", ["hell"] = "Hell", ["starfall"] = "Starfall", ["corruption"] = "Corruption",
    ["null"] = "Null", ["manager"] = "Glitched", ["dreamspace"] = "Dreamspace", ["mari"] = "Mari",
    ["jester"] = "Jester", ["eden"] = "Eden",
}

local keywordsToImage = {
    ["windy"] = "https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/Windy_Icon_(BloxTrap).png",
    ["snowy"] = "https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/Snowy_Icon_(BloxTrap).png",
    ["rainy"] = "https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/Rainy_Biome_(BloxTrap_Icon).png",
    ["blazing sun"] = "https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/images%20(14).jpeg",
    ["sand storm"] = "https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/Sand_Storm_Biome_(BloxTrap).png",
    ["hell"] = "https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/Hell_Biome_(BloxTrap).png",
    ["starfall"] = "https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/Starfall_Biome_(Bloxtrap_Icon).png",
    ["corruption"] = "https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/Corruption_Biome_(BloxTrap).png",
    ["null"] = "https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/Null_Biome_(BloxTrap).png",
    ["manager"] = "https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/Glitch_Tree.png",
    ["dreamspace"] = "https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/images%20(13).jpeg",
    ["mari"] = "https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/images%20(15).jpeg",
    ["jester"] = "https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/images%20(16).jpeg",
    ["eden"] = "https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/IMG_20250813_213446.jpg",
}

local function findKeyword(text)
    text = text:lower()
    for k,_ in pairs(keywordsToColor) do
        if text:find(k,1,true) then
            return k, keywordsToColor[k], keywordsToDisplayName[k], keywordsToImage[k]
        end
    end
end

-- ===================== Anti AFK =====================
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new(0,0))
end)

-- ===================== Aura Detection =====================
channel2.MessageReceived:Connect(function(message)
    local text = message.Text
    if not text then return end
    text = text:gsub("<.->","")
    local now = os.time()
    local discordTime = "<t:"..now..":F>"

    local numberStr = text:match("CHANCE OF 1 IN ([%d,]+)")
    if numberStr then
        local number = tonumber(numberStr:gsub(",",""))
        if number then
            local color, contentmsg = nil,""
            if number<9999 then color=0x800080
            elseif number<99999 then color=0xFFA500
            elseif number<999999 then color=0x00BFFF
            elseif number<9999999 then color=0xFF69B4
            elseif number<99999999 then color=0x0000FF
            else color=0xFF0000 contentmsg="<"..GlobalPing..">"
            end
            SendAuraWebhook("**Aura Detected**",text,"",color,text,AuraURL,discordTime,contentmsg)
        end
        return
    end

    local auraKeywords={["PIXELATED"]={0xFF70D9,BillionPing},["Blinding"]={0xFFFFFF,BillionPing},
    ["POSITIVE"]={0x000000,BillionPing},["GLORIOUS"]={0xFF0000,GlobalPing},["EXALTED"]={0x0000FF,nil}}
    for k,v in pairs(auraKeywords) do
        if text:find(k,1,true) then
            local color,ping=v[1],v[2]
            local contentmsg=ping and "<"..ping..">" or ""
            SendAuraWebhook("**Aura Detected**",text,"",color,text,AuraURL,discordTime,contentmsg)
            break
        end
    end
end)

-- ===================== Biome / Merchant / Eden Detection (RBXGeneral) =====================
channel.MessageReceived:Connect(function(message)
    if message.TextSource then return end
    local keyword, color, display, image = findKeyword(message.Text)
    if not keyword then return end

    local cleanMsg = message.Text:gsub('<font color=".-">', ""):gsub("</font>", "")
    local despawnTime = 0
    local contentmsg = ""
    local now = os.time()
    local discordTime = "<t:" .. now .. ":F>"
    local discordDespawnTime

    -- Biome Detection
    if keyword ~= "mari" and keyword ~= "jester" and keyword ~= "eden" and BiomeURL then
        if display == "Windy" then despawnTime=120
        elseif display == "Snowy" then despawnTime=120
        elseif display == "Rainy" then despawnTime=120
        elseif display == "Blazing Sun" then despawnTime=140
        elseif display == "Sand Storm" then despawnTime=660 contentmsg="<"..SandStormPing..">"
        elseif display == "Hell" then despawnTime=660 contentmsg="<"..HellPing..">"
        elseif display == "Starfall" then despawnTime=600 contentmsg="<"..StarfallPing..">"
        elseif display == "Corruption" then despawnTime=660 contentmsg="<"..CorruptionPing..">"
        elseif display == "Null" then despawnTime=99 contentmsg="<"..NullPing..">"
        elseif display == "Glitched" then despawnTime=124 if GlitchedPing then contentmsg="@everyone" end
        elseif display == "Dreamspace" then despawnTime=128 if DreamspacePing then contentmsg="@everyone" end
        end

        discordDespawnTime = "<t:" .. (now + despawnTime) .. ":F>"
        SendBiomeWebhook("**Biome Detected**", display.." Has Spawned!", image, color, cleanMsg, BiomeURL, discordTime, discordDespawnTime, contentmsg, "https://www.roblox.com/th/games/15532962292/Sols-RNG-Fishing-Beta?privateServerLinkCode=60426804869505446691875439115801")
    else
        -- Merchant / Eden Detection
        if display=="Eden" then despawnTime=1800 else despawnTime=180 end
        discordDespawnTime = "<t:" .. (now + despawnTime) .. ":F>"

        if keyword=="jester" then
            contentmsg="<"..JesterPing..">"
            SendMerchantWebhook("**Merchant Detected**", display.." Has Spawned!", image, color, cleanMsg, MerchantURL, discordTime, discordDespawnTime, contentmsg)
        elseif keyword=="mari" then
            SendMerchantWebhook("**Merchant Detected**", display.." Has Spawned!", image, color, cleanMsg, MerchantURL, discordTime, discordDespawnTime, contentmsg)
        elseif keyword=="eden" then
            contentmsg="<"..EdenPing..">"
            SendBiomeWebhook("**Eden Detected**", "Eden Has Spawned On "..player.Name.." Side!", image, color, cleanMsg, AuraURL, discordTime, discordDespawnTime, contentmsg, "")
        end
    end
end)
