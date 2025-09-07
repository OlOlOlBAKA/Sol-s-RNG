
if not _G.AlreadyRun then
   _G.AlreadyRun = true
else
   return
end

local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local channel = TextChatService.TextChannels["RBXGeneral"]

-- Webhooks
local BiomeURL = _G.BiomeWebhook
local AuraURL = _G.AuraWebhook
local MerchantURL = _G.MerchantWebhook
-- Biome Ping
local SandStormPing = _G.SandStorm
local HellPing = _G.Hell
local StarfallPing = _G.Starfall
local CorruptionPing = _G.Corruption
local NullPing = _G.Null
local GlitchedPing = _G.Glitched
local DreamspacePing = _G.Dreamspace
-- Merchant Ping
local JesterPing = _G.Jester
-- Auras Ping
local GlobalPing = _G.Globals
local BillionPing = _G.OneBillion
-- Eden (ONLY FOR PERSON WHO USED MACRO)
local EdenPing = _G.Eden

-- Useless
local urlimage = "https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/images%20(13).jpeg"
-- credit to regular vynixu
local Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/refs/heads/main/Functions.lua"))()
-- Code
local function SendBiomeWebhook(title, desc, imageURL, color, anothermessage, webhookURL, spawnTime, despawnTime, contentmsg, Link)
   local Response = request({
       Url = webhookURL,
       Method = "POST",
       Headers = {
           ["Content-Type"] = "application/json"
       },
       Body = HttpService:JSONEncode({
           ["content"] = contentmsg,
           ["embeds"] = {{
               ["title"] = title,
               ["description"] = desc,
               ["image"] = {["url"] = imageURL},
               ["type"] = "rich",
               ["color"] = tonumber(color),
               ["fields"] = {
                   {
                       ["name"] = "Spawn Time",
                       ["value"] = spawnTime,
                       ["inline"] = true,
                   },
                   {
                       ["name"] = "Despawn Time",
                       ["value"] = despawnTime,
                       ["inline"] = true,
                   },
                   {
                       ["name"] = "Original Message",
                       ["value"] = anothermessage,
                       ["inline"] = true,
                   },
               }
           }}
       })
   })
end

local function SendAuraWebhook(title, desc, imageURL, color, anothermessage, webhookURL, GotTime, contentmsg)
   local Response = request({
Url = webhookURL,
Method = "POST",
Headers = {
["Content-Type"] = "application/json"
},
Body = HttpService:JSONEncode({
["content"] = contentmsg,
["embeds"] = {{
["title"] = title,
["description"] = desc,
["image"] = {["url"] = imageURL},
["type"] = "rich",
["color"] = tonumber(color),
["fields"] = {
{
["name"] = "Time",
["value"] = GotTime,
["inline"] = true,
},
}
}}
})
}
)
end

local function SendMerchantWebhook(title, desc, imageURL, color, anothermessage, webhookURL, spawnTime, despawnTime, contentmsg)
    local Response = request({
        Url = webhookURL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode({
            ["content"] = contentmsg,
            ["embeds"] = {{
                ["title"] = title,
                ["description"] = desc,
                ["image"] = {["url"] = imageURL},
                ["type"] = "rich",
                ["color"] = tonumber(color),
                ["fields"] = {
                    {
                        ["name"] = "Spawn Time",
                        ["value"] = spawnTime,
                        ["inline"] = true,
                    },
                    {
                        ["name"] = "Despawn Time",
                        ["value"] = despawnTime,
                        ["inline"] = true,
                    },
                    {
                        ["name"] = "Original Message",
                        ["value"] = anothermessage,
                        ["inline"] = false, -- ปรับเป็น false จะได้แสดงเต็มบรรทัด
                    },
                }
            }}
        })
    })
end

local keywordsToColor = {
["windy"] = 0xFFFFFF,
["snowy"] = 0xFFFFFF,
["rainy"] = 0xADD8E6,
["blazing sun"] = 0xFFA500,
["sand storm"] = 0xDAA520,
["hell"] = 0x8B0000,
["starfall"] = 0x1E90FF,
["corruption"] = 0x800080,
["null"] = 0x000000,
["manager"] = 0x228B22,
["dreamspace"] = 0xFF70D9,
["mari"] = 0xFFFFFF,
["jester"] = 0x800080,
["eden"] = 0x000000,
}

local keywordsToNumber = {
["windy"] = 120,
["snowy"] = 120,
["rainy"] = 120,
["blazing sun"] = 140,
["sand storm"] = 660,
["hell"] = 660,
["starfall"] = 600,
["corruption"] = 660,
["null"] = 99,
["manager"] = 124,
["dreamspace"] = 128,
["mari"] = 180,
["jester"] = 180,
["eden"] = 1800,
}

local keywordsToDisplayName = {
["windy"] = "Windy",
["snowy"] = "Snowy",
["rainy"] = "Rainy",
["blazing sun"] = "Blazing Sun",
["sand storm"] = "Sand Storm",
["hell"] = "Hell",
["starfall"] = "Starfall",
["corruption"] = "Corruption",
["null"] = "Null",
["manager"] = "Glitched",
["dreamspace"] = "Dreamspace",
["mari"] = "Mari",
["jester"] = "Jester",
["eden"] = "Eden",
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
   text = string.lower(text)
   for keyword, _ in pairs(keywordsToColor) do
       if string.find(text, keyword) then
          local color = keywordsToColor[keyword]
          local Display =  keywordsToDisplayName[keyword]
          local IMAGE = keywordsToImage[keyword]
          return keyword, color, Display, IMAGE
       end
   end
   return nil
end

task.spawn(function()
   -- AntiAFK
player.Idled:Connect(function()
        print("[AntiAFK] ผู้เล่น Idle! กำลังทำ VirtualInput")
        
        -- กดเมาส์ปลอม 1 ครั้ง
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(0,0))
    end)
end

TextChatService.OnIncomingMessage = function(message)
    if not message.Text then return end
    print(message.TextChannel.Name)
    if message.TextChannel and message.TextChannel.Name == "Server Message" and AuraURL then
          local text = message.Text
    local numberStr = nil

    if string.match(text, "<.->") then
        text = text:gsub("<.->","")
        print(text)
    end
    if string.match(text,",") then
        numberStr = string.match(text, "CHANCE OF 1 IN ([%d,]+)")
        print(text)
    end
    print(text)
     print(numberStr)
    if numberStr then
        numberStr = numberStr:gsub(",","")
        local number = tonumber(numberStr)
        if number then
            local color = nil
           local contentmsg = ""

            if number < 9999  then
                color = 0x800080 -- PURPLE
            elseif number < 99999 then
                color = 0xFFA500 -- ORANGE
            elseif number < 999999 then
                color = 0x00BFFF -- CYAN
            elseif number < 9999999 then
                color = 0xFF69B4 --PINK
            elseif number < 99999999 then
                color = 0x0000FF -- BLUE
            elseif number >= 99999998 then
                color = 0xFF0000 -- RED
                contentmsg = "<" .. GlobalPing .. ">"
            end
            if color then
                local time = os.time()
                local discordTime = "<t:" .. time .. ":F>"
                SendAuraWebhook("**Aura Detected**",text,"",color,text,AuraURL, discordTime, contentmsg)
            end
        end
    elseif string.match(text,"PIXELATED") then
local contentmsg = "<" .. BillionPing .. ">"
                   local color = 0xFF70D9
                local time = os.time()
                local discordTime = "<t:" .. time .. ":F>"
      SendAuraWebhook("**Aura Detected**",text,"",color,text,AuraURL, discordTime, contentmsg)
             elseif string.match(text,"Blinding") then
local contentmsg = "<" .. BillionPing .. ">"
                   local color = 0xFFFFFF
                local time = os.time()
                local discordTime = "<t:" .. time .. ":F>"
      SendAuraWebhook("**Aura Detected**",text,"",color,text,AuraURL, discordTime, contentmsg)
             elseif string.match(text,"POSITIVE") then
local contentmsg = "<" .. BillionPing .. ">"
                   local color = 0x000000
                local time = os.time()
                local discordTime = "<t:" .. time .. ":F>"
      SendAuraWebhook("**Aura Detected**",text,"",color,text,AuraURL, discordTime, contentmsg)
             elseif string.match(text,"GLORIOUS") then
local contentmsg =  "<" .. GlobalPing .. ">"
                   local color = 0xFF0000
                local time = os.time()
                local discordTime = "<t:" .. time .. ":F>"
      SendAuraWebhook("**Aura Detected**",text,"",color,text,AuraURL, discordTime, contentmsg)
         elseif string.match(text,"EXALTED") then
                   local color = 0x0000FF
                local time = os.time()
                local discordTime = "<t:" .. time .. ":F>"
      SendAuraWebhook("**Aura Detected**",text,"",color,text,AuraURL, discordTime, contentmsg)
    end
    elseif message.TextChannel and message.TextChannel.Name == "RBXGeneral" then
          if message.TextSource == nil then
       local keyword, color, display, image = findKeyword(message.Text)
       if keyword then
           local cleanMsg = message.Text:gsub('<font color=".-">', ""):gsub("</font>","")
           if keyword ~= "mari" and keyword ~= "jester" and keyword ~= "eden" and BiomeURL then
               local despawnTime = 0
               local contentmsg = ""
               if display == "Windy" then
                   despawnTime = 120
               elseif display == "Snowy" then
                   despawnTime = 120
               elseif display == "Rainy" then
                   despawnTime = 120
               elseif display == "Blazing Sun" then
                   despawnTime = 140
               elseif display == "Sand Storm" then
                   despawnTime = 660
                  contentmsg = "<" .. SandStormPing .. ">"
               elseif display == "Hell" then
                   despawnTime = 660
                  contentmsg = "<" .. HellPing .. ">"
               elseif display == "Starfall" then
                   despawnTime = 600
                  contentmsg = "<" .. StarfallPing .. ">"
               elseif display == "Corruption" then
                   despawnTime = 660
                  contentmsg = "<" .. CorruptionPing .. ">"
               elseif display == "Null" then
                   despawnTime = 99
                  contentmsg = "<" .. NullPing .. ">"
               elseif display == "Glitched" then
                   despawnTime = 124
                   if GlitchedPing then
                      contentmsg = "@everyone"
                   end
               elseif display == "Dreamspace" then
                   despawnTime = 128
                   if DreamspacePing then
                      contentmsg = "@everyone"
                   end
               end
               local time = os.time()
               local discordTime = "<t:" .. time .. ":F>"
               local discordDespawnTime = "<t:" .. time + despawnTime .. ":F>"
               SendBiomeWebhook("**Biome Detected**", display .. " Has Spawned!", image, color, cleanMsg, BiomeURL, discordTime, discordDespawnTime, contentmsg, "https://www.roblox.com/th/games/15532962292/Sols-RNG-Fishing-Beta?privateServerLinkCode=60426804869505446691875439115801")
           else
               local despawnTime = 180
               if display == "Eden" then
                  despawnTime = 1800
               end
               local time = os.time()
               local discordTime = "<t:" .. time .. ":F>"
               local discordDespawnTime = "<t:" .. time + despawnTime .. ":F>"
               local contentmsg = ""
           if keyword == "jester" then
                          contentmsg = "<" .. JesterPing .. ">"
                         SendMerchantWebhook("**Merchant Detected**", display .. " Has Spawned!", image, color, cleanMsg, MerchantURL, discordTime, discordDespawnTime, contentmsg)
           elseif keyword == "mari" then
                      SendMerchantWebhook("**Merchant Detected**", display .. " Has Spawned!", image, color, cleanMsg, MerchantURL, discordTime, discordDespawnTime,contentmsg)
         elseif keyword == "eden" then
                  contentmsg = "<" .. EdenPing .. ">"
                SendBiomeWebhook("**Eden Detected**","Eden Has Spawned On "..  game.Players.LocalPlayer.Name .. " Side!", image, color, cleanMsg, AuraURL, discordTime, discordDespawnTime, contentmsg, "")
           end
           end
       end
   end
    end
end

print("V15 Loaded")
