local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Anime Idle Simulator Script - Sakai#7392", "GrapeTheme")

local Tab = Window:NewTab("AutoFarm")
local Tab2 = Window:NewTab("Upgrade / Skill")
local Tab3 = Window:NewTab("Claim")
local Tab4 = Window:NewTab("Chest")
local Tab5 = Window:NewTab("About")

local Section = Tab:NewSection("")
local Section15 = Tab:NewSection("")
local Section2 = Tab2:NewSection("Select Upgrades")
local Section25 = Tab2:NewSection("Select Skills")

local Section3 = Tab3:NewSection("")

local Section4 = Tab4:NewSection("")

local Section5 = Tab5:NewSection("")

-- Variables
local Players = game:GetService("Players")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char.HumanoidRootPart

local current_plot
local nextlvl
local unitcost
local yen

local choosed_ally
local choosed_howmuch = 1
local choosed_howmuch2 = 1
local choosed_cd
local choosed_chest

-- Tables
local Allies = {[1] = "Narudo",[2] = "Sosuke",[3] = "Minaro",[4] = "Kakashy",[5] = "Ruffy",[6] = "Zaro",[7] = "Sangi",[8] = "Shonks",[9] = "Roku",[10] = "Vegeto",[11] = "Picolo",[12] = "Beeros",[13] = "Tanjiro",[14] = "Nozuko",[15] = "Zenitso",[16] = "Rengoko",[17] = "Reku",[18] = "Todoroko",[19] = "No Gravity",[20] = "Bakago",[21] = "Gan",[22] = "Kirua",[23] = "Gonos",[24] = "John"}
local suffixes = {"K", "M", "B", "T", "Q"}
local Chests = {}
for i,v in pairs(game:GetService("ReplicatedStorage")["_GAME"]["_DATA"].Chests.Chests:GetChildren()) do
    table.insert(Chests, tostring(v.Name))
end

-- Functions
local function GetCurrentPlot()
    for i,v in pairs(game:GetService("Workspace").Game.PlayerIslands:GetChildren()) do
        if v:IsA("Folder") and v.Name == lp.Name then
            return v
        end
    end
end
current_plot = GetCurrentPlot()

local function IndexUnit(ally)
    for index, unit in Allies do
        if ally == unit then
            return index
        end
    end
end

local function Convert(s)
	local n, suffix = string.match(s, "(.*)(%a)$")
	if n and suffix then
		local i = table.find(suffixes, suffix) or 0
		return tonumber(n) * math.pow(10, i * 3)
	end
	return tonumber(s)
end

local function Swing()
    -- Remote
    local args = {[1] = "Swing"}
    game:GetService("ReplicatedStorage"):WaitForChild("_GAME"):WaitForChild("_MODULES"):WaitForChild("Utilities"):WaitForChild("NetworkUtility"):WaitForChild("Functions"):WaitForChild("Weapon"):InvokeServer(unpack(args)) 
end

local function NextLevel()
    if current_plot.Buttons:FindFirstChild("NextLevel")["Meshes/Circle"].Transparency ~= 1 then
        nextlvl = true
		local partlevel = current_plot.Buttons.NextLevel["Meshes/Circle"]
        hrp.CFrame = partlevel.CFrame + Vector3.new(-4, 1, 0)
		char:FindFirstChildOfClass("Humanoid"):MoveTo(partlevel.Position)
    else
        nextlvl = false
    end
end

local function Hire()
    unitcost = lp.PlayerGui.Hire.Holder.MainFrame.Unit1.YenAmount.Text
    yen = lp.PlayerData.Stats.Yen.Value
    
    if tonumber(yen) >= Convert(unitcost) then
        -- Remote
        local args = {[1] = "Hire"}
	    game:GetService("ReplicatedStorage"):WaitForChild("_GAME"):WaitForChild("_MODULES"):WaitForChild("Utilities"):WaitForChild("NetworkUtility"):WaitForChild("Events"):WaitForChild("Allies"):FireServer(unpack(args))
    end
end

local function UpgradeAll()
    for index in Allies do
        local args = {[1] = "Upgrade",[2] = index,[3] = choosed_howmuch2}
        game:GetService("ReplicatedStorage"):WaitForChild("_GAME"):WaitForChild("_MODULES"):WaitForChild("Utilities"):WaitForChild("NetworkUtility"):WaitForChild("Events"):WaitForChild("Allies"):FireServer(unpack(args))
    end
end

local function Upgrade(id, amount)
	local args = {[1] = "Upgrade",[2] = id,[3] = amount}
	game:GetService("ReplicatedStorage"):WaitForChild("_GAME"):WaitForChild("_MODULES"):WaitForChild("Utilities"):WaitForChild("NetworkUtility"):WaitForChild("Events"):WaitForChild("Allies"):FireServer(unpack(args))
end

-- Main

Section:NewToggle("Auto Mob", "Attack the vilain monster", function(state)
    if state then
        getgenv().AutoMob = state
        while AutoMob and task.wait() do
            if not nextlvl then
                for i,v in pairs(game:GetService("Workspace").Game.Hits:GetDescendants()) do
                    if v:IsA("Part") and v.Name == "hitbox" then
                        hrp.CFrame = v.CFrame
                    end
                end
            end
        end
    else
        getgenv().AutoMob = state
        for i = 1, 10 do
            hrp.CFrame = current_plot.Spawns.MobTargetPosition.CFrame
            task.wait()
        end
    end
end)

Section:NewToggle("Auto Swing", "Auto Swing", function(state)
    if state then
        getgenv().AutoSwing = state
        while AutoSwing and task.wait() do
            Swing()
        end
    else
        getgenv().AutoSwing = state
    end
end)

Section:NewToggle("Auto Hire", "Auto Hire", function(state)
    if state then
        if not lp.PlayerGui.Hire.Holder.MainFrame.SkipFrame.Toggle:FindFirstChild("Icon").Visible then
            local args = {[1] = "CanSkipHireScene"}
            game:GetService("ReplicatedStorage")._GAME._MODULES.Utilities.NetworkUtility.Events.UpdateSettings:FireServer(unpack(args))
        end
        
        if lp.PlayerGui.Feedback:FindFirstChild("Verification") then
            lp.PlayerGui.Feedback.Verification:Destroy()
        end
        getgenv().Hire = state
        task.spawn(function()
            while task.wait() do
                if getgenv().Hire then
                    Hire()
                    task.wait(.75)
                end
            end
        end)
    else
        getgenv().Hire = state
    end
end)

Section:NewToggle("Auto Use Skills", "Auto Use Skills", function(state)
    if state then
        getgenv().AUS = state
        task.spawn(function()
            while AUS do
                for i,v in pairs(game:GetService("ReplicatedStorage")["_GAME"]["_DATA"].Skills.Skills:GetChildren()) do
                    local args = {[1] = "Use",[2] = tostring(v.Name)}
                    game:GetService("ReplicatedStorage")._GAME._MODULES.Utilities.NetworkUtility.Events.Skills:FireServer(unpack(args))
                end
                task.wait(3)
            end
        end)
    else
        getgenv().AUS = state
    end
end)

Section:NewToggle("Auto Reincarnate", "Auto Next Level", function(state)
    if state then
        getgenv().AutoRE = state
        task.spawn(function()
            while AutoRE do
                game:GetService("ReplicatedStorage"):WaitForChild("_GAME"):WaitForChild("_MODULES"):WaitForChild("Utilities"):WaitForChild("NetworkUtility"):WaitForChild("Events"):WaitForChild("Reincarnate"):FireServer()
                task.wait(5)
            end
        end)
    else
        getgenv().AutoRE = state
    end
end)

Section:NewToggle("Auto Next Level", "Auto Next Level", function(state)
    if state then
        getgenv().AutoNL = state
        task.spawn(function()
            while AutoNL do
                NextLevel()
                task.wait(.1)
            end
        end)
    else
        getgenv().AutoNL = state
    end
end)

Section15:NewDropdown("How much?", "I hope you like the script", {"1", "10", "25", "100"}, function(currentOption)
    choosed_howmuch2 = tonumber(currentOption)
end)

Section15:NewToggle("Auto Upgrade All", "Auto Upgrade All", function(state)
    if state then
        if lp.PlayerGui.Feedback:FindFirstChild("Verification") then
            lp.PlayerGui.Feedback.Verification:Destroy()
        end
        getgenv().AUA = state
        task.spawn(function()
            while AUA do
                UpgradeAll()
                task.wait(.5)
            end
        end)
    else
        getgenv().AUA = state
    end
end)

Section2:NewDropdown("Which Unit?", "hi", {unpack(Allies)}, function(currentOption)
    choosed_ally = IndexUnit(currentOption)
end)

Section2:NewDropdown("How much?", "I hope you like the script", {"1", "10", "25", "100"}, function(currentOption)
    choosed_howmuch = tonumber(currentOption)
end)


Section2:NewSlider("Cooldown ( /s )", "hi x2", 10, 0.1, function(s)
    choosed_cd = s
end)

Section2:NewToggle("Auto Upgrade Unit", "Choose your unit!!!!!!!!!!!!!", function(state)
    if state then
        if lp.PlayerGui.Feedback:FindFirstChild("Verification") then
            lp.PlayerGui.Feedback.Verification:Destroy()
        end
        getgenv().AutoUnitUpgrade = state
        task.spawn(function()
            while AutoUnitUpgrade and task.wait() do
                Upgrade(choosed_ally, choosed_howmuch)
                task.wait(choosed_cd)
            end
        end)
    else
        getgenv().AutoUnitUpgrade = state
    end
end)

Section25:NewToggle("Auto Six Paths Mode", "pro", function(state)
    if state then
        getgenv().ASPM = state
        task.spawn(function()
            while ASPM do
                local args = {[1] = "Use",[2] = "Six Paths Mode"}
                game:GetService("ReplicatedStorage")._GAME._MODULES.Utilities.NetworkUtility.Events.Skills:FireServer(unpack(args))
                task.wait(3)
            end
        end)
    else
        getgenv().ASPM = state
    end
end)

Section25:NewToggle("Auto Crimson Blade", "pro", function(state)
    if state then
        getgenv().ACB = state
        task.spawn(function()
            while ACB do
                local args = {[1] = "Use",[2] = "Crimson Blade"}
                game:GetService("ReplicatedStorage")._GAME._MODULES.Utilities.NetworkUtility.Events.Skills:FireServer(unpack(args))
                task.wait(3)
            end
        end)
    else
        getgenv().ACB = state
    end
end)

Section25:NewToggle("Auto God of Destruction", "pro", function(state)
    if state then
        getgenv().AGOD = state
        task.spawn(function()
            while AGOD do
                local args = {[1] = "Use",[2] = "God of Destruction"}
                game:GetService("ReplicatedStorage")._GAME._MODULES.Utilities.NetworkUtility.Events.Skills:FireServer(unpack(args))
                task.wait(3)
            end
        end)
    else
        getgenv().AGOD = state
    end
end)

Section25:NewToggle("Auto LightSpeed Slash", "pro", function(state)
    if state then
        getgenv().ALS = state
        task.spawn(function()
            while ALS do
                local args = {[1] = "Use",[2] = "LightSpeed Slash"}
                game:GetService("ReplicatedStorage")._GAME._MODULES.Utilities.NetworkUtility.Events.Skills:FireServer(unpack(args))
                task.wait(3)
            end
        end)
    else
        getgenv().ALS = state
    end
end)

Section25:NewToggle("Auto Skill Release", "pro", function(state)
    if state then
        getgenv().ASR = state
        task.spawn(function()
            while ASR do
                local args = {[1] = "Use",[2] = "Skill Release"}
                game:GetService("ReplicatedStorage")._GAME._MODULES.Utilities.NetworkUtility.Events.Skills:FireServer(unpack(args))
                task.wait(3)
            end
        end)
    else
        getgenv().ASR = state
    end
end)


Section3:NewButton("Get All Gamepasses", "Gamepasses", function()
    for i,v in pairs(lp.Gamepasses:GetChildren()) do
        v.Value = true
    end
end)

Section3:NewButton("Daily Spin", "Spin", function()
    local args = {[1] = "PerformDailySpin"}
    game:GetService("ReplicatedStorage"):WaitForChild("_GAME"):WaitForChild("_MODULES"):WaitForChild("Utilities"):WaitForChild("NetworkUtility"):WaitForChild("Events"):WaitForChild("Rewards"):FireServer(unpack(args))
end)

Section3:NewButton("Claim Playtime", "Claim Playtime", function()
    for i = 1, 10 do
        local args = {[1] = "ClaimPlaytimeReward",[2] = i}
        game:GetService("ReplicatedStorage"):WaitForChild("_GAME"):WaitForChild("_MODULES"):WaitForChild("Utilities"):WaitForChild("NetworkUtility"):WaitForChild("Events"):WaitForChild("Rewards"):FireServer(unpack(args))
        task.wait()
    end
end)

Section3:NewButton("Claim Daily Chest", "Daily Chest", function()
    local args = {[1] = "CollectReward",[2] = "Daily Chest"}
    game:GetService("ReplicatedStorage"):WaitForChild("_GAME"):WaitForChild("_MODULES"):WaitForChild("Utilities"):WaitForChild("NetworkUtility"):WaitForChild("Events"):WaitForChild("UpdateChests"):FireServer(unpack(args))
end)

Section3:NewButton("Redeem Codes", "Codes", function()
    local Codes = {"JOJO", "RELEASE", "ONEPUNCH", "UPDATE3", "NODELAY", "HUNTER", "VOLTRA", "S3CR3T"}
    
    for i, code in Codes do
        local args = {[1] = "EnterCode",[2] = code}
        game:GetService("ReplicatedStorage"):WaitForChild("_GAME"):WaitForChild("_MODULES"):WaitForChild("Utilities"):WaitForChild("NetworkUtility"):WaitForChild("Events"):WaitForChild("UpdateCodes"):FireServer(unpack(args))
        task.wait(.1)
    end
end)

Section4:NewDropdown("Select Chest", "bbbbbbbb", {unpack(Chests)}, function(currentOption)
    choosed_chest = currentOption
end)

Section4:NewButton("Buy Chest", "aaaaa", function()
    local args = {[1] = "Purchase",[2] = choosed_chest}
    game:GetService("ReplicatedStorage")._GAME._MODULES.Utilities.NetworkUtility.Events.Chests:FireServer(unpack(args))
end)

Section5:NewLabel("Thank you for using my script")
Section5:NewLabel("Need help? / You have suggestions?")
Section5:NewLabel("Then join my discord :D ( or add me : crime_187 )")
Section5:NewButton("Copy Discord", "ButtonInfo", function()
    setclipboard("https://discord.gg/vMFWwx5dU3")
end)
