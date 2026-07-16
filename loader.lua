-- Pistol Arena v4.2 | plalettescripts
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
local Authorized = false
local ScriptActive = true

local Config = {
    Aimbot = false, AimRadius = 120, SilentAim = false,
    Triggerbot = false, Hitbox = false, HitboxSize = 3,
    ESP = false, Tracers = false, Radar = false,
    SpeedHack = false, SpeedValue = 24,
    Fly = false, FlySpeed = 25,
    Fullbright = false, AntiAFK = true,
    InfJump = false, JumpPower = 50
}

local ESPD = {}
local FOVC = nil
local Connections = {}

local function ClearESP()
    for _, d in pairs(ESPD) do pcall(function() d:Remove() end) end
    ESPD = {}
    if FOVC then pcall(function() FOVC:Remove() end) FOVC = nil end
end

local function DisconnectAll()
    for _, c in pairs(Connections) do pcall(function() c:Disconnect() end) end
    Connections = {}
end

-- NOTAUS: Alles stoppen
local function EmergencyStop()
    ScriptActive = false
    Config.Aimbot = false
    Config.SilentAim = false
    Config.Triggerbot = false
    Config.Hitbox = false
    Config.ESP = false
    Config.Tracers = false
    Config.Radar = false
    Config.SpeedHack = false
    Config.Fly = false
    Config.InfJump = false
    Config.Fullbright = false
    Config.AntiAFK = false
    ClearESP()
    DisconnectAll()
    -- Reset speed
    if LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 16 end
    end
    -- Reset lighting
    Lighting.Brightness = 1
    Lighting.ClockTime = 14
    Lighting.FogEnd = 10000
    -- Remove fly physics
    if LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, c in ipairs(hrp:GetChildren()) do
                if c:IsA("BodyGyro") or c:IsA("BodyVelocity") then
                    c:Destroy()
                end
            end
        end
    end
    -- Reset hitboxes
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 0
            end
        end
    end
end

local function GetTargetInFOV()
    local closest = math.huge
    local target = nil
    local cx = Camera.ViewportSize.X / 2
    local cy = Camera.ViewportSize.Y / 2
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local head = p.Character:FindFirstChild("Head")
            if head then
                local pos, on = Camera:WorldToViewportPoint(head.Position)
                if on then
                    local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(cx, cy)).Magnitude
                    if d < Config.AimRadius and d < closest then
                        closest = d
                        target = p
                    end
                end
            end
        end
    end
    return target
end

-- Password Screen
local PassGui = Instance.new("ScreenGui")
PassGui.Parent = CoreGui

local PassFrame = Instance.new("Frame")
PassFrame.Size = UDim2.new(0, 260, 0, 160)
PassFrame.Position = UDim2.new(0.5, -130, 0.5, -80)
PassFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
PassFrame.BorderSizePixel = 0
PassFrame.Active = true
PassFrame.Draggable = true
PassFrame.Parent = PassGui
Instance.new("UICorner", PassFrame).CornerRadius = UDim.new(0, 12)

local PassGlow = Instance.new("Frame")
PassGlow.Size = UDim2.new(1, 2, 1, 2)
PassGlow.Position = UDim2.new(0, -1, 0, -1)
PassGlow.BackgroundColor3 = Color3.fromRGB(91, 81, 244)
PassGlow.BackgroundTransparency = 0.5
PassGlow.BorderSizePixel = 0
PassGlow.Parent = PassFrame
Instance.new("UICorner", PassGlow).CornerRadius = UDim.new(0, 12)

local PassTitle = Instance.new("TextLabel")
PassTitle.Size = UDim2.new(1, 0, 0, 22)
PassTitle.Position = UDim2.new(0, 0, 0, 15)
PassTitle.BackgroundTransparency = 1
PassTitle.TextColor3 = Color3.fromRGB(200, 200, 220)
PassTitle.Text = "Pistol Arena v4.2"
PassTitle.Font = Enum.Font.SourceSansBold
PassTitle.TextSize = 18
PassTitle.Parent = PassFrame

local PassSub = Instance.new("TextLabel")
PassSub.Size = UDim2.new(1, 0, 0, 14)
PassSub.Position = UDim2.new(0, 0, 0, 40)
PassSub.BackgroundTransparency = 1
PassSub.TextColor3 = Color3.fromRGB(140, 140, 160)
PassSub.Text = "plalettescripts"
PassSub.Font = Enum.Font.SourceSans
PassSub.TextSize = 12
PassSub.Parent = PassFrame

local PassInput = Instance.new("TextBox")
PassInput.Size = UDim2.new(1, -40, 0, 30)
PassInput.Position = UDim2.new(0, 20, 0, 65)
PassInput.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
PassInput.TextColor3 = Color3.fromRGB(255, 255, 255)
PassInput.PlaceholderText = "Passwort..."
PassInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
PassInput.Text = ""
PassInput.Font = Enum.Font.SourceSans
PassInput.TextSize = 14
PassInput.Parent = PassFrame
Instance.new("UICorner", PassInput).CornerRadius = UDim.new(0, 8)

local PassBtn = Instance.new("TextButton")
PassBtn.Size = UDim2.new(1, -40, 0, 28)
PassBtn.Position = UDim2.new(0, 20, 0, 105)
PassBtn.BackgroundColor3 = Color3.fromRGB(91, 81, 244)
PassBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PassBtn.Text = "Freischalten"
PassBtn.Font = Enum.Font.SourceSansBold
PassBtn.TextSize = 13
PassBtn.Parent = PassFrame
Instance.new("UICorner", PassBtn).CornerRadius = UDim.new(0, 8)

local function TryPass()
    if PassInput.Text == PASSWORD then
        Authorized = true
        PassGui:Destroy()
        LoadMain()
    else
        PassInput.Text = ""
        PassInput.PlaceholderText = "Falsch!"
        task.wait(0.8)
        PassInput.PlaceholderText = "Passwort..."
    end
end
PassBtn.MouseButton1Click:Connect(TryPass)
PassInput.FocusLost:Connect(function(ep) if ep then TryPass() end end)

function LoadMain()
    local GUI = Instance.new("ScreenGui")
    GUI.Parent = CoreGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 560, 0, 380)
    Main.Position = UDim2.new(0.5, -280, 0.5, -190)
    Main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Main.BackgroundTransparency = 0.04
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Parent = GUI
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

    local Glow = Instance.new("Frame")
    Glow.Size = UDim2.new(1, 2, 1, 2)
    Glow.Position = UDim2.new(0, -1, 0, -1)
    Glow.BackgroundColor3 = Color3.fromRGB(91, 81, 244)
    Glow.BackgroundTransparency = 0.55
    Glow.BorderSizePixel = 0
    Glow.Parent = Main
    Instance.new("UICorner", Glow).CornerRadius = UDim.new(0, 10)

    -- MINIMIZED (CTRL)
    local Mini = Instance.new("Frame")
    Mini.Size = UDim2.new(0, 170, 0, 28)
    Mini.Position = UDim2.new(0.5, -85, 0.02, 0)
    Mini.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Mini.BackgroundTransparency = 0.04
    Mini.BorderSizePixel = 0
    Mini.Visible = false
    Mini.Active = true
    Mini.Draggable = true
    Mini.Parent = GUI
    Instance.new("UICorner", Mini).CornerRadius = UDim.new(0, 8)
    local MiniText = Instance.new("TextLabel")
    MiniText.Size = UDim2.new(1, 0, 1, 0)
    MiniText.BackgroundTransparency = 1
    MiniText.TextColor3 = Color3.fromRGB(200, 200, 220)
    MiniText.Text = "v4.2 | plalettescripts | CTRL"
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
    Header.Size = UDim2.new(1, 0, 0, 36)
    Header.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    Header.BorderSizePixel = 0
    Header.Parent = Main
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

    local HT = Instance.new("TextLabel")
    HT.Size = UDim2.new(0.5, 0, 1, 0)
    HT.Position = UDim2.new(0, 14, 0, 0)
    HT.BackgroundTransparency = 1
    HT.TextColor3 = Color3.fromRGB(255, 255, 255)
    HT.Text = "Pistol Arena v4.2"
    HT.Font = Enum.Font.SourceSansBold
    HT.TextSize = 15
    HT.TextXAlignment = Enum.TextXAlignment.Left
    HT.Parent = Header

    -- NOTAUS BUTTON (X)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 24, 0, 22)
    CloseBtn.Position = UDim2.new(1, -30, 0, 7)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Text = "✕"
    CloseBtn.Font = Enum.Font.SourceSansBold
    CloseBtn.TextSize = 13
    CloseBtn.Parent = Header
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)
    CloseBtn.MouseButton1Click:Connect(function()
        EmergencyStop()
        GUI:Destroy()
    end)

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 140, 1, -36)
    Sidebar.Position = UDim2.new(0, 0, 0, 36)
    Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main

    local SideList = Instance.new("UIListLayout")
    SideList.Padding = UDim.new(0, 2)
    SideList.FillDirection = Enum.FillDirection.Vertical
    SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SideList.SortOrder = Enum.SortOrder.LayoutOrder
    SideList.Parent = Sidebar

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -140, 1, -58)
    Content.Position = UDim2.new(0, 140, 0, 36)
    Content.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Content.BorderSizePixel = 0
    Content.Parent = Main

    local Footer = Instance.new("Frame")
    Footer.Size = UDim2.new(1, -140, 0, 22)
    Footer.Position = UDim2.new(0, 140, 1, -22)
    Footer.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Footer.BorderSizePixel = 0
    Footer.Parent = Main

    local FooterLeft = Instance.new("TextLabel")
    FooterLeft.Size = UDim2.new(0.5, 0, 1, 0)
    FooterLeft.Position = UDim2.new(0, 8, 0, 0)
    FooterLeft.BackgroundTransparency = 1
    FooterLeft.TextColor3 = Color3.fromRGB(150, 150, 150)
    FooterLeft.Text = "Welcome, " .. LocalPlayer.Name
    FooterLeft.Font = Enum.Font.SourceSans
    FooterLeft.TextSize = 11
    FooterLeft.TextXAlignment = Enum.TextXAlignment.Left
    FooterLeft.Parent = Footer

    local FooterRight = Instance.new("TextLabel")
    FooterRight.Size = UDim2.new(0.5, 0, 1, 0)
    FooterRight.Position = UDim2.new(0.5, -8, 0, 0)
    FooterRight.BackgroundTransparency = 1
    FooterRight.TextColor3 = Color3.fromRGB(150, 150, 150)
    FooterRight.Text = "FPS: 60"
    FooterRight.Font = Enum.Font.SourceSans
    FooterRight.TextSize = 11
    FooterRight.TextXAlignment = Enum.TextXAlignment.Right
    FooterRight.Parent = Footer

    task.spawn(function()
        while GUI and GUI.Parent do
            local fps = math.floor(1 / task.wait())
            pcall(function() FooterRight.Text = "FPS: " .. fps end)
        end
    end)

    local tabContents = {}

    local function CreateTab(name, icon)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        btn.Text = "  " .. icon .. "  " .. name
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = Sidebar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, -16, 1, -16)
        page.Position = UDim2.new(0, 8, 0, 8)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = Color3.fromRGB(91, 81, 244)
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.Visible = false
        page.Parent = Content

        local pageList = Instance.new("UIListLayout")
        pageList.Padding = UDim.new(0, 4)
        pageList.FillDirection = Enum.FillDirection.Vertical
        pageList.SortOrder = Enum.SortOrder.LayoutOrder
        pageList.Parent = page

        btn.MouseButton1Click:Connect(function()
            for _, b in ipairs(Sidebar:GetChildren()) do
                if b:IsA("TextButton") then
                    b.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                    b.TextColor3 = Color3.fromRGB(180, 180, 180)
                end
            end
            for _, p in pairs(tabContents) do p.Visible = false end
            btn.BackgroundColor3 = Color3.fromRGB(91, 81, 244)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            page.Visible = true
        end)

        table.insert(tabContents, page)
        if #tabContents == 1 then
            btn.BackgroundColor3 = Color3.fromRGB(91, 81, 244)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            page.Visible = true
        end

        return page
    end

    local function Section(page, text)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 18)
        f.BackgroundTransparency = 1
        f.Parent = page
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.fromRGB(140, 140, 160)
        l.Text = text
        l.Font = Enum.Font.SourceSansBold
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
        page.CanvasSize = UDim2.new(0, 0, 0, page.CanvasSize.Y.Offset + 22)
    end

    local function Toggle(page, name, key)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 30)
        f.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        f.Parent = page
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.6, 0, 1, 0)
        l.Position = UDim2.new(0, 10, 0, 0)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.fromRGB(220, 220, 220)
        l.Text = name .. ": OFF"
        l.Font = Enum.Font.SourceSans
        l.TextSize = 12
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
        local track = Instance.new("Frame")
        track.Size = UDim2.new(0, 38, 0, 20)
        track.Position = UDim2.new(1, -48, 0, 5)
        track.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        track.BorderSizePixel = 0
        track.Parent = f
        Instance.new("UICorner", track).CornerRadius = UDim.new(0, 10)
        local thumb = Instance.new("Frame")
        thumb.Size = UDim2.new(0, 16, 0, 16)
        thumb.Position = UDim2.new(0, 2, 0, 2)
        thumb.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        thumb.BorderSizePixel = 0
        thumb.Parent = track
        Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 8)
        local tb = Instance.new("TextButton")
        tb.Size = UDim2.new(1, 0, 1, 0)
        tb.BackgroundTransparency = 1
        tb.Text = ""
        tb.Parent = track
        local on = false
        tb.MouseButton1Click:Connect(function()
            on = not on
            Config[key] = on
            l.Text = name .. ": " .. (on and "ON" or "OFF")
            if on then
                TweenService:Create(track, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(91, 81, 244)}):Play()
                TweenService:Create(thumb, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            else
                TweenService:Create(track, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                TweenService:Create(thumb, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            end
        end)
        page.CanvasSize = UDim2.new(0, 0, 0, page.CanvasSize.Y.Offset + 34)
    end

    local function Slider(page, name, key, min, max, def)
        Config[key] = def
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 44)
        f.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        f.Parent = page
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.4, 0, 0, 18)
        l.Position = UDim2.new(0, 10, 0, 3)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.fromRGB(220, 220, 220)
        l.Text = name
        l.Font = Enum.Font.SourceSans
        l.TextSize = 12
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
        local vl = Instance.new("TextLabel")
        vl.Size = UDim2.new(0, 40, 0, 18)
        vl.Position = UDim2.new(1, -50, 0, 3)
        vl.BackgroundTransparency = 1
        vl.TextColor3 = Color3.fromRGB(91, 81, 244)
        vl.Text = tostring(def)
        vl.Font = Enum.Font.SourceSansBold
        vl.TextSize = 12
        vl.TextXAlignment = Enum.TextXAlignment.Right
        vl.Parent = f
        local inp = Instance.new("TextBox")
        inp.Size = UDim2.new(0.3, 0, 0, 20)
        inp.Position = UDim2.new(0.35, 0, 0, 22)
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
                Config[key] = v
                vl.Text = tostring(v)
            else
                inp.Text = tostring(Config[key])
            end
        end)
        page.CanvasSize = UDim2.new(0, 0, 0, page.CanvasSize.Y.Offset + 48)
    end

    -- Tabs
    local homePage = CreateTab("Home", "🏠")
    local combatPage = CreateTab("Combat", "🎯")
    local visualPage = CreateTab("Visuals", "👁")
    local charPage = CreateTab("Character", "🏃")
    local settingsPage = CreateTab("Settings", "⚙️")

    -- HOME
    local wf = Instance.new("Frame")
    wf.Size = UDim2.new(1, 0, 0, 80)
    wf.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    wf.Parent = homePage
    Instance.new("UICorner", wf).CornerRadius = UDim.new(0, 8)
    local wt = Instance.new("TextLabel")
    wt.Size = UDim2.new(1, -20, 0, 30)
    wt.Position = UDim2.new(0, 10, 0, 10)
    wt.BackgroundTransparency = 1
    wt.TextColor3 = Color3.fromRGB(255, 255, 255)
    wt.Text = "Welcome, " .. LocalPlayer.Name
    wt.Font = Enum.Font.SourceSansBold
    wt.TextSize = 18
    wt.TextXAlignment = Enum.TextXAlignment.Left
    wt.Parent = wf
    local wi = Instance.new("TextLabel")
    wi.Size = UDim2.new(1, -20, 0, 30)
    wi.Position = UDim2.new(0, 10, 0, 40)
    wi.BackgroundTransparency = 1
    wi.TextColor3 = Color3.fromRGB(160, 160, 160)
    wi.Text = "v4.2 | plalettescripts\nCTRL = Hide | X = EMERGENCY STOP"
    wi.Font = Enum.Font.SourceSans
    wi.TextSize = 13
    wi.TextXAlignment = Enum.TextXAlignment.Left
    wi.Parent = wf
    homePage.CanvasSize = UDim2.new(0, 0, 0, 100)

    -- COMBAT
    Section(combatPage, "Aimbot")
    Toggle(combatPage, "FOV Aimbot", "Aimbot")
    Slider(combatPage, "FOV Radius", "AimRadius", 30, 300, 120)
    Toggle(combatPage, "Silent Aim", "SilentAim")
    Section(combatPage, "Weapon")
    Toggle(combatPage, "Triggerbot", "Triggerbot")
    Toggle(combatPage, "Hitbox Expander", "Hitbox")
    Slider(combatPage, "Hitbox Size", "HitboxSize", 1, 8, 3)

    -- VISUALS
    Section(visualPage, "ESP")
    Toggle(visualPage, "Player ESP", "ESP")
    Toggle(visualPage, "Tracers", "Tracers")
    Toggle(visualPage, "Radar", "Radar")

    -- CHARACTER
    Section(charPage, "Movement")
    Toggle(charPage, "Speed Hack", "SpeedHack")
    Slider(charPage, "Walk Speed", "SpeedValue", 16, 28, 24)
    Toggle(charPage, "Infinite Jump", "InfJump")
    Slider(charPage, "Jump Power", "JumpPower", 50, 200, 50)
    Toggle(charPage, "Fly", "Fly")
    Slider(charPage, "Fly Speed", "FlySpeed", 15, 35, 25)

    -- SETTINGS
    Section(settingsPage, "World")
    Toggle(settingsPage, "Fullbright", "Fullbright")
    Toggle(settingsPage, "Anti-AFK", "AntiAFK")
    Section(settingsPage, "Info")
    local cf = Instance.new("Frame")
    cf.Size = UDim2.new(1, 0, 0, 60)
    cf.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    cf.Parent = settingsPage
    Instance.new("UICorner", cf).CornerRadius = UDim.new(0, 8)
    local cr = Instance.new("TextLabel")
    cr.Size = UDim2.new(1, -20, 1, -20)
    cr.Position = UDim2.new(0, 10, 0, 10)
    cr.BackgroundTransparency = 1
    cr.TextColor3 = Color3.fromRGB(160, 160, 160)
    cr.Text = "v4.2 | plalettescripts\nPass: plalette1 | X = NOTAUS"
    cr.Font = Enum.Font.SourceSans
    cr.TextSize = 11
    cr.TextXAlignment = Enum.TextXAlignment.Left
    cr.Parent = cf
    settingsPage.CanvasSize = UDim2.new(0, 0, 0, settingsPage.CanvasSize.Y.Offset + 80)

    -- ==================== FEATURES ====================

    -- FOV Circle
    task.spawn(function()
        while task.wait(0.03) and ScriptActive do
            if Config.Aimbot then
                if not FOVC then FOVC = Drawing.new("Circle") end
                FOVC.Visible = true
                FOVC.Radius = Config.AimRadius
                FOVC.Thickness = 1.5
                FOVC.Color = Color3.fromRGB(91, 81, 244)
                FOVC.Filled = false
                FOVC.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            else
                if FOVC then FOVC.Visible = false end
            end
        end
    end)

    -- Silent Aim
    local oldNC = hookmetamethod(game, "__namecall", function(self, ...)
        local m = getnamecallmethod()
        local a = {...}
        if m == "FireServer" and Config.Aimbot and Config.SilentAim and ScriptActive then
            local t = GetTargetInFOV()
            if t and t.Character and t.Character:FindFirstChild("Head") and a[1] then
                a[1] = t.Character.Head.Position
            end
        end
        return oldNC(self, unpack(a))
    end)

    -- Triggerbot
    task.spawn(function()
        while task.wait(0.06) and ScriptActive do
            if Config.Triggerbot and LocalPlayer.Character then
                pcall(function()
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        local t = GetTargetInFOV()
                        if t and t.Character and t.Character:FindFirstChild("Head") then
                            if tool:FindFirstChild("Shoot") then
                                tool.Shoot:FireServer(t.Character.Head.Position)
                            end
                        end
                    end
                end)
            end
        end
    end)

    -- Hitbox
    task.spawn(function()
        while task.wait(0.3) and ScriptActive do
            if Config.Hitbox then
                local s = Config.HitboxSize
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.Size = Vector3.new(s, s, s)
                            hrp.Transparency = 0.35
                        end
                    end
                end
            end
        end
    end)

    -- ESP
    task.spawn(function()
        while task.wait(0.06) and ScriptActive do
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
            if Config.Tracers then
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
            if Config.Radar then
                local rs = 55
                local rx = Camera.ViewportSize.X - rs - 8
                local ry = Camera.ViewportSize.Y - rs - 8
                local bg = Drawing.new("Square")
                bg.Color = Color3.fromRGB(0
