if _G.MusicEnabled then
  local function GetGitSound(GithubSnd,SoundName)
	local url=GithubSnd
	if not isfile(SoundName..".mp3") then
		writefile(SoundName..".mp3", game:HttpGet(url))
	end
	local sound=(getcustomasset or getsynasset)(SoundName..".mp3")
	return sound
end

local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")
local player = Players.LocalPlayer

local function fixSound(sound)
    if sound.SoundId ~= "" and sound.SoundId ~= "rbxasset://10" then
        ContentProvider:PreloadAsync({sound})
        if sound.TimeLength > 30 then
            sound.SoundId = GetGitSound(_G.MusicLink,_G.FileName)
        end
    end
end

local function scanOnce()
    local character = player.Character
    if not character then return end
    
    -- for ครั้งเดียว: ตรวจเสียงที่มีอยู่แล้ว
    for _, obj in pairs(character:GetDescendants()) do
        if obj:IsA("Sound") then
            fixSound(obj)
        end
    end
end

-- รัน for ครั้งแรก
if player.Character then
    scanOnce()
else
    player.CharacterAdded:Wait()
    scanOnce()
end

-- DescendantAdded: จับเสียงใหม่ real-time
player.Character.DescendantAdded:Connect(function(obj)
    if obj:IsA("Sound") then
        wait(0.1) -- รอ SoundId โหลด
        fixSound(obj)
    end
end)
end
