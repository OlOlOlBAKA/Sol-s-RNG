
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")

local channel = TextChatService.TextChannels["RBXGeneral"]

local URL = "https://discord.com/api/webhooks/1401863494181064785/d5jCAV2Uzct4BgQwfhJahYmviX3huH9uzmZUDkF9K7W77YryXQ8bcufDhHlP5DinuhTv"
local urlimage = "https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/images%20(13).jpeg"
-- credit to regular vynixu
local Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/refs/heads/main/Functions.lua"))()

local function SendWebhook(title, desc, imageURL, color, anothermessage)
   local Response = request({
Url = URL,
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

channel.MessageReceived:Connect(function(message)
   if message.TextSource == nil then
       local keyword, color, display, image = findKeyword(message.Text)
       if keyword then
           local cleanMsg = message.Text:gsub('<font color=".-">', ""):gsub("</font>","")
           if keyword ~= "merchant" then
               SendWebhook("**Biome Detected**", display .. " Has Spawned!", image, color, cleanMsg)
           end
       end
   end
end)

print("Loaded")
