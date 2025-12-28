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
local baseAfkNumber = 60
local currentAfkNumber = baseAfkNumber

_G.BiomeWebhook = ""
_G.AuraWebhook = ""
_G.MerchantWebhook = ""

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

_G.Globals = ""
_G.OneBillion = ""
_G.Native = ""
_G.Eden = ""

local currentVersion = "2.1.6"
local macroLOGO = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/Images/%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B8%8A%E0%B8%B7%E0%B9%88%E0%B8%AD%2036_20251104174445.png?raw=true"

local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")

local player = Players["LocalPlayer"]
local channel1 = TextChatService["TextChannels"]["RBXGeneral"]
local channel2 = TextChatService["Server Message"]

local Blacklisted = _G.BlacklistedUsers or loadstring(game:HttpGet("https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/Blacklisted.lua"))()

-- Webhook Functions
local function SendBiomeWebhook(title, desc, color, anothermessage, webhookURL, spawnTime, despawnTime, contentmsg, image)
    if webhookURL == "" or not enableMacro then return end
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
                    ["icon_url"] = macroLOGO,
                },
                ["thumbnail"] = {
                    ["url"] = image
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
    if webhookURL == "" or not enableMacro then return end
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

local function SendMerchantWebhook(title, desc, color, anothermessage, webhookURL, spawnTime, despawnTime, contentmsg)
    if webhookURL == "" or not enableMacro then return end
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
                    ["icon_url"] = macroLOGO,
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

    -- detect biome keyword
    for key, data in pairs(native) do
        if string.find(lower, key) then
            biomeName = data.display
            nativeMultiplier = data.multiplier
            isNative = true
            break
        end
    end

    if isNative then
        return biomeName, nativeMultiplier, isNative
    end
    return false
end

local Window = Rayfield:CreateWindow({
   Name = "Macro Script (v."..currentVersion..")",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Loading System...",
   LoadingSubtitle = "by Chosen and P Joe",
   ShowText = "Macro", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "Q", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Macro Script Configs"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Tab = Window:CreateTab("Main", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Main")
local MacroToggle = Tab:CreateToggle({
   Name = "Enable Macro",
   CurrentValue = true,
   Flag = "EnableMacro",
   Callback = function(Value)
      enableMacro = Value
   end,
})
local AntiAFKToggle = Tab:CreateToggle({
   Name = "Anti AFK",
   CurrentValue = true,
   Flag = "AntiAFK",
   Callback = function(Value)
      antiAFK = Value
   end,
})
local AFKInput = Tab:CreateInput({
   Name = "Click Screen Every (Seconds)",
   CurrentValue = "",
   PlaceholderText = "Type Number Here",
   RemoveTextAfterFocusLost = false,
   Flag = "AntiAFKSetting",
   Callback = function(Text)
      if tonumber(Text) == nil then
         currentAfkNumber = baseAfkNumber
         CurrentValue = ""
      else
         currentAfkNumber = tonumber(Text)
      end
   end,
})
local BiomeLabel = Tab:CreateLabel("Biome Setting", 4483362458, Color3.fromRGB(80,80,80), false) -- Title, Icon, Color, IgnoreTheme
local BiomeInput = Tab:CreateInput({
   Name = "Biome Webhook",
   CurrentValue = "",
   PlaceholderText = "Enter Webhook Link",
   RemoveTextAfterFocusLost = false,
   Flag = "BiomeWebhookConfig",
   Callback = function(Text)
      _G.BiomeWebhook = Text
   end,
})
local SandStormInput = Tab:CreateInput({
   Name = "Sand Storm Ping Role",
   CurrentValue = "",
   PlaceholderText = "Enter Discord Role ID",
   RemoveTextAfterFocusLost = false,
   Flag = "Config1",
   Callback = function(Text)
      _G.SandStorm = "<@&"..Text..">"
   end,
})
local HellInput = Tab:CreateInput({
   Name = "Hell Ping Role",
   CurrentValue = "",
   PlaceholderText = "Enter Discord Role ID",
   RemoveTextAfterFocusLost = false,
   Flag = "Config2",
   Callback = function(Text)
      _G.Hell = "<@&"..Text..">"
   end,
})
local StarfallInput = Tab:CreateInput({
   Name = "Starfall Ping Role",
   CurrentValue = "",
   PlaceholderText = "Enter Discord Role ID",
   RemoveTextAfterFocusLost = false,
   Flag = "Config3",
   Callback = function(Text)
      _G.Starfall = "<@&"..Text..">"
   end,
})
local HeavenInput = Tab:CreateInput({
   Name = "Heaven Ping Role",
   CurrentValue = "",
   PlaceholderText = "Enter Discord Role ID",
   RemoveTextAfterFocusLost = false,
   Flag = "Config4",
   Callback = function(Text)
      _G.Heaven = "<@&"..Text..">"
   end,
})
local CorruptionInput = Tab:CreateInput({
   Name = "Corruption Ping Role",
   CurrentValue = "",
   PlaceholderText = "Enter Discord Role ID",
   RemoveTextAfterFocusLost = false,
   Flag = "Config5",
   Callback = function(Text)
      _G.Corruption = "<@&"..Text..">"
   end,
})
local NullInput = Tab:CreateInput({
   Name = "Null Ping Role",
   CurrentValue = "",
   PlaceholderText = "Enter Discord Role ID",
   RemoveTextAfterFocusLost = false,
   Flag = "Config6",
   Callback = function(Text)
      _G.Null = "<@&"..Text..">"
   end,
})
local AuroraInput = Tab:CreateInput({
   Name = "Aurora Ping Role",
   CurrentValue = "",
   PlaceholderText = "Enter Discord Role ID",
   RemoveTextAfterFocusLost = false,
   Flag = "AuroraBiomeConfig",
   Callback = function(Text)
      _G.Aurora = "<@&"..Text..">"
   end,
})
local CyberspaceToggle = Tab:CreateToggle({
   Name = "Cyberspace Ping Everyone",
   CurrentValue = true,
   Flag = "Config7",
   Callback = function(Value)
      _G.Cyberspace = Value
   end,
})
local DreamspaceToggle = Tab:CreateToggle({
   Name = "Dreamspace Ping Everyone",
   CurrentValue = true,
   Flag = "Config8",
   Callback = function(Value)
      _G.Dreamspace = Value
   end,
})
local GlitchedToggle = Tab:CreateToggle({
   Name = "Glitched Ping Everyone",
   CurrentValue = true,
   Flag = "Config9",
   Callback = function(Value)
      _G.Glitched = Value
   end,
})
local AuraLabel = Tab:CreateLabel("Aura Setting (Detect from message of chat, so you need to setting your server message ignore rarity in game setting.", 4483362458, Color3.fromRGB(80,80,80), false) -- Title, Icon, Color, IgnoreTheme
local BiomeInput = Tab:CreateInput({
   Name = "Aura Webhook",
   CurrentValue = "",
   PlaceholderText = "Enter Webhook Link",
   RemoveTextAfterFocusLost = false,
   Flag = "AuraWebhookConfig",
   Callback = function(Text)
      _G.AuraWebhook = Text
   end,
})
local GlobalInput = Tab:CreateInput({
   Name = "Global Ping Role",
   CurrentValue = "",
   PlaceholderText = "Enter Discord Role ID",
   RemoveTextAfterFocusLost = false,
   Flag = "AuraConfig1",
   Callback = function(Text)
      _G.Globals = "<@&"..Text..">"
   end,
})
local NativeInput = Tab:CreateInput({
   Name = "Native Global Ping Role",
   CurrentValue = "",
   PlaceholderText = "Enter Discord Role ID",
   RemoveTextAfterFocusLost = false,
   Flag = "AuraConfig2",
   Callback = function(Text)
      _G.Native = "<@&"..Text..">"
   end,
})
local OneBillionInput = Tab:CreateInput({
   Name = "1B Ping Role",
   CurrentValue = "",
   PlaceholderText = "Enter Discord Role ID",
   RemoveTextAfterFocusLost = false,
   Flag = "AuraConfig3",
   Callback = function(Text)
      _G.OneBillion = "<@&"..Text..">"
   end,
})
local EdenInput = Tab:CreateInput({
   Name = "Eden Ping Role",
   CurrentValue = "",
   PlaceholderText = "Enter Discord Role ID",
   RemoveTextAfterFocusLost = false,
   Flag = "AuraConfig4",
   Callback = function(Text)
      _G.Eden = "<@&"..Text..">"
   end,
})
local MerchantLabel = Tab:CreateLabel("Merchant Setting", 4483362458, Color3.fromRGB(80,80,80), false) -- Title, Icon, Color, IgnoreTheme
local MerchantInput = Tab:CreateInput({
   Name = "Merchant Webhook",
   CurrentValue = "",
   PlaceholderText = "Enter Webhook Link",
   RemoveTextAfterFocusLost = false,
   Flag = "MerchantWebhookConfig",
   Callback = function(Text)
      _G.MerchantWebhook = Text
   end,
})
local MariInput = Tab:CreateInput({
   Name = "Mari Ping Role",
   CurrentValue = "",
   PlaceholderText = "Enter Discord Role ID",
   RemoveTextAfterFocusLost = false,
   Flag = "MerchantConfig1",
   Callback = function(Text)
      _G.Mari = "<@&"..Text..">"
   end,
})
local JesterInput = Tab:CreateInput({
   Name = "Jester Ping Role",
   CurrentValue = "",
   PlaceholderText = "Enter Discord Role ID",
   RemoveTextAfterFocusLost = false,
   Flag = "MerchantConfig2",
   Callback = function(Text)
      _G.Jester = "<@&"..Text..">"
   end,
})

task.spawn(function()
    while true do
        task.wait(currentAfkNumber)
        if antiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(0,0))
        end
    end
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
            local discordTime = "<t:" .. os.time() .. ":F>" .. " Or " .. "<t:" .. os.time() .. ":R>"
            local biome, multi, isNative = IsNative(text, numberStr)
            if isNative then
                local trueRarity = tonumber(numberStr) * multi
                if trueRarity >= 99999999 then
                    contentmsg = _G["Native"]
                end
                SendAuraWebhook("**Aura Detected**", text, color, text, _G["AuraWebhook"], discordTime, contentmsg, RollAmount)
            else
                local number = tonumber(numberStr)
                if number >= 99999999 then
                   contentmsg = _G["Globals"]
                elseif number >= 999999999 then
                   contentmsg = _G["OneBillion"]
                end
                SendAuraWebhook("**Aura Detected**", text, color, text, _G["AuraWebhook"], discordTime, contentmsg, RollAmount)
            end
        else
            -- 1B auras check + special auras
            if string.match(lowerText, "pixelated")
                or string.match(lowerText, "blinding")
                or string.match(lowerText, "positive")
                or string.match(lowerText, "transcendent")
                or string.match(lowerText, "the truth")
                or string.match(lowerText, "neferkhaf")
                or string.match(lowerText, "nightmare")
                or string.match(lowerText, "calamity")
                or string.match(lowerText, "perfect puppet")
                or string.match(lowerText, "frozen sovereign") then

                pingRole = _G.OneBillion

            elseif string.match(lowerText, "glorious")
                or string.match(lowerText, "memory") then

                pingRole = _G.Globals
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
        local contentmsg = ""

        if keyword == "dreamspace" or keyword == "cyberspace" or keyword == "manager" then
            if data["ping"] == true then
                contentmsg = "@everyone"
            end
        else
            contentmsg = data["ping"] or ""
        end

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
                contentmsg,
                ""
            )
        else
            local imageURL = ""
            if keyword == "windy" then
               imageURL = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/Images/%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B8%8A%E0%B8%B7%E0%B9%88%E0%B8%AD%2039_20251108101501.png?raw=true"
            elseif keyword == "snowy" then
               imageURL = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/Images/%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B8%8A%E0%B8%B7%E0%B9%88%E0%B8%AD%2040_20251108101523.png?raw=true"
            elseif keyword == "rainy" then
               imageURL = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/Images/%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B8%8A%E0%B8%B7%E0%B9%88%E0%B8%AD%2041_20251108101642.png?raw=true"
            elseif keyword == "sandstorm" then
               imageURL = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/Images/%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B8%8A%E0%B8%B7%E0%B9%88%E0%B8%AD%2042_20251108101707.png?raw=true"
            elseif keyword == "hell" then
               imageURL = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/Images/%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B8%8A%E0%B8%B7%E0%B9%88%E0%B8%AD%2043_20251108101728.png?raw=true"
            elseif keyword == "heaven" then
               imageURL = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/Images/%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B8%8A%E0%B8%B7%E0%B9%88%E0%B8%AD%2056_20251207074340.png?raw=true"
            elseif keyword == "starfall" then
               imageURL = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/Images/%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B8%8A%E0%B8%B7%E0%B9%88%E0%B8%AD%2044_20251108101751.png?raw=true"
            elseif keyword == "corruption" then
               imageURL = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/Images/%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B8%8A%E0%B8%B7%E0%B9%88%E0%B8%AD%2045_20251108101812.png?raw=true"
            elseif keyword == "null" then
               imageURL = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/Images/%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B8%8A%E0%B8%B7%E0%B9%88%E0%B8%AD%2046_20251108101901.png?raw=true"
            elseif keyword == "manager" then
                imageURL = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/Images/%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B8%8A%E0%B8%B7%E0%B9%88%E0%B8%AD%2038_20251108095656.png?raw=true"
                if string.match(cleanMsg:lower(), "resolved") then return end
            elseif keyword == "dreamspace" then
                imageURL = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/Images/%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B8%8A%E0%B8%B7%E0%B9%88%E0%B8%AD%2037_20251108095605.png?raw=true"
                if string.match(cleanMsg:lower(), "waking") then return end
            elseif keyword == "cyberspace" then
                imageURL = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/Images/%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B8%8A%E0%B8%B7%E0%B9%88%E0%B8%AD%2053_20251129034504.png?raw=true"
                if string.match(cleanMsg:lower(), "lost") then return end
            elseif keyword == "graveyard" then
               imageURL = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/Images/%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B8%8A%E0%B8%B7%E0%B9%88%E0%B8%AD%2048_20251108102000.png?raw=true"
            elseif keyword == "pumpkinmoon" then
               imageURL = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/Images/%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B8%8A%E0%B8%B7%E0%B9%88%E0%B8%AD%2047_20251108101932.png?raw=true"
            elseif keyword == "bloodrain" then
               imageURL = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/Images/%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B8%8A%E0%B8%B7%E0%B9%88%E0%B8%AD%2049_20251108102024.png?raw=true"
            elseif keyword == "blazingsun" then
               imageURL = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/Images/%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B8%8A%E0%B8%B7%E0%B9%88%E0%B8%AD%2050_20251108102110.png?raw=true"
            elseif keyword == "aurora" then
               imageURL = "https://github.com/OlOlOlBAKA/Sol-s-RNG/blob/main/Images/%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B8%8A%E0%B8%B7%E0%B9%88%E0%B8%AD%2057_20251221212241.png?raw=true"
               if string.match(cleanMsg:lower(), "disappears") then return end
               color = "0x9258FC"
            end
            SendBiomeWebhook(
                "**Biome Detected**",
                data["display"] .. " Has Spawned!",
                color,
                cleanMsg,
                _G["BiomeWebhook"],
                discordTime,
                discordDespawnTime,
                contentmsg,
                imageURL
            )
        end
    end)
end)

Rayfield:LoadConfiguration()
Rayfield:SetVisibility(false)

print(currentVersion)
print("Loaded Script.")
Rayfield:Notify({
   Title = "Loaded Script",
   Content = "The Script is Loaded!",
   Duration = 5,
   Image = 4483362458,
})
