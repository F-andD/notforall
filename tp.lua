-- Define the distance in front of your character where enemy players will be teleported
local teleportDistance = 5

-- Get the local player (this script assumes it is a LocalScript)
local player = game.Players.LocalPlayer

-- Initialize teleportation state
local teleportEnabled = false
local teleportInterval = 0.1 -- Interval in seconds to update the position
local teleportThread = nil -- To keep track of the teleportation coroutine

-- Function to teleport enemy players in front of the local player
local function teleportEnemiesInFront()
    while teleportEnabled do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local rootPart = character.HumanoidRootPart
            local positionInFront = rootPart.CFrame * CFrame.new(0, 0, -teleportDistance)
            
            for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Team ~= player.Team and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    otherPlayer.Character.HumanoidRootPart.CFrame = positionInFront
                end
            end
        end
        wait(teleportInterval)
    end
end

-- Function to handle chat commands
local function onPlayerChatted(message)
    local lowerMessage = message:lower()
    if lowerMessage == "tpon" then
        if not teleportEnabled then
            teleportEnabled = true
            game:GetService("Chat"):Chat(player.Character.Head, "Teleportation enabled", Enum.ChatColor.Red)
            if not teleportThread then
                teleportThread = coroutine.create(teleportEnemiesInFront)
                coroutine.resume(teleportThread)
            end
        end
    elseif lowerMessage == "tpoff" then
        if teleportEnabled then
            teleportEnabled = false
            game:GetService("Chat"):Chat(player.Character.Head, "Teleportation disabled", Enum.ChatColor.Red)
            teleportThread = nil
        end
    end
end

-- Connect the Player.Chatted event to handle chat commands
player.Chatted:Connect(onPlayerChatted)
