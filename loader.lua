-- Pistol Arena Ultimate v3.1 FIXED | plalettescripts
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PASSWORD = "plalette1"
local Authorized = false

local Config = {
    Aimbot = false, AimCircleRadius = 120, AimCircleThickness = 1.5,
    AimCircleFilled = false, SilentAim = false,
    Triggerbot = false, HitboxExpander = false, HitboxSize = 3,
    ESP = false, ESPBoxes = true, ESPNames = true, ESPDistance = true,
    Tracers = false, Radar = false,
    SpeedHack = false, SpeedValue = 24,
    Fly = false, FlySpeed = 25,
    Fullbright = false, AntiAFK = true
}

local ESPDrawings = {}
local Connections = {}
local FOVCircle = nil

local function ClearESP()
    for _, d in pairs(ESPDrawings) do pcall(function() d:Remove() end) end
    ESPDrawings = {}
    if FOVCircle then pcall(function() FOVCircle:Remove() end) FOVCircle = nil end
end

local function GetBestTarget()
    local closest = math.huge
    local target = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local head = p.Character:FindFirstChild("Head")
            if head then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if dist < Config.AimCircleRadius and dist < closest then
                        closest = dist
                        target = p
                    end
                end
            end
        end
    end
    return target
end

-- Password GUI
local PassGui = Instance.new("ScreenGui")
PassGui.Name = "Pass"
PassGui.Parent = CoreGui
PassGui.ResetOnSpawn = false

local PF = Instance.new("Frame")
PF.Size = UDim2.new(0, 240, 0, 150)
PF.Position = UDim2.new(0.5, -120, 0.5, -75)
PF.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
PF.BackgroundTransparency = 0.06
PF.BorderSizePixel = 0
PF.Active = true
PF.Draggable = true
PF.Parent = PassGui
Instance.new("UICorner", PF).CornerRadius = UDim.new(0, 14)

local PGlow = Instance.new("Frame")
PGlow.Size = UDim2.new(1, 2, 1, 2)
PGlow.Position = UDim2.new(0, -1, 0, -1)
PGlow.BackgroundColor3 = Color3.fromRGB(255, 60, 160)
PGlow.BackgroundTransparency = 0.5
PGlow.BorderSizePixel = 0
PGlow.Parent = PF
Instance.new("UICorner", PGlow).CornerRadius = UDim.new(0, 14)

task.spawn(function()
    local a = 0
    while PassGui and PassGui.Parent and not Authorized do
        a = (a + 0.03) % (math.pi * 2)
        pcall(function() PGlow.BackgroundTransparency = 0.55 - math.sin(a) * 0.3 end)
        task.wait(0.04)
    end
end)

local PT = Instance.new("TextLabel")
PT.Size = UDim2.new(1, 0, 0, 20)
PT.Position = UDim2.new(0, 0, 0, 15)
PT.BackgroundTransparency = 1
PT.TextColor3 = Color3.fromRGB(240, 180, 210)
PT.Text = "🔐 Pistol Arena Ultimate"
PT.Font = Enum.Font.SourceSansBold
PT.TextSize = 16
PT.Parent = PF

local PS = Instance.new("TextLabel")
PS.Size = UDim2.new(1, 0, 0, 14)
PS.Position = UDim2.new(0, 0, 0, 38)
PS.BackgroundTransparency = 1
PS.TextColor3 = Color3.fromRGB(160, 120, 150)
PS.Text = "v3.1 · plalettescripts"
PS.Font = Enum.Font.SourceSans
PS.TextSize = 11
PS.Parent = PF

local PI = Instance.new("TextBox")
PI.Size = UDim2.new(1, -30, 0, 28)
PI.Position = UDim2.new(0, 15, 0, 60)
PI.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
PI.BackgroundTransparency = 0.12
PI.TextColor3 = Color3.fromRGB(255, 200, 230)
PI.PlaceholderText = "Passwort..."
PI.PlaceholderColor3 = Color3.fromRGB(120, 90, 110)
PI.Text = ""
PI.Font = Enum.Font.SourceSansSemibold
PI.TextSize = 14
PI.Parent = PF
Instance.new("UICorner", PI).CornerRadius = UDim.new(0, 10)

local PB = Instance.new("TextButton")
PB.Size = UDim2.new(1, -30, 0, 26)
PB.Position = UDim2.new(0, 15, 0, 98)
PB.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
PB.BackgroundTransparency = 0.08
PB.TextColor3 = Color3.fromRGB(255, 255, 255)
PB.Text = "Freischalten"
PB.Font = Enum.Font.SourceSansBold
PB.TextSize = 13
PB.Parent = PF
Instance.new("UICorner", PB).CornerRadius = UDim.new(0, 10)

local function Try()
    if PI.Text == PASSWORD then
        Authorized = true
        PassGui:Destroy()
        LoadMain()
    else
        PI.Text = ""
        PI.PlaceholderText = "❌ Falsch!"
        PI.PlaceholderColor3 = Color3.fromRGB(255, 80, 80)
        task.wait(0.8)
        PI.PlaceholderText = "Passwort..."
        PI.PlaceholderColor3 = Color3.fromRGB(120, 90, 110)
    end
end

PB.MouseButton1Click:Connect(Try)
PI.FocusLost:Connect(function(ep) if ep then Try() end end)

-- Main GUI
function LoadMain()
    local GUI = Instance.new("ScreenGui")
    GUI.Name = "Main"
    GUI.Parent = CoreGui
    GUI.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 230, 0, 340)
    Main.Position = UDim2.new(0.01, 0, 0.08, 0)
    Main.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
    Main.BackgroundTransparency = 0.08
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Parent = GUI
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

    local Glow = Instance.new("Frame")
    Glow.Size = UDim2.new(1, 2, 1, 2)
    Glow.Position = UDim2.new(0, -1, 0, -1)
    Glow.BackgroundColor3 = Color3.fromRGB(255, 60, 160)
    Glow.BackgroundTransparency = 0.5
    Glow.BorderSizePixel = 0
    Glow.Parent = Main
    Instance.new("UICorner", Glow).CornerRadius = UDim.new(0, 14)

    local Mini = Instance.new("Frame")
    Mini.Size = UDim2.new(0, 160, 0, 28)
    Mini.Position = UDim2.new(0.01, 0, 0.08, 0)
    Mini.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
    Mini.BackgroundTransparency = 0.08
    Mini.BorderSizePixel = 0
    Mini.Visible = false
    Mini.Active = true
    Mini.Draggable = true
    Mini.Parent = GUI
    Instance.new("UICorner", Mini).CornerRadius = UDim.new(0, 10)

    local MT = Instance.new("TextLabel")
    MT.Size = UDim2.new(1, 0, 1, 0)
    MT.BackgroundTransparency = 1
    MT.TextColor3 = Color3.fromRGB(255, 160, 200)
    MT.Text = "🔫 v3.1 | plalettescripts"
    MT.Font = Enum.Font.SourceSansBold
    MT.TextSize = 11
    MT.Parent = Mini

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
            Main.Visible = not Main.Visible
            Mini.Visible = not Mini.Visible
        end
    end)

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 36)
    Header.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    Header.BackgroundTransparency = 0.05
    Header.BorderSizePixel = 0
    Header.Parent = Main
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

    local HT = Instance.new("TextLabel")
    HT.Size = UDim2.new(0.6, 0, 0.5, 0)
    HT.Position = UDim2.new(0.05, 0, 0, 3)
    HT.BackgroundTransparency = 1
    HT.TextColor3 = Color3.fromRGB(255, 160, 210)
    HT.Text = "Pistol Arena v3.1"
    HT.Font = Enum.Font.SourceSansBold
    HT.TextSize = 15
    HT.TextXAlignment = Enum.TextXAlignment.Left
    HT.Parent = Header

    local HS = Instance.new("TextLabel")
    HS.Size = UDim2.new(0.6, 0, 0.4, 0)
    HS.Position = UDim2.new(0.05, 0, 0.55, 0)
    HS.BackgroundTransparency = 1
    HS.TextColor3 = Color3.fromRGB(170, 120, 155)
    HS.Text = "plalettescripts"
    HS.Font = Enum.Font.SourceSans
    HS.TextSize = 9
    HS.TextXAlignment = Enum.TextXAlignment.Left
    HS.Parent = Header

    local CB = Instance.new("TextButton")
    CB.Size = UDim2.new(0, 22, 0, 20)
    CB.Position = UDim2.new(1, -26, 0, 8)
    CB.BackgroundColor3 = Color3.fromRGB(200, 30, 60)
    CB.BackgroundTransparency = 0.12
    CB.TextColor3 = Color3.fromRGB(255, 255, 255)
    CB.Text = "X"
    CB.Font = Enum.Font.SourceSansBold
    CB.TextSize = 12
    CB.Parent = Header
    Instance.new("UICorner", CB).CornerRadius = UDim.new(0, 6)
    CB.MouseButton1Click:Connect(function()
        ClearESP()
        for _, c in pairs(Connections) do pcall(function() c:Disconnect() end) end
        GUI:Destroy()
    end)

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, -8, 1, -42)
    Scroll.Position = UDim2.new(0, 4, 0, 38)
    Scroll.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    Scroll.BackgroundTransparency = 0.15
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 2
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 80, 160)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 700)
    Scroll.Parent = Main

    local SL = Instance.new("UIListLayout")
    SL.Padding = UDim.new(0, 4)
    SL.FillDirection = Enum.FillDirection.Vertical
    SL.SortOrder = Enum.SortOrder.LayoutOrder
    SL.Parent = Scroll

    -- Section
    local function Section(t)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 18)
        f.BackgroundTransparency = 1
        f.Parent = Scroll
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.fromRGB(255, 130, 180)
        l.Text = "▸ " .. t
        l.Font = Enum.Font.SourceSansBold
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
    end

    -- Toggle
    local function Toggle(name, key)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 30)
        f.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
        f.BackgroundTransparency = 0.2
        f.Parent = Scroll
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.55, 0, 1, 0)
        l.Position = UDim2.new(0.06, 0, 0, 0)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.fromRGB(210, 200, 225)
        l.Text = name
        l.Font = Enum.Font.SourceSansMedium
        l.TextSize = 12
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
        local track = Instance.new("Frame")
        track.Size = UDim2.new(0, 40, 0, 22)
        track.Position = UDim2.new(1, -48, 0, 4)
        track.BackgroundColor3 = Color3.fromRGB(45, 40, 50)
        track.BackgroundTransparency = 0.25
        track.BorderSizePixel = 0
        track.Parent = f
        Instance.new("UICorner", track).CornerRadius = UDim.new(0, 11)
        local thumb = Instance.new("Frame")
        thumb.Size = UDim2.new(0, 18, 0, 18)
        thumb.Position = UDim2.new(0, 2, 0, 2)
        thumb.BackgroundColor3 = Color3.fromRGB(190, 170, 200)
        thumb.BorderSizePixel = 0
        thumb.Parent = track
        Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 9)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = track
        local enabled = false
        btn.MouseButton1Click:Connect(function()
            enabled = not enabled
            Config[key] = enabled
            track.BackgroundColor3 = enabled and Color3.fromRGB(255, 60, 160) or Color3.fromRGB(45, 40, 50)
            track.BackgroundTransparency = enabled and 0.15 or 0.25
            thumb.Position = enabled and UDim2.new(1, -20, 0, 2) or UDim2.new(0, 2, 0, 2)
            thumb.BackgroundColor3 = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(190, 170, 200)
        end)
    end

    -- Slider
    local function Slider(name, key, min, max, def)
        Config[key] = def
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 44)
        f.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
        f.BackgroundTransparency = 0.2
        f.Parent = Scroll
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.45, 0, 0, 18)
        l.Position = UDim2.new(0.06, 0, 0, 4)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.fromRGB(210, 200, 225)
        l.Text = name
        l.Font = Enum.Font.SourceSansMedium
        l.TextSize = 12
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
        local val = Instance.new("TextLabel")
        val.Size = UDim2.new(0, 45, 0, 18)
        val.Position = UDim2.new(1, -53, 0, 4)
        val.BackgroundTransparency = 1
        val.TextColor3 = Color3.fromRGB(255, 180, 210)
        val.Text = tostring(def)
        val.Font = Enum.Font.SourceSansBold
        val.TextSize = 11
        val.TextXAlignment = Enum.TextXAlignment.Right
        val.Parent = f
        local inp = Instance.new("TextBox")
        inp.Size = UDim2.new(0.35, 0, 0, 18)
        inp.Position = UDim2.new(0.3, 0, 0, 24)
        inp.BackgroundColor3 = Color3.fromRGB(35, 30, 45)
        inp.BackgroundTransparency = 0.2
        inp.TextColor3 = Color3.fromRGB(255, 200, 230)
        inp.Text = tostring(def)
        inp.Font = Enum.Font.SourceSans
        inp.TextSize = 10
        inp.Parent = f
        Instance.new("UICorner", inp).CornerRadius = UDim.new(0, 6)
        inp.FocusLost:Connect(function()
            local v = tonumber(inp.Text)
            if v and v >= min and v <= max then
                Config[key] = v
                val.Text = tostring(v)
            else
                inp.Text = tostring(Config[key])
            end
        end)
    end

    -- BUILD
    Section("FOV Aimbot")
    Toggle("FOV Aimbot", "Aimbot")
    Slider("FOV Radius", "AimCircleRadius", 30, 300, 120)
    Slider("Thickness", "AimCircleThickness", 0.5, 4, 1.5)
    Toggle("Filled", "AimCircleFilled")
    Toggle("Silent Aim", "SilentAim")

    Section("Weapon")
    Toggle("Triggerbot", "Triggerbot")
    Toggle("Hitbox Expander", "HitboxExpander")
    Slider("Hitbox Size", "HitboxSize", 1, 8, 3)

    Section("ESP")
    Toggle("Player ESP", "ESP")
    Toggle("Boxes", "ESPBoxes")
    Toggle("Names", "ESPNames")
    Toggle("Distance", "ESPDistance")
    Toggle("Tracers", "Tracers")
    Toggle("Radar", "Radar")

    Section("Movement")
    Toggle("Speed Hack", "SpeedHack")
    Slider("Walk Speed", "SpeedValue", 16, 28, 24)
    Toggle("Fly", "Fly")
    Slider("Fly Speed", "FlySpeed", 15, 35, 25)

    Section("World")
    Toggle("Fullbright", "Fullbright")
    Toggle("Anti-AFK", "AntiAFK")

    local Foot = Instance.new("TextLabel")
    Foot.Size = UDim2.new(1, 0, 0, 14)
    Foot.BackgroundTransparency = 1
    Foot.TextColor3 = Color3.fromRGB(140, 110, 140)
    Foot.Text = "v3.1 · plalettescripts"
    Foot.Font = Enum.Font.SourceSans
    Foot.TextSize = 9
    Foot.Parent = Scroll

    -- ==================== FEATURES ====================

    -- FOV Circle
    task.spawn(function()
        while task.wait(0.03) do
            if Config.Aimbot then
                if not FOVCircle then FOVCircle = Drawing.new("Circle") end
                FOVCircle.Visible = true
                FOVCircle.Radius = Config.AimCircleRadius
                FOVCircle.Thickness = Config.AimCircleThickness
                FOVCircle.Color = Color3.fromRGB(255, 60, 160)
                FOVCircle.Filled = Config.AimCircleFilled
                FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            else
                if FOVCircle then FOVCircle.Visible = false end
            end
        end
    end)

    -- Aimbot
    task.spawn(function()
        while task.wait() do
            if Config.Aimbot and not Config.SilentAim then
                pcall(function()
                    local t = GetBestTarget()
                    if t and t.Character and t.Character:FindFirstChild("Head") then
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
                    end
                end)
            end
        end
    end)

    -- Silent Aim
    local old = hookmetamethod(game, "__namecall", function(self, ...)
        local m = getnamecallmethod()
        local a = {...}
        if m == "FireServer" and Config.SilentAim and Config.Aimbot then
            local t = GetBestTarget()
            if t and t.Character and t.Character:FindFirstChild("Head") and a[1] then
                a[1] = t.Character.Head.Position
            end
        end
        return old(self, unpack(a))
    end)

    -- Triggerbot
    task.spawn(function()
        while task.wait(0.05) do
            if Config.Triggerbot and LocalPlayer.Character then
                pcall(function()
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        local t = GetBestTarget()
                        if t and t.Character and t.Character:FindFirstChild("Head") then
                            if tool:FindFirstChild("Shoot") then tool.Shoot:FireServer(t.Character.Head.Position) end
                        end
                    end
                end)
            end
        end
    end)

    -- Hitbox
    task.spawn(function()
        while task.wait(0.25) do
            if Config.HitboxExpander then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        p.Character.HumanoidRootPart.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                        p.Character.HumanoidRootPart.Transparency = 0.35
                    end
                end
            end
        end
    end)

    -- ESP
    task.spawn(function()
        while task.wait(0.05) do
            ClearESP()
            if Config.ESP then
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
                                if Config.ESPBoxes then
                                    local b = Drawing.new("Square")
                                    b.Color = Color3.fromRGB(255, 80, 180)
                                    b.Thickness = 1.2
                                    b.Size = Vector2.new(w, h)
                                    b.Position = Vector2.new(hp.X - w/2, hp.Y)
                                    b.Filled = false
                                    b.Visible = true
                                    table.insert(ESPDrawings, b)
                                end
                                if Config.ESPNames then
                                    local n = Drawing.new("Text")
                                    n.Text = p.Name
                                    n.Color = Color3.fromRGB(255, 220, 240)
                                    n.Size = 12
                                    n.Position = Vector2.new(hp.X, hp.Y - 18)
                                    n.Center = true
                                    n.Visible = true
                                    table.insert(ESPDrawings, n)
                                end
                                if Config.ESPDistance and LocalPlayer.Character then
                                    local mh = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    if mh then
                                        local d = Drawing.new("Text")
                                        d.Text = math.floor((hrp.Position - mh.Position).Magnitude) .. "m"
                                        d.Color = Color3.fromRGB(200, 180, 200)
                                        d.Size = 10
                                        d.Position = Vector2.new(hp.X, hp.Y - 4)
                                        d.Center = true
                                        d.Visible = true
                                        table.insert(ESPDrawings, d)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if Config.Tracers then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local pos, on = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                        if on then
                            local l = Drawing.new("Line")
                            l.Color = Color3.fromRGB(255, 120, 200)
                            l.Thickness = 0.5
                            l.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                            l.To = Vector2.new(pos.X, pos.Y)
                            l.Visible = true
                            table.insert(ESPDrawings, l)
                        end
                    end
                end
            end
            if Config.Radar then
                local rs = 55
                local rx = Camera.ViewportSize.X - rs - 6
                local ry = Camera.ViewportSize.Y - rs - 6
                local bg = Drawing.new("Square")
                bg.Color = Color3.fromRGB(0, 0, 0)
                bg.Size = Vector2.new(rs, rs)
                bg.Position = Vector2.new(rx, ry)
                bg.Filled = true
                bg.Visible = true
                table.insert(ESPDrawings, bg)
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local my = LocalPlayer.Character.HumanoidRootPart
                    for _, pl in ipairs(Players:GetPlayers()) do
                        if pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                            local tp = pl.Character.HumanoidRootPart
                            local off = tp.Position - my.Position
                            local rd = math.clamp(off.Magnitude/3, 0, rs/2-2)
                            local a = math.atan2(off.Z, off.X)
                            local d = Drawing.new("Circle")
                            d.Color = pl == LocalPlayer and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 80, 180)
                            d.Radius = 2
                            d.Position = Vector2.new(rx+rs/2+math.cos(a)*rd, ry+rs/2+math.sin(a)*rd)
                            d.Filled = true
                            d.Visible = true
                            table.insert(ESPDrawings, d)
                        end
                    end
                end
            end
        end
    end)

    -- Speed
    RunService.Stepped:Connect(function()
        if Config.SpeedHack and LocalPlayer.Character then
            local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = math.min(Config.SpeedValue, 28) end
        end
    end)

    -- Fly
    task.spawn(function()
        while task.wait() do
            if Config.Fly and LocalPlayer.Character then
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local g = hrp:FindFirstChild("FG") or Instance.new("BodyGyro", hrp)
                    local v = hrp:FindFirstChild("FV") or Instance.new("BodyVelocity", hrp)
                    g.Name = "FG" g.MaxTorque = Vector3.new(9e9, 9e9, 9e9) g.CFrame = Camera.CFrame
                    v.Name = "FV" v.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    local s = math.min(Config.FlySpeed or 25, 35)
                    local m = Vector3.zero
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then m += Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then m -= Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then m -= Camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then m += Camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then m += Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then m -= Vector3.new(0, 1, 0) end
                    v.Velocity = m * s
                end
            end
        end
    end)

    -- Fullbright + AntiAFK
    task.spawn(function()
        while task.wait(60) do
            if Config.Fullbright then
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
            end
            if Config.AntiAFK then
                pcall(function()
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Space, false, nil)
                    task.wait(0.1)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Space, false, nil)
                end)
            end
        end
    end)

    print("🔫 Pistol Arena v3.1 | plalettescripts")
end
