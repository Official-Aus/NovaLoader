local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ===================== RIVALS =====================
if game.PlaceId == 17625359962 then
    local Window = Rayfield:CreateWindow({
        Name = "Nova Loader ~ Rivals",
        Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
        LoadingTitle = "Nova Loader ~ Rivals",
        LoadingSubtitle = "by Aus",
        ShowText = "Nova", -- for mobile users to unhide rayfield, change if you'd like
        Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

        ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

        DisableRayfieldPrompts = false,
        DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

        Discord = {
            Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
            Invite = "DZQZWa3sut", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
            RememberJoins = true -- Set this to false to make them join the discord every time they load it up
        },

        KeySystem = false, -- Set this to true to use our key system
        KeySettings = {
            Title = "Untitled",
            Subtitle = "Key System",
            Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
            FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
            SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
            GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
            Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
        }
    })

    local ESP = {
        Skeleton = false,
        Tracers = false
    }

    local Drawings = {}

    -- ================== DRAWING HELPERS ==================
    local function NewDraw(type, props)
        local d = Drawing.new(type)
        for i,v in pairs(props) do
            d[i] = v
        end
        return d
    end

    local function RemoveESP(plr)
        if Drawings[plr] then
            for _,obj in pairs(Drawings[plr]) do
                if typeof(obj) == "table" then
                    for _,l in pairs(obj) do l:Remove() end
                else
                    obj:Remove()
                end
            end
            Drawings[plr] = nil
        end
    end

    local function CreateESP(plr)
        Drawings[plr] = {
            Tracer = NewDraw("Line",{Thickness=1,Color=Color3.new(1,1,1)}),
            Skeleton = {}
        }
    end

    -- ================== SKELETON BONES ==================
    local Bones = {
        {"Head","UpperTorso"},
        {"UpperTorso","LowerTorso"},
        {"UpperTorso","LeftUpperArm"},
        {"LeftUpperArm","LeftLowerArm"},
        {"LeftLowerArm","LeftHand"},
        {"UpperTorso","RightUpperArm"},
        {"RightUpperArm","RightLowerArm"},
        {"RightLowerArm","RightHand"},
        {"LowerTorso","LeftUpperLeg"},
        {"LeftUpperLeg","LeftLowerLeg"},
        {"LeftLowerLeg","LeftFoot"},
        {"LowerTorso","RightUpperLeg"},
        {"RightUpperLeg","RightLowerLeg"},
        {"RightLowerLeg","RightFoot"}
    }

    -- ESP functions
    RunService.RenderStepped:Connect(function()
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                if not Drawings[plr] then
                    CreateESP(plr)
                end

                local char = plr.Character
                local hrp = char.HumanoidRootPart
                local hum = char:FindFirstChildOfClass("Humanoid")

                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if not onScreen then
                    RemoveESP(plr)
                    continue
                end

                local scale = 1 / pos.Z
                local size = Vector2.new(2200 * scale, 3000 * scale)
                local boxPos = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)

                -- TRACER
                local tracer = Drawings[plr].Tracer
                tracer.Visible = ESP.Tracers
                tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                tracer.To = Vector2.new(pos.X, pos.Y)

                -- SKELETON
                for _,line in pairs(Drawings[plr].Skeleton) do
                    line:Remove()
                end
                Drawings[plr].Skeleton = {}

                if ESP.Skeleton then
                    for _,bone in pairs(Bones) do
                        local p1 = char:FindFirstChild(bone[1])
                        local p2 = char:FindFirstChild(bone[2])
                        if p1 and p2 then
                            local s1, v1 = Camera:WorldToViewportPoint(p1.Position)
                            local s2, v2 = Camera:WorldToViewportPoint(p2.Position)
                            if v1 and v2 then
                                local l = NewDraw("Line",{
                                    Thickness = 1,
                                    Color = Color3.new(1,1,1),
                                    From = Vector2.new(s1.X,s1.Y),
                                    To = Vector2.new(s2.X,s2.Y)
                                })
                                table.insert(Drawings[plr].Skeleton, l)
                            end
                        end
                    end
                end
            else
                RemoveESP(plr)
            end
        end
    end)

    -- Tabs
    local MainTab = Window:CreateTab("Main", 4483362458)
    local VisualTab = Window:CreateTab("Visuals", 4483362458)
    local OtherTab = Window:CreateTab("Other Menu", 4483362458)
    local SettingsTab = Window:CreateTab("Settings", 4483362458)

    -- Main

    --Visuals
    VisualTab:CreateToggle({Name="Skeleton",CurrentValue=false,Callback=function(v) ESP.Skeleton=v end})
    VisualTab:CreateToggle({Name="Tracers",CurrentValue=false,Callback=function(v) ESP.Tracers=v end})

    --Others
    Other:CreateButton({
        Name="Load Z3US",
        Callback=function()
            loadstring(game:HttpGet(
                "https://raw.githubusercontent.com/blackowl1231/Z3US/refs/heads/main/Games/Z3US%20Rivals%20Beta.lua"
            ))()
        end
    })

    --Settings
end
