-- Pistol Arena v4.2 COMPLETE | plalettescripts
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local Workspace=game:GetService("Workspace")
local CoreGui=game:GetService("CoreGui")
local Lighting=game:GetService("Lighting")
local TweenService=game:GetService("TweenService")
local LocalPlayer=Players.LocalPlayer
local Camera=Workspace.CurrentCamera
local PASSWORD="plalette1"
local Authorized=false
local ScriptActive=true

local Config={Aimbot=false,AimRadius=120,SilentAim=false,Triggerbot=false,Hitbox=false,HitboxSize=3,ESP=false,Tracers=false,Radar=false,SpeedHack=false,SpeedValue=24,Fly=false,FlySpeed=25,Fullbright=false,AntiAFK=true,InfJump=false,JumpPower=50}
local ESPD={}
local FOVC=nil
local Connections={}

local function ClearESP()for _,d in pairs(ESPD)do pcall(function()d:Remove()end)end ESPD={}if FOVC then pcall(function()FOVC:Remove()end)FOVC=nil end end
local function DisconnectAll()for _,c in pairs(Connections)do pcall(function()c:Disconnect()end)end Connections={}end

local function EmergencyStop()
    ScriptActive=false
    for k,_ in pairs(Config)do if type(Config[k])=="boolean"then Config[k]=false end end
    ClearESP()DisconnectAll()
    if LocalPlayer.Character then local h=LocalPlayer.Character:FindFirstChildOfClass("Humanoid")if h then h.WalkSpeed=16 end end
    Lighting.Brightness=1 Lighting.ClockTime=14 Lighting.FogEnd=10000
    if LocalPlayer.Character then local hrp=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if hrp then for _,c in ipairs(hrp:GetChildren())do if c:IsA("BodyGyro")or c:IsA("BodyVelocity")then c:Destroy()end end end end
    for _,p in ipairs(Players:GetPlayers())do if p~=LocalPlayer and p.Character then local hrp=p.Character:FindFirstChild("HumanoidRootPart")if hrp then hrp.Size=Vector3.new(2,2,1)hrp.Transparency=0 end end end
end

local function GetTargetInFOV()
    local cl=math.huge local tr=nil local cx=Camera.ViewportSize.X/2 local cy=Camera.ViewportSize.Y/2
    for _,p in ipairs(Players:GetPlayers())do if p~=LocalPlayer and p.Character then local head=p.Character:FindFirstChild("Head")if head then local pos,on=Camera:WorldToViewportPoint(head.Position)if on then local d=(Vector2.new(pos.X,pos.Y)-Vector2.new(cx,cy)).Magnitude if d<Config.AimRadius and d<cl then cl=d tr=p end end end end end
    return tr
end

-- PASSWORD
local PassGui=Instance.new("ScreenGui")PassGui.Parent=CoreGui
local PF=Instance.new("Frame")PF.Size=UDim2.new(0,260,0,160)PF.Position=UDim2.new(0.5,-130,0.5,-80)PF.BackgroundColor3=Color3.fromRGB(18,18,18)PF.BorderSizePixel=0 PF.Active=true PF.Draggable=true PF.Parent=PassGui
Instance.new("UICorner",PF).CornerRadius=UDim.new(0,12)
local PGL=Instance.new("Frame")PGL.Size=UDim2.new(1,2,1,2)PGL.Position=UDim2.new(0,-1,0,-1)PGL.BackgroundColor3=Color3.fromRGB(91,81,244)PGL.BackgroundTransparency=0.5 PGL.BorderSizePixel=0 PGL.Parent=PF
Instance.new("UICorner",PGL).CornerRadius=UDim.new(0,12)
local PT=Instance.new("TextLabel")PT.Size=UDim2.new(1,0,0,22)PT.Position=UDim2.new(0,0,0,15)PT.BackgroundTransparency=1 PT.TextColor3=Color3.fromRGB(200,200,220)PT.Text="Pistol Arena v4.2"PT.Font=Enum.Font.SourceSansBold PT.TextSize=18 PT.Parent=PF
local PS=Instance.new("TextLabel")PS.Size=UDim2.new(1,0,0,14)PS.Position=UDim2.new(0,0,0,40)PS.BackgroundTransparency=1 PS.TextColor3=Color3.fromRGB(140,140,160)PS.Text="plalettescripts"PS.Font=Enum.Font.SourceSans PS.TextSize=12 PS.Parent=PF
local PI=Instance.new("TextBox")PI.Size=UDim2.new(1,-40,0,30)PI.Position=UDim2.new(0,20,0,65)PI.BackgroundColor3=Color3.fromRGB(30,30,40)PI.TextColor3=Color3.fromRGB(255,255,255)PI.PlaceholderText="Passwort..."PI.Text=""PI.Font=Enum.Font.SourceSans PI.TextSize=14 PI.Parent=PF
Instance.new("UICorner",PI).CornerRadius=UDim.new(0,8)
local PB=Instance.new("TextButton")PB.Size=UDim2.new(1,-40,0,28)PB.Position=UDim2.new(0,20,0,105)PB.BackgroundColor3=Color3.fromRGB(91,81,244)PB.TextColor3=Color3.fromRGB(255,255,255)PB.Text="Freischalten"PB.Font=Enum.Font.SourceSansBold PB.TextSize=13 PB.Parent=PF
Instance.new("UICorner",PB).CornerRadius=UDim.new(0,8)
local function Try()if PI.Text==PASSWORD then Authorized=true PassGui:Destroy()Load()else PI.Text=""PI.PlaceholderText="Falsch!"task.wait(0.8)PI.PlaceholderText="Passwort..."end end
PB.MouseButton1Click:Connect(Try)PI.FocusLost:Connect(function(ep)if ep then Try()end end)

function Load()
    local GUI=Instance.new("ScreenGui")GUI.Parent=CoreGui
    local M=Instance.new("Frame")M.Size=UDim2.new(0,560,0,380)M.Position=UDim2.new(0.5,-280,0.5,-190)M.BackgroundColor3=Color3.fromRGB(18,18,18)M.BackgroundTransparency=0.04 M.BorderSizePixel=0 M.Active=true M.Draggable=true M.Parent=GUI
    Instance.new("UICorner",M).CornerRadius=UDim.new(0,10)
    local GL=Instance.new("Frame")GL.Size=UDim2.new(1,2,1,2)GL.Position=UDim2.new(0,-1,0,-1)GL.BackgroundColor3=Color3.fromRGB(91,81,244)GL.BackgroundTransparency=0.55 GL.BorderSizePixel=0 GL.Parent=M
    Instance.new("UICorner",GL).CornerRadius=UDim.new(0,10)

    local Mini=Instance.new("Frame")Mini.Size=UDim2.new(0,170,0,28)Mini.Position=UDim2.new(0.5,-85,0.02,0)Mini.BackgroundColor3=Color3.fromRGB(18,18,18)Mini.BackgroundTransparency=0.04 Mini.BorderSizePixel=0 Mini.Visible=false Mini.Active=true Mini.Draggable=true Mini.Parent=GUI
    Instance.new("UICorner",Mini).CornerRadius=UDim.new(0,8)
    local MT=Instance.new("TextLabel")MT.Size=UDim2.new(1,0,1,0)MT.BackgroundTransparency=1 MT.TextColor3=Color3.fromRGB(200,200,220)MT.Text="v4.2 | plalettescripts | CTRL"MT.Font=Enum.Font.SourceSansBold MT.TextSize=11 MT.Parent=Mini

    UserInputService.InputBegan:Connect(function(i,p)if p then return end if i.KeyCode==Enum.KeyCode.LeftControl or i.KeyCode==Enum.KeyCode.RightControl then M.Visible=not M.Visible Mini.Visible=not Mini.Visible end end)

    local H=Instance.new("Frame")H.Size=UDim2.new(1,0,0,36)H.BackgroundColor3=Color3.fromRGB(24,24,24)H.BorderSizePixel=0 H.Parent=M
    Instance.new("UICorner",H).CornerRadius=UDim.new(0,10)
    local HT=Instance.new("TextLabel")HT.Size=UDim2.new(0.5,0,1,0)HT.Position=UDim2.new(0,14,0,0)HT.BackgroundTransparency=1 HT.TextColor3=Color3.fromRGB(255,255,255)HT.Text="Pistol Arena v4.2"HT.Font=Enum.Font.SourceSansBold HT.TextSize=15 HT.TextXAlignment=Enum.TextXAlignment.Left HT.Parent=H
    local CB=Instance.new("TextButton")CB.Size=UDim2.new(0,24,0,22)CB.Position=UDim2.new(1,-30,0,7)CB.BackgroundColor3=Color3.fromRGB(220,30,30)CB.TextColor3=Color3.fromRGB(255,255,255)CB.Text="X"CB.Font=Enum.Font.SourceSansBold CB.TextSize=13 CB.Parent=H
    Instance.new("UICorner",CB).CornerRadius=UDim.new(0,4)CB.MouseButton1Click:Connect(function()EmergencyStop()GUI:Destroy()end)

    local SB=Instance.new("Frame")SB.Size=UDim2.new(0,140,1,-36)SB.Position=UDim2.new(0,0,0,36)SB.BackgroundColor3=Color3.fromRGB(22,22,22)SB.BorderSizePixel=0 SB.Parent=M
    local SBL=Instance.new("UIListLayout")SBL.Padding=UDim.new(0,2)SBL.FillDirection=Enum.FillDirection.Vertical SBL.HorizontalAlignment=Enum.HorizontalAlignment.Center SBL.SortOrder=Enum.SortOrder.LayoutOrder SBL.Parent=SB
    local CT=Instance.new("Frame")CT.Size=UDim2.new(1,-140,1,-58)CT.Position=UDim2.new(0,140,0,36)CT.BackgroundColor3=Color3.fromRGB(20,20,20)CT.BorderSizePixel=0 CT.Parent=M
    local FT=Instance.new("Frame")FT.Size=UDim2.new(1,-140,0,22)FT.Position=UDim2.new(0,140,1,-22)FT.BackgroundColor3=Color3.fromRGB(22,22,22)FT.BorderSizePixel=0 FT.Parent=M
    local FL=Instance.new("TextLabel")FL.Size=UDim2.new(0.5,0,1,0)FL.Position=UDim2.new(0,8,0,0)FL.BackgroundTransparency=1 FL.TextColor3=Color3.fromRGB(150,150,150)FL.Text="Welcome, "..LocalPlayer.Name FL.Font=Enum.Font.SourceSans FL.TextSize=11 FL.TextXAlignment=Enum.TextXAlignment.Left FL.Parent=FT
    local FR=Instance.new("TextLabel")FR.Size=UDim2.new(0.5,0,1,0)FR.Position=UDim2.new(0.5,-8,0,0)FR.BackgroundTransparency=1 FR.TextColor3=Color3.fromRGB(150,150,150)FR.Text="FPS: 60"FR.Font=Enum.Font.SourceSans FR.TextSize=11 FR.TextXAlignment=Enum.TextXAlignment.Right FR.Parent=FT
    task.spawn(function()while GUI and GUI.Parent do local fps=math.floor(1/task.wait())pcall(function()FR.Text="FPS: "..fps end)end end)

    local tabContents={}
    local function CreateTab(name,icon)
        local btn=Instance.new("TextButton")btn.Size=UDim2.new(1,-10,0,30)btn.BackgroundColor3=Color3.fromRGB(28,28,28)btn.TextColor3=Color3.fromRGB(180,180,180)btn.Text="  "..icon.."  "..name btn.Font=Enum.Font.SourceSans btn.TextSize=12 btn.TextXAlignment=Enum.TextXAlignment.Left btn.Parent=SB
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
        local page=Instance.new("ScrollingFrame")page.Size=UDim2.new(1,-16,1,-16)page.Position=UDim2.new(0,8,0,8)page.BackgroundTransparency=1 page.BorderSizePixel=0 page.ScrollBarThickness=3 page.ScrollBarImageColor3=Color3.fromRGB(91,81,244)page.CanvasSize=UDim2.new(0,0,0,0)page.Visible=false page.Parent=CT
        local pl=Instance.new("UIListLayout")pl.Padding=UDim.new(0,4)pl.FillDirection=Enum.FillDirection.Vertical pl.SortOrder=Enum.SortOrder.LayoutOrder pl.Parent=page
        btn.MouseButton1Click:Connect(function()for _,b in ipairs(SB:GetChildren())do if b:IsA("TextButton")then b.BackgroundColor3=Color3.fromRGB(28,28,28)b.TextColor3=Color3.fromRGB(180,180,180)end end for _,p in pairs(tabContents)do p.Visible=false end btn.BackgroundColor3=Color3.fromRGB(91,81,244)btn.TextColor3=Color3.fromRGB(255,255,255)page.Visible=true end)
        table.insert(tabContents,page)if #tabContents==1 then btn.BackgroundColor3=Color3.fromRGB(91,81,244)btn.TextColor3=Color3.fromRGB(255,255,255)page.Visible=true end
        return page
    end

    local function Section(page,text)
        local f=Instance.new("Frame")f.Size=UDim2.new(1,0,0,18)f.BackgroundTransparency=1 f.Parent=page
        local l=Instance.new("TextLabel")l.Size=UDim2.new(1,0,1,0)l.BackgroundTransparency=1 l.TextColor3=Color3.fromRGB(140,140,160)l.Text=text l.Font=Enum.Font.SourceSansBold l.TextSize=11 l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=f
        page.CanvasSize=UDim2.new(0,0,0,page.CanvasSize.Y.Offset+22)
    end

    local function Toggle(page,name,key)
        local f=Instance.new("Frame")f.Size=UDim2.new(1,0,0,30)f.BackgroundColor3=Color3.fromRGB(28,28,28)f.Parent=page
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
        local l=Instance.new("TextLabel")l.Size=UDim2.new(0.6,0,1,0)l.Position=UDim2.new(0,10,0,0)l.BackgroundTransparency=1 l.TextColor3=Color3.fromRGB(220,220,220)l.Text=name..": OFF"l.Font=Enum.Font.SourceSans l.TextSize=12 l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=f
        local track=Instance.new("Frame")track.Size=UDim2.new(0,38,0,20)track.Position=UDim2.new(1,-48,0,5)track.BackgroundColor3=Color3.fromRGB(50,50,50)track.BorderSizePixel=0 track.Parent=f
        Instance.new("UICorner",track).CornerRadius=UDim.new(0,10)
        local thumb=Instance.new("Frame")thumb.Size=UDim2.new(0,16,0,16)thumb.Position=UDim2.new(0,2,0,2)thumb.BackgroundColor3=Color3.fromRGB(200,200,200)thumb.BorderSizePixel=0 thumb.Parent=track
        Instance.new("UICorner",thumb).CornerRadius=UDim.new(0,8)
        local tb=Instance.new("TextButton")tb.Size=UDim2.new(1,0,1,0)tb.BackgroundTransparency=1 tb.Text=""tb.Parent=track
        local on=false
        tb.MouseButton1Click:Connect(function()on=not on Config[key]=on l.Text=name..": "..(on and"ON"or"OFF")if on then TweenService:Create(track,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(91,81,244)}):Play()TweenService:Create(thumb,TweenInfo.new(0.2),{Position=UDim2.new(1,-18,0,2),BackgroundColor3=Color3.fromRGB(255,255,255)}):Play()else TweenService:Create(track,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(50,50,50)}):Play()TweenService:Create(thumb,TweenInfo.new(0.2),{Position=UDim2.new(0,2,0,2),BackgroundColor3=Color3.fromRGB(200,200,200)}):Play()end end)
        page.CanvasSize=UDim2.new(0,0,0,page.CanvasSize.Y.Offset+34)
    end

    local function Slider(page,name,key,min,max,def)
        Config[key]=def
        local f=Instance.new("Frame")f.Size=UDim2.new(1,0,0,44)f.BackgroundColor3=Color3.fromRGB(28,28,28)f.Parent=page
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
        local l=Instance.new("TextLabel")l.Size=UDim2.new(0.4,0,0,18)l.Position=UDim2.new(0,10,0,3)l.BackgroundTransparency=1 l.TextColor3=Color3.fromRGB(220,220,220)l.Text=name l.Font=Enum.Font.SourceSans l.TextSize=12 l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=f
        local vl=Instance.new("TextLabel")vl.Size=UDim2.new(0,40,0,18)vl.Position=UDim2.new(1,-50,0,3)vl.BackgroundTransparency=1 vl.TextColor3=Color3.fromRGB(91,81,244)vl.Text=tostring(def)vl.Font=Enum.Font.SourceSansBold vl.TextSize=12 vl.TextXAlignment=Enum.TextXAlignment.Right vl.Parent=f
        local inp=Instance.new("TextBox")inp.Size=UDim2.new(0.3,0,0,20)inp.Position=UDim2.new(0.35,0,0,22)inp.BackgroundColor3=Color3.fromRGB(40,40,40)inp.TextColor3=Color3.fromRGB(255,255,255)inp.Text=tostring(def)inp.Font=Enum.Font.SourceSans inp.TextSize=11 inp.Parent=f
        Instance.new("UICorner",inp).CornerRadius=UDim.new(0,4)
        inp.FocusLost:Connect(function()local v=tonumber(inp.Text)if v and v>=min and v<=max then Config[key]=v vl.Text=tostring(v)else inp.Text=tostring(Config[key])end end)
        page.CanvasSize=UDim2.new(0,0,0,page.CanvasSize.Y.Offset+48)
    end

    local homePage=CreateTab("Home","HS")
    local combatPage=CreateTab("Combat","CO")
    local visualPage=CreateTab("Visuals","VI")
    local charPage=CreateTab("Char","CH")
    local settingsPage=CreateTab("Settings","SE")

    -- HOME
    local wf=Instance.new("Frame")wf.Size=UDim2.new(1,0,0,80)wf.BackgroundColor3=Color3.fromRGB(28,28,28)wf.Parent=homePage
    Instance.new("UICorner",wf).CornerRadius=UDim.new(0,8)
    local wt=Instance.new("TextLabel")wt.Size=UDim2.new(1,-20,0,30)wt.Position=UDim2.new(0,10,0,10)wt.BackgroundTransparency=1 wt.TextColor3=Color3.fromRGB(255,255,255)wt.Text="Welcome, "..LocalPlayer.Name wt.Font=Enum.Font.SourceSansBold wt.TextSize=18 wt.TextXAlignment=Enum.TextXAlignment.Left wt.Parent=wf
    local wi=Instance.new("TextLabel")wi.Size=UDim2.new(1,-20,0,30)wi.Position=UDim2.new(0,10,0,40)wi.BackgroundTransparency=1 wi.TextColor3=Color3.fromRGB(160,160,160)wi.Text="v4.2 | plalettescripts"wi.Font=Enum.Font.SourceSans wi.TextSize=13 wi.TextXAlignment=Enum.TextXAlignment.Left wi.Parent=wf
    homePage.CanvasSize=UDim2.new(0,0,0,100)

    -- COMBAT
    Section(combatPage,"Aimbot")Toggle(combatPage,"FOV Aimbot","Aimbot")Slider(combatPage,"FOV Radius","AimRadius",30,300,120)Toggle(combatPage,"Silent Aim","SilentAim")
    Section(combatPage,"Weapon")Toggle(combatPage,"Triggerbot","Triggerbot")Toggle(combatPage,"Hitbox Expander","Hitbox")Slider(combatPage,"Hitbox Size","HitboxSize",1,8,3)

    -- VISUALS
    Section(visualPage,"ESP")Toggle(visualPage,"Player ESP","ESP")Toggle(visualPage,"Tracers","Tracers")Toggle(visualPage,"Radar","Radar")

    -- CHARACTER
    Section(charPage,"Movement")Toggle(charPage,"Speed Hack","SpeedHack")Slider(charPage,"Walk Speed","SpeedValue",16,28,24)Toggle(charPage,"Infinite Jump","InfJump")Slider(charPage,"Jump Power","JumpPower",50,200,50)Toggle(charPage,"Fly","Fly")Slider(charPage,"Fly Speed","FlySpeed",15,35,25)

    -- SETTINGS
    Section(settingsPage,"World")Toggle(settingsPage,"Fullbright","Fullbright")Toggle(settingsPage,"Anti-AFK","AntiAFK")
    Section(settingsPage,"Info")
    local cf=Instance.new("Frame")cf.Size=UDim2.new(1,0,0,60)cf.BackgroundColor3=Color3.fromRGB(28,28,28)cf.Parent=settingsPage
    Instance.new("UICorner",cf).CornerRadius=UDim.new(0,8)
    local cr=Instance.new("TextLabel")cr.Size=UDim2.new(1,-20,1,-20)cr.Position=UDim2.new(0,10,0,10)cr.BackgroundTransparency=1 cr.TextColor3=Color3.fromRGB(160,160,160)cr.Text="v4.2 | plalettescripts\nPass: plalette1 | X = NOTAUS"cr.Font=Enum.Font.SourceSans cr.TextSize=11 cr.TextXAlignment=Enum.TextXAlignment.Left cr.Parent=cf
    settingsPage.CanvasSize=UDim2.new(0,0,0,settingsPage.CanvasSize.Y.Offset+80)

    -- ==================== FEATURES ====================
    task.spawn(function()while task.wait(0.03)and ScriptActive do if Config.Aimbot then if not FOVC then FOVC=Drawing.new("Circle")end FOVC.Visible=true FOVC.Radius=Config.AimRadius FOVC.Thickness=1.5 FOVC.Color=Color3.fromRGB(91,81,244)FOVC.Filled=false FOVC.Position=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)else if FOVC then FOVC.Visible=false end end end end)

    local oldNC=hookmetamethod(game,"__namecall",function(self,...)local m=getnamecallmethod()local a={...}if m=="FireServer"and Config.Aimbot and Config.SilentAim and ScriptActive then local t=GetTargetInFOV()if t and t.Character and t.Character:FindFirstChild("Head")and a[1]then a[1]=t.Character.Head.Position end end return oldNC(self,unpack(a))end)

    task.spawn(function()while task.wait(0.06)and ScriptActive do if Config.Triggerbot and LocalPlayer.Character then pcall(function()local tool=LocalPlayer.Character:FindFirstChildOfClass("Tool")if tool then local t=GetTargetInFOV()if t and t.Character and t.Character:FindFirstChild("Head")then if tool:FindFirstChild("Shoot")then tool.Shoot:FireServer(t.Character.Head.Position)end end end end)end end end)

    task.spawn(function()while task.wait(0.3)and ScriptActive do if Config.Hitbox then local s=Config.HitboxSize for _,p in ipairs(Players:GetPlayers())do if p~=LocalPlayer and p.Character then local hrp=p.Character:FindFirstChild("HumanoidRootPart")if hrp then hrp.Size=Vector3.new(s,s,s)hrp.Transparency=0.35 end end end end end end)

    task.spawn(function()while task.wait(0.06)and ScriptActive do ClearESP()
        if Config.ESP then for _,p in ipairs(Players:GetPlayers())do if p~=LocalPlayer and p.Character then local head=p.Character:FindFirstChild("Head")local hrp=p.Character:FindFirstChild("HumanoidRootPart")if head and hrp then local hp,on=Camera:WorldToViewportPoint(head.Position+Vector3.new(0,0.5,0))local fp=Camera:WorldToViewportPoint(hrp.Position-Vector3.new(0,3,0))if on then local h=math.abs(hp.Y-fp.Y)local w=h/2 local box=Drawing.new("Square")box.Color=Color3.fromRGB(91,81,244)box.Thickness=1 box.Size=Vector2.new(w,h)box.Position=Vector2.new(hp.X-w/2,hp.Y)box.Filled=false box.Visible=true table.insert(ESPD,box)local nm=Drawing.new("Text")nm.Text=p.Name nm.Color=Color3.fromRGB(255,255,255)nm.Size=12 nm.Position=Vector2.new(hp.X,hp.Y-16)nm.Center=true nm.Visible=true table.insert(ESPD,nm)end end end end end
        if Config.Tracers then for _,p in ipairs(Players:GetPlayers())do if p~=LocalPlayer and p.Character then local hrp=p.Character:FindFirstChild("HumanoidRootPart")if hrp then local pos,on=Camera:WorldToViewportPoint(hrp.Position)if on then local ln=Drawing.new("Line")ln.Color=Color3.fromRGB(120,110,255)ln.Thickness=0.5 ln.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y)ln.To=Vector2.new(pos.X,pos.Y)ln.Visible=true table.insert(ESPD,ln)end end end end end
        if Config.Radar then local rs=55 local rx=Camera.ViewportSize.X-rs-8 local ry=Camera.ViewportSize.Y-rs-8 local bg=Drawing.new("Square")bg.Color=Color3.fromRGB(0,0,0)bg.Size=Vector2.new(rs,rs)bg.Position=Vector2.new(rx,ry)bg.Filled=true bg.Visible=true table.insert(ESPD,bg)if LocalPlayer.Character then local myHrp=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if myHrp then for _,pl in ipairs(Players:GetPlayers())do if pl.Character then local tHrp=pl.Character:FindFirstChild("HumanoidRootPart")if tHrp then local off=tHrp.Position-myHrp.Position local rd=math.clamp(off.Magnitude/3,0,rs/2-2)local a=math.atan2(off.Z,off.X)local dx=rx+rs/2+math.cos(a)*rd local dy=ry+rs/2+math.sin(a)*rd local dot=Drawing.new("Circle")dot.Color=pl==LocalPlayer and Color3.fromRGB(0,255,0)or Color3.fromRGB(91,81,244)dot.Radius=2 dot.Position=Vector2.new(dx,dy)dot.Filled=true dot.Visible=true table.insert(ESPD,dot)end end end end end end end
    end end)

    RunService.Stepped:Connect(function()if ScriptActive then if Config.SpeedHack and LocalPlayer.Character then local h=LocalPlayer.Character:FindFirstChildOfClass("Humanoid")if h then h.WalkSpeed=math.min(Config.SpeedValue,28)end end if Config.InfJump and LocalPlayer.Character then local h=LocalPlayer.Character:FindFirstChildOfClass("Humanoid")if h then h.JumpPower=Config.JumpPower end end end end)

    UserInputService.JumpRequest:Connect(function()if Config.InfJump and ScriptActive and LocalPlayer.Character then local h=LocalPlayer.Character:FindFirstChildOfClass("Humanoid")if h then h:ChangeState(Enum.HumanoidStateType.Jumping)end end end)

    task.spawn(function()while task.wait()and ScriptActive do if Config.Fly and LocalPlayer.Character then local hrp=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if hrp then local g=hrp:FindFirstChild("FlyG")or Instance.new("BodyGyro",hrp)local v=hrp:FindFirstChild("FlyV")or Instance.new("BodyVelocity",hrp)g.Name="FlyG"g.MaxTorque=Vector3.new(9e9,9e9,9e9)g.CFrame=Camera.CFrame v.Name="FlyV"v.MaxForce=Vector3.new(9e9,9e9,9e9)local s=math.min(Config.FlySpeed or 25,35)local m=Vector3.zero if UserInputService:IsKeyDown(Enum.KeyCode.W)then m=m+Camera.CFrame.LookVector end if UserInputService:IsKeyDown(Enum.KeyCode.S)then m=m-Camera.CFrame.LookVector end if UserInputService:IsKeyDown(Enum.KeyCode.A)then m=m-Camera.CFrame.RightVector end if UserInputService:IsKeyDown(Enum.KeyCode.D)then m=m+Camera.CFrame.RightVector end if UserInputService:IsKeyDown(Enum.KeyCode.Space)then m=m+Vector3.new(0,1,0)end if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)then m=m-Vector3.new(0,1,0)end v.Velocity=m*s end end end end)

    task.spawn(function()while task.wait(60)and ScriptActive do if Config.Fullbright then Lighting.Brightness=2 Lighting.ClockTime=14 end if Config.AntiAFK then pcall(function()local VIM=game:GetService("VirtualInputManager")VIM:SendKeyEvent(true,Enum.KeyCode.Space,false,nil)task.wait(0.1)VIM:SendKeyEvent(false,Enum.KeyCode.Space,false,nil)end)end end end)

    print("Pistol Arena v4.2 | plalettescripts | CTRL=Hide X=NOTAUS")
end
