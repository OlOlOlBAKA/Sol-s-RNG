local enableMacro = true

local currentVersion = "1.27.2"
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
    ["heaven"]      = {["display"]="Heaven", ["despawn"]=240, ["ping"]=_G["Heaven"]},
    ["starfall"]    = {["display"]="Starfall", ["despawn"]=600, ["ping"]=_G["Starfall"]},
    ["corruption"]  = {["display"]="Corruption", ["despawn"]=660, ["ping"]=_G["Corruption"]},
    ["null"]        = {["display"]="Null", ["despawn"]=99, ["ping"]=_G["Null"]},
    ["manager"]     = {["display"]="Glitched", ["despawn"]=124},
    ["dreamspace"]  = {["display"]="Dreamspace", ["despawn"]=192},
    ["cyberspace"]  = {["display"]="Cyberspace", ["despawn"]=720},
    ["mari"]        = {["display"]="Mari", ["despawn"]=180},
    ["jester"]      = {["display"]="Jester", ["despawn"]=180, ["ping"]=_G["Jester"]},
    ["eden"]        = {["display"]="Eden", ["despawn"]=1800, ["ping"]=_G["Eden"]},
}
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

_G.BiomeWebhook = ""
_G.AuraWebhook = ""
_G.MerchantWebhook = ""

_G.SandStorm = ""
_G.Hell = ""
_G.Heaven = ""
_G.Starfall = ""
_G.Corruption = ""
_G.Null = ""

_G.Glitched = false
_G.Dreamspace = false
_G.Cyberspace = false

_G.Jester = ""

_G.Globals = ""
_G.OneBillion = ""
_G.Native = ""
_G.Eden ‎ = "" 

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
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
local BiomeLabel = Tab:CreateLabel("Biome Setting", 4483362458, Color3.fromRGB(255, 255, 255), false) -- Title, Icon, Color, IgnoreTheme
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
      _G.SandStorm = Text
   end,
})
local HellInput = Tab:CreateInput({
   Name = "Hell Ping Role",
   CurrentValue = "",
   PlaceholderText = "Enter Discord Role ID",
   RemoveTextAfterFocusLost = false,
   Flag = "Config2",
   Callback = function(Text)
      _G.Hell = Text
   end,
})
local StarfallInput = Tab:CreateInput({
   Name = "Starfall Ping Role",
   CurrentValue = "",
   PlaceholderText = "Enter Discord Role ID",
   RemoveTextAfterFocusLost = false,
   Flag = "Config3",
   Callback = function(Text)
      _G.Starfall = Text
   end,
})
local HeavenInput = Tab:CreateInput({
   Name = "Heaven Ping Role",
   CurrentValue = "",
   PlaceholderText = "Enter Discord Role ID",
   RemoveTextAfterFocusLost = false,
   Flag = "Config4",
   Callback = function(Text)
      _G.Heaven = Text
   end,
})
local CorruptionInput = Tab:CreateInput({
   Name = "Corruption Ping Role",
   CurrentValue = "",
   PlaceholderText = "Enter Discord Role ID",
   RemoveTextAfterFocusLost = false,
   Flag = "Config5",
   Callback = function(Text)
      _G.Corruption = Text
   end,
})
local NullInput = Tab:CreateInput({
   Name = "Null Ping Role",
   CurrentValue = "",
   PlaceholderText = "Enter Discord Role ID",
   RemoveTextAfterFocusLost = false,
   Flag = "Config6",
   Callback = function(Text)
      _G.Null = Text
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

Rayfield:LoadConfiguration()
