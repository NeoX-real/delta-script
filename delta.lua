-- Neo X | Created by Dazai
-- Load OrionLib
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- Create Window
local Window = OrionLib:MakeWindow({
    Name = "Neo X  |  Created by Dazai",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "NeoX",
    IntroEnabled = true,
    IntroText = "Welcome to Neo X"
})

-- Notification Sound
local sound = Instance.new("Sound", game.CoreGui)
sound.SoundId = "rbxassetid://9118828563" -- Cute "Arigato" sound
sound.Volume = 1

OrionLib:MakeNotification({
    Name = "Neo X",
    Content = "Thank you for using my script 💜",
    Image = "rbxassetid://4483345998",
    Time = 3
})
sound:Play()

-- Variables
local noclip = false
local flying = false
local players = {}

-- Player Tab
local PlayerTab = Window:MakeTab({
    Name = "Player Options",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- WalkSpeed
PlayerTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 500,
    Default = 16,
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

-- Noclip
PlayerTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(state)
        noclip = state
        game:GetService('RunService').Stepped:Connect(function()
            if noclip then
                for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
})

-- Fly Speed
local flySpeed = 1

PlayerTab:AddSlider({
    Name = "Fly Speed",
    Min = 1,
    Max = 100,
    Default = 1,
    Callback = function(Value)
        flySpeed = Value
    end
})

-- Fly Toggle
PlayerTab:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(Value)
        flying = Value
        local plr = game.Players.LocalPlayer
        local mouse = plr:GetMouse()
        local char = plr.Character or plr.CharacterAdded:Wait()
        local humanoidRootPart = char:WaitForChild("HumanoidRootPart")
        local bodyGyro = Instance.new("BodyGyro", humanoidRootPart)
        local bodyVelocity = Instance.new("BodyVelocity", humanoidRootPart)
        bodyGyro.P = 9e4
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.CFrame = humanoidRootPart.CFrame
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

        while flying do
            game:GetService("RunService").Heartbeat:Wait()
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
            local direction = Vector3.new()
            if mouse.W then direction = direction + workspace.CurrentCamera.CFrame.LookVector end
            if mouse.S then direction = direction - workspace.CurrentCamera.CFrame.LookVector end
            if mouse.A then direction = direction - workspace.CurrentCamera.CFrame.RightVector end
            if mouse.D then direction = direction + workspace.CurrentCamera.CFrame.RightVector end
            bodyVelocity.Velocity = direction * flySpeed * 10
        end

        bodyGyro:Destroy()
        bodyVelocity:Destroy()
    end
})

-- Trolling Tab
local TrollTab = Window:MakeTab({
    Name = "Trolling Options",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Get Players
local function updatePlayers()
    players = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Name ~= game.Players.LocalPlayer.Name then
            table.insert(players, player.Name)
        end
    end
end

updatePlayers()

-- Player Dropdown
local selectedPlayer = nil

TrollTab:AddDropdown({
    Name = "Select Player",
    Default = "",
    Options = players,
    Callback = function(Value)
        selectedPlayer = game.Players:FindFirstChild(Value)
    end
})

-- Refresh Players
TrollTab:AddButton({
    Name = "Refresh Players",
    Callback = function()
        updatePlayers()
        OrionLib:MakeNotification({
            Name = "Neo X",
            Content = "Player list refreshed!",
            Time = 2
        })
    end
})

-- Sit on Player
TrollTab:AddButton({
    Name = "Sit on Player",
    Callback = function()
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 0)
            end
        end
    end
})

-- Spectate Player
TrollTab:AddButton({
    Name = "Spectate Player",
    Callback = function()
        if selectedPlayer then
            game.Workspace.CurrentCamera.CameraSubject = selectedPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        end
    end
})

-- Fling Player
TrollTab:AddButton({
    Name = "Fling Player",
    Callback = function()
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = selectedPlayer.Character.HumanoidRootPart
            hrp.Velocity = Vector3.new(5000,5000,5000)
        end
    end
})

-- Teleport to Player
TrollTab:AddButton({
    Name = "Teleport to Player",
    Callback = function()
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
            end
        end
    end
})

-- Initialize GUI
OrionLib:Init()
