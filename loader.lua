-- Pistol Arena v5.1 | plalettescripts
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PASSWORD = "plalette1"

local AimbotOn = false
local AimRadius = 120
local SilentOn = false
local TriggerOn = false
local HitboxOn = false
local HitboxSz = 3
local ESPOn = false
local TracersOn = false
local RadarOn = false
local SpeedOn = false
local SpeedVal = 24
local FlyOn = false
local FlyVal = 25
local JumpOn = false
local JumpVal = 50
local BrightOn = false
local AFKOn = true

local ESPD = {}
local FOVC = nil

local function ClearESP()
    for _, d in pairs(ESPD) do pcall(function() d:Remove() end) end
    ESPD = {}
    if FOVC then pcall(function() FOVC:Remove() end) FOVC = nil end
end

local function GetTarget()
    local best = 9999
    local tgt = nil
    local cx = Camera.ViewportSize.X / 2
    local cy = Camera.ViewportSize.Y / 2
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local head = p.Character:FindFirstChild("Head")
            if head then
                local pos, on = Camera:WorldToViewportPoint(head.Position)
                if on then
                    local dx = pos.X - cx
                    local dy = pos.Y - cy
                    local d = math.sqrt(dx*dx + dy*dy)
                    if d < AimRadius and d < best then
                        best = d
                        tgt = p
                    end
                end
            end
        end
    end
    return tgt
end

local function NOTAUS()
    AimbotOn = false
    SilentOn = false
    TriggerOn = false
    HitboxOn = false
    ESPOn = false
    TracersOn = false
    RadarOn = false
    SpeedOn = false
    FlyOn = false
    JumpOn = false
    BrightOn = false
    AFKOn = false
    ClearESP()
    if LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 16 end
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, c in ipairs(hrp:GetChildren()) do
                if c:IsA("BodyGyro") or c:IsA("BodyVelocity") then c:Destroy() end
            end
        end
    end
    Lighting.Brightness = 1
end

-- Password Screen
local PassGui = Instance.new("ScreenGui")
PassGui.Parent = CoreGui
PassGui.ResetOnSpawn = false

local PF = Instance.new("Frame")
PF.Size = UDim2.new(0, 240, 0, 140)
PF.Position = UDim2.new(0.5, -120, 0.5, -70)
PF.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
PF.BorderSizePixel = 0
PF.Active = true
PF.Draggable = true
PF.Parent = PassGui
Instance.new("UICorner", PF).CornerRadius = UDim.new(0, 12)

local PT = Instance.new("TextLabel")
PT.Size = UDim2.new(1, 0, 0, 22)
PT.Position = UDim2.new(0, 0, 0, 15)
PT.BackgroundTransparency = 1
PT.TextColor3 = Color3.fromRGB(200, 200, 220)
PT.Text = "Pistol Arena v5.1"
PT.Font = Enum.Font.SourceSansBold
PT.TextSize = 18
PT.Parent = PF

local PS = Instance.new("TextLabel")
PS.Size = UDim2.new(1, 0, 0, 14)
PS.Position = UDim2.new(0, 0, 0, 40)
PS.BackgroundTransparency = 1
PS.TextColor3 = Color3.fromRGB(140, 140, 160)
PS.Text = "plalettescripts"
PS.Font = Enum.Font.SourceSans
PS.TextSize = 12
PS.Parent = PF

local PI = Instance.new("TextBox")
PI.Size = UDim2.new(1, -30, 0, 28)
PI.Position = UDim2.new(0, 15, 0, 60)
PI.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
PI.TextColor3 = Color3.fromRGB(255, 255, 255)
PI.PlaceholderText = "Passwort..."
PI.Text = ""
PI.Font = Enum.Font.SourceSans
PI.TextSize = 14
PI.Parent = PF
Instance.new("UICorner", PI).CornerRadius = UDim.new(0, 8)

local PB = Instance.new("TextButton")
PB.Size = UDim2.new(1, -30, 0, 26)
PB.Position = UDim2.new(0, 15, 0, 95)
PB.BackgroundColor3 = Color3.fromRGB(91, 81, 244)
PB.TextColor3 = Color3.fromRGB(255, 255, 255)
PB.Text = "Freischalten"
PB.Font = Enum.Font.SourceSansBold
PB.TextSize = 13
PB.Parent = PF
Instance.new("UICorner", PB).CornerRadius = UDim.new(0, 8)

local function Try()
    if PI.Text == PASSWORD then
        PassGui:Destroy()
        Load()
    else
        PI.Text = ""
        PI.PlaceholderText = "Falsch!"
        task.wait(0.8)
        PI.PlaceholderText = "Passwort..."
    end
end
PB.MouseButton1Click:Connect(Try)
PI.FocusLost:Connect(function(ep) if ep then Try() end end)

function Load()
    local GUI = Instance.new("ScreenGui")
    GUI.Parent = CoreGui
    GUI.ResetOnSpawn = false

    local M = Instance.new("Frame")
    M.Size = UDim2.new(0, 580, 0, 400)
    M.Position = UDim2.new(0.5, -290, 0.5, -200)
    M.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    M.BackgroundTransparency = 0.04
    M.BorderSizePixel = 0
    M.Active = true
    M.Draggable = true
    M.Parent = GUI
    Instance.new("UICorner", M).CornerRadius = UDim.new(0, 10)

    local GL = Instance.new("Frame")
    GL.Size = UDim2.new(1, 2, 1, 2)
    GL.Position = UDim2.new(0, -1, 0, -1)
    GL.BackgroundColor3 = Color3.fromRGB(91, 81, 244)
    GL.BackgroundTransparency = 0.55
    GL.BorderSizePixel = 0
    GL.Parent = M
    Instance.new("UICorner", GL).CornerRadius = UDim.new(0, 10)

    -- Minimized
    local MN = Instance.new("Frame")
    MN.Size = UDim2.new(0, 180, 0, 28)
    MN.Position = UDim2.new(0.5, -90, 0.02, 0)
    MN.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    MN.BackgroundTransparency = 0.04
    MN.BorderSizePixel = 0
    MN.Visible = false
    MN.Active = true
    MN.Draggable = true
    MN.Parent = GUI
    Instance.new("UICorner", MN).CornerRadius = UDim.new(0, 8)
    local MT = Instance.new("TextLabel")
    MT.Size = UDim2.new(1, 0, 1, 0)
    MT.BackgroundTransparency = 1
    MT.TextColor3 = Color3.fromRGB(200, 200, 220)
    MT.Text = "v5.1 | plalettescripts | CTRL"
    MT.Font = Enum.Font.SourceSansBold
    MT.TextSize = 11
    MT.Parent = MN

    UserInputService.InputBegan:Connect(function(i, p)
        if p then return end
        if i.KeyCode == Enum.KeyCode.LeftControl or i.KeyCode == Enum.KeyCode.RightControl then
            M.Visible = not M.Visible
            MN.Visible = not MN.Visible
        end
    end)

    -- Header
    local H = Instance.new("Frame")
    H.Size = UDim2.new(1, 0, 0, 40)
    H.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    H.BorderSizePixel = 0
    H.Parent = M
    Instance.new("UICorner", H).CornerRadius = UDim.new(0, 10)

    local HT = Instance.new("TextLabel")
    HT.Size = UDim2.new(0.5, 0, 1, 0)
    HT.Position = UDim2.new(0, 14, 0, 0)
    HT.BackgroundTransparency = 1
    HT.TextColor3 = Color3.fromRGB(255, 255, 255)
    HT.Text = "Pistol Arena v5.1"
    HT.Font = Enum.Font.SourceSansBold
    HT.TextSize = 15
    HT.TextXAlignment = Enum.TextXAlignment.Left
    HT.Parent = H

    local CB = Instance.new("TextButton")
    CB.Size = UDim2.new(0, 26, 0, 24)
    CB.Position = UDim2.new(1, -32, 0, 8)
    CB.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
    CB.TextColor3 = Color3.fromRGB(255, 255, 255)
    CB.Text = "✕"
    CB.Font = Enum.Font.SourceSansBold
    CB.TextSize = 14
    CB.Parent = H
    Instance.new("UICorner", CB).CornerRadius = UDim.new(0, 5)
    CB.MouseButton1Click:Connect(function()
        NOTAUS()
        GUI:Destroy()
    end)

    -- Sidebar
    local SB = Instance.new("Frame")
    SB.Size = UDim2.new(0, 150, 1, -40)
    SB.Position = UDim2.new(0, 0, 0, 40)
    SB.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    SB.BorderSizePixel = 0
    SB.Parent = M

    local SBL = Instance.new("UIListLayout")
    SBL.Padding = UDim.new(0, 2)
    SBL.FillDirection = Enum.FillDirection.Vertical
    SBL.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SBL.SortOrder = Enum.SortOrder.LayoutOrder
    SBL.Parent = SB

    -- Content
    local CT = Instance.new("Frame")
    CT.Size = UDim2.new(1, -150, 1, -65)
    CT.Position = UDim2.new(0, 150, 0, 40)
    CT.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    CT.BorderSizePixel = 0
    CT.Parent = M

    -- Footer
    local FT = Instance.new("Frame")
    FT.Size = UDim2.new(1, -150, 0, 25)
    FT.Position = UDim2.new(0, 150, 1, -25)
    FT.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    FT.BorderSizePixel = 0
    FT.Parent = M

    -- Player avatar image
    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.new(0, 30, 0, 30)
    Avatar.Position = UDim2.new(0.5, -200, 0.5, -15)
    Avatar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Avatar.BorderSizePixel = 0
    Avatar.Parent = FT
    Instance.new("UICorner", Avatar).CornerRadius = UDim.new(0, 15)
    
    -- Load avatar
    task.spawn(function()
        local userId = LocalPlayer.UserId
        local thumbType = Enum.ThumbnailType.HeadShot
        local thumbSize = Enum.ThumbnailSize.Size48x48
        local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
        Avatar.Image = content
    end)

    local FL = Instance.new("TextLabel")
    FL.Size = UDim2.new(1, 0, 1, 0)
    FL.Position = UDim2.new(0, 0, 0, 0)
    FL.BackgroundTransparency = 1
    FL.TextColor3 = Color3.fromRGB(150, 150, 150)
    FL.Text = "  Welcome, " .. LocalPlayer.Name .. "  |  plalettescripts"
    FL.Font = Enum.Font.SourceSans
    FL.TextSize = 11
    FL.TextXAlignment = Enum.TextXAlignment.Center
    FL.Parent = FT

    -- Tabs
    local tabs = {}

    local function MakeTab(name, icon)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -10, 0, 32)
        b.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        b.TextColor3 = Color3.fromRGB(180, 180, 180)
        b.Text = "  " .. icon .. "  " .. name
        b.Font = Enum.Font.SourceSans
        b.TextSize = 12
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.Parent = SB
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

        local p = Instance.new("ScrollingFrame")
        p.Size = UDim2.new(1, -16, 1, -16)
        p.Position = UDim2.new(0, 8, 0, 8)
        p.BackgroundTransparency = 1
        p.BorderSizePixel = 0
        p.ScrollBarThickness = 3
        p.ScrollBarImageColor3 = Color3.fromRGB(91, 81, 244)
        p.CanvasSize = UDim2.new(0, 0, 0, 0)
        p.Visible = false
        p.Parent = CT

        local pl = Instance.new("UIListLayout")
        pl.Padding = UDim.new(0, 4)
        pl.FillDirection = Enum.FillDirection.Vertical
        pl.SortOrder = Enum.SortOrder.LayoutOrder
        pl.Parent = p

        b.MouseButton1Click:Connect(function()
            for _, x in ipairs(SB:GetChildren()) do
                if x:IsA("TextButton") then
                    x.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                    x.TextColor3 = Color3.fromRGB(180, 180, 180)
                end
            end
            for _, x in pairs(tabs) do x.Visible = false end
            b.BackgroundColor3 = Color3.fromRGB(91, 81, 244)
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            p.Visible = true
        end)

        table.insert(tabs, p)
        if #tabs == 1 then
            b.BackgroundColor3 = Color3.fromRGB(91, 81, 244)
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            p.Visible = true
        end
        return p
    end

    local function Sec(p, t)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 20)
        f.BackgroundTransparency = 1
        f.Parent = p
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.fromRGB(140, 140, 160)
        l.Text = t
        l.Font = Enum.Font.SourceSansBold
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
        p.CanvasSize = UDim2.new(0, 0, 0, p.CanvasSize.Y.Offset + 24)
    end

    local function Tog(p, n, varName)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 32)
        f.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        f.Parent = p
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.6, 0, 1, 0)
        l.Position = UDim2.new(0, 10, 0, 0)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.fromRGB(220, 220, 220)
        l.Text = n .. ": OFF"
        l.Font = Enum.Font.SourceSans
        l.TextSize = 12
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f

        local tr = Instance.new("Frame")
        tr.Size = UDim2.new(0, 40, 0, 22)
        tr.Position = UDim2.new(1, -50, 0, 5)
        tr.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tr.BorderSizePixel = 0
        tr.Parent = f
        Instance.new("UICorner", tr).CornerRadius = UDim.new(0, 11)

        local th = Instance.new("Frame")
        th.Size = UDim2.new(0, 18, 0, 18)
        th.Position = UDim2.new(0, 2, 0, 2)
        th.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        th.BorderSizePixel = 0
        th.Parent = tr
        Instance.new("UICorner", th).CornerRadius = UDim.new(0, 9)

        local tb = Instance.new("TextButton")
        tb.Size = UDim2.new(1, 0, 1, 0)
        tb.BackgroundTransparency = 1
        tb.Text = ""
        tb.Parent = tr

        local on = false
        tb.MouseButton1Click:Connect(function()
            on = not on
            if varName == "Aimbot" then AimbotOn = on
            elseif varName == "Silent" then SilentOn = on
            elseif varName == "Trigger" then TriggerOn = on
            elseif varName == "Hitbox" then HitboxOn = on
            elseif varName == "ESP" then ESPOn = on
            elseif varName == "Tracers" then TracersOn = on
            elseif varName == "Radar" then RadarOn = on
            elseif varName == "Speed" then SpeedOn = on
            elseif varName == "Fly" then FlyOn = on
            elseif varName == "Jump" then JumpOn = on
            elseif varName == "Bright" then BrightOn = on
            elseif varName == "AFK" then AFKOn = on
            end
            l.Text = n .. ": " .. (on and "ON" or "OFF")
            if on then
                TweenService:Create(tr, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(91, 81, 244)}):Play()
                TweenService:Create(th, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            else
                TweenService:Create(tr, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                TweenService:Create(th, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            end
        end)
        p.CanvasSize = UDim2.new(0, 0, 0, p.CanvasSize.Y.Offset + 36)
    end

    local function Sli(p, n, varName, min, max, def)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 46)
        f.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        f.Parent = p
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.4, 0, 0, 18)
        l.Position = UDim2.new(0, 10, 0, 4)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.fromRGB(220, 220, 220)
        l.Text = n
        l.Font = Enum.Font.SourceSans
        l.TextSize = 12
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f

        local vl = Instance.new("TextLabel")
        vl.Size = UDim2.new(0, 40, 0, 18)
        vl.Position = UDim2.new(1, -50, 0, 4)
        vl.BackgroundTransparency = 1
        vl.TextColor3 = Color3.fromRGB(91, 81, 244)
        vl.Text = tostring(def)
        vl.Font = Enum.Font.SourceSansBold
        vl.TextSize = 12
        vl.TextXAlignment = Enum.TextXAlignment.Right
        vl.Parent = f

        local inp = Instance.new("TextBox")
        inp.Size = UDim2.new(0.3, 0, 0, 20)
        inp.Position = UDim2.new(0.35, 0, 0, 24)
        inp.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        inp.TextColor3 = Color3.fromRGB(255, 255, 255)
        inp.Text = tostring(def)
        inp.Font = Enum.Font.SourceSans
        inp.TextSize = 11
        inp.Parent = f
        Instance.new("UICorner", inp).CornerRadius = UDim.new(0, 4)

        inp.FocusLost:Connect(function()
            local v = tonumber(inp.Text)
            if v and v >= min and v <= max then
                if varName == "AimR" then AimRadius = v
                elseif varName == "HitS" then HitboxSz = v
                elseif varName == "SpdV" then SpeedVal = v
                elseif varName == "JumpV" then JumpVal = v
                elseif varName == "FlyV" then FlyVal = v
                end
                vl.Text = tostring(v)
            end
        end)
        p.CanvasSize = UDim2.new(0, 0, 0, p.CanvasSize.Y.Offset + 50)
    end

    -- Build Tabs
    local home = MakeTab("Home", "🏠")
    local combat = MakeTab("Combat", "🎯")
    local visual = MakeTab("Visuals", "👁")
    local char = MakeTab("Char", "🏃")
    local sett = MakeTab("Settings", "⚙️")

    -- HOME
    local wf = Instance.new("Frame")
    wf.Size = UDim2.new(1, 0, 0, 90)
    wf.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    wf.Parent = home
    Instance.new("UICorner", wf).CornerRadius = UDim.new(0, 8)
    local wt = Instance.new("TextLabel")
    wt.Size = UDim2.new(1, -20, 0, 30)
    wt.Position = UDim2.new(0, 10, 0, 12)
    wt.BackgroundTransparency = 1
    wt.TextColor3 = Color3.fromRGB(255, 255, 255)
    wt.Text = "Welcome, " .. LocalPlayer.Name .. " 👋"
    wt.Font = Enum.Font.SourceSansBold
    wt.TextSize = 18
    wt.TextXAlignment = Enum.TextXAlignment.Left
    wt.Parent = wf
    local wi = Instance.new("TextLabel")
    wi.Size = UDim2.new(1, -20, 0, 30)
    wi.Position = UDim2.new(0, 10, 0, 45)
    wi.BackgroundTransparency = 1
    wi.TextColor3 = Color3.fromRGB(160, 160, 160)
    wi.Text = "Pistol Arena v5.1 | plalettescripts\nCTRL = Hide | X = NOTAUS"
    wi.Font = Enum.Font.SourceSans
    wi.TextSize = 13
    wi.TextXAlignment = Enum.TextXAlignment.Left
    wi.Parent = wf
    home.CanvasSize = UDim2.new(0, 0, 0, 110)

    -- COMBAT
    Sec(combat, "Aimbot")
    Tog(combat, "FOV Aimbot", "Aimbot")
    Sli(combat, "FOV Radius", "AimR", 30, 300, 120)
    Tog(combat, "Silent Aim", "Silent")
    Sec(combat, "Weapon")
    Tog(combat, "Triggerbot", "Trigger")
    Tog(combat, "Hitbox Expander", "Hitbox")
    Sli(combat, "Hitbox Size", "HitS", 1, 8, 3)

    -- VISUALS
    Sec(visual, "ESP")
    Tog(visual, "Player ESP", "ESP")
    Tog(visual, "Tracers", "Tracers")
    Tog(visual, "Radar", "Radar")

    -- CHARACTER
    Sec(char, "Movement")
    Tog(char, "Speed Hack", "Speed")
    Sli(char, "Walk Speed", "SpdV", 16, 28, 24)
    Tog(char, "Infinite Jump", "Jump")
    Sli(char, "Jump Power", "JumpV", 50, 200, 50)
    Tog(char, "Fly", "Fly")
    Sli(char, "Fly Speed", "FlyV", 15, 35, 25)

    -- SETTINGS
    Sec(sett, "World")
    Tog(sett, "Fullbright", "Bright")
    Tog(sett, "Anti-AFK", "AFK")
    local cf = Instance.new("Frame")
    cf.Size = UDim2.new(1, 0, 0, 70)
    cf.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    cf.Parent = sett
    Instance.new("UICorner", cf).CornerRadius = UDim.new(0, 8)
    local cr = Instance.new("TextLabel")
    cr.Size = UDim2.new(1, -20, 1, -20)
    cr.Position = UDim2.new(0, 10, 0, 10)
    cr.BackgroundTransparency = 1
    cr.TextColor3 = Color3.fromRGB(160, 160, 160)
    cr.Text = "v5.1 | plalettescripts\nPass: plalette1 | X = NOTAUS"
    cr.Font = Enum.Font.SourceSans
    cr.TextSize = 11
    cr.TextXAlignment = Enum.TextXAlignment.Left
    cr.Parent = cf
    sett.CanvasSize = UDim2.new(0, 0, 0, sett.CanvasSize.Y.Offset + 90)

    -- ==================== FEATURES ====================

    task.spawn(function()
        while task.wait(0.03) do
            if AimbotOn then
                if not FOVC then FOVC = Drawing.new("Circle") end
                FOVC.Visible = true
                FOVC.Radius = AimRadius
                FOVC.Thickness = 1.5
                FOVC.Color = Color3.fromRGB(91, 81, 244)
                FOVC.Filled = false
                FOVC.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            else
                if FOVC then FOVC.Visible = false end
            end
        end
    end)

    local oldNC = hookmetamethod(game, "__namecall", function(self, ...)
        local m = getnamecallmethod()
        local a = {...}
        if m == "FireServer" and AimbotOn and SilentOn then
            local t = GetTarget()
            if t and t.Character then
                local head = t.Character:FindFirstChild("Head")
                if head and a[1] then a[1] = head.Position end
            end
        end
        return oldNC(self, unpack(a))
    end)

    task.spawn(function()
        while task.wait(0.06) do
            if TriggerOn and LocalPlayer.Character then
                pcall(function()
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        local t = GetTarget()
                        if t and t.Character then
                            local head = t.Character:FindFirstChild("Head")
                            if head and tool:FindFirstChild("Shoot") then
                                tool.Shoot:FireServer(head.Position)
                            end
                        end
                    end
                end)
            end
        end
    end)

    task.spawn(function()
        while task.wait(0.3) do
            if HitboxOn then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.Size = Vector3.new(HitboxSz, HitboxSz, HitboxSz)
                            hrp.Transparency = 0.35
                        end
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait(0.06) do
            ClearESP()
            if ESPOn then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local head = p.Character:FindFirstChild("Head")
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if head and hrp then
                            local hp, on = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                            local fp = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                            if on then
                                local h = math.abs(hp.Y - fp.Y)
                                local w = h / 2
                                local box = Drawing.new("Square")
                                box.Color = Color3.fromRGB(91, 81, 244)
                                box.Thickness = 1
                                box.Size = Vector2.new(w, h)
                                box.Position = Vector2.new(hp.X - w / 2, hp.Y)
                                box.Filled = false
                                box.Visible = true
                                table.insert(ESPD, box)
                                local nm = Drawing.new("Text")
                                nm.Text = p.Name
                                nm.Color = Color3.fromRGB(255, 255, 255)
                                nm.Size = 12
                                nm.Position = Vector2.new(hp.X, hp.Y - 16)
                                nm.Center = true
                                nm.Visible = true
                                table.insert(ESPD, nm)
                            end
                        end
                    end
                end
            end
            if TracersOn then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local pos, on = Camera:WorldToViewportPoint(hrp.Position)
                            if on then
                                local ln = Drawing.new("Line")
                                ln.Color = Color3.fromRGB(120, 110, 255)
                                ln.Thickness = 0.5
                                ln.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                                ln.To = Vector2.new(pos.X, pos.Y)
                                ln.Visible = true
                                table.insert(ESPD, ln)
                            end
                        end
                    end
                end
            end
            if RadarOn then
                local rs = 55
                local rx = Camera.ViewportSize.X - rs - 8
                local ry = Camera.ViewportSize.Y - rs - 8
                local bg = Drawing.new("Square")
                bg.Color = Color3.fromRGB(0, 0, 0)
                bg.Size = Vector2.new(rs, rs)
                bg.Position = Vector2.new(rx, ry)
                bg.Filled = true
                bg.Visible = true
                table.insert(ESPD, bg)
                if LocalPlayer.Character then
                    local mh = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if mh then
                        for _, pl in ipairs(Players:GetPlayers()) do
                            if pl.Character then
                                local th = pl.Character:FindFirstChild("HumanoidRootPart")
                                if th then
                                    local off = th.Position - mh.Position
                                    local rd = math.clamp(off.Magnitude / 3, 0, rs / 2 - 2)
                                    local a = math.atan2(off.Z, off.X)
                                    local dx = rx + rs / 2 + math.cos(a) * rd
                                    local dy = ry + rs / 2 + math.sin(a) * rd
                                    local dt = Drawing.new("Circle")
                                    dt.Color = pl == LocalPlayer and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(91, 81, 244)
                                    dt.Radius = 2
                                    dt.Position = Vector2.new(dx, dy)
                                    dt.Filled = true
                                    dt.Visible = true
                                    table.insert(ESPD, dt)
                                end
                            end
                        end
                    end                end
            end
        end
    end)

    RunService.Stepped:Connect(function()
        if SpeedOn and LocalPlayer.Character then
            local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = math.min(SpeedVal, 28) end
        end
        if JumpOn and LocalPlayer.Character then
            local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then h.JumpPower = JumpVal end
        end
    end)

    UserInputService.JumpRequest:Connect(function()
        if JumpOn and LocalPlayer.Character then
            local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)

    task.spawn(function()
        while task.wait() do
            if FlyOn and LocalPlayer.Character then
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local g = hrp:FindFirstChild("FlyG")
                    if not g then
                        g = Instance.new("BodyGyro")
                        g.Name = "FlyG"
                        g.Parent = hrp
                    end
                    local v = hrp:FindFirstChild("FlyV")
                    if not v then
                        v = Instance.new("BodyVelocity")
                        v.Name = "FlyV"
                        v.Parent = hrp
                    end
                    g.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                    g.CFrame = Camera.CFrame
                    v.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    local s = math.min(FlyVal, 35)
                    local m = Vector3.zero
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then m = m + Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then m = m - Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then m = m - Camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then m = m + Camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then m = m + Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then m = m - Vector3.new(0, 1, 0) end
                    v.Velocity = m * s
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait(60) do
            if BrightOn then
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
            end
            if AFKOn then
                pcall(function()
                    local VIM = game:GetService("VirtualInputManager")
                    VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, nil)
                    task.wait(0.1)
                    VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, nil)
                end)
            end
        end
    end)

    print("Pistol Arena v5.1 | plalettescripts")
end
