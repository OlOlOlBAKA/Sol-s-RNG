-- Webhooks Type Your Webhook Link here (you can use same link if you want them be in 1 text channel of discord server
_G.BiomeWebhook = ""
_G.AuraWebhook = ""
_G.MerchantWebhook = ""
-- Biome Ping Type Your Role ID here example <@&ROLE_ID>
_G.SandStorm = ""
_G.Hell = ""
_G.Starfall = ""
_G.Corruption = ""
_G.Null = ""
-- For Glitched And Dreamspace You Need To Type Only true or false for allow ping everyone or not
_G.Glitched = false
_G.Dreamspace = true
-- Merchant Ping Type Your Role ID here
_G.Jester = ""
-- Auras Ping Type Your Role ID here
_G.Globals = ""
_G.OneBillion = ""
-- type user in table here
-- blacklist users will disable message that blacklisted user found the aura in chat
_G.BlacklistedUsers = {"Player1","Player2"}
-- Eden (ONLY FOR PERSON WHO USED MACRO) Role ID too
_G.Eden = ""

loadstring(game:HttpGet("https://raw.githubusercontent.com/OlOlOlBAKA/Sol-s-RNG/refs/heads/main/Test.lua"))()
