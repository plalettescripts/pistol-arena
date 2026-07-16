-- Pistol Arena Ultimate v3.0 | plalettescripts
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local PASSWORD = "plalette1"
local Authorized = false

local Config = {
    Aimbot = false,
    AimFOV = 120,
    AimCircleColor = Color3.fromRGB(255, 60, 160),
    AimCircleThickness = 1.5,
    AimCircleFilled = false,
    AimCircleRadius = 80,
    SilentAim = false,
    Triggerbot = false,
    HitboxExpander = false,
    HitboxSize = 3,
    ESP = false,
    ESPBoxes = true,
    ESPNames = true,
    ESPDistance = true,
    ESPHealth = true,
    ESPColor = Color3.fromRGB(255, 80, 180),
    Tracers = false,
    TracerColor = Color3.fromRGB(255, 120, 200),
    Radar = false,
    RadarSize = 60,
    SpeedHack = false,
    SpeedValue = 24,
    Fly = false,
    FlySpeed = 25,
    Fullbright = false,
    NoRecoil = false,
    NoSpread = false,
    InstantReload = false,
    AntiAFK = true
}

local ESPDrawings = {}
local Connections = {}
local FOVCircle = nil

local function ClearESP()
    for _, d in pairs(ESPDrawings) do pcall(function() d:Remove() end) end
    ESPDrawings = {}
    if FOVCircle then pcall(function() FOVCircle:Remove() end) FOVCircle = nil end
end

local function AddESP(d)
    if #ESPDrawings >= 100 then table.remove(ESPDrawings, 1):Remove() end
    table.insert(ESPDrawings, d)
    return d
end

-- Get nearest enemy in FOV
local function GetBestTarget()
    local closest = math.huge
    local target = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local head = p.Character:FindFirstChild("Head")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if head and hrp then
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

-- ==================== PASSWORD GUI ====================
local PassGui = Instance.new("ScreenGui")
PassGui.Name = "PassScreen"
PassGui.Parent = CoreGui
PassGui.ResetOnSpawn = false

local PassFrame = Instance.new("Frame")
PassFrame.Size = UDim2.new(0, 260, 0, 160)
PassFrame.Position = UDim2.new(0.5, -130, 0.5, -80)
PassFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
PassFrame.BackgroundTransparency = 0.06
PassFrame.BorderSizePixel = 0
PassFrame.Active = true
PassFrame.Draggable = true
PassFrame.Parent = PassGui
Instance.new("UICorner", PassFrame).CornerRadius = UDim.new(0, 14)

local PassGlow = Instance.new("Frame")
PassGlow.Size = UDim2.new(1, 2, 1, 2)
PassGlow.Position = UDim2.new(0, -1, 0, -1)
PassGlow.BackgroundColor3 = Color3.fromRGB(255, 60, 160)
PassGlow.BackgroundTransparency = 0.5
PassGlow.BorderSizePixel = 0
PassGlow.Parent = PassFrame
Instance.new("UICorner", PassGlow).CornerRadius = UDim.new(0, 14)

task.spawn(function()
    local a = 0
    while PassGui and PassGui.Parent and not Authorized do
        a = (a + 0.03) % (math.pi * 2)
        pcall(function() PassGlow.BackgroundTransparency = 0.55 - math.sin(a) * 0.3 end)
        task.wait(0.04)
    end
end)

local PassIcon = Instance.new("TextLabel")
PassIcon.Size = UDim2.new(1, 0, 0, 30)
PassIcon.Position = UDim2.new(0, 0, 0, 15)
PassIcon.BackgroundTransparency = 1
PassIcon.Text = "🔐"
PassIcon.Font = Enum.Font.SourceSans
PassIcon.TextSize = 26
PassIcon.Parent = PassFrame

local PassTitle = Instance.new("TextLabel")
PassTitle.Size = UDim2.new(1, -40, 0, 20)
PassTitle.Position = UDim2.new(0, 20, 0, 48)
PassTitle.BackgroundTransparency = 1
PassTitle.TextColor3 = Color3.fromRGB(240, 180, 210)
PassTitle.Text = "Pistol Arena Ultimate"
PassTitle.Font = Enum.Font.SourceSansBold
PassTitle.TextSize = 16
PassTitle.Parent = PassFrame

local PassBy = Instance.new("TextLabel")
PassBy.Size = UDim2.new(1, -40, 0, 14)
PassBy.Position = UDim2.new(0, 20, 0, 68)
PassBy.BackgroundTransparency = 1
PassBy.TextColor3 = Color3.fromRGB(160, 120, 150)
PassBy.Text = "v3.0 · plalettescripts"
PassBy.Font = Enum.Font.SourceSans
PassBy.TextSize = 11
PassBy.Parent = PassFrame

local PassInput = Instance.new("TextBox")
PassInput.Size = UDim2.new(1, -40, 0, 30)
PassInput.Position = UDim2.new(0, 20, 0, 90)
PassInput.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
PassInput.BackgroundTransparency = 0.12
PassInput.TextColor3 = Color3.fromRGB(255, 200, 230)
PassInput.PlaceholderText = "Passwort eingeben..."
PassInput.PlaceholderColor3 = Color3.fromRGB(120, 90, 110)
PassInput.Text = ""
PassInput.Font = Enum.Font.SourceSansSemibold
PassInput.TextSize = 14
PassInput.Parent = PassFrame
Instance.new("UICorner", PassInput).CornerRadius = UDim.new(0, 10)

local PassBtn = Instance.new("TextButton")
PassBtn.Size = UDim2.new(1, -40, 0, 26)
PassBtn.Position = UDim2.new(0, 20, 0, 126)
PassBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
PassBtn.BackgroundTransparency = 0.08
PassBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PassBtn.Text = "Freischalten"
PassBtn.Font = Enum.Font.SourceSansBold
PassBtn.TextSize = 13
PassBtn.Parent = PassFrame
Instance.new("UICorner", PassBtn).CornerRadius = UDim.new(0, 10)

local function TryPassword()
    if PassInput.Text == PASSWORD then
        Authorized = true
        PassGui:Destroy()
        LoadMainGUI()
    else
        PassInput.Text = ""
        PassInput.PlaceholderText = "❌ Falsches Passwort!"
        PassInput.PlaceholderColor3 = Color3.fromRGB(255, 80, 80)
        task.wait(1)
        PassInput.PlaceholderText = "Passwort eingeben..."
        PassInput.PlaceholderColor3 = Color3.fromRGB(120, 90, 110)
    end
end

PassBtn.MouseButton1Click:Connect(TryPassword)
PassInput.FocusLost:Connect(function(ep) if ep then TryPassword() end end)

-- ==================== MAIN GUI ====================
function LoadMainGUI()
    local GUI = Instance.new("ScreenGui")
    GUI.Name = "MainGUI"
    GUI.Parent = CoreGui
    GUI.ResetOnSpawn = false

    -- Main container
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 230, 0, 340)
    Main.Position = UDim2.new(0.01, 0, 0.08, 0)
    Main.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
    Main.BackgroundTransparency = 0.08
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.ClipsDescendants = true
    Main.Parent = GUI
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

    -- Outer glow
    local Glow = Instance.new("Frame")
    Glow.Size = UDim2.new(1, 2, 1, 2)
    Glow.Position = UDim2.new(0, -1, 0, -1)
    Glow.BackgroundColor3 = Color3.fromRGB(255, 60, 160)
    Glow.BackgroundTransparency = 0.5
    Glow.BorderSizePixel = 0
    Glow.Parent = Main
    Instance.new("UICorner", Glow).CornerRadius = UDim.new(0, 14)

    task.spawn(function()
        local a = 0
        while GUI and GUI.Parent do
            a = (a + 0.02) % (math.pi * 2)
            pcall(function() Glow.BackgroundTransparency = 0.52 - math.sin(a) * 0.25 end)
            task.wait(0.05)
        end
    end)

    -- Minimized
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

    local MiniText = Instance.new("TextLabel")
    MiniText.Size = UDim2.new(1, 0, 1, 0)
    MiniText.BackgroundTransparency = 1
    MiniText.TextColor3 = Color3.fromRGB(255, 160, 200)
    MiniText.Text = "🔫 v3.0 | plalettescripts"
    MiniText.Font = Enum.Font.SourceSansBold
    MiniText.TextSize = 11
    MiniText.Parent = Mini

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
            Main.Visible = not Main.Visible
            Mini.Visible = not Mini.Visible
        end
    end)

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 38)
    Header.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    Header.BackgroundTransparency = 0.05
    Header.BorderSizePixel = 0
    Header.Parent = Main
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

    local HeaderTitle = Instance.new("TextLabel")
    HeaderTitle.Size = UDim2.new(0.6, 0, 0.5, 0)
    HeaderTitle.Position = UDim2.new(0.05, 0, 0, 3)
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.TextColor3 = Color3.fromRGB(255, 160, 210)
    HeaderTitle.Text = "Pistol Arena v3.0"
    HeaderTitle.Font = Enum.Font.SourceSansBold
    HeaderTitle.TextSize = 15
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTitle.Parent = Header

    local HeaderSub = Instance.new("TextLabel")
    HeaderSub.Size = UDim2.new(0.6, 0, 0.4, 0)
    HeaderSub.Position = UDim2.new(0.05, 0, 0.55, 0)
    HeaderSub.BackgroundTransparency = 1
    HeaderSub.TextColor3 = Color3.fromRGB(170, 120, 155)
    HeaderSub.Text = "plalettescripts"
    HeaderSub.Font = Enum.Font.SourceSans
    HeaderSub.TextSize = 9
    HeaderSub.TextXAlignment = Enum.TextXAlignment.Left
    HeaderSub.Parent = Header

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 22, 0, 20)
    CloseBtn.Position = UDim2.new(1, -26, 0, 9)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 60)
    CloseBtn.BackgroundTransparency = 0.12
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Text = "✕"
    CloseBtn.Font = Enum.Font.SourceSansBold
    CloseBtn.TextSize = 12
    CloseBtn.Parent = Header
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
    CloseBtn.MouseButton1Click:Connect(function()
        ClearESP()
        for _, c in pairs(Connections) do pcall(function() c:Disconnect() end) end
        GUI:Destroy()
    end)

    -- Scroll
    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, -8, 1, -43)
    Scroll.Position = UDim2.new(0, 4, 0, 40)
    Scroll.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    Scroll.BackgroundTransparency = 0.15
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 2
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 80, 160)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 900)
    Scroll.Parent = Main
    Scroll.ScrollingDirection = Enum.ScrollingDirection.Y

    local SL = Instance.new("UIListLayout")
    SL.Padding = UDim.new(0, 4)
    SL.FillDirection = Enum.FillDirection.Vertical
    SL.SortOrder = Enum.SortOrder.LayoutOrder
    SL.Parent = Scroll

    -- Section Header
    local function Section(text)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -4, 0, 18)
        f.BackgroundTransparency = 1
        f.Parent = Scroll
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 1, 0)
        l.Position = UDim2.new(0, 4, 0, 0)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.fromRGB(255, 130, 180)
        l.Text = "▸ " .. text
        l.Font = Enum.Font.SourceSansBold
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
        return f
    end

    -- Toggle Switch
    local function Toggle(name, key)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -4, 0, 30)
        f.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
        f.BackgroundTransparency = 0.2
        f.Parent = Scroll
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.5, 0, 1, 0)
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
        track.Position = UDim2.new(1, -46, 0, 4)
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
        f.Size = UDim2.new(1, -4, 0, 44)
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

    -- Dropdown
    local function Dropdown(name, key, options, def)
        Config[key] = def or options[1]
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -4, 0, 30)
        f.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
        f.BackgroundTransparency = 0.2
        f.Parent = Scroll
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.35, 0, 1, 0)
        l.Position = UDim2.new(0.06, 0, 0, 0)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.fromRGB(210, 200, 225)
        l.Text = name
        l.Font = Enum.Font.SourceSansMedium
        l.TextSize = 12
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f

        local dbtn = Instance.new("TextButton")
        dbtn.Size = UDim2.new(0.45, 0, 0, 22)
        dbtn.Position = UDim2.new(0.5, 0, 0, 4)
        dbtn.BackgroundColor3 = Color3.fromRGB(35, 30, 45)
        dbtn.BackgroundTransparency = 0.2
        dbtn.TextColor3 = Color3.fromRGB(255, 200, 230)
        dbtn.Text = Config[key]
        dbtn.Font = Enum.Font.SourceSans
        dbtn.TextSize = 10
        dbtn.Parent = f
        Instance.new("UICorner", dbtn).CornerRadius = UDim.new(0, 6)

        local dlist = Instance.new("Frame")
        dlist.Size = UDim2.new(0.45, 0, 0, #options * 22)
        dlist.Position = UDim2.new(0.5, 0, 0, 28)
        dlist.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
        dlist.BorderSizePixel = 0
        dlist.Visible = false
        dlist.ZIndex = 10
        dlist.Parent = f
        Instance.new("UICorner", dlist).CornerRadius = UDim.new(0, 6)

        for _, opt in ipairs(options) do
            local ob = Instance.new("TextButton")
            ob.Size = UDim2.new(1, 0, 0, 22)
            ob.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
            ob.TextColor3 = Color3.fromRGB(220, 210, 230)
            ob.Text = opt
            ob.Font = Enum.Font.SourceSans
            ob.TextSize = 10
            ob.ZIndex = 11
            ob.Parent = dlist
            ob.MouseButton1Click:Connect(function()
                Config[key] = opt
                dbtn.Text = opt
                dlist.Visible = false
            end)
        end

        dbtn.MouseButton1Click:Connect(function()
            dlist.Visible = not dlist.Visible
        end)
    end

    -- ==================== BUILD MENU ====================
    Section("🎯 FOV Aimbot")
    Toggle("FOV Aimbot", "Aimbot")
    Slider("FOV Radius", "AimCircleRadius", 30, 300, 120)
    Slider("FOV Thickness", "AimCircleThickness", 0.5, 4, 1.5)
    Toggle("FOV Circle Filled", "AimCircleFilled")
    Toggle("Silent Aim", "SilentAim")

    Section("🔫 Weapon")
    Toggle("Triggerbot", "Triggerbot")
    Toggle("Hitbox Expander", "HitboxExpander")
    Slider("Hitbox Size", "HitboxSize", 1, 8, 3)
    Toggle("No Recoil", "NoRecoil")
    Toggle("No Spread", "NoSpread")
    Toggle("Instant Reload", "InstantReload")

    Section("👁 ESP")
    Toggle("Player ESP", "ESP")
    Toggle("ESP Boxes", "ESPBoxes")
    Toggle("ESP Names", "ESPNames")
    Toggle("ESP Distance", "ESPDistance")
    Toggle("ESP Health", "ESPHealth")
    Toggle("Tracers", "Tracers")
    Toggle("Radar", "Radar")

    Section("🏃 Movement")
    Toggle("Speed Hack", "SpeedHack")
    Slider("Walk Speed", "SpeedValue", 16, 28, 24)
    Toggle("Fly (Slow)", "Fly")
    Slider("Fly Speed", "FlySpeed", 15, 35, 25)

    Section("🌍 World")
    Toggle("Fullbright", "Fullbright")

    Section("🛡️ System")
    Toggle("Anti-AFK", "AntiAFK")

    -- Footer
    local Foot = Instance.new("TextLabel")
    Foot.Size = UDim2.new(1, -4, 0, 16)
    Foot.BackgroundTransparency = 1
    Foot.TextColor3 = Color3.fromRGB(140, 110, 140)
    Foot.Text = "v3.0 · plalettescripts"
    Foot.Font = Enum.Font.SourceSans
    Foot.TextSize = 9
    Foot.Parent = Scroll

    -- ==================== FEATURES ====================

    -- FOV Circle
    task.spawn(function()
        while task.wait(0.03) do
            if Config.Aimbot then
                if not FOVCircle then
                    FOVCircle = Drawing.new("Circle")
                end
                FOVCircle.Visible = true
                FOVCircle.Radius = Config.AimCircleRadius
                FOVCircle.Thickness = Config.AimCircleThickness
                FOVCircle.Color = Config.AimCircleColor
                FOVCircle.Filled = Config.AimCircleFilled
                FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            else
                if FOVCircle then
                    FOVCircle.Visible = false
                end
            end
        end
    end)

    -- Aimbot (FOV Circle based)
    task.spawn(function()
        while task.wait() do
            if Config.Aimbot then
                pcall(function()
                    local target = GetBestTarget()
                    if target and target.Character and target.Character:FindFirstChild("Head") then
                        if Config.SilentAim then
                            -- Silent: nur Schüsse umlenken
                            Connections.SilentAimTarget = target
                        else
                            -- Normal: Kamera folgt
                            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
                        end
                    end
                end)
            end
        end
    end)

    -- Silent Aim (lenkt Schüsse um)
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if method == "FireServer" and Config.SilentAim and Config.Aimbot then
            local target = GetBestTarget()
            if target and target.Character and target.Character:FindFirstChild("Head") and args[1] then
                args[1] = target.Character.Head.Position
            end
        end
        return oldNamecall(self, unpack(args))
    end)

    -- Triggerbot
    task.spawn(function()
        while task.wait(0.05) do
            if Config.Triggerbot and LocalPlayer.Character then
                pcall(function()
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        local target = GetBestTarget()
                        if target and target.Character and target.Character:FindFirstChild("Head") then
                            if tool:FindFirstChild("Shoot") then tool.Shoot:FireServer(target.Character.Head.Position) end
                            if tool:FindFirstChild("Fire") then tool:FireServer(target.Character.Head.Position) end
                        end
                    end
                end)
            end
        end
    end)

    -- Hitbox Expander
    task.spawn(function()
        while task.wait(0.25) do
            if Config.HitboxExpander then
                local s = Config.HitboxSize
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        p.Character.HumanoidRootPart.Size = Vector3.new(s, s, s)
                        p.Character.HumanoidRootPart.Transparency = 0.35
                    end
                end
            end
        end
    end)

    -- Instant Reload
    task.spawn(function()
        while task.wait(0.1) do
            if Config.InstantReload then
                pcall(function()
                    for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
                        if t:IsA("Tool") and t:FindFirstChild("Ammo") then
                            if t.Ammo:IsA("IntValue") then t.Ammo.Value = 99
                            elseif t.Ammo:IsA("NumberValue") then t.Ammo.Value = 99 end
                        end
                    end
                    local ct = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if ct and ct:FindFirstChild("Ammo") then
                        if ct.Ammo:IsA("IntValue") then ct.Ammo.Value = 99
                        elseif ct.Ammo:IsA("NumberValue") then ct.Ammo.Value = 99 end
                    end
                end)
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
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if head and hrp then
                            local hPos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                            local fPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                            if onScreen then
                                local h = math.abs(hPos.Y - fPos.Y)
                                local w = h / 2

                                if Config.ESPBoxes then
                                    local box = AddESP(Drawing.new("Square"))
                                    box.Color = Config.ESPColor
                                    box.Thickness = 1.2
                                    box.Size = Vector2.new(w, h)
                                    box.Position = Vector2.new(hPos.X - w/2, hPos.Y)
                                    box.Filled = false
                                    box.Visible = true
                                end

                                local yOffset = 0
                                if Config.ESPNames then
                                    local nm = AddESP(Drawing.new("Text"))
                                    nm.Text = p.Name
                                    nm.Color = Color3.fromRGB(255, 220, 240)
                                    nm.Size = 12
                                    nm.Position = Vector2.new(hPos.X, hPos.Y - 18)
                                    nm.Center = true
                                    nm.Visible = true
                                    yOffset = yOffset + 14
                                end

                                if Config.ESPDistance and LocalPlayer.Character then
                                    local myHrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    if myHrp then
                                        local dist = math.floor((hrp.Position - myHrp.Position).Magnitude)
                                        local dt = AddESP(Drawing.new("Text"))
                                        dt.Text = dist .. "m"
                                        dt.Color = Color3.fromRGB(200, 180, 200)
                                        dt.Size = 10
                                        dt.Position = Vector2.new(hPos.X, hPos.Y - 18 + yOffset)
                                        dt.Center = true
                                        dt.Visible = true
                                    end
                                end

                                if Config.ESPHealth and hum then
                                    local hp = hum.Health / hum.MaxHealth
                                    local barW = w
                                    local barH = 3
                                    local barX = hPos.X - w/2
                                    local barY = fPos.Y + 3
                                    local bg = AddESP(Drawing.new("Square"))
                                    bg.Color = Color3.fromRGB(40, 40, 40)
                                    bg.Size = Vector2.new(barW, barH)
                                    bg.Position = Vector2.new(barX, barY)
                                    bg.Filled = true
                                    bg.Visible = true
                                    local fill = AddESP(Drawing.new("Square"))
                                    fill.Color = hp > 0.5 and Color3.fromRGB(100, 255, 100) or (hp > 0.25 and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(255, 50, 50))
                                    fill.Size = Vector2.new(barW * hp, barH)
                                    fill.Position = Vector2.new(barX, barY)
                                    fill.Filled = true
                                    fill.Visible = true
                                end
                            end
                        end
                    end
                end
            end

            if Config.Tracers then
                for _, p in ipairs(Players:GetPlayers())
