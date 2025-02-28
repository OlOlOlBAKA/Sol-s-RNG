local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local myUsername = "@" .. LocalPlayer.Name -- Convert to @Username format
-- Removed webhook URL since we don't need it anymore

-- Function to clean up the message by removing any font color or other HTML tags
local function cleanMessage(text)
    -- Ensure that the text is valid before trying to clean it
    if not text or text == "" then
        return ""  -- Return an empty string if the message is invalid
    end

    -- Remove any font color or HTML tags (e.g., <font color="...">)
    local cleanedText = text:gsub("<[^>]+>", "")  -- Removes anything inside < and >

    return cleanedText
end

-- Function to process the message and print the cleaned text
local function printCleanedMessage(message)
    local text = message.Text

    -- Ensure the message text is valid before proceeding
    if not text or text == "" then
        print("Received invalid or empty message.")
        return  -- Exit if the message is invalid
    end

    -- Clean the message text to remove font tags
    local cleanedText = cleanMessage(text)

    -- Debugging: print the cleaned text to ensure it's correct
    if string.match(cleanedText, "CHANCE OF") then
    local response = request({ 
Url = "https://discord.com/api/webhooks/1252906057077100605/b42EX3JP5VPmI5_OnsJyQYSOHFyGwRrE0iWLnTczqHbnMCH66MDiyqgzvypfmjJTiev6",
Method = 'POST',
Headers = {
['Content-Type'] = 'application/json'
},
Body = HttpService:JSONEncode({
["content"] = "",
["embeds"] = {{
   ["title"] = "**Rare Aura Founded**",
   ["description"] = cleanedText,
   ["type"] = "rich",
   ["color"] = tonumber(0xffffff),
   ["fields"] = {
   {
        ["name"] = "Time Discovered",
        ["value"] = os.date()
   }}
}}
})
}
)

print(response)
    end
end

-- Connect the function to the message received event
TextChatService.MessageReceived:Connect(function(message)
    printCleanedMessage(message)  -- Just print the cleaned message
end)
