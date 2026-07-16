-- Pistol Arena Ultimate v2.0 | plalettescripts
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local PASSWORD = "plalette1"
local Authorized = false

local Config = {
    Aimbot = false, AimFOV = 150,
    Triggerbot = false, HitboxExpander = false, HitboxSize = 3,
    ESP = false, Tracers = false, Radar = false,
    SpeedHack = false, SpeedValue = 24,
    Fly = false, FlySpeed = 30,
    Fullbright = false
}

local ESPDrawings = {}
local Connections = {}
local Tabs = {}
local CurrentTab = nil

local function ClearESP()
    for _, d in pairs(ESPDrawings) do pcall(function() d:Remove() end) end
    ESPDrawings = {}
end

local function AddESP(d)
    if #ESPDrawings >= 80 then table.remove(ESPDrawings, 1):Remove() end
    table.insert(ESPDrawings, d)
    return d
end

-- ==================== PASSWORD SCREEN ====================
local PassGui = Instance.new("ScreenGui")
PassGui.Name = "PassScreen"
PassGui.Parent = CoreGui
PassGui.ResetOnSpawn = false

local PassFrame = Instance.new("Frame")
PassFrame.Size = UDim2.new(0, 260, 0, 170)
PassFrame.Position = UDim2.new(0.5, -130, 0.5, -85)
PassFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
PassFrame.BackgroundTransparency = 0.08
PassFrame.BorderSizePixel = 0
PassFrame.Active = true
PassFrame.Draggable = true
PassFrame.Parent = PassGui
Instance.new("UICorner", PassFrame).CornerRadius = UDim.new(0, 14)

local PassGlow = Instance.new("Frame")
PassGlow.Size = UDim2.new(1, 3, 1, 3)
PassGlow.Position = UDim2.new(0, -1.5, 0, -1.5)
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
PassIcon.Size = UDim2.new(1, 0, 0, 35)
PassIcon.Position = UDim2.new(0, 0, 0, 15)
PassIcon.BackgroundTransparency = 1
PassIcon.Text = "🔐"
PassIcon.Font = Enum.Font.SourceSans
PassIcon.TextSize = 28
PassIcon.Parent = PassFrame

local PassTitle = Instance.new("TextLabel")
PassTitle.Size = UDim2.new(1, -40, 0, 22)
PassTitle.Position = UDim2.new(0, 20, 0, 50)
PassTitle.BackgroundTransparency = 1
PassTitle.TextColor3 = Color3.fromRGB(240, 180, 210)
PassTitle.Text = "Pistol Arena Ultimate"
PassTitle.Font = Enum.Font.SourceSansBold
PassTitle.TextSize = 16
PassTitle.Parent = PassFrame

local PassBy = Instance.new("TextLabel")
PassBy.Size = UDim2.new(1, -40, 0, 14)
PassBy.Position = UDim2.new(0, 20, 0, 72)
PassBy.BackgroundTransparency = 1
PassBy.TextColor3 = Color3.fromRGB(160, 120, 150)
PassBy.Text = "by plalettescripts"
PassBy.Font = Enum.Font.SourceSans
PassBy.TextSize = 11
PassBy.Parent = PassFrame

local PassInput = Instance.new("TextBox")
PassInput.Size = UDim2.new(1, -40, 0, 32)
PassInput.Position = UDim2.new(0, 20, 0, 95)
PassInput.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
PassInput.BackgroundTransparency = 0.15
PassInput.TextColor3 = Color3.fromRGB(255, 200, 230)
PassInput.PlaceholderText = "Passwort..."
PassInput.PlaceholderColor3 = Color3.fromRGB(120, 90, 110)
PassInput.Text = ""
PassInput.Font = Enum.Font.SourceSansSemibold
PassInput.TextSize = 14
PassInput.Parent = PassFrame
Instance.new("UICorner", PassInput).CornerRadius = UDim.new(0, 10)

local PassBtn = Instance.new("TextButton")
PassBtn.Size = UDim2.new(1, -40, 0, 28)
PassBtn.Position = UDim2.new(0, 20, 0, 132)
PassBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
PassBtn.BackgroundTransparency = 0.08
PassBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PassBtn.Text = "Freischalten"
PassBtn.Font = Enum.Font.SourceSansBold
PassBtn.TextSize = 13
PassBtn.Parent = PassFrame
Instance.new("UICorner", PassBtn).CornerRadius = UDim.new(0, 10)

PassBtn.MouseEnter:Connect(function()
    TweenService:Create(PassBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
end)
PassBtn.MouseLeave:Connect(function()
    TweenService:Create(PassBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.08}):Play()
end)

local function TryPassword()
    if PassInput.Text == PASSWORD then
        Authorized = true
        PassGui:Destroy()
        LoadMainGUI()
    else
        PassInput.Text = ""
        PassInput.PlaceholderText = "❌ Falsch!"
        PassInput.PlaceholderColor3 = Color3.fromRGB(255, 80, 80)
        local orig = PassFrame.Position
        for i = 1, 4 do
            PassFrame.Position = orig + UDim2.new(0, 4, 0, 0)
            task.wait(0.02)
            PassFrame.Position = orig + UDim2.new(0, -4, 0, 0)
            task.wait(0.02)
        end
        PassFrame.Position = orig
        task.wait(0.8)
        PassInput.PlaceholderText = "Passwort..."
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

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 210, 0, 310)
    Main.Position = UDim2.new(0.01, 0, 0.12, 0)
    Main.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
    Main.BackgroundTransparency = 0.1
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.ClipsDescendants = true
    Main.Parent = GUI
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

    local Glow = Instance.new("Frame")
    Glow.Size = UDim2.new(1, 2.5, 1, 2.5)
    Glow.Position = UDim2.new(0, -1.25, 0, -1.25)
    Glow.BackgroundColor3 = Color3.fromRGB(255, 70, 170)
    Glow.BackgroundTransparency = 0.45
    Glow.BorderSizePixel = 0
    Glow.Parent = Main
    Instance.new("UICorner", Glow).CornerRadius = UDim.new(0, 14)

    task.spawn(function()
        local a = 0
        while GUI and GUI.Parent do
            a = (a + 0.025) % (math.pi * 2)
            pcall(function() Glow.BackgroundTransparency = 0.5 - math.sin(a) * 0.28 end)
            task.wait(0.05)
        end
    end)

    -- Minimized
    local Mini = Instance.new("Frame")
    Mini.Size = UDim2.new(0, 160, 0, 28)
    Mini.Position = UDim2.new(0.01, 0, 0.12, 0)
    Mini.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
    Mini.BackgroundTransparency = 0.1
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
    MiniText.Text = "🔫 v2.0 | plalettescripts"
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
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Header.BackgroundTransparency = 0.05
    Header.BorderSizePixel = 0
    Header.Parent = Main
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

    local HeaderTitle = Instance.new("TextLabel")
    HeaderTitle.Size = UDim2.new(0.6, 0, 0.5, 0)
    HeaderTitle.Position = UDim2.new(0.05, 0, 0, 3)
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.TextColor3 = Color3.fromRGB(255, 170, 210)
    HeaderTitle.Text = "Pistol Arena"
    HeaderTitle.Font = Enum.Font.SourceSansBold
    HeaderTitle.TextSize = 15
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTitle.Parent = Header

    local HeaderSub = Instance.new("TextLabel")
    HeaderSub.Size = UDim2.new(0.6, 0, 0.4, 0)
    HeaderSub.Position = UDim2.new(0.05, 0, 0.55, 0)
    HeaderSub.BackgroundTransparency = 1
    HeaderSub.TextColor3 = Color3.fromRGB(180, 130, 160)
    HeaderSub.Text = "v2.0 · plalettescripts"
    HeaderSub.Font = Enum.Font.SourceSans
    HeaderSub.TextSize = 9
    HeaderSub.TextXAlignment = Enum.TextXAlignment.Left
    HeaderSub.Parent = Header

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 22, 0, 20)
    CloseBtn.Position = UDim2.new(1, -26, 0, 10)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 60)
    CloseBtn.BackgroundTransparency = 0.15
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Text = "✕"
    CloseBtn.Font = Enum.Font.SourceSansBold
    CloseBtn.TextSize = 12
    CloseBtn.Parent = Header
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.15}):Play()
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        ClearESP()
        for _, c in pairs(Connections) do pcall(function() c:Disconnect() end) end
        GUI:Destroy()
    end)

    -- Tabs
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, -10, 0, 28)
    TabBar.Position = UDim2.new(0, 5, 0, 43)
    TabBar.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    TabBar.BackgroundTransparency = 0.2
    TabBar.BorderSizePixel = 0
    TabBar.Parent = Main
    Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8)

    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 3)
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabBar

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -10, 1, -80)
    Content.Position = UDim2.new(0, 5, 0, 74)
    Content.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Content.BackgroundTransparency = 0.2
    Content.BorderSizePixel = 0
    Content.Parent = Main
    Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 10)

    local ContentScroll = Instance.new("ScrollingFrame")
    ContentScroll.Size = UDim2.new(1, -6, 1, -6)
    ContentScroll.Position = UDim2.new(0, 3, 0, 3)
    ContentScroll.BackgroundTransparency = 1
    ContentScroll.BorderSizePixel = 0
    ContentScroll.ScrollBarThickness = 2
    ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 80, 160)
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
    ContentScroll.Parent = Content

    local ContentList = Instance.new("UIListLayout")
    ContentList.Padding = UDim.new(0, 4)
    ContentList.FillDirection = Enum.FillDirection.Vertical
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Parent = ContentScroll

    -- Switch Component
    local function CreateSwitch(name, key, parent)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 30)
        Frame.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
        Frame.BackgroundTransparency = 0.2
        Frame.Parent = parent
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.5, 0, 1, 0)
        Label.Position = UDim2.new(0.05, 0, 0, 0)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Color3.fromRGB(220, 210, 230)
        Label.Text = name
        Label.Font = Enum.Font.SourceSansMedium
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        -- Custom Switch Track
        local Track = Instance.new("Frame")
        Track.Size = UDim2.new(0, 38, 0, 20)
        Track.Position = UDim2.new(1, -44, 0, 5)
        Track.BackgroundColor3 = Color3.fromRGB(45, 40, 50)
        Track.BackgroundTransparency = 0.3
        Track.BorderSizePixel = 0
        Track.Parent = Frame
        Instance.new("UICorner", Track).CornerRadius = UDim.new(0, 10)

        local Thumb = Instance.new("Frame")
        Thumb.Size = UDim2.new(0, 16, 0, 16)
        Thumb.Position = UDim2.new(0, 2, 0, 2)
        Thumb.BackgroundColor3 = Color3.fromRGB(200, 180, 210)
        Thumb.BorderSizePixel = 0
        Thumb.Parent = Track
        Instance.new("UICorner", Thumb).CornerRadius = UDim.new(0, 8)

        local enabled = false
        local function UpdateVisual()
            if enabled then
                TweenService:Create(Track, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = Color3.fromRGB(255, 60, 160), BackgroundTransparency = 0.15}):Play()
                TweenService:Create(Thumb, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -18, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            else
                TweenService:Create(Track, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = Color3.fromRGB(45, 40, 50), BackgroundTransparency = 0.3}):Play()
                TweenService:Create(Thumb, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(200, 180, 210)}):Play()
            end
        end

        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
        ToggleBtn.BackgroundTransparency = 1
        ToggleBtn.Text = ""
        ToggleBtn.Parent = Track
        ToggleBtn.MouseButton1Click:Connect(function()
            enabled = not enabled
            Config[key] = enabled
            UpdateVisual()
        end)

        return Frame
    end

    -- Slider Component
    local function CreateSlider(name, key, min, max, def, parent)
        Config[key] = def
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 42)
        Frame.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
        Frame.BackgroundTransparency = 0.2
        Frame.Parent = parent
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.5, 0, 0, 18)
        Label.Position = UDim2.new(0.05, 0, 0, 3)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Color3.fromRGB(220, 210, 230)
        Label.Text = name
        Label.Font = Enum.Font.SourceSansMedium
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local Value = Instance.new("TextLabel")
        Value.Size = UDim2.new(0, 40, 0, 18)
        Value.Position = UDim2.new(1, -48, 0, 3)
        Value.BackgroundTransparency = 1
        Value.TextColor3 = Color3.fromRGB(255, 180, 210)
        Value.Text = tostring(def)
        Value.Font = Enum.Font.SourceSansBold
        Value.TextSize = 11
        Value.TextXAlignment = Enum.TextXAlignment.Right
        Value.Parent = Frame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(0.35, 0, 0, 18)
        Input.Position = UDim2.new(0.3, 0, 0, 21)
        Input.BackgroundColor3 = Color3.fromRGB(35, 30, 45)
        Input.BackgroundTransparency = 0.25
        Input.TextColor3 = Color3.fromRGB(255, 200, 230)
        Input.Text = tostring(def)
        Input.Font = Enum.Font.SourceSans
        Input.TextSize = 10
        Input.Parent = Frame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)

        Input.FocusLost:Connect(function()
            local v = tonumber(Input.Text)
            if v and v >= min and v <= max then
                Config[key] = v
                Value.Text = tostring(v)
            else
                Input.Text = tostring(Config[key])
            end
        end)

        return Frame
    end

    -- Section Label
    local function Section(text, parent)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 16)
        f.BackgroundTransparency = 1
        f.Parent = parent
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 1, 0)
        l.Position = UDim2.new(0, 2, 0, 0)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.fromRGB(255, 130, 180)
        l.Text = text
        l.Font = Enum.Font.SourceSansBold
        l.TextSize = 10
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
        return f
    end

    -- Tab Button
    local function CreateTab(name, icon)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0, 50, 0, 24)
        Btn.BackgroundColor3 = Color3.fromRGB(30, 25, 38)
        Btn.BackgroundTransparency = 0.2
        Btn.TextColor3 = Color3.fromRGB(180, 160, 180)
        Btn.Text = icon .. " " .. name
        Btn.Font = Enum.Font.SourceSansMedium
        Btn.TextSize = 10
        Btn.Parent = TabBar
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

        Btn.MouseButton1Click:Connect(function()
            for _, child in ipairs(TabBar:GetChildren()) do
                if child:IsA("TextButton") then
                    TweenService:Create(child, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 25, 38), TextColor3 = Color3.fromRGB(180, 160, 180), BackgroundTransparency = 0.2}):Play()
                end
            end
            for _, child in ipairs(ContentScroll:GetChildren()) do
                if child:IsA("Frame") and child.Size == UDim2.new(1, 0, 0, 400) then
                    child.Visible = false
                end
            end
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 60, 160), TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.05}):Play()
            
            local page = Btn:GetAttribute("Page")
            if page then page.Visible = true end
        end)

        local page = Instance.new("Frame")
        page.Size = UDim2.new(1, 0, 0, 400)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = ContentScroll

        local pageList = Instance.new("UIListLayout")
        pageList.Padding = UDim.new(0, 4)
        pageList.FillDirection = Enum.FillDirection.Vertical
        pageList.SortOrder = Enum.SortOrder.LayoutOrder
        pageList.Parent = page

        Btn:SetAttribute("Page", page)

        if not CurrentTab then
            CurrentTab = Btn
            page.Visible = true
            TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 60, 160), TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.05}):Play()
        end

        return page
    end

    -- Build Tabs
    local CombatPage = CreateTab("Combat", "⚔")
    local VisualPage = CreateTab("Visuals", "👁")
    local MovePage = CreateTab("Move", "🏃")

    -- Combat Page
    Section("Aimbot", CombatPage)
    CreateSwitch("Aimbot (Right Click)", "Aimbot", CombatPage)
    CreateSlider("Aim FOV", "AimFOV", 50, 300, 150, CombatPage)
    
    Section("Weapon", CombatPage)
    CreateSwitch("Triggerbot", "Triggerbot", CombatPage)
    CreateSwitch("Hitbox Expander", "HitboxExpander", CombatPage)
    CreateSlider("Hitbox Size", "HitboxSize", 1, 6, 3, CombatPage)

    -- Visual Page
    Section("ESP", VisualPage)
    CreateSwitch("Player ESP", "ESP", VisualPage)
    CreateSwitch("Tracers", "Tracers", VisualPage)
    CreateSwitch("Radar", "Radar", VisualPage)

    -- Move Page
    Section("Movement (SAFE)", MovePage)
    CreateSwitch("Speed Hack", "SpeedHack", MovePage)
    CreateSlider("Walk Speed", "SpeedValue", 16, 30, 24, MovePage)
    CreateSwitch("Fly", "Fly", MovePage)
    CreateSlider("Fly Speed", "FlySpeed", 15, 40, 30, MovePage)
    
    Section("World", MovePage)
    CreateSwitch("Fullbright", "Fullbright", MovePage)

    -- ==================== FEATURES ====================

    -- Aimbot
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton2 and Config.Aimbot then
            Connections.Aimbot = RunService.RenderStepped:Connect(function()
                local closest, target = math.huge, nil
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                        local pos, on = Camera:WorldToViewportPoint(p.Character.Head.Position)
                        local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                        if on and d < Config.AimFOV and d < closest then
                            closest = d
                            target = p
                        end
                    end
                end
                if target and target.Character and target.Character:FindFirstChild("Head") then
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Character.Head.Position), 0.35)
                end
            end)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            if Connections.Aimbot then Connections.Aimbot:Disconnect() Connections.Aimbot = nil end
        end
    end)

    -- Triggerbot
    task.spawn(function()
        while task.wait(0.06) do
            if Config.Triggerbot and LocalPlayer.Character then
                pcall(function()
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        local ray = Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 300)
                        local hit = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
                        if hit and hit.Parent and hit.Parent:FindFirstChildOfClass("Humanoid") and hit.Parent ~= LocalPlayer.Character then
                            if tool:FindFirstChild("Shoot") then tool.Shoot:FireServer(hit.Position) end
                            if tool:FindFirstChild("Fire") then tool:FireServer(hit.Position) end
                        end
                    end
                end)
            end
        end
    end)

    -- Hitbox Expander
    task.spawn(function()
        while task.wait(0.3) do
            if Config.HitboxExpander then
                local s = Config.HitboxSize
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        p.Character.HumanoidRootPart.Size = Vector3.new(s, s, s)
                        p.Character.HumanoidRootPart.Transparency = 0.3
                    end
                end
            end
        end
    end)

    -- ESP
    task.spawn(function()
        while task.wait(0.06) do
            ClearESP()
            if Config.ESP then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local head = p.Character:FindFirstChild("Head")
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if head and hrp then
                            local hPos, on = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                            local fPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                            if on then
                                local h = math.abs(hPos.Y - fPos.Y)
                                local w = h / 2
                                local box = AddESP(Drawing.new("Square"))
                                box.Color = Color3.fromRGB(255, 80, 180)
                                box.Thickness = 1
                                box.Size = Vector2.new(w, h)
                                box.Position = Vector2.new(hPos.X - w/2, hPos.Y)
                                box.Filled = false
                                box.Visible = true
                                local nm = AddESP(Drawing.new("Text"))
                                nm.Text = p.Name
                                nm.Color = Color3.fromRGB(255, 200, 230)
                                nm.Size = 11
                                nm.Position = Vector2.new(hPos.X, hPos.Y - 15)
                                nm.Center = true
                                nm.Visible = true
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
                            local l = AddESP(Drawing.new("Line"))
                            l.Color = Color3.fromRGB(255, 120, 200)
                            l.Thickness = 0.5
                            l.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                            l.To = Vector2.new(pos.X, pos.Y)
                            l.Visible = true
                        end
                    end
                end
            end
            if Config.Radar then
                local rs = 55
                local rx = Camera.ViewportSize.X - rs - 6
                local ry = Camera.ViewportSize.Y - rs - 6
                AddESP(Drawing.new("Square")).Color = Color3.fromRGB(0,0,0)
                local bg = ESPDrawings[#ESPDrawings]
                bg.Size = Vector2.new(rs, rs)
                bg.Position = Vector2.new(rx, ry)
                bg.Filled = true
                bg.Visible = true
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local my = LocalPlayer.Character.HumanoidRootPart
                    for _, pl in ipairs(Players:GetPlayers()) do
                        if pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                            local tp = pl.Character.HumanoidRootPart
                            local off = tp.Position - my.Position
                            local rd = math.clamp(off.Magnitude/3, 0, rs/2-2)
                            local a = math.atan2(off.Z, off.X)
                            local d = AddESP(Drawing.new("Circle"))
                            d.Color = pl == LocalPlayer and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,80,180)
                            d.Radius = 2
                            d.Position = Vector2.new(rx+rs/2+math.cos(a)*rd, ry+rs/2+math.sin(a)*rd)
                            d.Filled = true
                            d.Visible = true
                        end
                    end
                end
            end
        end
    end)

    -- Speed Hack
    RunService.Stepped:Connect(function()
        if Config.SpeedHack and LocalPlayer.Character then
            local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = math.min(Config.SpeedValue, 30) end
        end
    end)

    -- Fly
    task.spawn(function()
        while task.wait() do
            if Config.Fly and LocalPlayer.Character then
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local g = hrp:FindFirstChild("FG") or Instance.new("
