-- Pistol Arena Ultimate v3.2 | plalettescripts
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local Workspace=game:GetService("Workspace")
local CoreGui=game:GetService("CoreGui")
local Lighting=game:GetService("Lighting")
local LocalPlayer=Players.LocalPlayer
local Camera=Workspace.CurrentCamera
local PASSWORD="plalette1"
local Authorized=false

local Config={
    Aimbot=false,AimRadius=120,AimThick=1.5,AimFilled=false,SilentAim=false,
    Triggerbot=false,Hitbox=false,HitboxSize=3,
    ESP=false,ESPBox=true,ESPName=true,ESPDist=true,
    Tracers=false,Radar=false,
    SpeedHack=false,SpeedValue=24,
    Fly=false,FlySpeed=25,
    Fullbright=false,AntiAFK=true
}

local ESPD={}
local CONN={}
local FOVC=nil

local function ClearESP()for _,d in pairs(ESPD)do pcall(function()d:Remove()end)end ESPD={}if FOVC then pcall(function()FOVC:Remove()end)FOVC=nil end end

local function GetTarget()
    local cl=math.huge local tr=nil
    for _,p in ipairs(Players:GetPlayers())do
        if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("Head")then
            local pos,on=Camera:WorldToViewportPoint(p.Character.Head.Position)
            if on then
                local d=(Vector2.new(pos.X,pos.Y)-Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude
                if d<Config.AimRadius and d<cl then cl=d tr=p end
            end
        end
    end
    return tr
end

-- Passwort
local PG=Instance.new("ScreenGui")PG.Name="P"PG.Parent=CoreGui PG.ResetOnSpawn=false
local PF=Instance.new("Frame")PF.Size=UDim2.new(0,240,0,150)PF.Position=UDim2.new(0.5,-120,0.5,-75)PF.BackgroundColor3=Color3.fromRGB(16,16,24)PF.BackgroundTransparency=0.06 PF.BorderSizePixel=0 PF.Active=true PF.Draggable=true PF.Parent=PG
Instance.new("UICorner",PF).CornerRadius=UDim.new(0,14)
local PGL=Instance.new("Frame")PGL.Size=UDim2.new(1,2,1,2)PGL.Position=UDim2.new(0,-1,0,-1)PGL.BackgroundColor3=Color3.fromRGB(255,60,160)PGL.BackgroundTransparency=0.5 PGL.BorderSizePixel=0 PGL.Parent=PF
Instance.new("UICorner",PGL).CornerRadius=UDim.new(0,14)
task.spawn(function()local a=0 while PG and PG.Parent and not Authorized do a=(a+0.03)%(math.pi*2)pcall(function()PGL.BackgroundTransparency=0.55-math.sin(a)*0.3 end)task.wait(0.04)end end)
local PT=Instance.new("TextLabel")PT.Size=UDim2.new(1,0,0,20)PT.Position=UDim2.new(0,0,0,15)PT.BackgroundTransparency=1 PT.TextColor3=Color3.fromRGB(240,180,210)PT.Text="Pistol Arena Ultimate"PT.Font=Enum.Font.SourceSansBold PT.TextSize=16 PT.Parent=PF
local PS=Instance.new("TextLabel")PS.Size=UDim2.new(1,0,0,14)PS.Position=UDim2.new(0,0,0,38)PS.BackgroundTransparency=1 PS.TextColor3=Color3.fromRGB(160,120,150)PS.Text="v3.2 | plalettescripts"PS.Font=Enum.Font.SourceSans PS.TextSize=11 PS.Parent=PF
local PI=Instance.new("TextBox")PI.Size=UDim2.new(1,-30,0,28)PI.Position=UDim2.new(0,15,0,60)PI.BackgroundColor3=Color3.fromRGB(28,28,38)PI.BackgroundTransparency=0.12 PI.TextColor3=Color3.fromRGB(255,200,230)PI.PlaceholderText="Passwort..."PI.Text=""PI.Font=Enum.Font.SourceSansSemibold PI.TextSize=14 PI.Parent=PF
Instance.new("UICorner",PI).CornerRadius=UDim.new(0,10)
local PB=Instance.new("TextButton")PB.Size=UDim2.new(1,-30,0,26)PB.Position=UDim2.new(0,15,0,98)PB.BackgroundColor3=Color3.fromRGB(255,50,150)PB.BackgroundTransparency=0.08 PB.TextColor3=Color3.fromRGB(255,255,255)PB.Text="Freischalten"PB.Font=Enum.Font.SourceSansBold PB.TextSize=13 PB.Parent=PF
Instance.new("UICorner",PB).CornerRadius=UDim.new(0,10)
local function Try()if PI.Text==PASSWORD then Authorized=true PG:Destroy()Load()else PI.Text=""PI.PlaceholderText="Falsch!"task.wait(0.8)PI.PlaceholderText="Passwort..."end end
PB.MouseButton1Click:Connect(Try)PI.FocusLost:Connect(function(ep)if ep then Try()end end)

function Load()
    local GUI=Instance.new("ScreenGui")GUI.Name="M"GUI.Parent=CoreGui GUI.ResetOnSpawn=false
    local M=Instance.new("Frame")M.Size=UDim2.new(0,220,0,330)M.Position=UDim2.new(0.01,0,0.08,0)M.BackgroundColor3=Color3.fromRGB(14,14,22)M.BackgroundTransparency=0.08 M.BorderSizePixel=0 M.Active=true M.Draggable=true M.Parent=GUI
    Instance.new("UICorner",M).CornerRadius=UDim.new(0,14)
    local GL=Instance.new("Frame")GL.Size=UDim2.new(1,2,1,2)GL.Position=UDim2.new(0,-1,0,-1)GL.BackgroundColor3=Color3.fromRGB(255,60,160)GL.BackgroundTransparency=0.5 GL.BorderSizePixel=0 GL.Parent=M
    Instance.new("UICorner",GL).CornerRadius=UDim.new(0,14)
    task.spawn(function()local a=0 while GUI and GUI.Parent do a=(a+0.02)%(math.pi*2)pcall(function()GL.BackgroundTransparency=0.52-math.sin(a)*0.25 end)task.wait(0.05)end end)
    
    local Mini=Instance.new("Frame")Mini.Size=UDim2.new(0,150,0,26)Mini.Position=UDim2.new(0.01,0,0.08,0)Mini.BackgroundColor3=Color3.fromRGB(14,14,22)Mini.BackgroundTransparency=0.08 Mini.BorderSizePixel=0 Mini.Visible=false Mini.Active=true Mini.Draggable=true Mini.Parent=GUI
    Instance.new("UICorner",Mini).CornerRadius=UDim.new(0,10)
    local MT=Instance.new("TextLabel")MT.Size=UDim2.new(1,0,1,0)MT.BackgroundTransparency=1 MT.TextColor3=Color3.fromRGB(255,160,200)MT.Text="v3.2 | plalettescripts"MT.Font=Enum.Font.SourceSansBold MT.TextSize=11 MT.Parent=Mini
    
    UserInputService.InputBegan:Connect(function(i,p)if p then return end if i.KeyCode==Enum.KeyCode.LeftControl or i.KeyCode==Enum.KeyCode.RightControl then M.Visible=not M.Visible Mini.Visible=not Mini.Visible end end)
    
    local H=Instance.new("Frame")H.Size=UDim2.new(1,0,0,34)H.BackgroundColor3=Color3.fromRGB(18,18,28)H.BackgroundTransparency=0.05 H.BorderSizePixel=0 H.Parent=M
    Instance.new("UICorner",H).CornerRadius=UDim.new(0,14)
    local HT=Instance.new("TextLabel")HT.Size=UDim2.new(0.6,0,0.5,0)HT.Position=UDim2.new(0.05,0,0,3)HT.BackgroundTransparency=1 HT.TextColor3=Color3.fromRGB(255,160,210)HT.Text="Pistol Arena v3.2"HT.Font=Enum.Font.SourceSansBold HT.TextSize=15 HT.TextXAlignment=Enum.TextXAlignment.Left HT.Parent=H
    local HS=Instance.new("TextLabel")HS.Size=UDim2.new(0.6,0,0.4,0)HS.Position=UDim2.new(0.05,0,0.55,0)HS.BackgroundTransparency=1 HS.TextColor3=Color3.fromRGB(170,120,155)HS.Text="plalettescripts"HS.Font=Enum.Font.SourceSans HS.TextSize=9 HS.TextXAlignment=Enum.TextXAlignment.Left HS.Parent=H
    local CB=Instance.new("TextButton")CB.Size=UDim2.new(0,20,0,18)CB.Position=UDim2.new(1,-24,0,8)CB.BackgroundColor3=Color3.fromRGB(200,30,60)CB.BackgroundTransparency=0.12 CB.TextColor3=Color3.fromRGB(255,255,255)CB.Text="X"CB.Font=Enum.Font.SourceSansBold CB.TextSize=12 CB.Parent=H
    Instance.new("UICorner",CB).CornerRadius=UDim.new(0,6)CB.MouseButton1Click:Connect(function()ClearESP()for _,c in pairs(CONN)do pcall(function()c:Disconnect()end)end GUI:Destroy()end)
    
    local S=Instance.new("ScrollingFrame")S.Size=UDim2.new(1,-6,1,-38)S.Position=UDim2.new(0,3,0,36)S.BackgroundColor3=Color3.fromRGB(18,18,26)S.BackgroundTransparency=0.15 S.BorderSizePixel=0 S.ScrollBarThickness=2 S.ScrollBarImageColor3=Color3.fromRGB(255,80,160)S.CanvasSize=UDim2.new(0,0,0,700)S.Parent=M
    local SL=Instance.new("UIListLayout")SL.Padding=UDim.new(0,4)SL.FillDirection=Enum.FillDirection.Vertical SL.SortOrder=Enum.SortOrder.LayoutOrder SL.Parent=S
    
    -- Divider
    local function Div(t)
        local f=Instance.new("Frame")f.Size=UDim2.new(1,0,0,16)f.BackgroundTransparency=1 f.Parent=S
        local l=Instance.new("TextLabel")l.Size=UDim2.new(1,0,1,0)l.Position=UDim2.new(0,2,0,0)l.BackgroundTransparency=1 l.TextColor3=Color3.fromRGB(255,130,180)l.Text="▸ "..t l.Font=Enum.Font.SourceSansBold l.TextSize=11 l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=f
    end
    
    -- Toggle
    local function Tog(name,key)
        local f=Instance.new("Frame")f.Size=UDim2.new(1,0,0,28)f.BackgroundColor3=Color3.fromRGB(24,24,34)f.BackgroundTransparency=0.2 f.Parent=S
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)
        local l=Instance.new("TextLabel")l.Size=UDim2.new(0.55,0,1,0)l.Position=UDim2.new(0.06,0,0,0)l.BackgroundTransparency=1 l.TextColor3=Color3.fromRGB(210,200,225)l.Text=name l.Font=Enum.Font.SourceSansMedium l.TextSize=12 l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=f
        local b=Instance.new("TextButton")b.Size=UDim2.new(0,30,0,16)b.Position=UDim2.new(1,-38,0,6)b.BackgroundColor3=Color3.fromRGB(50,45,60)b.Text=""b.Parent=f
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
        local on=false
        b.MouseButton1Click:Connect(function()
            on=not on Config[key]=on
            b.BackgroundColor3=on and Color3.fromRGB(255,60,160)or Color3.fromRGB(50,45,60)
            l.Text=name..": "..(on and"ON"or"OFF")
        end)
    end
    
    -- Slider
    local function Sli(name,key,min,max,def)
        Config[key]=def
        local f=Instance.new("Frame")f.Size=UDim2.new(1,0,0,40)f.BackgroundColor3=Color3.fromRGB(24,24,34)f.BackgroundTransparency=0.2 f.Parent=S
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)
        local l=Instance.new("TextLabel")l.Size=UDim2.new(0.45,0,0,16)l.Position=UDim2.new(0.06,0,0,3)l.BackgroundTransparency=1 l.TextColor3=Color3.fromRGB(210,200,225)l.Text=name l.Font=Enum.Font.SourceSansMedium l.TextSize=12 l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=f
        local vl=Instance.new("TextLabel")vl.Size=UDim2.new(0,40,0,16)vl.Position=UDim2.new(1,-48,0,3)vl.BackgroundTransparency=1 vl.TextColor3=Color3.fromRGB(255,180,210)vl.Text=tostring(def)vl.Font=Enum.Font.SourceSansBold vl.TextSize=11 vl.TextXAlignment=Enum.TextXAlignment.Right vl.Parent=f
        local inp=Instance.new("TextBox")inp.Size=UDim2.new(0.35,0,0,18)inp.Position=UDim2.new(0.3,0,0,20)inp.BackgroundColor3=Color3.fromRGB(35,30,45)inp.BackgroundTransparency=0.2 inp.TextColor3=Color3.fromRGB(255,200,230)inp.Text=tostring(def)inp.Font=Enum.Font.SourceSans inp.TextSize=10 inp.Parent=f
        Instance.new("UICorner",inp).CornerRadius=UDim.new(0,6)
        inp.FocusLost:Connect(function()local v=tonumber(inp.Text)if v and v>=min and v<=max then Config[key]=v vl.Text=tostring(v)else inp.Text=tostring(Config[key])end end)
    end
    
    -- BUILD MENU
    Div("FOV Aimbot")
    Tog("Aimbot","Aimbot")
    Sli("FOV Radius","AimRadius",30,300,120)
    Sli("Thickness","AimThick",0.5,4,1.5)
    Tog("Filled","AimFilled")
    Tog("Silent Aim","SilentAim")
    
    Div("Weapon")
    Tog("Triggerbot","Triggerbot")
    Tog("Hitbox Expander","Hitbox")
    Sli("Hitbox Size","HitboxSize",1,8,3)
    
    Div("ESP")
    Tog("Player ESP","ESP")
    Tog("Boxes","ESPBox")
    Tog("Names","ESPName")
    Tog("Distance","ESPDist")
    Tog("Tracers","Tracers")
    Tog("Radar","Radar")
    
    Div("Movement")
    Tog("Speed Hack","SpeedHack")
    Sli("Walk Speed","SpeedValue",16,28,24)
    Tog("Fly","Fly")
    Sli("Fly Speed","FlySpeed",15,35,25)
    
    Div("World")
    Tog("Fullbright","Fullbright")
    Tog("Anti-AFK","AntiAFK")
    
    local Foot=Instance.new("TextLabel")Foot.Size=UDim2.new(1,0,0,14)Foot.BackgroundTransparency=1 Foot.TextColor3=Color3.fromRGB(140,110,140)Foot.Text="v3.2 | plalettescripts"Foot.Font=Enum.Font.SourceSans Foot.TextSize=9 Foot.Parent=S
    
    -- FEATURES
    task.spawn(function()while task.wait(0.03)do if Config.Aimbot then if not FOVC then FOVC=Drawing.new("Circle")end FOVC.Visible=true FOVC.Radius=Config.AimRadius FOVC.Thickness=Config.AimThick FOVC.Color=Color3.fromRGB(255,60,160)FOVC.Filled=Config.AimFilled FOVC.Position=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)else if FOVC then FOVC.Visible=false end end end end)
    task.spawn(function()while task.wait()do if Config.Aimbot and not Config.SilentAim then pcall(function()local t=GetTarget()if t and t.Character and t.Character:FindFirstChild("Head")then Camera.CFrame=CFrame.new(Camera.CFrame.Position,t.Character.Head.Position)end end)end end end)
    
    local old=hookmetamethod(game,"__namecall",function(s,...)local m=getnamecallmethod()local a={...}if m=="FireServer"and Config.SilentAim and Config.Aimbot then local t=GetTarget()if t and t.Character and t.Character:FindFirstChild("Head")and a[1]then a[1]=t.Character.Head.Position end end return old(s,unpack(a))end)
    
    task.spawn(function()while task.wait(0.05)do if Config.Triggerbot and LocalPlayer.Character then pcall(function()local tool=LocalPlayer.Character:FindFirstChildOfClass("Tool")if tool then local t=GetTarget()if t and t.Character and t.Character:FindFirstChild("Head")then if tool:FindFirstChild("Shoot")then tool.Shoot:FireServer(t.Character.Head.Position)end end end end)end end end)
    task.spawn(function()while task.wait(0.25)do if Config.Hitbox then for _,p in ipairs(Players:GetPlayers())do if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart")then p.Character.HumanoidRootPart.Size=Vector3.new(Config.HitboxSize,Config.HitboxSize,Config.HitboxSize)p.Character.HumanoidRootPart.Transparency=0.35 end end end end end)
    
    -- ESP
    task.spawn(function()while task.wait(0.05)do ClearESP()
        if Config.ESP then for _,p in ipairs(Players:GetPlayers())do if p~=LocalPlayer and p.Character then local hd=p.Character:FindFirstChild("Head")local hr=p.Character:FindFirstChild("HumanoidRootPart")if hd and hr then local hp,on=Camera:WorldToViewportPoint(hd.Position+Vector3.new(0,0.5,0))local fp=Camera:WorldToViewportPoint(hr.Position-Vector3.new(0,3,0))if on then local h=math.abs(hp.Y-fp.Y)local w=h/2
            if Config.ESPBox then local bx=Drawing.new("Square")bx.Color=Color3.fromRGB(255,80,180)bx.Thickness=1.2 bx.Size=Vector2.new(w,h)bx.Position=Vector2.new(hp.X-w/2,hp.Y)bx.Filled=false bx.Visible=true table.insert(ESPD,bx)end
            if Config.ESPName then local nm=Drawing.new("Text")nm.Text=p.Name nm.Color=Color3.fromRGB(255,220,240)nm.Size=12 nm.Position=Vector2.new(hp.X,hp.Y-18)nm.Center=true nm.Visible=true table.insert(ESPD,nm)end
            if Config.ESPDist and LocalPlayer.Character then local mh=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if mh then local dt=Drawing.new("Text")dt.Text=math.floor((hr.Position-mh.Position).Magnitude).."m"dt.Color=Color3.fromRGB(200,180,200)dt.Size=10 dt.Position=Vector2.new(hp.X,hp.Y-4)dt.Center=true dt.Visible=true table.insert(ESPD,dt)end end
        end end end end end
        if Config.Tracers then for _,p in ipairs(Players:GetPlayers())do if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart")then local pos,on=Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)if on then local ln=Drawing.new("Line")ln.Color=Color3.fromRGB(255,120,200)ln.Thickness=0.5 ln.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y)ln.To=Vector2.new(pos.X,pos.Y)ln.Visible=true table.insert(ESPD,ln)end end end end
        if Config.Radar then local rs=55 local rx=Camera.ViewportSize.X-rs-6 local ry=Camera.ViewportSize.Y-rs-6 local bg=Drawing.new("Square")bg.Color=Color3.fromRGB(0,0,0)bg.Size=Vector2.new(rs,rs)bg.Position=Vector2.new(rx,ry)bg.Filled=true bg.Visible=true table.insert(ESPD,bg)if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")then local my=LocalPlayer.Character.HumanoidRootPart for _,pl in ipairs(Players:GetPlayers())do if pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")then local tp=pl.Character.HumanoidRootPart local off=tp.Position-my.Position local rd=math.clamp(off.Magnitude/3,0,rs/2-2)local a=math.atan2(off.Z,off.X)local d=Drawing.new("Circle")d.Color=pl==LocalPlayer and Color3.fromRGB(0,255,0)or Color3.fromRGB(255,80,180)d.Radius=2 d.Position=Vector2.new(rx+rs/2+math.cos(a)*rd,ry+rs/2+math.sin(a)*rd)d.Filled=true d.Visible=true table.insert(ESPD,d)end end end end end
    end end)
    
    RunService.Stepped:Connect(function()if Config.SpeedHack and LocalPlayer.Character then local h=LocalPlayer.Character:FindFirstChildOfClass("Humanoid")if h then h.WalkSpeed=math.min(Config.SpeedValue,28)end end end)
    
    task.spawn(function()while task.wait()do if Config.Fly and LocalPlayer.Character then local hrp=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if hrp then local g=hrp:FindFirstChild("FG")or Instance.new("BodyGyro",hrp)local v=hrp:FindFirstChild("FV")or Instance.new("BodyVelocity",hrp)g.Name="FG"g.MaxTorque=Vector3.new(9e9,9e9,9e9)g.CFrame=Camera.CFrame v.Name="FV"v.MaxForce=Vector3.new(9e9,9e9,9e9)local s=math.min(Config.FlySpeed or 25,35)local m=Vector3.zero if UserInputService:IsKeyDown(Enum.KeyCode.W)then m+=Camera.CFrame.LookVector end if UserInputService:IsKeyDown(Enum.KeyCode.S)then m-=Camera.CFrame.LookVector end if UserInputService:IsKeyDown(Enum.KeyCode.A)then m-=Camera.CFrame.RightVector end if UserInputService:IsKeyDown(Enum.KeyCode.D)then m+=Camera.CFrame.RightVector end if UserInputService:IsKeyDown(Enum.KeyCode.Space)then m+=Vector3.new(0,1,0)end if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)then m-=Vector3.new(0,1,0)end v.Velocity=m*s end end end end)
    
    task.spawn(function()while task.wait(60)do if Config.Fullbright then Lighting.Brightness=2 Lighting.ClockTime=14 end if Config.AntiAFK then pcall(function()game:GetService("VirtualInputManager"):SendKeyEvent(true,Enum.KeyCode.Space,false,nil)task.wait(0.1)game:GetService("VirtualInputManager"):SendKeyEvent(false,Enum.KeyCode.Space,false,nil)end)end end end)
    
    print("Pistol Arena v3.2 loaded")
end
