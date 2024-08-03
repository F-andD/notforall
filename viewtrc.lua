local Settings = {
    Color = Color3.fromRGB(255, 203, 138), -- Color of the line
    Thickness = 1, -- Thickness of the line (Overruled by AutoThickness if activated)
    Transparency = 1, -- 1 Visible - 0 Not Visible
    AutoThickness = true, -- Makes Thickness above futile, scales according to distance, good for less encumbered screen
    Length = 15, -- In studs of the line
    Smoothness = 0.2, -- 0.01 - Less Smooth(Faster), 1 - Smoother (Slower)
    MaxDistance = 550 -- Maximum distance (in studs) at which the tracer is visible
}

local toggle = true -- use this variable to control the visibility of the tracer

local player = game:GetService("Players").LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local chat = game:GetService("Chat")

-- Function to create and update the ESP tracer for a player
local function ESP(plr)
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Color = Settings.Color
    line.Thickness = Settings.Thickness
    line.Transparency = Settings.Transparency

    local function Updater()
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            if toggle and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Head") then
                if plr.TeamColor ~= player.TeamColor then
                    local headpos, OnScreen = camera:WorldToViewportPoint(plr.Character.Head.Position)
                    if OnScreen then
                        local distance = (player.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude
                        if distance <= Settings.MaxDistance then
                            local offsetCFrame = CFrame.new(0, 0, -Settings.Length)
                            local check = false
                            line.From = Vector2.new(headpos.X, headpos.Y)
                            if Settings.AutoThickness then
                                local value = math.clamp(1/distance*100, 0.1, 3)
                                line.Thickness = value
                            end
                            repeat
                                local dir = plr.Character.Head.CFrame:ToWorldSpace(offsetCFrame)
                                offsetCFrame = offsetCFrame * CFrame.new(0, 0, Settings.Smoothness)
                                local dirpos, vis = camera:WorldToViewportPoint(Vector3.new(dir.X, dir.Y, dir.Z))
                                if vis then
                                    check = true
                                    line.To = Vector2.new(dirpos.X, dirpos.Y)
                                    line.Visible = true
                                    offsetCFrame = CFrame.new(0, 0, -Settings.Length)
                                end
                            until check == true
                        else
                            line.Visible = false
                        end
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            else
                line.Visible = false
                if game.Players:FindFirstChild(plr.Name) == nil then
                    connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Updater)()
end

-- Function to handle chat commands
local function onChat(message)
    if message == "/t_off" then
        toggle = false
        chat:Chat(player.Character.Head, "Tracer is now OFF", Enum.ChatColor.Red)
    elseif message == "/t_on" then
        toggle = true
        chat:Chat(player.Character.Head, "Tracer is now ON", Enum.ChatColor.Green)
    end
end

-- Connect chat function to local player chat
player.Chatted:Connect(function(message)
    -- Only process messages from the local player
    if message and player.Character then
        onChat(message)
    end
end)

-- Initialize tracers for existing players
for i, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Name ~= player.Name then
        coroutine.wrap(ESP)(v)
    end
end

-- Initialize tracers for players who join after script starts
game.Players.PlayerAdded:Connect(function(newplr)
    if newplr.Name ~= player.Name then
        coroutine.wrap(ESP)(newplr)
    end
end)
