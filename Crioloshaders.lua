--[[
    CRIOLOSHADERS V12 - "THE MULTIVERSE"
    All-Seeing God Edition
    Otimizado para Mobile (Moto G35 5G)
    Executores: Delta / Fluxus / Arceus X
--]]

local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local lighting = game:GetService("Lighting")
local camera = workspace.CurrentCamera

-- ===== CONFIGURAÇÕES GLOBAIS =====
local settings = {
    theme = "Internal",
    enabled = {
        visuals = {},
        combat = {},
        esp = {},
        movement = {},
        world = {}
    },
    values = {
        aimSmoothness = 0.3,
        reachDistance = 12,
        flySpeed = 50,
        speedMultiplier = 2,
        espColor = Color3.fromRGB(0, 255, 255)
    }
}

-- ===== SISTEMA DE TEMAS (UI STYLES) =====
local themes = {
    Internal = {
        bgColor = Color3.fromRGB(15, 15, 18),
        bgTransparency = 0.1,
        borderColor = Color3.fromRGB(0, 255, 255),
        cornerRadius = 12,
        textColor = Color3.fromRGB(255, 255, 255),
        toggleColor = Color3.fromRGB(0, 200, 255)
    },
    RetroMatrix = {
        bgColor = Color3.fromRGB(0, 0, 0),
        bgTransparency = 0.2,
        borderColor = Color3.fromRGB(0, 255, 0),
        cornerRadius = 0,
        textColor = Color3.fromRGB(0, 255, 0),
        toggleColor = Color3.fromRGB(0, 255, 0)
    },
    Glassmorphism = {
        bgColor = Color3.fromRGB(255, 255, 255),
        bgTransparency = 0.85,
        borderColor = Color3.fromRGB(255, 255, 255),
        cornerRadius = 16,
        textColor = Color3.fromRGB(255, 255, 255),
        toggleColor = Color3.fromRGB(100, 150, 255)
    }
}

-- ===== CRIAR INTERFACE PRINCIPAL =====
local function createUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CrioloShadersV12"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 380, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
    mainFrame.BackgroundColor3 = themes[settings.theme].bgColor
    mainFrame.BackgroundTransparency = themes[settings.theme].bgTransparency
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = themes[settings.theme].borderColor
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, themes[settings.theme].cornerRadius)
    corner.Parent = mainFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "CRIOLOSHADERS V12 | THE MULTIVERSE"
    title.TextColor3 = themes[settings.theme].borderColor
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Sistema de abas
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 40)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainFrame
    
    local tabs = {"VISUAL", "COMBAT", "ESP", "MOVEMENT", "WORLD"}
    local currentTab = 1
    local contentFrames = {}
    
    for i, tabName in ipairs(tabs) do
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0.2, 0, 1, 0)
        tabBtn.Position = UDim2.new((i-1)*0.2, 0, 0, 0)
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text = tabName
        tabBtn.TextColor3 = themes[settings.theme].textColor
        tabBtn.TextScaled = true
        tabBtn.Font = Enum.Font.GothamBold
        tabBtn.Parent = tabContainer
        
        local contentFrame = Instance.new("ScrollingFrame")
        contentFrame.Size = UDim2.new(1, 0, 1, -80)
        contentFrame.Position = UDim2.new(0, 0, 0, 80)
        contentFrame.BackgroundTransparency = 1
        contentFrame.Visible = (i == 1)
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        contentFrame.ScrollBarThickness = 4
        contentFrame.Parent = mainFrame
        contentFrames[i] = contentFrame
        
        tabBtn.MouseButton1Click:Connect(function()
            for j, frame in pairs(contentFrames) do
                frame.Visible = (j == i)
            end
            currentTab = i
        end)
    end
    
    -- Botão fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = themes[settings.theme].borderColor
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = mainFrame
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Função para criar toggles
    local function createToggle(parent, text, callback, yPos)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -20, 0, 40)
        toggleFrame.Position = UDim2.new(0, 10, 0, yPos)
        toggleFrame.BackgroundTransparency = 0.5
        toggleFrame.BackgroundColor3 = themes[settings.theme].bgColor
        toggleFrame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0, 5, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = themes[settings.theme].textColor
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.Parent = toggleFrame
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 50, 0, 30)
        toggleBtn.Position = UDim2.new(1, -60, 0.5, -15)
        toggleBtn.BackgroundColor3 = themes[settings.theme].toggleColor
        toggleBtn.BackgroundTransparency = 0.5
        toggleBtn.Text = "OFF"
        toggleBtn.TextColor3 = themes[settings.theme].textColor
        toggleBtn.TextScaled = true
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.Parent = toggleFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = toggleBtn
        
        local enabled = false
        
        toggleBtn.MouseButton1Click:Connect(function()
            enabled = not enabled
            toggleBtn.BackgroundTransparency = enabled and 0.2 or 0.5
            toggleBtn.Text = enabled and "ON" or "OFF"
            callback(enabled)
        end)
        
        return toggleFrame
    end
    
    -- ABA 01: VISUAL (Shaders & Atmosfera)
    local visualFrame = contentFrames[1]
    local visualY = 10
    
    createToggle(visualFrame, "Ray Tracing (Sombras Dinâmicas)", function(state)
        if state then
            lighting.ShadowSoftness = 0.5
            lighting.Technology = Enum.Technology.Future
        else
            lighting.ShadowSoftness = 0
            lighting.Technology = Enum.Technology.Legacy
        end
    end, visualY)
    visualY = visualY + 45
    
    createToggle(visualFrame, "Global Illumination", function(state)
        if state then
            lighting.Ambient = Color3.fromRGB(100, 100, 120)
            lighting.OutdoorAmbient = Color3.fromRGB(80, 85, 100)
        else
            lighting.Ambient = Color3.fromRGB(0, 0, 0)
            lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
        end
    end, visualY)
    visualY = visualY + 45
    
    createToggle(visualFrame, "Volumetric Fog", function(state)
        if state then
            lighting.FogEnd = 500
            lighting.FogStart = 50
        else
            lighting.FogEnd = 100000
            lighting.FogStart = 0
        end
    end, visualY)
    visualY = visualY + 45
    
    createToggle(visualFrame, "Bloom Effect", function(state)
        if state then
            lighting.Bloom.Intensity = 0.5
            lighting.Bloom.Threshold = 0.8
        else
            lighting.Bloom.Intensity = 0
        end
    end, visualY)
    
    -- ABA 02: COMBAT (Aimbot & KillAura)
    local combatFrame = contentFrames[2]
    local combatY = 10
    
    local aimbotEnabled = false
    local silentAimEnabled = false
    
    createToggle(combatFrame, "Silent Aim", function(state)
        silentAimEnabled = state
    end, combatY)
    combatY = combatY + 45
    
    createToggle(combatFrame, "Aimbot Smooth", function(state)
        aimbotEnabled = state
    end, combatY)
    combatY = combatY + 45
    
    createToggle(combatFrame, "Trigger Bot", function(state)
        settings.enabled.combat.triggerbot = state
    end, combatY)
    combatY = combatY + 45
    
    createToggle(combatFrame, "No Recoil / No Spread", function(state)
        settings.enabled.combat.norecoil = state
    end, combatY)
    
    -- Função Aimbot
    runService.RenderStepped:Connect(function()
        if aimbotEnabled then
            local closestPlayer = nil
            local shortestDistance = math.huge
            
            for _, target in pairs(game:GetService("Players"):GetPlayers()) do
                if target ~= player and target.Character and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 then
                    local targetPos, visible = camera:WorldToScreenPoint(target.Character.Head.Position)
                    if visible then
                        local distance = (Vector2.new(targetPos.X, targetPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            closestPlayer = target
                        end
                    end
                end
            end
            
            if closestPlayer and closestPlayer.Character and closestPlayer.Character.Head then
                local headPos = closestPlayer.Character.Head.Position
                local currentCFrame = camera.CFrame
                local targetCFrame = CFrame.new(currentCFrame.Position, headPos)
                camera.CFrame = camera.CFrame:Lerp(targetCFrame, settings.values.aimSmoothness)
            end
        end
    end)
    
    -- ABA 03: ESP (All-Seeing)
    local espFrame = contentFrames[3]
    local espY = 10
    
    local espEnabled = false
    local espObjects = {}
    
    createToggle(espFrame, "Box ESP", function(state)
        espEnabled = state
        if not state then
            for _, obj in pairs(espObjects) do
                obj:Destroy()
            end
            espObjects = {}
        end
    end, espY)
    espY = espY + 45
    
    createToggle(espFrame, "Skeleton ESP", function(state)
        settings.enabled.esp.skeleton = state
    end, espY)
    espY = espY + 45
    
    createToggle(espFrame, "Health Bar & Distance", function(state)
        settings.enabled.esp.healthbar = state
    end, espY)
    
    -- Sistema ESP
    runService.RenderStepped:Connect(function()
        if espEnabled then
            for _, target in pairs(game:GetService("Players"):GetPlayers()) do
                if target ~= player and target.Character and target.Character:FindFirstChild("Humanoid") then
                    local rootPart = target.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local vector, onScreen = camera:WorldToScreenPoint(rootPart.Position)
                        if onScreen then
                            local espBox = Instance.new("Frame")
                            espBox.Size = UDim2.new(0, 100, 0, 200)
                            espBox.Position = UDim2.new(0, vector.X - 50, 0, vector.Y - 100)
                            espBox.BackgroundTransparency = 0.6
                            espBox.BackgroundColor3 = settings.values.espColor
                            espBox.BorderSizePixel = 2
                            espBox.BorderColor3 = Color3.fromRGB(255, 255, 255)
                            espBox.Parent = player.PlayerGui
                            
                            table.insert(espObjects, espBox)
                            
                            game:GetService("Debris"):AddItem(espBox, 0.1)
                        end
                    end
                end
            end
        end
    end)
    
    -- ABA 04: MOVEMENT (Physics Breaker)
    local movementFrame = contentFrames[4]
    local movementY = 10
    
    local flyEnabled = false
    local flyVelocity = Vector3.new(0, 0, 0)
    
    createToggle(movementFrame, "Fly / Jetpack", function(state)
        flyEnabled = state
        if state then
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.PlatformStand = true
            end
        else
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.PlatformStand = false
            end
        end
    end, movementY)
    movementY = movementY + 45
    
    createToggle(movementFrame, "NoClip", function(state)
        settings.enabled.movement.noclip = state
        if state then
            local char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end, movementY)
    movementY = movementY + 45
    
    createToggle(movementFrame, "SpeedHack", function(state)
        settings.enabled.movement.speedhack = state
    end, movementY)
    movementY = movementY + 45
    
    createToggle(movementFrame, "GodMode", function(state)
        settings.enabled.movement.godmode = state
        if state then
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.MaxHealth = math.huge
                char.Humanoid.Health = math.huge
            end
        end
    end, movementY)
    
    -- Sistema de Fly
    userInputService.InputBegan:Connect(function(input, gameProcessed)
        if flyEnabled and not gameProcessed then
            if input.KeyCode == Enum.KeyCode.W then
                flyVelocity = camera.CFrame.LookVector * settings.values.flySpeed
            elseif input.KeyCode == Enum.KeyCode.S then
                flyVelocity = -camera.CFrame.LookVector * settings.values.flySpeed
            end
        end
    end)
    
    runService.RenderStepped:Connect(function()
        if flyEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Velocity = flyVelocity
        end
        
        if settings.enabled.movement.speedhack and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16 * settings.values.speedMultiplier
        end
    end)
    
    -- ABA 05: WORLD & SYSTEM
    local worldFrame = contentFrames[5]
    local worldY = 10
    
    createToggle(worldFrame, "FullBright", function(state)
        if state then
            lighting.Brightness = 2
            lighting.ClockTime = 12
        else
            lighting.Brightness = 1
        end
    end, worldY)
    worldY = worldY + 45
    
    createToggle(worldFrame, "X-Ray (Transparent Walls)", function(state)
        settings.enabled.world.xray = state
    end, worldY)
    worldY = worldY + 45
    
    -- Monitor de Sistema
    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Size = UDim2.new(0, 150, 0, 30)
    fpsLabel.Position = UDim2.new(1, -160, 0, 10)
    fpsLabel.BackgroundTransparency = 0.7
    fpsLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    fpsLabel.TextScaled = true
    fpsLabel.Font = Enum.Font.Gotham
    fpsLabel.Parent = screenGui
    
    local frameCount = 0
    local lastTime = tick()
    
    runService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local currentTime = tick()
        if currentTime - lastTime >= 1 then
            fpsLabel.Text = string.format("FPS: %d | RAM: %d MB", frameCount, math.floor(collectgarbage("count") / 1000))
            frameCount = 0
            lastTime = currentTime
        end
    end)
    
    return screenGui
end

-- Inicializar UI
createUI()

-- Mensagem de boas-vindas
player.Chatted:Connect(function(message)
    if message:lower() == "!criolo" then
        wait(0.5)
        player:Chat("CRIOLOSHADERS V12 - All-Seeing God Edition Ativado!")
    end
end)

print("CrioloShaders V12 - The Multiverse carregado com sucesso!")
