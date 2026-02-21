if game:IsLoaded() then else game.Loaded:Wait() end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
if not _G["AlreadyRun"] then
    _G["AlreadyRun"] = true
else
    Rayfield:Notify({
       Title = "Error",
       Content = "The Script Is Already Run!",
       Duration = 4,
       Image = 4483362458,
    })
    return
end

local enableMacro = true
local antiAFK = true
local UpdateStatus = true
local baseAfkNumber = 60
local currentAfkNumber = baseAfkNumber
local baseStatusNumber = 30
local currentStatusNumber = baseStatusNumber

_G.totalWindy       = 0
_G.totalSnowy       = 0
_G.totalRainy       = 0
_G.totalSandStorm   = 0
_G.totalHell        = 0
_G.totalStarfall    = 0
_G.totalHeaven      = 0
_G.totalCorruption  = 0
_G.totalNull        = 0
_G.totalGlitched    = 0
_G.totalDreamspace  = 0
_G.totalCyberspace  = 0

_G.total1M          = 0
_G.total10M         = 0
_G.total100M        = 0
_G.total1B          = 0

_G.totalMari        = 0
_G.totalRin         = 0
_G.totalJester      = 0

local saveFile = "macro_stats.txt" 

-- Single webhooks (Aura & Merchant)
_G.AuraWebhook = ""
_G.MerchantWebhooks = _G.MerchantWebhooks or {}

-- Multi webhooks (Biome only)
_G.RareBiomeWebhooks = _G.RareBiomeWebhooks or {}
_G.BiomeWebhooks = _G.BiomeWebhooks or {}

_G.StatusWebhook = ""

_G.SandStorm = ""
_G.Hell = ""
_G.Heaven = ""
_G.Starfall = ""
_G.Corruption = ""
_G.Null = ""
_G.Aurora = ""

_G.Glitched = false
_G.Dreamspace = false
_G.Cyberspace = false

_G.Mari = ""
_G.Jester = ""
_G.Rin = ""

_G.Globals = ""
_G.OneBillion = ""
_G.Native = ""
_G.Eden = ""

local currentVersion = "3.2.4"
local macroLOGO = "https://images-ext-1.discordapp.net/external/5SQy_HFQ9qnNKrpddi_zNH1Nb9t10WXPqggSJqVg_A8/%3Fcb%3D20260101162000/https/cdn.mongoosee.com/assets/biomes/GLITCHED.png"

local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")

local player = Players["LocalPlayer"]
local channel1 = TextChatService["TextChannels"]["RBXGeneral"]
local channel2 = TextChatService["Server Message"]

local Blacklisted = _G.BlacklistedUsers or loadstring(game:HttpGet("https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/Blacklisted.lua"))()
local privateServerLink = ""

-- Updated Biome Webhook Function (Multi-link support with smart pings)
local function SendBiomeWebhook(title, desc, color, anothermessage, spawnTime, despawnTime, contentmsg, image)
    if not enableMacro or #_G.BiomeWebhooks == 0 then return end

    local lowerTitleDesc = string.lower(title .. " " .. desc)

    local isEveryoneBiome = string.find(lowerTitleDesc, "glitched") 
        or string.find(lowerTitleDesc, "dreamspace") 
        or string.find(lowerTitleDesc, "cyberspace")

    local isRoleLimitedBiome = string.find(lowerTitleDesc, "sand storm")
        or string.find(lowerTitleDesc, "hell")
        or string.find(lowerTitleDesc, "starfall")
        or string.find(lowerTitleDesc, "heaven")
        or string.find(lowerTitleDesc, "corruption")
        or string.find(lowerTitleDesc, "null")

    local baseEmbed = {
        ["title"] = title,
        ["description"] = desc,
        ["image"] = {["url"] = ""},
        ["type"] = "rich",
        ["color"] = tonumber(color),
        ["footer"] = {
            ["text"] = "Unnamed Macro (v." .. currentVersion ..")",
            ["icon_url"] = macroLOGO,
        },
        ["thumbnail"] = { ["url"] = image or "" },
        ["fields"] = {
            {["name"]="Spawn Time", ["value"]=spawnTime, ["inline"]=true},
            {["name"]="Despawn Time", ["value"]=despawnTime, ["inline"]=true},
            {["name"]="Original Message", ["value"]=anothermessage, ["inline"]=true},
            {["name"]="Private Server Link", ["value"]=privateServerLink, ["inline"]=true}
        }
    }

    for i, webhookURL in pairs(_G.BiomeWebhooks) do
        local finalContent = contentmsg or ""

        if isEveryoneBiome then
            finalContent = "@everyone"  -- Always @everyone for these in ALL webhooks
        elseif isRoleLimitedBiome then
            if i == 1 then  -- Only ping role in FIRST webhook
                if string.find(lowerTitleDesc, "sand storm") then finalContent = _G.SandStorm or ""
                elseif string.find(lowerTitleDesc, "hell") then finalContent = _G.Hell or ""
                elseif string.find(lowerTitleDesc, "starfall") then finalContent = _G.Starfall or ""
                elseif string.find(lowerTitleDesc, "heaven") then finalContent = _G.Heaven or ""
                elseif string.find(lowerTitleDesc, "corruption") then finalContent = _G.Corruption or ""
                elseif string.find(lowerTitleDesc, "null") then finalContent = _G.Null or "" end
            else
                finalContent = ""  -- No ping in other webhooks
            end
        end
        -- For all other biomes: use original contentmsg (from toggles/inputs)

        local payload = HttpService:JSONEncode({
            ["content"] = finalContent,
            ["embeds"] = { baseEmbed }
        })

        spawn(function()
            request({
                ["Url"] = webhookURL,
                ["Method"] = "POST",
                ["Headers"] = {["Content-Type"] = "application/json"},
                ["Body"] = payload
            })
        end)
    end
end

local function SendRareBiomeWebhook(title, desc, color, anothermessage, spawnTime, despawnTime, contentmsg, image)
    if not enableMacro or #_G.RareBiomeWebhooks == 0 then return end

    local lowerTitleDesc = string.lower(title .. " " .. desc)

    local isEveryoneBiome = string.find(lowerTitleDesc, "glitched") 
        or string.find(lowerTitleDesc, "dreamspace") 
        or string.find(lowerTitleDesc, "cyberspace")

    local isRoleLimitedBiome = string.find(lowerTitleDesc, "sand storm")
        or string.find(lowerTitleDesc, "hell")
        or string.find(lowerTitleDesc, "starfall")
        or string.find(lowerTitleDesc, "heaven")
        or string.find(lowerTitleDesc, "corruption")
        or string.find(lowerTitleDesc, "null")

    local baseEmbed = {
        ["title"] = title,
        ["description"] = desc,
        ["image"] = {["url"] = ""},
        ["type"] = "rich",
        ["color"] = tonumber(color),
        ["footer"] = {
            ["text"] = "Unnamed Macro (v." .. currentVersion ..")",
            ["icon_url"] = macroLOGO,
        },
        ["thumbnail"] = { ["url"] = image or "" },
        ["fields"] = {
            {["name"]="Spawn Time", ["value"]=spawnTime, ["inline"]=true},
            {["name"]="Despawn Time", ["value"]=despawnTime, ["inline"]=true},
            {["name"]="Original Message", ["value"]=anothermessage, ["inline"]=true},
            {["name"]="Private Server Link", ["value"]=privateServerLink, ["inline"]=true}
        }
    }

    for i, webhookURL in pairs(_G.RareBiomeWebhooks) do
        local finalContent = contentmsg or ""

        if isEveryoneBiome then
            finalContent = "@everyone"  -- Always @everyone for these in ALL webhooks
        elseif isRoleLimitedBiome then
            if i == 1 then  -- Only ping role in FIRST webhook
                if string.find(lowerTitleDesc, "sand storm") then finalContent = _G.SandStorm or ""
                elseif string.find(lowerTitleDesc, "hell") then finalContent = _G.Hell or ""
                elseif string.find(lowerTitleDesc, "starfall") then finalContent = _G.Starfall or ""
                elseif string.find(lowerTitleDesc, "heaven") then finalContent = _G.Heaven or ""
                elseif string.find(lowerTitleDesc, "corruption") then finalContent = _G.Corruption or ""
                elseif string.find(lowerTitleDesc, "null") then finalContent = _G.Null or "" end
            else
                finalContent = ""  -- No ping in other webhooks
            end
        end
        -- For all other biomes: use original contentmsg (from toggles/inputs)

        local payload = HttpService:JSONEncode({
            ["content"] = finalContent,
            ["embeds"] = { baseEmbed }
        })

        spawn(function()
            request({
                ["Url"] = webhookURL,
                ["Method"] = "POST",
                ["Headers"] = {["Content-Type"] = "application/json"},
                ["Body"] = payload
            })
        end)
    end
end

-- Aura & Merchant remain single webhook (unchanged)
local function SendAuraWebhook(title, desc, color, anothermessage, GotTime, contentmsg, rolls)
    if not enableMacro then return end
    request({
        ["Url"] = _G.AuraWebhook,
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
                    ["text"] = "Unnamed Macro (v." .. currentVersion ..")",
                    ["icon_url"] = macroLOGO,
                },
                ["fields"] = {
                    {["name"]="Time Discovered", ["value"]=GotTime, ["inline"]=true},
                    {["name"]="Roll At Around", ["value"]=rolls, ["inline"]=true},
                }
            }}
        })
    })
end

local function SendMerchantWebhook(title, desc, color, anothermessage, spawnTime, despawnTime, contentmsg)
    if not enableMacro or #_G.MerchantWebhooks == 0 then return end

    local lowerDesc = string.lower(desc)
    local isMari = string.find(lowerDesc, "mari")
    local isJester = string.find(lowerDesc, "jester")
    local isRin = string.find(lowerDesc, "rin")

    local baseEmbed = {
        ["title"] = title,
        ["description"] = desc,
        ["image"] = {["url"] = ""},
        ["type"] = "rich",
        ["color"] = tonumber(color),
        ["footer"] = {
            ["text"] = "Unnamed Macro (v." .. currentVersion ..")",
            ["icon_url"] = macroLOGO,
        },
        ["fields"] = {
            {["name"]="Spawn Time", ["value"]=spawnTime, ["inline"]=true},
            {["name"]="Despawn Time", ["value"]=despawnTime, ["inline"]=true},
            {["name"]="Original Message", ["value"]=anothermessage, ["inline"]=true},
            {["name"]="Private Server Link", ["value"]=privateServerLink, ["inline"]=true}
        }
    }

    for i, url in pairs(_G.MerchantWebhooks) do
        local ping = (i == 1) and contentmsg or ""

        if i == 1 then
            if isMari then ping = _G.Mari or ""
            elseif isJester then ping = _G.Jester or "" 
            elseif isRin then ping = _G.Rin or ""
            end
        else
            ping = ""
        end

        spawn(function()
            request({
                Url = url,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({content = ping, embeds = {baseEmbed}})
            })
        end)
    end
end

local function SendStatusWebhook()
    if not enableMacro then return end
    request({
        ["Url"] = _G.StatusWebhook,
        ["Method"] = "POST",
        ["Headers"] = {["Content-Type"] = "application/json"},
        ["Body"] = HttpService:JSONEncode({
            ["content"] = "",
            ["embeds"] = {{
                ["title"] = "Macro Detection Status",
                ["description"] = "Total of biomes, auras and merchant in past " .. tostring(currentStatusNumber) .. " seconds",
                ["image"] = {["url"] = ""},
                ["type"] = "rich",
                ["color"] = tonumber(0xFF0000),
                ["footer"] = {
                    ["text"] = "Unnamed Macro (v." .. currentVersion ..")",
                    ["icon_url"] = macroLOGO,
                },
                ["fields"] = {
                    {["name"] = "Total Normal Biomes Found", ["value"] = _G.totalWindy + _G.totalSnowy + _G.totalRainy, ["inline"] = false},
                    {["name"] = "Windy",                     ["value"] = _G.totalWindy,   ["inline"] = false},
                    {["name"] = "Snowy",                     ["value"] = _G.totalSnowy,   ["inline"] = false},
                    {["name"] = "Rainy",                     ["value"] = _G.totalRainy,   ["inline"] = false},

                    {["name"] = "Total Rare Biomes Found",   ["value"] = _G.totalSandStorm + _G.totalHell + _G.totalStarfall + _G.totalHeaven + _G.totalCorruption + _G.totalNull + _G.totalGlitched + _G.totalDreamspace + _G.totalCyberspace, ["inline"] = false},
                    {["name"] = "Sand Storm",                ["value"] = _G.totalSandStorm,   ["inline"] = false},
                    {["name"] = "Hell",                      ["value"] = _G.totalHell,        ["inline"] = false},
                    {["name"] = "Starfall",                  ["value"] = _G.totalStarfall,    ["inline"] = false},
                    {["name"] = "Heaven",                    ["value"] = _G.totalHeaven,      ["inline"] = false},
                    {["name"] = "Corruption",                ["value"] = _G.totalCorruption,  ["inline"] = false},
                    {["name"] = "Null",                      ["value"] = _G.totalNull,        ["inline"] = false},
                    {["name"] = "Glitched",                  ["value"] = _G.totalGlitched,    ["inline"] = false},
                    {["name"] = "Dreamspace",                ["value"] = _G.totalDreamspace,  ["inline"] = false},
                    {["name"] = "Cyberspace",                ["value"] = _G.totalCyberspace,  ["inline"] = false},

                    {["name"] = "Total Auras Found (1M+ only)", ["value"] = _G.total1M + _G.total10M + _G.total100M + _G.total1B, ["inline"] = false},
                    {["name"] = "1M Auras",                  ["value"] = _G.total1M,     ["inline"] = false},
                    {["name"] = "10M Auras",                 ["value"] = _G.total10M,    ["inline"] = false},
                    {["name"] = "100M Auras",                ["value"] = _G.total100M,   ["inline"] = false},
                    {["name"] = "1B Auras",                  ["value"] = _G.total1B,     ["inline"] = false},

                    {["name"] = "Total Merchants Found",     ["value"] = _G.totalMari + _G.totalRin + _G.totalJester, ["inline"] = false},
                    {["name"] = "Mari",                      ["value"] = _G.totalMari,   ["inline"] = false},
                    {["name"] = "Rin",                       ["value"] = _G.totalRin,    ["inline"] = false},
                    {["name"] = "Jester",                    ["value"] = _G.totalJester, ["inline"] = false},
                }
            }}
        })
    })
end

local function extractHexColor(input)
    local hex = string.match(input, 'color="[#]?(%x%x%x%x%x%x)"')
    if hex then return "0x"..hex end
    return "0xFFFFFF"
end

local function formatNumberWithCommas(number)
    local formatted = tostring(number)
    local result = ""
    local isNegative = formatted:sub(1, 1) == "-"
    if isNegative then formatted = formatted:sub(2) end
    local length = #formatted
    for i = 1, length do
        result = formatted:sub(length - i + 1, length - i + 1) .. result
        if i % 3 == 0 and i ~= length then result = "," .. result end
    end
    return isNegative and "-" .. result or result
end

local function GetKeywordCache()
    return {
        ["windy"]       = {["display"]="Windy", ["despawn"]=120},
        ["snowy"]       = {["display"]="Snowy", ["despawn"]=120},
        ["rainy"]       = {["display"]="Rainy", ["despawn"]=120},
        ["blazingsun"] = {["display"]="Blazing Sun", ["despawn"]=140},
        ["graveyard"] = {["display"]="Graveyard", ["despawn"]=140},
        ["pumpkinmoon"] = {["display"]="Pumpkin Moon", ["despawn"]=140},
        ["bloodrain"] = {["display"]="Blood Rain", ["despawn"]=600},
        ["aurora"] = {["display"]="Aurora", ["despawn"]=300, ["ping"]=_G["Aurora"]},
        ["sandstorm"]  = {["display"]="Sand Storm", ["despawn"]=660, ["ping"]=_G["SandStorm"]},
        ["hell"]        = {["display"]="Hell", ["despawn"]=660, ["ping"]=_G["Hell"]},
        ["heaven"]      = {["display"]="Heaven", ["despawn"]=240, ["ping"]=_G["Heaven"]},
        ["starfall"]    = {["display"]="Starfall", ["despawn"]=600, ["ping"]=_G["Starfall"]},
        ["corruption"]  = {["display"]="Corruption", ["despawn"]=660, ["ping"]=_G["Corruption"]},
        ["null"]        = {["display"]="Null", ["despawn"]=99, ["ping"]=_G["Null"]},
        ["manager"]     = {["display"]="Glitched", ["despawn"]=124, ["ping"]=_G["Glitched"]},
        ["dreamspace"]  = {["display"]="Dreamspace", ["despawn"]=192, ["ping"]=_G["Dreamspace"]},
        ["cyberspace"]  = {["display"]="Cyberspace", ["despawn"]=720, ["ping"]=_G["Cyberspace"]},
        ["mari"]        = {["display"]="Mari", ["despawn"]=180, ["ping"]=_G["Mari"]},
        ["jester"]      = {["display"]="Jester", ["despawn"]=180, ["ping"]=_G["Jester"]},
        ["rin"]         = {["display"]="Rin", ["despawn"]=180, ["ping"]=_G["Rin"]},
        ["eden"]        = {["display"]="Eden", ["despawn"]=1800, ["ping"]=_G["Eden"]},
    }
end

local native = {
    ["windy"]       = { display = "Windy",       multiplier = 3  },
    ["snowy"]       = { display = "Snowy",       multiplier = 3  },
    ["rainy"]       = { display = "Rainy",       multiplier = 4  },
    ["sandstorm"]   = { display = "Sandstorm",   multiplier = 4  },
    ["starfall"]    = { display = "Starfall",    multiplier = 5  },
    ["heaven"]      = { display = "Heaven",      multiplier = 5  },
    ["corruption"]  = { display = "Corruption",  multiplier = 5  },
    ["hell"]        = { display = "Hell",        multiplier = 6  },
    ["day"]         = { display = "Day",         multiplier = 10 },
    ["night"]       = { display = "Night",       multiplier = 10 },
    ["null"]        = { display = "Null",        multiplier = 1000 },
    ["cyberspace"]  = { display = "Cyberspace",  multiplier = 2 },
    ["aurora"]  = { display = "Aurora",  multiplier = 2 },
}

local function IsNative(text)
    local lower = text:lower():gsub(" ", "")
    local isNative = false
    local nativeMultiplier = 1
    local biomeName = nil
    for key, data in pairs(native) do
        if string.find(lower, key) then
            biomeName = data.display
            nativeMultiplier = data.multiplier
            isNative = true
            break
        end
    end
    if isNative then return biomeName, nativeMultiplier, isNative end
    return false
end

local function saveBiomes()
    local data = {
        "totalWindy = " .. _G.totalWindy,
        "totalSnowy = " .. _G.totalSnowy,
        "totalRainy = " .. _G.totalRainy,
        "totalSandStorm = " .. _G.totalSandStorm,
        "totalHell = " .. _G.totalHell,
        "totalStarfall = " .. _G.totalStarfall,
        "totalHeaven = " .. _G.totalHeaven,
        "totalCorruption = " .. _G.totalCorruption,
        "totalNull = " .. _G.totalNull,
        "totalGlitched = " .. _G.totalGlitched,
        "totalDreamspace = " .. _G.totalDreamspace,
        "totalCyberspace = " .. _G.totalCyberspace,
        "total1M = " .. _G.total1M,
        "total10M = " .. _G.total10M,
        "total100M = " .. _G.total100M,
        "total1B = " .. _G.total1B,
        "totalMari = " .. _G.totalMari,
        "totalRin = " .. _G.totalRin,
        "totalJester = " .. _G.totalJester
    }
    
    local content = table.concat(data, "\n")
    
    local success, err = pcall(function()
        writefile(saveFile, content)
    end)
    
    if success then
        print("Successfully saved file: " .. saveFile)
    else
        warn("Failed to save file " .. saveFile .. ": " .. tostring(err))
    end
end

local function loadBiomes()
    if isfile(saveFile) then
        local content = readfile(saveFile)
        for line in content:gmatch("[^\r\n]+") do
            local var, val = line:match("([^=]+)%s*=%s*(%d+)")
            if var and val then
                var = var:match("^%s*(.-)%s*$")  -- trim ช่องว่าง
                _G[var] = tonumber(val) or 0     -- อัปเดตตัวแปร global
            end
        end
        print("Successfully loaded file")
    else
        warn("Cannot find the old file")
    end
end

local Window = Rayfield:CreateWindow({
   Name = "Macro Script (v."..currentVersion..")",
   Icon = 0,
   LoadingTitle = "Loading System...",
   LoadingSubtitle = "by Chosen and P Joe",
   ShowText = "Macro",
   Theme = "Default",
   ToggleUIKeybind = "Q",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Macro Script Configs"
   },
   Discord = { Enabled = false, Invite = "noinvitelink", RememberJoins = true },
   KeySystem = false,
})

local Tab = Window:CreateTab("Main", 4483362458)
local Section = Tab:CreateSection("Main")

local MacroToggle = Tab:CreateToggle({
   Name = "Enable Macro",
   CurrentValue = true,
   Flag = "EnableMacro",
   Callback = function(Value) enableMacro = Value end,
})

local AntiAFKToggle = Tab:CreateToggle({
   Name = "Anti AFK",
   CurrentValue = true,
   Flag = "AntiAFK",
   Callback = function(Value) antiAFK = Value end,
})

local AFKInput = Tab:CreateInput({
   Name = "Click Screen Every (Seconds)",
   CurrentValue = "",
   PlaceholderText = "Type Number Here (Min = 3)",
   RemoveTextAfterFocusLost = false,
   Flag = "AntiAFKSetting",
   Callback = function(Text)
      currentAfkNumber = tonumber(Text) or baseAfkNumber
      if currentAfkNumber <= 3 then currentAfkNumber = 4 end
   end,
})

local DetectionStatusToggle = Tab:CreateToggle({
   Name = "Update Total Macro Detection",
   CurrentValue = true,
   Flag = "UpdateStatus",
   Callback = function(Value) UpdateStatus = Value end,
})

local StatusInput = Tab:CreateInput({
   Name = "Update Status Every (Seconds)",
   CurrentValue = "",
   PlaceholderText = "Type Number Here (Min = 30)",
   RemoveTextAfterFocusLost = false,
   Flag = "StatusMacroSetting",
   Callback = function(Text)
      currentStatusNumber = tonumber(Text) or baseStatusNumber
      if currentStatusNumber < 30 then currentStatusNumber = 30 end
   end,
})
local StatusWebhook = Tab:CreateInput({ Name = "Status Webhook", PlaceholderText = "Enter Webhook Link", Flag = "StatusWebhookConfig", Callback = function(Text) _G.StatusWebhook = Text end })

local BiomeLabel = Tab:CreateLabel("Biome Setting", 4483362458, Color3.fromRGB(80,80,80), false)

-- MULTI BIOME WEBHOOK INPUT
local BiomeWebhooksInput = Tab:CreateInput({
   Name = "Biome Webhooks (comma separated)",
   CurrentValue = "",
   PlaceholderText = "Enter multiple biome webhooks, separate with commas",
   RemoveTextAfterFocusLost = false,
   Flag = "BiomeWebhookConfig",
   Callback = function(Text)
      _G.BiomeWebhooks = {}
      for url in string.gmatch(Text or "", "([^,]+)") do
         url = url:gsub("^%s*(.-)%s*$", "%1")
         if url ~= "" and string.find(url, "^https?://discord%.com/api/webhooks/") then
            table.insert(_G.BiomeWebhooks, url)
         end
      end
   end,
})

local RareBiomeWebhooksInput = Tab:CreateInput({
   Name = "Rare Biome Webhooks (comma separated)",
   CurrentValue = "",
   PlaceholderText = "Enter multiple biome webhooks, separate with commas",
   RemoveTextAfterFocusLost = false,
   Flag = "RareBiomeWebhookConfig",
   Callback = function(Text)
      _G.RareBiomeWebhooks = {}
      for url in string.gmatch(Text or "", "([^,]+)") do
         url = url:gsub("^%s*(.-)%s*$", "%1")
         if url ~= "" and string.find(url, "^https?://discord%.com/api/webhooks/") then
            table.insert(_G.RareBiomeWebhooks, url)
         end
      end
   end,
})

-- Role ping inputs (unchanged)
local SandStormInput = Tab:CreateInput({ Name = "Sand Storm Ping Role", PlaceholderText = "Enter Discord Role ID", Flag = "Config1", Callback = function(Text) _G.SandStorm = "<@&"..Text..">" end })
local HellInput = Tab:CreateInput({ Name = "Hell Ping Role", PlaceholderText = "Enter Discord Role ID", Flag = "Config2", Callback = function(Text) _G.Hell = "<@&"..Text..">" end })
local StarfallInput = Tab:CreateInput({ Name = "Starfall Ping Role", PlaceholderText = "Enter Discord Role ID", Flag = "Config3", Callback = function(Text) _G.Starfall = "<@&"..Text..">" end })
local HeavenInput = Tab:CreateInput({ Name = "Heaven Ping Role", PlaceholderText = "Enter Discord Role ID", Flag = "Config4", Callback = function(Text) _G.Heaven = "<@&"..Text..">" end })
local CorruptionInput = Tab:CreateInput({ Name = "Corruption Ping Role", PlaceholderText = "Enter Discord Role ID", Flag = "Config5", Callback = function(Text) _G.Corruption = "<@&"..Text..">" end })
local NullInput = Tab:CreateInput({ Name = "Null Ping Role", PlaceholderText = "Enter Discord Role ID", Flag = "Config6", Callback = function(Text) _G.Null = "<@&"..Text..">" end })
--local AuroraInput = Tab:CreateInput({ Name = "Aurora Ping Role", PlaceholderText = "Enter Discord Role ID", Flag = "AuroraBiomeConfig", Callback = function(Text) _G.Aurora = "<@&"..Text..">" end })
local PSInput = Tab:CreateInput({ Name = "Private Server Link", PlaceholderText = "Enter Your Private Server Link", Flag = "privateServerLinkConfig", Callback = function(Text) privateServerLink = Text end })

local CyberspaceToggle = Tab:CreateToggle({ Name = "Cyberspace Ping Everyone", CurrentValue = true, Flag = "Config7", Callback = function(Value) _G.Cyberspace = Value end })
local DreamspaceToggle = Tab:CreateToggle({ Name = "Dreamspace Ping Everyone", CurrentValue = true, Flag = "Config8", Callback = function(Value) _G.Dreamspace = Value end })
local GlitchedToggle = Tab:CreateToggle({ Name = "Glitched Ping Everyone", CurrentValue = true, Flag = "Config9", Callback = function(Value) _G.Glitched = Value end })

-- Aura & Merchant sections (single webhook - unchanged)
local AuraLabel = Tab:CreateLabel("Aura Setting (Detect from message of chat...)", 4483362458, Color3.fromRGB(80,80,80), false)
Tab:CreateInput({ Name = "Aura Webhook", PlaceholderText = "Enter Webhook Link", Flag = "AuraWebhookConfig", Callback = function(Text) _G.AuraWebhook = Text end })
Tab:CreateInput({ Name = "Global Ping Role", PlaceholderText = "Enter Discord Role ID", Flag = "AuraConfig1", Callback = function(Text) _G.Globals = "<@&"..Text..">" end })
Tab:CreateInput({ Name = "Native Global Ping Role", PlaceholderText = "Enter Discord Role ID", Flag = "AuraConfig2", Callback = function(Text) _G.Native = "<@&"..Text..">" end })
Tab:CreateInput({ Name = "1B Ping Role", PlaceholderText = "Enter Discord Role ID", Flag = "AuraConfig3", Callback = function(Text) _G.OneBillion = "<@&"..Text..">" end })
Tab:CreateInput({ Name = "Eden Ping Role", PlaceholderText = "Enter Discord Role ID", Flag = "AuraConfig4", Callback = function(Text) _G.Eden = "<@&"..Text..">" end })

local MerchantLabel = Tab:CreateLabel("Merchant Setting", 4483362458, Color3.fromRGB(80,80,80), false)
local MerchantWebhooksInput = Tab:CreateInput({
   Name = "Merchant Webhooks (comma separated)",
   CurrentValue = "",
   PlaceholderText = "Enter multiple merchant webhooks, separate with commas",
   RemoveTextAfterFocusLost = false,
   Flag = "MerchantWebhookConfig",
   Callback = function(Text)
      _G.MerchantWebhooks = {}
      for url in string.gmatch(Text or "", "([^,]+)") do
         url = url:gsub("^%s*(.-)%s*$", "%1")
         if url ~= "" and string.find(url, "^https?://discord%.com/api/webhooks/") then
            table.insert(_G.MerchantWebhooks, url)
         end
      end
   end,
})
Tab:CreateInput({ Name = "Mari Ping Role", PlaceholderText = "Enter Discord Role ID", Flag = "MerchantConfig1", Callback = function(Text) _G.Mari = "<@&"..Text..">" end })
Tab:CreateInput({ Name = "Jester Ping Role", PlaceholderText = "Enter Discord Role ID", Flag = "MerchantConfig2", Callback = function(Text) _G.Jester = "<@&"..Text..">" end })
Tab:CreateInput({ Name = "Rin Ping Role", PlaceholderText = "Enter Discord Role ID", Flag = "MerchantConfig3", Callback = function(Text) _G.Rin = "<@&"..Text..">" end })

-- Anti-AFK Loop
task.spawn(function()
    while true do
        task.wait(currentAfkNumber)
        if antiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(0,0))
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(currentStatusNumber)
        if UpdateStatus then
            SendStatusWebhook()
        end
    end
end)

-- Aura Detection (channel2)
task.spawn(function()
    channel2["MessageReceived"]:Connect(function(message)
        if not message["Text"] then return end
        if string.match(message.Text:lower(), "global") then return end

        local text = message["Text"]
        local playerRolled = nil
        for _, v in pairs(Players:GetPlayers()) do
            if string.match(text, v.Name) then playerRolled = v break end
        end

        if playerRolled then
            for _,v in pairs(Blacklisted) do
                if string.match(playerRolled.Name, v) then return end
            end
        end

        local color = extractHexColor(message.Text)
        text = text:gsub("<.->", "")
        local lowerText = text:lower()
        local numberStr = string.match(text, "CHANCE OF 1 IN ([%d,]+)")
        local RollAmount = playerRolled and formatNumberWithCommas(playerRolled:GetAttribute("Rolls")) or "[ Unknown ]"
        local contentmsg = ""

        local discordTime = "<t:" .. os.time() .. ":F>" .. " Or " .. "<t:" .. os.time() .. ":R>"

        if numberStr then
            numberStr = numberStr:gsub(",", "")
            local biome, multi, isNative = IsNative(text)
            if isNative then
                local trueRarity = tonumber(numberStr) * multi
                if trueRarity >= 99999999 then
                   contentmsg = _G["Native"]
                   _G.total100M += 1
                end
                SendAuraWebhook("**Aura Detected**", text, color, text, discordTime, contentmsg, RollAmount)
                saveBiomes()
            else
                local number = tonumber(numberStr)
                
                if number >= 999999999 then 
                    contentmsg = _G["OneBillion"] 
                    _G.total1B += 1
                elseif number >= 99999999 then 
                    contentmsg = _G["Globals"]
                    _G.total100M += 1
                elseif number >= 9999999 then
                    _G.total10M += 1
                elseif number >= 999999 then
                    _G.total1M += 1
                end
                SendAuraWebhook("**Aura Detected**", text, color, text, discordTime, contentmsg, RollAmount)
                saveBiomes()
            end
        else
            local pingRole = ""
            if string.match(lowerText, "pixelated") 
                or string.match(lowerText, "blinding") 
                or string.match(lowerText, "positive")
                or string.match(lowerText, "transcendent") 
                or string.match(lowerText, "the truth") 
                or string.match(lowerText, "neferkhaf")
                or string.match(lowerText, "nightmare") 
                or string.match(lowerText, "calamity") 
                or string.match(lowerText, "perfect puppet")
                or string.match(lowerText, "frozen sovereign") 
                or string.match(lowerText, "all hail")
                or string.match(lowerText, "beneath") 
                or string.match(lowerText, "breakthrough") then
                _G.total1B += 1
                pingRole = _G.OneBillion
            elseif string.match(lowerText, "glorious") or string.match(lowerText, "memory") then
                _G.total100M += 1
                pingRole = _G.Globals
            end
            SendAuraWebhook("**Aura Detected**", text, color, text, discordTime, pingRole, RollAmount)
            saveBiomes()
        end
    end)
end)

-- Biome/Merchant/Eden Detection (channel1)
task.spawn(function()
    channel1["MessageReceived"]:Connect(function(message)
        if not message["Text"] or message["TextSource"] ~= nil then return end
        if string.match(message["Text"]:lower(), "tip") then return end
        local text = message["Text"]:lower()
        local gsubText = message.Text:lower():gsub(" ","")
        local color = extractHexColor(message.Text)
        local keywordCache = GetKeywordCache()
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

        -- Smart contentmsg for multi-webhook logic
        local contentmsg = ""
        if keyword == "dreamspace" or keyword == "cyberspace" or keyword == "manager" then
            if _G.Dreamspace or _G.Cyberspace or _G.Glitched then
                contentmsg = "@everyone"
            end
        else
            contentmsg = data["ping"] or ""
        end

        local time = os.time()
        local discordTime = "<t:" .. time .. ":F>" .. " Or " .. "<t:" .. time .. ":R>"
        local discordDespawnTime = "<t:" .. (time + despawnTime) .. ":F>" .. " Or " .. "<t:" .. (time + despawnTime) .. ":R>"

        local imageURL = ""
        if keyword == "windy" then _G.totalWindy += 1 imageURL = "https://images-ext-1.discordapp.net/external/eo1JYqLLEdIz9Fa6lO4vq67nuwP-WRwTwUwGawZxFhE/%3Fcb%3D20260102004000/https/cdn.mongoosee.com/assets/biomes/WINDY.png"
        elseif keyword == "snowy" then _G.totalSnowy += 1 imageURL = "https://images-ext-1.discordapp.net/external/sWb2oiEYrmUNKNkCtv6JKynYKRUvRqhc4ADSS7C2z1E/%3Fcb%3D20260102004000/https/cdn.mongoosee.com/assets/biomes/SNOWY.png"
        elseif keyword == "rainy" then _G.totalRainy += 1 imageURL = "https://images-ext-1.discordapp.net/external/h0Ia04sYgDtxzz_UPKyNxpC7V4EYPoQv8NG2W1VU1RA/%3Fcb%3D20260102004000/https/cdn.mongoosee.com/assets/biomes/RAINY.png"
        elseif keyword == "sandstorm" then _G.totalSandStorm += 1 imageURL = "https://images-ext-1.discordapp.net/external/DDds7hi6Fvis70CJJNKIrtX276EcinbBSzDr-1w410s/%3Fcb%3D20260101235000/https/cdn.mongoosee.com/assets/biomes/SAND%2520STORM.png"
        elseif keyword == "hell" then _G.totalHell += 1 imageURL = "https://images-ext-1.discordapp.net/external/dzf7wwtggtJrTtGm2gmVjBdygGFrSphMj6m1cJCHVyk/%3Fcb%3D20260102003000/https/cdn.mongoosee.com/assets/biomes/HELL.png"
        elseif keyword == "heaven" then _G.totalHeaven += 1 imageURL = "https://images-ext-1.discordapp.net/external/9u3imY3UUVyeG_YbKI1wM2d_mPYAjlU2JYGCTfgEOUk/%3Fcb%3D20260101234000/https/cdn.mongoosee.com/assets/biomes/HEAVEN.png"
        elseif keyword == "starfall" then _G.totalStarfall += 1 imageURL = "https://images-ext-1.discordapp.net/external/fvrAcNOIkLGcRLt_oYvmbb5rEVxy18WRFzW5xRmKvAE/%3Fcb%3D20260102004000/https/cdn.mongoosee.com/assets/biomes/STARFALL.png"
        elseif keyword == "corruption" then _G.totalCorruption += 1 imageURL = "https://images-ext-1.discordapp.net/external/8DjoqCte5sN1qwxk6i72W5KHR_ZQklBKmkgt0SnMHf4/%3Fcb%3D20260102004000/https/cdn.mongoosee.com/assets/biomes/CORRUPTION.png"
        elseif keyword == "null" then _G.totalNull += 1 imageURL = "https://images-ext-1.discordapp.net/external/52UYmSQzxuFU8Ic3ynXdB2jORcht7PGkOQi-c50jLrE/%3Fcb%3D20260102003000/https/cdn.mongoosee.com/assets/biomes/NULL.png"
        elseif keyword == "manager" then imageURL = "https://images-ext-1.discordapp.net/external/5SQy_HFQ9qnNKrpddi_zNH1Nb9t10WXPqggSJqVg_A8/%3Fcb%3D20260101162000/https/cdn.mongoosee.com/assets/biomes/GLITCHED.png"
            if string.match(cleanMsg:lower(), "resolved") then return end _G.totalGlitched += 1
        elseif keyword == "dreamspace" then imageURL = "https://images-ext-1.discordapp.net/external/xCsP-8SbE5Z5HSoZP8uCe-eYZvxzSapISP969dyJ52M/%3Fcb%3D20260101141000/https/cdn.mongoosee.com/assets/biomes/DREAMSPACE.png"
            if string.match(cleanMsg:lower(), "waking") then return end _G.totalDreamspace += 1
        elseif keyword == "cyberspace" then imageURL = "https://images-ext-1.discordapp.net/external/2wCNSYyhRB-yxKOSt6qsLNohgam0TCUOQ6ITZP3o5_s/%3Fcb%3D20260101161000/https/cdn.mongoosee.com/assets/biomes/CYBERSPACE.png"
            if string.match(cleanMsg:lower(), "lost") then return end _G.totalCyberspace += 1
        elseif keyword == "aurora" then imageURL = "https://images-ext-1.discordapp.net/external/rm6JpGpB0Mlxe28ULtYy2L8nbY0O7X5qYKje0Zfrmk4/%3Fcb%3D20260101231000/https/cdn.mongoosee.com/assets/biomes/AURORA.png"
            if string.match(cleanMsg:lower(), "disappears") then return end
            color = "0x9258FC"
        end

        if keyword == "mari" or keyword == "jester" or keyword == "rin" then
            if keyword == "mari" then 
                _G.totalMari += 1
            elseif keyword == "rin" then
                _G.totalRin += 1
            else
                _G.totalJester += 1
            end
            SendMerchantWebhook("**Merchant Detected**", data["display"] .. " Has Spawned!", color, cleanMsg, discordTime, discordDespawnTime, contentmsg)
        elseif keyword == "eden" then
            SendBiomeWebhook("**Eden Detected**", "Eden Has Spawned On " .. player["Name"] .. " Side!", color, cleanMsg, discordTime, discordDespawnTime, contentmsg, "")
        elseif keyword == "rainy" or keyword == "windy" or keyword == "snowy" then
            SendBiomeWebhook("**Common Biome Detected**", data["display"] .. " Has Spawned!", color, cleanMsg, discordTime, discordDespawnTime, contentmsg, imageURL)
        else
            SendRareBiomeWebhook("**Rare Biome Detected**", data["display"] .. " Has Spawned!", color, cleanMsg, discordTime, discordDespawnTime, contentmsg, imageURL)
        end
        saveBiomes()
    end)
end)

Rayfield:LoadConfiguration()
loadBiomes()
Rayfield:SetVisibility(false)

print(currentVersion)
print("Loaded Script.")
Rayfield:Notify({
   Title = "Loaded Script",
   Content = "The Script is Loaded!",
   Duration = 5,
   Image = 4483362458,
})
