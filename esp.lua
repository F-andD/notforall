local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local Camera = game:GetService("Workspace").CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local espConnections = {} -- Store ESP connections to clean up later

local function DrawLine()
    local l = Drawing.new("Line")
    l.Visible = false
    l.From = Vector2.new(0, 0)
    l.To = Vector2.new(1, 1)
    l.Color = Color3.fromRGB(255, 0, 0) -- Default to red
    l.Thickness = 1
    l.Transparency = 1
    return l
end

local function DrawESP(plr)
    repeat wait() until plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil
    local limbs = {}
    local R15 = (plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R15) and true or false

    if R15 then 
        limbs = {
            Head_UpperTorso = DrawLine(),
            UpperTorso_LowerTorso = DrawLine(),
            UpperTorso_LeftUpperArm = DrawLine(),
            LeftUpperArm_LeftLowerArm = DrawLine(),
            LeftLowerArm_LeftHand = DrawLine(),
            UpperTorso_RightUpperArm = DrawLine(),
            RightUpperArm_RightLowerArm = DrawLine(),
            RightLowerArm_RightHand = DrawLine(),
            LowerTorso_LeftUpperLeg = DrawLine(),
            LeftUpperLeg_LeftLowerLeg = DrawLine(),
            LeftLowerLeg_LeftFoot = DrawLine(),
            LowerTorso_RightUpperLeg = DrawLine(),
            RightUpperLeg_RightLowerLeg = DrawLine(),
            RightLowerLeg_RightFoot = DrawLine(),
        }
    else 
        limbs = {
            Head_Spine = DrawLine(),
            Spine = DrawLine(),
            LeftArm = DrawLine(),
            LeftArm_UpperTorso = DrawLine(),
            RightArm = DrawLine(),
            RightArm_UpperTorso = DrawLine(),
            LeftLeg = DrawLine(),
            LeftLeg_LowerTorso = DrawLine(),
            RightLeg = DrawLine(),
            RightLeg_LowerTorso = DrawLine()
        }
    end

    local function Visibility(state)
        for i, v in pairs(limbs) do
            v.Visible = state
        end
    end

    local function Colorize(color)
        for i, v in pairs(limbs) do
            v.Color = color
        end
    end

    local function UpdaterR15()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character.Humanoid.Health > 0 then
                local HUM, vis = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                if vis then
                    local H = Camera:WorldToViewportPoint(plr.Character.Head.Position)
                    local UT = Camera:WorldToViewportPoint(plr.Character.UpperTorso.Position)
                    local LT = Camera:WorldToViewportPoint(plr.Character.LowerTorso.Position)
                    local LUA = Camera:WorldToViewportPoint(plr.Character.LeftUpperArm.Position)
                    local LLA = Camera:WorldToViewportPoint(plr.Character.LeftLowerArm.Position)
                    local LH = Camera:WorldToViewportPoint(plr.Character.LeftHand.Position)
                    local RUA = Camera:WorldToViewportPoint(plr.Character.RightUpperArm.Position)
                    local RLA = Camera:WorldToViewportPoint(plr.Character.RightLowerArm.Position)
                    local RH = Camera:WorldToViewportPoint(plr.Character.RightHand.Position)
                    local LUL = Camera:WorldToViewportPoint(plr.Character.LeftUpperLeg.Position)
                    local LLL = Camera:WorldToViewportPoint(plr.Character.LeftLowerLeg.Position)
                    local LF = Camera:WorldToViewportPoint(plr.Character.LeftFoot.Position)
                    local RUL = Camera:WorldToViewportPoint(plr.Character.RightUpperLeg.Position)
                    local RLL = Camera:WorldToViewportPoint(plr.Character.RightLowerLeg.Position)
                    local RF = Camera:WorldToViewportPoint(plr.Character.RightFoot.Position)

                    -- Update lines
                    limbs.Head_UpperTorso.From = Vector2.new(H.X, H.Y)
                    limbs.Head_UpperTorso.To = Vector2.new(UT.X, UT.Y)

                    limbs.UpperTorso_LowerTorso.From = Vector2.new(UT.X, UT.Y)
                    limbs.UpperTorso_LowerTorso.To = Vector2.new(LT.X, LT.Y)

                    limbs.UpperTorso_LeftUpperArm.From = Vector2.new(UT.X, UT.Y)
                    limbs.UpperTorso_LeftUpperArm.To = Vector2.new(LUA.X, LUA.Y)

                    limbs.LeftUpperArm_LeftLowerArm.From = Vector2.new(LUA.X, LUA.Y)
                    limbs.LeftUpperArm_LeftLowerArm.To = Vector2.new(LLA.X, LLA.Y)

                    limbs.LeftLowerArm_LeftHand.From = Vector2.new(LLA.X, LLA.Y)
                    limbs.LeftLowerArm_LeftHand.To = Vector2.new(LH.X, LH.Y)

                    limbs.UpperTorso_RightUpperArm.From = Vector2.new(UT.X, UT.Y)
                    limbs.UpperTorso_RightUpperArm.To = Vector2.new(RUA.X, RUA.Y)

                    limbs.RightUpperArm_RightLowerArm.From = Vector2.new(RUA.X, RUA.Y)
                    limbs.RightUpperArm_RightLowerArm.To = Vector2.new(RLA.X, RLA.Y)

                    limbs.RightLowerArm_RightHand.From = Vector2.new(RLA.X, RLA.Y)
                    limbs.RightLowerArm_RightHand.To = Vector2.new(RH.X, RH.Y)

                    limbs.LowerTorso_LeftUpperLeg.From = Vector2.new(LT.X, LT.Y)
                    limbs.LowerTorso_LeftUpperLeg.To = Vector2.new(LUL.X, LUL.Y)

                    limbs.LeftUpperLeg_LeftLowerLeg.From = Vector2.new(LUL.X, LUL.Y)
                    limbs.LeftUpperLeg_LeftLowerLeg.To = Vector2.new(LLL.X, LLL.Y)

                    limbs.LeftLowerLeg_LeftFoot.From = Vector2.new(LLL.X, LLL.Y)
                    limbs.LeftLowerLeg_LeftFoot.To = Vector2.new(LF.X, LF.Y)

                    limbs.LowerTorso_RightUpperLeg.From = Vector2.new(LT.X, LT.Y)
                    limbs.LowerTorso_RightUpperLeg.To = Vector2.new(RUL.X, RUL.Y)

                    limbs.RightUpperLeg_RightLowerLeg.From = Vector2.new(RUL.X, RUL.Y)
                    limbs.RightUpperLeg_RightLowerLeg.To = Vector2.new(RLL.X, RLL.Y)

                    limbs.RightLowerLeg_RightFoot.From = Vector2.new(RLL.X, RLL.Y)
                    limbs.RightLowerLeg_RightFoot.To = Vector2.new(RF.X, RF.Y)

                    -- Set color based on team
                    if plr.TeamColor == Player.TeamColor then
                        Visibility(false) -- Hide ESP for teammates
                    else
                        Colorize(Color3.fromRGB(255, 0, 0)) -- Red for enemies
                        if not limbs.Head_UpperTorso.Visible then
                            Visibility(true)
                        end
                    end
                else 
                    if limbs.Head_UpperTorso.Visible then
                        Visibility(false)
                    end
                end
            else 
                if limbs.Head_UpperTorso.Visible then
                    Visibility(false)
                end
                if game.Players:FindFirstChild(plr.Name) == nil then 
                    for i, v in pairs(limbs) do
                        v:Remove()
                    end
                    connection:Disconnect()
                    espConnections[plr] = nil
                end
            end
        end)
    end

    local function UpdaterR6()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character.Humanoid.Health > 0 then
                local HUM, vis = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                if vis then
                    local H = Camera:WorldToViewportPoint(plr.Character.Head.Position)
                    local T_Height = plr.Character.Torso.Size.Y / 2 - 0.2
                    local UT = Camera:WorldToViewportPoint((plr.Character.Torso.CFrame * CFrame.new(0, T_Height, 0)).p)
                    local LT = Camera:WorldToViewportPoint((plr.Character.Torso.CFrame * CFrame.new(0, -T_Height, 0)).p)
                    local LA_Height = plr.Character["Left Arm"].Size.Y / 2 - 0.2
                    local LUA = Camera:WorldToViewportPoint((plr.Character["Left Arm"].CFrame * CFrame.new(0, LA_Height, 0)).p)
                    local LLA = Camera:WorldToViewportPoint((plr.Character["Left Arm"].CFrame * CFrame.new(0, -LA_Height, 0)).p)
                    local RA_Height = plr.Character["Right Arm"].Size.Y / 2 - 0.2
                    local RUA = Camera:WorldToViewportPoint((plr.Character["Right Arm"].CFrame * CFrame.new(0, RA_Height, 0)).p)
                    local RLA = Camera:WorldToViewportPoint((plr.Character["Right Arm"].CFrame * CFrame.new(0, -RA_Height, 0)).p)
                    local LL_Height = plr.Character["Left Leg"].Size.Y / 2 - 0.2
                    local LUL = Camera:WorldToViewportPoint((plr.Character["Left Leg"].CFrame * CFrame.new(0, LL_Height, 0)).p)
                    local LLL = Camera:WorldToViewportPoint((plr.Character["Left Leg"].CFrame * CFrame.new(0, -LL_Height, 0)).p)
                    local RL_Height = plr.Character["Right Leg"].Size.Y / 2 - 0.2
                    local RUL = Camera:WorldToViewportPoint((plr.Character["Right Leg"].CFrame * CFrame.new(0, RL_Height, 0)).p)
                    local RLL = Camera:WorldToViewportPoint((plr.Character["Right Leg"].CFrame * CFrame.new(0, -RL_Height, 0)).p)

                    -- Update lines
                    limbs.Head_Spine.From = Vector2.new(H.X, H.Y)
                    limbs.Head_Spine.To = Vector2.new(UT.X, UT.Y)

                    limbs.Spine.From = Vector2.new(UT.X, UT.Y)
                    limbs.Spine.To = Vector2.new(LT.X, LT.Y)

                    limbs.LeftArm.From = Vector2.new(LUA.X, LUA.Y)
                    limbs.LeftArm.To = Vector2.new(LLA.X, LLA.Y)

                    limbs.LeftArm_UpperTorso.From = Vector2.new(UT.X, UT.Y)
                    limbs.LeftArm_UpperTorso.To = Vector2.new(LUA.X, LUA.Y)

                    limbs.RightArm.From = Vector2.new(RUA.X, RUA.Y)
                    limbs.RightArm.To = Vector2.new(RLA.X, RLA.Y)

                    limbs.RightArm_UpperTorso.From = Vector2.new(UT.X, UT.Y)
                    limbs.RightArm_UpperTorso.To = Vector2.new(RUA.X, RUA.Y)

                    limbs.LeftLeg.From = Vector2.new(LUL.X, LUL.Y)
                    limbs.LeftLeg.To = Vector2.new(LLL.X, LLL.Y)

                    limbs.LeftLeg_LowerTorso.From = Vector2.new(LT.X, LT.Y)
                    limbs.LeftLeg_LowerTorso.To = Vector2.new(LUL.X, LUL.Y)

                    limbs.RightLeg.From = Vector2.new(RUL.X, RUL.Y)
                    limbs.RightLeg.To = Vector2.new(RLL.X, RLL.Y)

                    limbs.RightLeg_LowerTorso.From = Vector2.new(LT.X, LT.Y)
                    limbs.RightLeg_LowerTorso.To = Vector2.new(RUL.X, RUL.Y)

                    -- Set color based on team
                    if plr.TeamColor == Player.TeamColor then
                        Visibility(false) -- Hide ESP for teammates
                    else
                        Colorize(Color3.fromRGB(255, 0, 0)) -- Red for enemies
                        if not limbs.Head_Spine.Visible then
                            Visibility(true)
                        end
                    end
                else 
                    if limbs.Head_Spine.Visible then
                        Visibility(false)
                    end
                end
            else 
                if limbs.Head_Spine.Visible then
                    Visibility(false)
                end
                if game.Players:FindFirstChild(plr.Name) == nil then 
                    for i, v in pairs(limbs) do
                        v:Remove()
                    end
                    connection:Disconnect()
                    espConnections[plr] = nil
                end
            end
        end)
    end

    if R15 then
        coroutine.wrap(UpdaterR15)()
    else 
        coroutine.wrap(UpdaterR6)()
    end

    espConnections[plr] = true
end

local function UpdateESP()
    while true do
        for i, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Name ~= Player.Name and not espConnections[v] then
                DrawESP(v)
            end
        end
        wait(2) -- Update every 2 seconds
    end
end

for i, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Name ~= Player.Name then
        DrawESP(v)
    end
end

game.Players.PlayerAdded:Connect(function(newplr)
    if newplr.Name ~= Player.Name then
        DrawESP(newplr)
    end
end)

-- Start the periodic ESP update check
coroutine.wrap(UpdateESP)()
