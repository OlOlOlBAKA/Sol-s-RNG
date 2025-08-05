


local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")

local channel = TextChatService.TextChannels["RBXGeneral"]

local BiomeURL = "https://discord.com/api/webhooks/1401863494181064785/d5jCAV2Uzct4BgQwfhJahYmviX3huH9uzmZUDkF9K7W77YryXQ8bcufDhHlP5DinuhTv"
local AuraURL = "https://discord.com/api/webhooks/1402263661308936272/QKTw1r0bxbVuZWTivCVlvkrpXwSuYSYfQCWzGpmlos20glq3rVh28TkRcs0TvtU2qfqO"
local MerchantURL = "https://discord.com/api/webhooks/1402263937071845396/PMHFPLS3OrpYEOR-zp8SHaJ3GB9jW3tjiRLtrUOi0bnUOU-oCLpFSeqVTYMzz2xW_gLu"
local urlimage = "https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/images%20(13).jpeg"
-- credit to regular vynixu
local Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/refs/heads/main/Functions.lua"))()

local function SendWebhook(title, desc, imageURL, color, anothermessage, webhookURL)
   local Response = request({
Url = webhookURL,
Method = "POST",
Headers = {
["Content-Type"] = "application/json"
},
Body = HttpService:JSONEncode({
["content"] = "",
["embeds"] = {{
["title"] = title,
["description"] = desc,
["image"] = {["url"] = imageURL},
["type"] = "rich",
["color"] = tonumber(color),
["fields"] = {
{
["name"] = "Date",
["value"] = os.date(),
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
}
)
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

TextChatService.OnIncomingMessage = function(message)
    if not message.Text then return end
    print(message.TextChannel.Name)
    if message.TextChannel and message.TextChannel.Name == "Server Message" then
            local text = message.Text
    text = text:gsub("<.->","")

    local numberStr = string.match(text, "CHANCE%s+OF%s+1%s+IN%s+([%d,]+)")
print(numberStr)
    if numberStr then
        numberStr = numberStr:gsub(",","")
        local number = tonumber(numberStr)
        if number then
            local length = #tostring(number)

            local color = nil

            if length == 4 then
                color = 0x800080 -- ม่วง
            elseif length == 5 then
                color = 0xFFA500 -- ฟ้า
            elseif length == 6 then
                color = 0x00BFFF -- ฟ้า
            elseif length == 7 then
                color = 0xFF69B4 -- ชมพู
            elseif length == 8 then
                color = 0x0000FF -- น้ำเงิน
            elseif length == 9 then
                color = 0xFF0000 -- แดง
            elseif length >= 10 then
                color = 0x808080 -- เทา
            end

            if color then
                SendWebhook("**Aura Detected**",text,"",color,text,AuraURL)
            end
        end
    end
    elseif message.TextChannel and message.TextChannel.Name == "RBXGeneral" then
          if message.TextSource == nil then
       local keyword, color, display, image = findKeyword(message.Text)
       if keyword then
           local cleanMsg = message.Text:gsub('<font color=".-">', ""):gsub("</font>","")
           if keyword ~= "mari" and keyword ~= "jester" then
               SendWebhook("**Biome Detected**", display .. " Has Spawned!", image, color, cleanMsg, BiomeURL)
           else
              SendWebhook("**Merchant Detected**", display .. " Has Spawned!", image, color, cleanMsg, MerchantURL)
           end
       end
   end
    end
end

print("V3 Loaded")
