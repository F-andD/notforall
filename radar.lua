local Players = game:service("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = game:service("Workspace").CurrentCamera
local RS = game:service("RunService")
local UIS = game:service("UserInputService")
local Chat = game:GetService("Chat")

repeat wait() until Player.Character ~= nil and Player.Character.PrimaryPart ~= nil

local LerpColorModule = loadstring(game:HttpGet("https://pastebin.com/raw/wRnsJeid"))()
local HealthBarLerp = LerpColorModule:Lerp(Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0))

local RadarInfo = {
    Position = Vector2.new(game:GetService("GuiService"):GetScreenResolution().X - 80, game:GetService("GuiService"):GetScreenResolution().Y - 80), -- Position in bottom-right corner
    Radius = 65, -- Radar radius
    Scale = 25, -- Increase scale to cover more area
    RadarBack = Color3.fromRGB(10, 10, 10),
    RadarBorder = Color3.fromRGB(75, 75, 75),
    LocalPlayerDot = Color3.fromRGB(255, 255, 255),
    PlayerDot = Color3.fromRGB(60, 170, 255),
    Team = Color3.fromRGB(0, 255, 0),
    Enemy = Color3.fromRGB(255, 0, 0),
    Health_Color = false, -- Change to false to use team/enemy colors
    Team_Check = true,
    Visible = true -- Add visibility toggle
}

local function NewCircle(Transparency, Color, Radius, Filled, Thickness)
    local c = Drawing.new("Circle")
    c.Transparency = Transparency
    c.Color = Color
    c.Visible = false
    c.Thickness = Thickness
    c.Position = Vector2.new(0, 0)
    c.Radius = Radius
    c.NumSides = math.clamp(Radius*55/100, 10, 75)
    c.Filled = Filled
    return c
end

local RadarBackground = NewCircle(0.9, RadarInfo.RadarBack, RadarInfo.Radius, true, 1)
local RadarBorder = NewCircle(0.75, RadarInfo.RadarBorder, RadarInfo.Radius, false, 3)

RadarBackground.Visible = RadarInfo.Visible
RadarBorder.Visible = RadarInfo.Visible
RadarBackground.Position = RadarInfo.Position
RadarBorder.Position = RadarInfo.Position

local function GetRelative(pos)
    local char = Player.Character
    if char ~= nil and char.PrimaryPart ~= nil then
        local pmpart = char.PrimaryPart
        local camerapos = Vector3.new(Camera.CFrame.Position.X, pmpart.Position.Y, Camera.CFrame.Position.Z)
        local newcf = CFrame.new(pmpart.Position, camerapos)
        local r = newcf:PointToObjectSpace(pos)
        return r.X, r.Z
    else
        return 0, 0
    end
end

local function PlaceDot(plr)
    local PlayerDot = NewCircle(1, RadarInfo.PlayerDot, 2, true, 1) -- Dot size

    local function Update()
        local c 
        c = game:service("RunService").RenderStepped:Connect(function()
            if RadarInfo.Visible then
                local char = plr.Character
                if char and char:FindFirstChildOfClass("Humanoid") and char.PrimaryPart ~= nil and char:FindFirstChildOfClass("Humanoid").Health > 0 then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local scale = RadarInfo.Scale
                    local relx, rely = GetRelative(char.PrimaryPart.Position)
                    local newpos = RadarInfo.Position - Vector2.new(relx / scale, rely / scale) -- Adjusted for larger coverage
                    
                    if (newpos - RadarInfo.Position).magnitude < RadarInfo.Radius-2 then 
                        PlayerDot.Radius = 2 -- Dot size
                        PlayerDot.Position = newpos
                        PlayerDot.Visible = true
                    else 
                        local dist = (RadarInfo.Position - newpos).magnitude
                        local calc = (RadarInfo.Position - newpos).unit * (dist - RadarInfo.Radius)
                        local inside = Vector2.new(newpos.X + calc.X, newpos.Y + calc.Y)
                        PlayerDot.Radius = 1 -- Dot size
                        PlayerDot.Position = inside
                        PlayerDot.Visible = true
                    end

                    if RadarInfo.Team_Check then
                        if plr.TeamColor == Player.TeamColor then
                            PlayerDot.Color = RadarInfo.Team
                        else
                            PlayerDot.Color = RadarInfo.Enemy
                        end
                    else
                        PlayerDot.Color = RadarInfo.PlayerDot
                    end

                    if RadarInfo.Health_Color then
                        PlayerDot.Color = HealthBarLerp(hum.Health / hum.MaxHealth)
                    end
                else 
                    PlayerDot.Visible = false
                    if Players:FindFirstChild(plr.Name) == nil then
                        PlayerDot:Remove()
                        c:Disconnect()
                    end
                end
            else
                PlayerDot.Visible = false
            end
        end)
    end
    coroutine.wrap(Update)()
end

for _,v in pairs(Players:GetChildren()) do
    if v.Name ~= Player.Name then
        PlaceDot(v)
    end
end

local function NewLocalDot()
    local d = Drawing.new("Triangle")
    d.Visible = RadarInfo.Visible
    d.Thickness = 1
    d.Filled = true
    d.Color = RadarInfo.LocalPlayerDot
    d.PointA = RadarInfo.Position + Vector2.new(0, -4) -- Adjusted size for smaller radar
    d.PointB = RadarInfo.Position + Vector2.new(-2, 4)
    d.PointC = RadarInfo.Position + Vector2.new(2, 4)
    return d
end

local LocalPlayerDot = NewLocalDot()

Players.PlayerAdded:Connect(function(v)
    if v.Name ~= Player.Name then
        PlaceDot(v)
    end
    LocalPlayerDot:Remove()
    LocalPlayerDot = NewLocalDot()
end)

coroutine.wrap(function()
    local c 
    c = game:service("RunService").RenderStepped:Connect(function()
        if RadarInfo.Visible then
            if LocalPlayerDot ~= nil then
                LocalPlayerDot.Color = RadarInfo.LocalPlayerDot
                LocalPlayerDot.PointA = RadarInfo.Position + Vector2.new(0, -4) -- Adjusted size for smaller radar
                LocalPlayerDot.PointB = RadarInfo.Position + Vector2.new(-2, 4)
                LocalPlayerDot.PointC = RadarInfo.Position + Vector2.new(2, 4)
            end
            RadarBackground.Position = RadarInfo.Position
            RadarBackground.Radius = RadarInfo.Radius
            RadarBackground.Color = RadarInfo.RadarBack

            RadarBorder.Position = RadarInfo.Position
            RadarBorder.Radius = RadarInfo.Radius
            RadarBorder.Color = RadarInfo.RadarBorder
        end
    end)
end)()

local dragging = false
local offset = Vector2.new(0, 0)
UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and (Vector2.new(Mouse.X, Mouse.Y + game:GetService("GuiService"):GetGuiInset().Y) - RadarInfo.Position).magnitude < RadarInfo.Radius then
        offset = RadarInfo.Position - Vector2.new(Mouse.X, Mouse.Y)
        dragging = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

coroutine.wrap(function()
    local dot = NewCircle(1, Color3.fromRGB(255, 255, 255), 2, true, 1) -- Adjusted size for smaller radar
    local c 
    c = game:service("RunService").RenderStepped:Connect(function()
        if RadarInfo.Visible then
            if (Vector2.new(Mouse.X, Mouse.Y + game:GetService("GuiService"):GetGuiInset().Y) - RadarInfo.Position).magnitude < RadarInfo.Radius then
                dot.Position = Vector2.new(Mouse.X, Mouse.Y + game:GetService("GuiService"):GetGuiInset().Y)
                dot.Visible = true
            else 
                dot.Visible = false
            end
            if dragging then
                RadarInfo.Position = Vector2.new(Mouse.X, Mouse.Y) + offset
            end
        else
            dot.Visible = false
        end
    end)
end)()

-- Function to handle chat commands
local function onChat(message)
    if message == "roff" then
        RadarInfo.Visible = false
        RadarBackground.Visible = false
        RadarBorder.Visible = false
        LocalPlayerDot.Visible = false
        Chat:Chat(Player.Character.Head, "Radar is now OFF", Enum.ChatColor.Red)
    elseif message == "ron" then
        RadarInfo.Visible = true
        RadarBackground.Visible = true
        RadarBorder.Visible = true
        LocalPlayerDot.Visible = true
        Chat:Chat(Player.Character.Head, "Radar is now ON", Enum.ChatColor.Green)
    end
end

-- Connect chat function to local player chat
Player.Chatted:Connect(function(message)
    -- Only process messages from the local player
    if message and Player.Character then
        onChat(message)
    end
end)
