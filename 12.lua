local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- 1. УНИВЕРСАЛЬНЫЙ ПОИСК ПАПКИ (Для инжекта)
local guiParent
pcall(function() guiParent = (gethui and gethui()) or CoreGui end)
if not guiParent then
    guiParent = player:WaitForChild("PlayerGui")
end

local guiName = "SATURNHUB_V3_PURPLE" 
if guiParent:FindFirstChild(guiName) then
    guiParent[guiName]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = guiParent

-- 2. ФИОЛЕТОВО-СИНЯЯ ТЕМА (Saturn Theme)
local Theme = {
    Base = Color3.fromRGB(15, 12, 28),         -- Темный фиолетово-синий фон
    ElementBg = Color3.fromRGB(28, 24, 45),    -- Цвет кнопок
    Accent = Color3.fromRGB(130, 90, 255),     -- Неоновый фиолетовый акцент
    TextMain = Color3.fromRGB(250, 250, 255),
    TextGray = Color3.fromRGB(160, 160, 180),
    Border = Color3.fromRGB(50, 45, 85),
    FontTitle = Enum.Font.GothamBlack,
    FontMain = Enum.Font.GothamMedium,
    CornerRadius = UDim.new(0, 10),
    MainTransparency = 0.25, -- Главное меню прозрачное
    SubTransparency = 0      -- Подменю ПЛОТНОЕ (0 прозрачности)
}

-- 3. КНОПКА ОТКРЫТИЯ (🪐)
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 50, 0, 50)
OpenButton.Position = UDim2.new(0, 20, 0.5, -25) 
OpenButton.BackgroundColor3 = Theme.Base
OpenButton.BackgroundTransparency = 0.2
OpenButton.Text = "🪐"
OpenButton.Font = Theme.FontTitle
OpenButton.TextSize = 28
OpenButton.ZIndex = 10
OpenButton.Parent = ScreenGui
Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(1, 0)
local buttonStroke = Instance.new("UIStroke", OpenButton)
buttonStroke.Color = Theme.Accent
buttonStroke.Thickness = 1.5

-- 4. ГЛАВНЫЙ КОНТЕЙНЕР
local Container = Instance.new("Frame")
Container.Size = UDim2.new(0, 420, 0, 550) -- Увеличил высоту для аватарки
Container.Position = UDim2.new(0.5, -210, 0.5, -275)
Container.BackgroundTransparency = 1
Container.Visible = false
Container.ClipsDescendants = true
Container.Parent = ScreenGui

OpenButton.MouseButton1Click:Connect(function()
    Container.Visible = not Container.Visible
end)

local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Container.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- --- ГЛАВНОЕ ОКНО (Прозрачное) ---
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Theme.Base
MainFrame.BackgroundTransparency = Theme.MainTransparency
MainFrame.ZIndex = 1
MainFrame.Parent = Container
Instance.new("UICorner", MainFrame).CornerRadius = Theme.CornerRadius
local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Theme.Border
mainStroke.Thickness = 1
MakeDraggable(MainFrame)

-- Заголовок
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -40, 0, 40)
TitleLabel.Position = UDim2.new(0, 20, 0, 15)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "SATURN HUB" 
TitleLabel.TextColor3 = Theme.TextMain
TitleLabel.TextSize = 32
TitleLabel.Font = Theme.FontTitle
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center 
TitleLabel.ZIndex = 2
TitleLabel.Parent = MainFrame

-- Подзаголовок
local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -40, 0, 15)
SubTitle.Position = UDim2.new(0, 20, 0, 55)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "ВЫБЕРИТЕ СКРИПТ" 
SubTitle.TextColor3 = Theme.Accent 
SubTitle.TextSize = 12
SubTitle.Font = Theme.FontMain
SubTitle.TextXAlignment = Enum.TextXAlignment.Center 
SubTitle.ZIndex = 2
SubTitle.Parent = MainFrame

-- Ссылка снизу
local BottomLink = Instance.new("TextLabel")
BottomLink.Size = UDim2.new(1, 0, 0, 20)
BottomLink.Position = UDim2.new(0, 0, 1, -100) -- Подняли выше над аватаркой
BottomLink.BackgroundTransparency = 1
BottomLink.Text = "T.ME/SABSCRIPTER" 
BottomLink.TextColor3 = Theme.TextGray 
BottomLink.TextSize = 12
BottomLink.Font = Theme.FontTitle
BottomLink.TextXAlignment = Enum.TextXAlignment.Center 
BottomLink.ZIndex = 2
BottomLink.Parent = MainFrame

-- --- КАРТОЧКА ПРОФИЛЯ ПОЛЬЗОВАТЕЛЯ (В самом низу) ---
local UserCard = Instance.new("Frame")
UserCard.Size = UDim2.new(1, -40, 0, 55)
UserCard.Position = UDim2.new(0, 20, 1, -75)
UserCard.BackgroundColor3 = Theme.ElementBg
UserCard.BackgroundTransparency = 0.2
UserCard.ZIndex = 2
UserCard.Parent = MainFrame
Instance.new("UICorner", UserCard).CornerRadius = Theme.CornerRadius
Instance.new("UIStroke", UserCard).Color = Theme.Border

local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 40, 0, 40)
Avatar.Position = UDim2.new(0, 10, 0, 7)
Avatar.BackgroundColor3 = Theme.Base
Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=48&h=48"
Avatar.ZIndex = 3
Avatar.Parent = UserCard
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

local UserName = Instance.new("TextLabel")
UserName.Size = UDim2.new(1, -70, 0, 20)
UserName.Position = UDim2.new(0, 60, 0, 8)
UserName.BackgroundTransparency = 1
UserName.Text = player.DisplayName or player.Name
UserName.TextColor3 = Theme.TextMain
UserName.Font = Enum.Font.GothamBold
UserName.TextSize = 14
UserName.TextXAlignment = Enum.TextXAlignment.Left
UserName.ZIndex = 3
UserName.Parent = UserCard

local UserRole = Instance.new("TextLabel")
UserRole.Size = UDim2.new(1, -70, 0, 15)
UserRole.Position = UDim2.new(0, 60, 0, 28)
UserRole.BackgroundTransparency = 1
UserRole.Text = "Роль: FREE-USER"
UserRole.TextColor3 = Theme.Accent
UserRole.Font = Theme.FontMain
UserRole.TextSize = 11
UserRole.TextXAlignment = Enum.TextXAlignment.Left
UserRole.ZIndex = 3
UserRole.Parent = UserCard

-- --- СПИСОК СКРИПТОВ ---
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -40, 1, -195) -- Место под ссылку и профиль
ScrollFrame.Position = UDim2.new(0, 20, 0, 85)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 2
ScrollFrame.ScrollBarImageColor3 = Theme.Accent
ScrollFrame.ZIndex = 2
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ScrollFrame

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

-- --- ПОДМЕНЮ (ПЛОТНОЕ, БЕЗ ПРОЗРАЧНОСТИ) ---
local SubMenuFrame = Instance.new("Frame")
SubMenuFrame.Size = UDim2.new(1, 0, 1, 0)
SubMenuFrame.BackgroundColor3 = Theme.Base
SubMenuFrame.BackgroundTransparency = Theme.SubTransparency -- 0 Прозрачности!
SubMenuFrame.Visible = false
SubMenuFrame.ZIndex = 1
SubMenuFrame.Parent = Container
Instance.new("UICorner", SubMenuFrame).CornerRadius = Theme.CornerRadius
Instance.new("UIStroke", SubMenuFrame).Color = Theme.Border
MakeDraggable(SubMenuFrame)

local BackBtn = Instance.new("TextButton")
BackBtn.Size = UDim2.new(0, 30, 0, 30)
BackBtn.Position = UDim2.new(0, 20, 0, 20)
BackBtn.BackgroundColor3 = Theme.ElementBg
BackBtn.Text = "<"
BackBtn.TextColor3 = Theme.TextMain
BackBtn.TextSize = 16
BackBtn.Font = Theme.FontTitle
BackBtn.ZIndex = 2
BackBtn.Parent = SubMenuFrame
Instance.new("UICorner", BackBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", BackBtn).Color = Theme.Border

local SubMenuTitle = Instance.new("TextLabel")
SubMenuTitle.Size = UDim2.new(1, -80, 0, 30)
SubMenuTitle.Position = UDim2.new(0, 60, 0, 20)
SubMenuTitle.BackgroundTransparency = 1
SubMenuTitle.Text = "" -- Пустой по умолчанию, чтобы не было "Label"
SubMenuTitle.TextColor3 = Theme.TextMain
SubMenuTitle.TextSize = 22
SubMenuTitle.Font = Theme.FontTitle
SubMenuTitle.TextXAlignment = Enum.TextXAlignment.Left
SubMenuTitle.ZIndex = 2
SubMenuTitle.Parent = SubMenuFrame

-- Скролл для подменю (чтобы функции не пропадали)
local SubMenuContent = Instance.new("ScrollingFrame")
SubMenuContent.Size = UDim2.new(1, -40, 1, -80)
SubMenuContent.Position = UDim2.new(0, 20, 0, 70)
SubMenuContent.BackgroundTransparency = 1
SubMenuContent.ScrollBarThickness = 2
SubMenuContent.ScrollBarImageColor3 = Theme.Accent
SubMenuContent.ZIndex = 2
SubMenuContent.Parent = SubMenuFrame

local SubUIListLayout = Instance.new("UIListLayout")
SubUIListLayout.Padding = UDim.new(0, 10)
SubUIListLayout.Parent = SubMenuContent

SubUIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SubMenuContent.CanvasSize = UDim2.new(0, 0, 0, SubUIListLayout.AbsoluteContentSize.Y + 10)
end)

BackBtn.MouseButton1Click:Connect(function()
    SubMenuFrame.Visible = false
    MainFrame.Visible = true
end)

-- --- ОКНО АКТИВАЦИИ (Bypass) ---
local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Theme.Base
Overlay.BackgroundTransparency = 0.05
Overlay.ZIndex = 20
Overlay.Visible = false
Overlay.Parent = Container
Instance.new("UICorner", Overlay).CornerRadius = Theme.CornerRadius

local Spinner = Instance.new("ImageLabel")
Spinner.Size = UDim2.new(0, 50, 0, 50)
Spinner.Position = UDim2.new(0.5, -25, 0, 150)
Spinner.BackgroundTransparency = 1
Spinner.Image = "rbxassetid://3602422090"
Spinner.ImageColor3 = Theme.Accent
Spinner.ZIndex = 21
Spinner.Parent = Overlay

local spinTween = TweenService:Create(Spinner, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})

local ActTitle = Instance.new("TextLabel")
ActTitle.Size = UDim2.new(1, 0, 0, 40)
ActTitle.Position = UDim2.new(0, 0, 0, 220)
ActTitle.BackgroundTransparency = 1
ActTitle.Text = "Активация..."
ActTitle.TextColor3 = Theme.Accent
ActTitle.TextSize = 26
ActTitle.Font = Theme.FontTitle
ActTitle.ZIndex = 21
ActTitle.Parent = Overlay

local ActDesc = Instance.new("TextLabel")
ActDesc.Size = UDim2.new(0.9, 0, 0, 60)
ActDesc.Position = UDim2.new(0.05, 0, 0, 260)
ActDesc.BackgroundTransparency = 1
ActDesc.Text = "Обходим античит игры: Займет примерно до 2-ух минут, пожалуйста не выходите из игры."
ActDesc.TextColor3 = Theme.TextGray
ActDesc.TextSize = 14
ActDesc.Font = Theme.FontMain
ActDesc.TextWrapped = true
ActDesc.ZIndex = 21
ActDesc.Parent = Overlay

local ProgressBarBg = Instance.new("Frame")
ProgressBarBg.Size = UDim2.new(0.8, 0, 0, 8)
ProgressBarBg.Position = UDim2.new(0.1, 0, 0, 340)
ProgressBarBg.BackgroundColor3 = Theme.ElementBg
ProgressBarBg.ZIndex = 21
ProgressBarBg.Parent = Overlay
Instance.new("UICorner", ProgressBarBg).CornerRadius = UDim.new(1, 0)

local ProgressBarFill = Instance.new("Frame")
ProgressBarFill.Size = UDim2.new(0, 0, 1, 0)
ProgressBarFill.BackgroundColor3 = Theme.Accent
ProgressBarFill.ZIndex = 22
ProgressBarFill.Parent = ProgressBarBg
Instance.new("UICorner", ProgressBarFill).CornerRadius = UDim.new(1, 0)

local bypassConnection = nil

local function ShowBypass(callback)
    Overlay.Visible = true
    ProgressBarFill.Size = UDim2.new(0, 0, 1, 0)
    spinTween:Play()
    
    local waitTime = math.random(10, 120) 
    
    local fillTween = TweenService:Create(ProgressBarFill, TweenInfo.new(waitTime, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
    fillTween:Play()
    
    if bypassConnection then bypassConnection:Disconnect() end
    bypassConnection = fillTween.Completed:Connect(function()
        Overlay.Visible = false
        spinTween:Pause()
        if callback then callback() end
    end)
end

-- --- ЛОГИКА СОЗДАНИЯ ЭЛЕМЕНТОВ ---
local function ClearSubMenu()
    for _, child in pairs(SubMenuContent:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then child:Destroy() end
    end
end

local function CreateToggle(parent, text)
    local Panel = Instance.new("Frame")
    Panel.Size = UDim2.new(1, 0, 0, 45)
    Panel.BackgroundColor3 = Theme.ElementBg
    Panel.ZIndex = 3
    Panel.Parent = parent
    Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 8)
    local panelStroke = Instance.new("UIStroke", Panel)
    panelStroke.Color = Theme.Border

    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(0, 200, 1, 0)
    Lbl.Position = UDim2.new(0, 15, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = text
    Lbl.TextColor3 = Theme.TextGray
    Lbl.TextSize = 13
    Lbl.Font = Theme.FontMain
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = 4
    Lbl.Parent = Panel

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 44, 0, 24)
    ToggleBtn.Position = UDim2.new(1, -60, 0.5, -12)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 30, 50)
    ToggleBtn.Text = ""
    ToggleBtn.ZIndex = 4
    ToggleBtn.Parent = Panel
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", ToggleBtn).Color = Theme.Border

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 4, 0.5, -8)
    Circle.BackgroundColor3 = Theme.TextGray
    Circle.ZIndex = 5
    Circle.Parent = ToggleBtn
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local toggled = false
    ToggleBtn.MouseButton1Click:Connect(function()
        if not toggled then
            ShowBypass(function()
                toggled = true
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -8), BackgroundColor3 = Theme.TextMain}):Play()
                TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
            end)
        else
            toggled = false
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 4, 0.5, -8), BackgroundColor3 = Theme.TextGray}):Play()
            TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 30, 50)}):Play()
        end
    end)
end

local function CreateSingleButton(parent, text)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = Theme.TextMain
    Btn.Text = text
    Btn.TextColor3 = Theme.Base
    Btn.TextSize = 12
    Btn.Font = Theme.FontTitle
    Btn.ZIndex = 3
    Btn.Parent = parent
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
end

local function CreateDualButtons(parent, text1, text2)
    local ContainerFrame = Instance.new("Frame")
    ContainerFrame.Size = UDim2.new(1, 0, 0, 40)
    ContainerFrame.BackgroundTransparency = 1
    ContainerFrame.ZIndex = 3
    ContainerFrame.Parent = parent

    local Btn1 = Instance.new("TextButton")
    Btn1.Size = UDim2.new(0.48, 0, 1, 0)
    Btn1.BackgroundColor3 = Theme.TextMain
    Btn1.Text = text1
    Btn1.TextColor3 = Theme.Base
    Btn1.TextSize = 12
    Btn1.Font = Theme.FontTitle
    Btn1.ZIndex = 4
    Btn1.Parent = ContainerFrame
    Instance.new("UICorner", Btn1).CornerRadius = UDim.new(0, 8)

    local Btn2 = Instance.new("TextButton")
    Btn2.Size = UDim2.new(0.48, 0, 1, 0)
    Btn2.Position = UDim2.new(0.52, 0, 0, 0)
    Btn2.BackgroundColor3 = Theme.TextMain
    Btn2.Text = text2
    Btn2.TextColor3 = Theme.Base
    Btn2.TextSize = 12
    Btn2.Font = Theme.FontTitle
    Btn2.ZIndex = 4
    Btn2.Parent = ContainerFrame
    Instance.new("UICorner", Btn2).CornerRadius = UDim.new(0, 8)
end

local function CreateSlider(parent, text)
    local Panel = Instance.new("Frame")
    Panel.Size = UDim2.new(1, 0, 0, 60)
    Panel.BackgroundColor3 = Theme.ElementBg
    Panel.ZIndex = 3
    Panel.Parent = parent
    Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 8)
    local panelStroke = Instance.new("UIStroke", Panel)
    panelStroke.Color = Theme.Border

    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(0, 200, 0, 30)
    Lbl.Position = UDim2.new(0, 15, 0, 5)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = text
    Lbl.TextColor3 = Theme.TextGray
    Lbl.TextSize = 13
    Lbl.Font = Theme.FontMain
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = 4
    Lbl.Parent = Panel

    local SliderBg = Instance.new("TextButton")
    SliderBg.Size = UDim2.new(1, -30, 0, 4)
    SliderBg.Position = UDim2.new(0, 15, 0, 40)
    SliderBg.BackgroundColor3 = Color3.fromRGB(35, 30, 50)
    SliderBg.Text = ""
    SliderBg.AutoButtonColor = false
    SliderBg.ZIndex = 4
    SliderBg.Parent = Panel
    Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    SliderFill.BackgroundColor3 = Theme.TextMain
    SliderFill.ZIndex = 5
    SliderFill.Parent = SliderBg
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new(1, -7, 0.5, -7)
    Knob.BackgroundColor3 = Theme.TextMain
    Knob.ZIndex = 6
    Knob.Parent = SliderFill
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
    end
    SliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; updateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
    end)
end

-- --- ДАННЫЕ МЕНЮ И СБОРКА ---
local menuData = {
    ["FREEZE DUEL"] = { {type="toggle", text="ВКЛЮЧИТЬ"} },
    ["FREEZE TRADE"] = { {type="toggle", text="ВКЛЮЧИТЬ"} },
    ["SEMI TP"] = { {type="toggle", text="ВКЛЮЧИТЬ (Bypass)"}, {type="dual_btn", text1="LEFT TP", text2="RIGHT TP"} },
    ["FLASH TP"] = { {type="toggle", text="ВКЛЮЧИТЬ (Bypass)"}, {type="single_btn", text="TP AND INSTANT GRAB"} },
    ["DESYNC"] = { {type="toggle", text="ВКЛЮЧИТЬ"} },
    ["INSTANT STEAL"] = { {type="toggle", text="ВКЛЮЧИТЬ"} },
    ["TP BLOCK"] = { {type="toggle", text="ВКЛЮЧИТЬ"}, {type="toggle", text="БАНИТЬ (ДА/НЕТ)"} },
    ["BEST AUTOGRAB"] = { {type="toggle", text="ВКЛЮЧИТЬ"}, {type="slider", text="СКОРОСТЬ"} }
}

local orderedMenus = {"FREEZE DUEL", "FREEZE TRADE", "SEMI TP", "FLASH TP", "DESYNC", "INSTANT STEAL", "TP BLOCK", "BEST AUTOGRAB"}

for _, name in ipairs(orderedMenus) do
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 48)
    Btn.BackgroundColor3 = Theme.ElementBg
    Btn.BackgroundTransparency = 0.2
    Btn.Text = ""
 Btn.ZIndex = 3
    Btn.Parent = ScrollFrame
    Instance.new("UICorner", Btn).CornerRadius = Theme.CornerRadius
    Instance.new("UIStroke", Btn).Color = Theme.Border

    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(0, 200, 1, 0)
    Lbl.Position = UDim2.new(0, 15, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = name
    Lbl.TextColor3 = Theme.TextMain
    Lbl.TextSize = 13
    Lbl.Font = Theme.FontTitle
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = 4
    Lbl.Parent = Btn

    local OpenText = Instance.new("TextLabel")
    OpenText.Size = UDim2.new(0, 50, 1, 0)
    OpenText.Position = UDim2.new(1, -65, 0, 0)
    OpenText.BackgroundTransparency = 1
    OpenText.Text = "OPEN"
    OpenText.TextColor3 = Theme.Accent
    OpenText.TextSize = 10
    OpenText.Font = Theme.FontTitle
    OpenText.ZIndex = 4
    OpenText.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        SubMenuTitle.Text = name
        ClearSubMenu()
        
        local data = menuData[name]
        if data then
            for _, item in ipairs(data) do
                if item.type == "toggle" then CreateToggle(SubMenuContent, item.text)
                elseif item.type == "single_btn" then CreateSingleButton(SubMenuContent, item.text)
                elseif item.type == "dual_btn" then CreateDualButtons(SubMenuContent, item.text1, item.text2)
                elseif item.type == "slider" then CreateSlider(SubMenuContent, item.text)
                end
            end
        end

        MainFrame.Visible = false
        SubMenuFrame.Visible = true
    end)
end
