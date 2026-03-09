local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("FreezeHubGUI") then
    CoreGui.FreezeHubGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FreezeHubGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Кнопка відкриття/закриття (Синя блискавка)
local ToggleBtnMain = Instance.new("TextButton")
ToggleBtnMain.Size = UDim2.new(0, 50, 0, 50)
ToggleBtnMain.Position = UDim2.new(0, 20, 0.5, -25)
ToggleBtnMain.BackgroundColor3 = Color3.fromRGB(22, 27, 40)
ToggleBtnMain.Text = "⚡"
ToggleBtnMain.TextColor3 = Color3.fromRGB(50, 150, 255)
ToggleBtnMain.TextSize = 28
ToggleBtnMain.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtnMain

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 27, 40)
MainFrame.Visible = false -- Сховано за замовчуванням
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Логіка відкриття/закриття
ToggleBtnMain.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Логіка перетягування (Drag)
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 0, 40)
Title.Position = UDim2.new(0, 20, 0, 20)
Title.BackgroundTransparency = 1
Title.Text = "Freeze Hub"
Title.TextColor3 = Color3.fromRGB(100, 150, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Онлайн статус
local OnlineStatus = Instance.new("Frame")
OnlineStatus.Size = UDim2.new(0, 100, 0, 30)
OnlineStatus.Position = UDim2.new(1, -120, 0, 25)
OnlineStatus.BackgroundColor3 = Color3.fromRGB(35, 42, 58)
OnlineStatus.Parent = MainFrame
Instance.new("UICorner", OnlineStatus).CornerRadius = UDim.new(0, 15)

local Dot = Instance.new("Frame")
Dot.Size = UDim2.new(0, 10, 0, 10)
Dot.Position = UDim2.new(0, 10, 0.5, -5)
Dot.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
Dot.Parent = OnlineStatus
Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

local OnlineText = Instance.new("TextLabel")
OnlineText.Size = UDim2.new(1, -30, 1, 0)
OnlineText.Position = UDim2.new(0, 25, 0, 0)
OnlineText.BackgroundTransparency = 1
OnlineText.Text = "онлайн: ?"
OnlineText.TextColor3 = Color3.fromRGB(200, 200, 200)
OnlineText.TextSize = 14
OnlineText.Font = Enum.Font.GothamMedium
OnlineText.Parent = OnlineStatus

-- Версия
local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(1, 0, 0, 30)
Version.Position = UDim2.new(0, 0, 1, -40)
Version.BackgroundTransparency = 1
Version.Text = "VERSION 2"
Version.TextColor3 = Color3.fromRGB(100, 100, 110)
Version.TextSize = 12
Version.Font = Enum.Font.GothamBold
Version.Parent = MainFrame

-- Окно активации (Overlay)
local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
Overlay.BackgroundTransparency = 0.1
Overlay.ZIndex = 10
Overlay.Visible = false
Overlay.Parent = MainFrame
Instance.new("UICorner", Overlay).CornerRadius = UDim.new(0, 12)

local ActTitle = Instance.new("TextLabel")
ActTitle.Size = UDim2.new(1, 0, 0, 40)
ActTitle.Position = UDim2.new(0, 0, 0, 120)
ActTitle.BackgroundTransparency = 1
ActTitle.Text = "Активация..."
ActTitle.TextColor3 = Color3.fromRGB(100, 150, 255)
ActTitle.TextSize = 28
ActTitle.Font = Enum.Font.GothamBold
ActTitle.ZIndex = 11
ActTitle.Parent = Overlay

local ActDesc = Instance.new("TextLabel")
ActDesc.Size = UDim2.new(0.9, 0, 0, 60)
ActDesc.Position = UDim2.new(0.05, 0, 0, 170)
ActDesc.BackgroundTransparency = 1
ActDesc.Text = "Обходим античит игры: Займет примерно до 2-ух минут, пожалуйста не выходите из игры."
ActDesc.TextColor3 = Color3.fromRGB(220, 220, 220)
ActDesc.TextSize = 16
ActDesc.Font = Enum.Font.Gotham
ActDesc.TextWrapped = true
ActDesc.ZIndex = 11
ActDesc.Parent = Overlay

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 140, 0, 40)
CloseBtn.Position = UDim2.new(0.5, -70, 0, 260)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
CloseBtn.Text = "ЗАКРЫТЬ"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 11
CloseBtn.Parent = Overlay
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 20)

local WarningText = Instance.new("TextLabel")
WarningText.Size = UDim2.new(0.9, 0, 0, 40)
WarningText.Position = UDim2.new(0.05, 0, 1, -80)
WarningText.BackgroundTransparency = 1
WarningText.Text = "ЕСЛИ ВЫ НЕ ДОЖДАЛИСЬ ОБХОДА\nАНТИЧИТА СКРИПТ РАБОТАТЬ НЕ БУДЕТ"
WarningText.TextColor3 = Color3.fromRGB(255, 100, 100)
WarningText.TextSize = 12
WarningText.Font = Enum.Font.GothamBold
WarningText.ZIndex = 11
WarningText.Parent = Overlay

CloseBtn.MouseButton1Click:Connect(function()
    Overlay.Visible = false
end)

-- Функция создания переключателей
local function CreateToggle(yPos, titleText, descText)
    local Panel = Instance.new("Frame")
    Panel.Size = UDim2.new(1, -40, 0, 80)
    Panel.Position = UDim2.new(0, 20, 0, yPos)
    Panel.BackgroundColor3 = Color3.fromRGB(32, 37, 52)
    Panel.Parent = MainFrame
    Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 10)

    local TName = Instance.new("TextLabel")
    TName.Size = UDim2.new(0, 200, 0, 20)
    TName.Position = UDim2.new(0, 20, 0, 20)
    TName.BackgroundTransparency = 1
    TName.Text = titleText
    TName.TextColor3 = Color3.fromRGB(255, 255, 255)
    TName.TextSize = 18
    TName.Font = Enum.Font.GothamBold
    TName.TextXAlignment = Enum.TextXAlignment.Left
    TName.Parent = Panel

    local TDesc = Instance.new("TextLabel")
    TDesc.Size = UDim2.new(0, 200, 0, 20)
    TDesc.Position = UDim2.new(0, 20, 0, 45)
    TDesc.BackgroundTransparency = 1
    TDesc.Text = descText
    TDesc.TextColor3 = Color3.fromRGB(150, 150, 160)
    TDesc.TextSize = 14
    TDesc.Font = Enum.Font.Gotham
    TDesc.TextXAlignment = Enum.TextXAlignment.Left
    TDesc.Parent = Panel

    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(0, 50, 0, 20)
    StatusText.Position = UDim2.new(1, -120, 0.5, -10)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "ВЫКЛ"
    StatusText.TextColor3 = Color3.fromRGB(120, 120, 130)
    StatusText.TextSize = 12
    StatusText.Font = Enum.Font.GothamBold
    StatusText.Parent = Panel

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 50, 0, 26)
    ToggleBtn.Position = UDim2.new(1, -70, 0.5, -13)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 55, 70)
    ToggleBtn.Text = ""
    ToggleBtn.Parent = Panel
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 20, 0, 20)
    Circle.Position = UDim2.new(0, 3, 0.5, -10)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Parent = ToggleBtn
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local toggled = false
    ToggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            StatusText.Text = "ВКЛ"
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -23, 0.5, -10)}):Play()
            TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 150, 255)}):Play()
            Overlay.Visible = true 
        else
            StatusText.Text = "ВЫКЛ"
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -10)}):Play()
            TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 55, 70)}):Play()
        end
    end)
end

CreateToggle(80, "Freeze Duel", "Заморозка дуэли")
CreateToggle(180, "Freeze Trade", "Заморозка обмена")
