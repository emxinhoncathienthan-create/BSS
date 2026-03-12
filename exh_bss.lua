-- LocalScript
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- GUI
local gui = Instance.new("ScreenGui")
gui.DisplayOrder = 999999
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- PANEL
local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(1,0)
frame.Position = UDim2.new(1,0,0,0)
frame.Size = UDim2.new(0,200,1,0)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BorderSizePixel = 0
frame.Parent = gui


-- // Nhận Tổ Gần Nhất \\

local characterhive = player.Character or player.CharacterAdded:Wait()
local hrphive = characterhive:WaitForChild("HumanoidRootPart")

local vimhive = game:GetService("VirtualInputManager")

local button = Instance.new("TextButton")
button.Size = UDim2.new(1,-10,0,30)
button.Position = UDim2.new(0,10,0,0)
button.Text = "Nhận Tổ Gần Nhất"
button.TextSize = 11
button.BackgroundColor3 = Color3.fromRGB(170,0,0)
button.TextColor3 = Color3.new(1,1,1)
button.Parent = frame

local usedhive = false
local savedPositionHive = nil

local function isArrow(part)
    return string.find(part:GetFullName(),"localpatharrow") ~= nil
end

local function searchArrow()

    local origin = hrphive.Position
    local step = 30
    local maxRadius = 2000

    for radius = step, maxRadius, step do

        local parts = workspace:GetPartBoundsInRadius(origin, radius)

        for _,part in ipairs(parts) do
            if part:IsA("BasePart") and isArrow(part) then
                return part
            end
        end

    end

    return nil
end

local function pressE()

    vimhive:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    vimhive:SendKeyEvent(false, Enum.KeyCode.E, false, game)

end

button.MouseButton1Click:Connect(function()

    if usedhive then
        hrphive.CFrame = CFrame.new(savedPositionHive)
    end

    if not usedhive then

        local target = searchArrow()

        if target then

            local top = target.Position + Vector3.new(0, target.Size.Y/2, 0)
            hrphive.CFrame = CFrame.new(top)

            task.wait(0.2)

            pressE()

            savedPositionHive = hrphive.Position

            button.Text = "Đã Nhận Tổ (Nhấn Để Trở Về)"
            button.BackgroundColor3 = Color3.fromRGB(255,69,0)

            usedhive = true

        end

    end

end)

-- \\ Nhận Tổ Gần Nhất //


-- // Tự Động Giữ Chuột \\

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local holding = false

local gui = Instance.new("ScreenGui")
gui.Name = "AutoHoldMouseUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local label = Instance.new("TextLabel")
label.AnchorPoint = Vector2.new(0,1)
label.Position = UDim2.new(0,5,1,-5)
label.Size = UDim2.new(0,260,0,18)
label.BackgroundTransparency = 1
label.TextSize = 12
label.Font = Enum.Font.SourceSans
label.TextXAlignment = Enum.TextXAlignment.Left
label.Parent = gui

local function updateText()
	if holding then
		label.Text = "Tự Động Giữ Chuột Bật"
		label.TextColor3 = Color3.fromRGB(0,255,0)
	else
		label.Text = "Tự Động Giữ Chuột Tắt"
		label.TextColor3 = Color3.fromRGB(255,0,0)
	end
end

updateText()

UIS.InputBegan:Connect(function(input,gameProcessed)

	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then

		holding = not holding

		if not holding then
			VIM:SendMouseButtonEvent(0,0,0,false,game,0)
		end

		updateText()

	end

end)

task.spawn(function()

	while true do
		task.wait(0.2)

		if holding then
			VIM:SendMouseButtonEvent(0,0,0,true,game,0)
		end

	end

end)

-- \\ Tự Động Giữ Chuột //


-- // Giảm Đồ Hoạ \\

local button = Instance.new("TextButton")
button.Size = UDim2.new(1,-10,0,30)
button.Position = UDim2.new(0,10,0,30)
button.Text = "Giảm Đồ Hoạ"
button.TextSize = 11
button.BackgroundColor3 = Color3.fromRGB(170,0,0)
button.TextColor3 = Color3.new(1,1,1)
button.Parent = frame

local enabled = false

local hideFolders = {
	"Leaderboards",
	"Decorations",
	"FieldDecos",
	"HiveDeco",
	"Badge Guild",
	"Gates"
}

local function optimize(obj)

	-- nếu object nằm trong model tên "C" thì bỏ qua
	if obj:FindFirstAncestor("C") then
		return
	end

	-- xoá texture + decal
	if obj:IsA("Texture") or obj:IsA("Decal") then
		obj:Destroy()
	end

	-- xoá particle
	if obj:IsA("ParticleEmitter")
	or obj:IsA("Trail")
	or obj:IsA("Smoke")
	or obj:IsA("Fire")
	or obj:IsA("Sparkles") then
		obj:Destroy()
	end

	-- tắt shadow + giảm material
	if obj:IsA("BasePart") then
		obj.CastShadow = false
		obj.Material = Enum.Material.Plastic
		obj.Reflectance = 0
	end

end

local function isInStumpPath(obj)

	local current = obj

	while current do
		if string.find(current.Name, "Stump") then
			return true
		end
		current = current.Parent
	end

	return false
end

local function hideFolder(folder)

	if not folder then return end

	for _,v in ipairs(folder:GetDescendants()) do

		-- bỏ qua object có đường dẫn chứa "Stump"
		if isInStumpPath(v) then
			continue
		end

		if v:IsA("BasePart") then
			v.Transparency = 1
			v.CanCollide = false
		end

	end

end

local function reduceLighting()

	for _,v in ipairs(Lighting:GetChildren()) do
		v:Destroy()
	end

	Lighting.GlobalShadows = false
	Lighting.Technology = Enum.Technology.Compatibility

end

local function applyLowGraphics()

	reduceLighting()

	for _,v in ipairs(Workspace:GetDescendants()) do
		optimize(v)
	end

	for _,name in ipairs(hideFolders) do
		hideFolder(Workspace:FindFirstChild(name))
	end

end

Workspace.DescendantAdded:Connect(function(obj)

	if enabled then
		optimize(obj)
	end

end)

button.MouseButton1Click:Connect(function()

	if not enabled then
		button.BackgroundColor3 = Color3.fromRGB(0,170,0)
		applyLowGraphics()
        enabled = true
	end

end)

-- \\ Giảm Đồ Hoạ //


-- // Bay \\ 

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(1,-10,0,30)
flyButton.Position = UDim2.new(0,10,0,60)
flyButton.Text = "Bay"
flyButton.TextSize = 11
flyButton.BackgroundColor3 = Color3.fromRGB(170,0,0)
flyButton.TextColor3 = Color3.new(1,1,1)
flyButton.Parent = frame

local RunService = game:GetService("RunService")

local flying = false
local speed = 90

local bv
local bg
local connection

local function startFly(character)

	local humanoid = character:WaitForChild("Humanoid")
	local hrp = character:WaitForChild("HumanoidRootPart")

	humanoid.PlatformStand = true

	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e6,1e6,1e6)
	bv.Velocity = Vector3.zero
	bv.Parent = hrp

	bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(1e6,1e6,1e6)
	bg.P = 10000
	bg.CFrame = hrp.CFrame
	bg.Parent = hrp

	connection = RunService.RenderStepped:Connect(function()

		local cam = workspace.CurrentCamera
		local move = Vector3.zero

		if UIS:IsKeyDown(Enum.KeyCode.W) then
			move += cam.CFrame.LookVector
		end

		if UIS:IsKeyDown(Enum.KeyCode.S) then
			move -= cam.CFrame.LookVector
		end

		if UIS:IsKeyDown(Enum.KeyCode.A) then
			move -= cam.CFrame.RightVector
		end

		if UIS:IsKeyDown(Enum.KeyCode.D) then
			move += cam.CFrame.RightVector
		end

		if UIS:IsKeyDown(Enum.KeyCode.Space) then
			move += Vector3.new(0,1,0)
		end

		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
			move -= Vector3.new(0,1,0)
		end

		if move.Magnitude > 0 then
			bv.Velocity = move.Unit * speed
		else
			bv.Velocity = Vector3.zero
		end

		bg.CFrame = cam.CFrame

	end)

end

local function stopFly(character)

	if connection then
		connection:Disconnect()
		connection = nil
	end

	if bv then
		bv:Destroy()
		bv = nil
	end

	if bg then
		bg:Destroy()
		bg = nil
	end

	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local hrp = character:FindFirstChild("HumanoidRootPart")

		if humanoid then
			humanoid.PlatformStand = false
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

			-- khôi phục di chuyển
			humanoid.WalkSpeed = 25
			humanoid.JumpPower = 60
		end

		if hrp then
			hrp.Velocity = Vector3.zero
			hrp.RotVelocity = Vector3.zero
		end
	end

end

flyButton.MouseButton1Click:Connect(function()

	flying = not flying

	local character = player.Character or player.CharacterAdded:Wait()

	if flying then
		flyButton.BackgroundColor3 = Color3.fromRGB(0,170,0)
		startFly(character)
	else
		flyButton.BackgroundColor3 = Color3.fromRGB(170,0,0)
		stopFly(character)
	end

end)

player.CharacterAdded:Connect(function(character)

	if flying then
		task.wait(0.1)
		startFly(character)
	end

end)

-- \\ Bay //


-- // Xuyên Tường \\

local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(1,-10,0,30)
noclipButton.Position = UDim2.new(0,10,0,90)
noclipButton.Text = "Xuyên Tường"
noclipButton.TextSize = 11
noclipButton.BackgroundColor3 = Color3.fromRGB(170,0,0)
noclipButton.TextColor3 = Color3.new(1,1,1)
noclipButton.Parent = frame

local noclip = false
local noclipLoop

local function startNoclip()

	if noclipLoop then return end

	noclipLoop = task.spawn(function()

		while noclip do

			local char = player.Character
			if char then

				for _,v in ipairs(char:GetDescendants()) do
					if v:IsA("BasePart") then
						v.CanCollide = false
					end
				end

			end

			task.wait(0.2)

		end

	end)

end

local function stopNoclip()

	noclip = false

	local char = player.Character
	if char then
		for _,v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = true
			end
		end
	end

	noclipLoop = nil

end

noclipButton.MouseButton1Click:Connect(function()

	noclip = not noclip

	if noclip then
		noclipButton.BackgroundColor3 = Color3.fromRGB(0,170,0)
		startNoclip()
	else
		noclipButton.BackgroundColor3 = Color3.fromRGB(170,0,0)
		stopNoclip()
	end

end)

player.CharacterAdded:Connect(function()

	task.wait(0.2)

	if noclip then
		startNoclip()
	end

end)

-- \\ Xuyên Tường //


-- // Chạy Nhanh \\

local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(1,-10,0,30)
speedButton.Position = UDim2.new(0,10,0,120)
speedButton.Text = "Chạy Nhanh"
speedButton.TextSize = 11
speedButton.BackgroundColor3 = Color3.fromRGB(170,0,0)
speedButton.TextColor3 = Color3.new(1,1,1)
speedButton.Parent = frame

local fastRun = false
local speedLoop

local function startFastRun()

	if speedLoop then return end

	speedLoop = task.spawn(function()

		while fastRun do

			local char = player.Character
			if char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then
					hum.WalkSpeed = 100
				end
			end

			task.wait(0.2)
		end

	end)

end

local function stopFastRun()

	fastRun = false

	local char = player.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = 40
		end
	end

	speedLoop = nil

end

speedButton.MouseButton1Click:Connect(function()

	fastRun = not fastRun

	if fastRun then
		speedButton.BackgroundColor3 = Color3.fromRGB(0,170,0)
		startFastRun()
	else
		speedButton.BackgroundColor3 = Color3.fromRGB(170,0,0)
		stopFastRun()
	end

end)

-- \\ Chạy Nhanh //


-- // Nhảy Cao \\

local jumpButton = Instance.new("TextButton")
jumpButton.Size = UDim2.new(1,-10,0,30)
jumpButton.Position = UDim2.new(0,10,0,150)
jumpButton.Text = "Nhảy Cao"
jumpButton.TextSize = 11
jumpButton.BackgroundColor3 = Color3.fromRGB(170,0,0)
jumpButton.TextColor3 = Color3.new(1,1,1)
jumpButton.Parent = frame

local highJump = false
local jumpLoop

local function startHighJump()

	if jumpLoop then return end

	jumpLoop = task.spawn(function()

		while highJump do

			local char = player.Character
			if char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then
					hum.JumpPower = 60 + 80
				end
			end

			task.wait(0.2)
		end

	end)

end

local function stopHighJump()

	highJump = false

	local char = player.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.JumpPower = 60
		end
	end

	jumpLoop = nil

end

jumpButton.MouseButton1Click:Connect(function()

	highJump = not highJump

	if highJump then
		jumpButton.BackgroundColor3 = Color3.fromRGB(0,170,0)
		startHighJump()
	else
		jumpButton.BackgroundColor3 = Color3.fromRGB(170,0,0)
		stopHighJump()
	end

end)

-- \\ Nhảy Cao //


-- // Trở Về Điểm Hồi Sinh \\

local spawnButton = Instance.new("TextButton")
spawnButton.Size = UDim2.new(1,-10,0,30)
spawnButton.Position = UDim2.new(0,10,0,180)
spawnButton.Text = "Trở Về Điểm Hồi Sinh"
spawnButton.TextSize = 11
spawnButton.BackgroundColor3 = Color3.fromRGB(80,80,200)
spawnButton.TextColor3 = Color3.new(1,1,1)
spawnButton.Parent = frame

spawnButton.MouseButton1Click:Connect(function()

	local char = player.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local spawn = workspace:FindFirstChildWhichIsA("SpawnLocation")

	if spawn then
		hrp.CFrame = spawn.CFrame + Vector3.new(0,5,0)
	end

end)

-- \\ Trở Về Điểm Hồi Sinh //


-- // Tự Động Cày \\

local autoFarmButton = Instance.new("TextButton")
autoFarmButton.Size = UDim2.new(1,-10,0,30)
autoFarmButton.Position = UDim2.new(0,10,0,210)
autoFarmButton.Text = "Tự Động Cày"
autoFarmButton.TextSize = 11
autoFarmButton.BackgroundColor3 = Color3.fromRGB(170,0,0)
autoFarmButton.TextColor3 = Color3.new(1,1,1)
autoFarmButton.Parent = frame

local autoFarmFrame = Instance.new("Frame")
autoFarmFrame.AnchorPoint = Vector2.new(1,0)
autoFarmFrame.Position = UDim2.new(1,-200,0,0)
autoFarmFrame.Size = UDim2.new(0,200,1,0)
autoFarmFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
autoFarmFrame.BorderSizePixel = 0
autoFarmFrame.Visible = false
autoFarmFrame.Parent = gui

local fields = {
"Sunflower Field (Zone 0)",
"Dandelion Field (Zone 0)",
"Mushroom Field (Zone 0)",
"Blue Flower Field (Zone 0)",
"Clover Field (Zone 0)",
"Strawberry Field (Zone 5)",
"Bamboo Field (Zone 5)",
"Spider Field (Zone 5)",
"Pineapple Patch (Zone 10)",
"Stump Field (Zone 10)",
"Cactus Field (Zone 15)",
"Pumpkin Patch (Zone 15)",
"Pine Tree Forest (Zone 15)",
"Rose Field (Zone 15)",
"Hub Field (Zone 20)",
"Moutain Top Field (Zone 30)",
"Coconut Field (Zone 35)",
"Pepper Patch (Zone 35)"
}

local activeFieldButton = nil
local fieldButtons = {}

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,1)
layout.Parent = autoFarmFrame

local autoFarmVisible = false
local tudongcay = false

local ignoredTokens = {}

local fieldData = {

["Sunflower Field (Zone 0)"] = {
start = Vector3.new(-256,0,244),
finish = Vector3.new(-168,7,104),
tp = Vector3.new(-210, 4, 174)
},

["Dandelion Field (Zone 0)"] = {
start = Vector3.new(-108,0,260),
finish = Vector3.new(44,7,180),
tp = Vector3.new(-34, 4, 222)
},

["Mushroom Field (Zone 0)"] = {
start = Vector3.new(-160,0,160),
finish = Vector3.new(-24,7,60),
tp = Vector3.new(-102, 4, 114)
},

["Blue Flower Field (Zone 0)"] = {
start = Vector3.new(56,0,136),
finish = Vector3.new(236,7,60),
tp = Vector3.new(146,4,98)
},

["Clover Field (Zone 0)"] = {
start = Vector3.new(100,30,256),
finish = Vector3.new(212,37,132),
tp = Vector3.new(154,34,192)
},

["Strawberry Field (Zone 5)"] = {
start = Vector3.new(-226,17,44),
finish = Vector3.new(-132,24,-68),
tp = Vector3.new(-182,21,-6)
},

["Bamboo Field (Zone 5)"] = {
start = Vector3.new(48,17,12),
finish = Vector3.new(212,24,-68),
tp = Vector3.new(130,21,-36)
},

["Spider Field (Zone 5)"] = {
start = Vector3.new(-104,17,40),
finish = Vector3.new(16,24,-68),
tp = Vector3.new(-50,21,2)
},

["Pineapple Patch (Zone 10)"] = {
start = Vector3.new(184,65,-160),
finish = Vector3.new(324,72,-260),
tp = Vector3.new(254,69,-206)
},

["Stump Field (Zone 10)"] = {
start = Vector3.new(372,93,-120),
finish = Vector3.new(472,100,-228),
tp = Vector3.new(410,97,-170)
},

["Cactus Field (Zone 15)"] = {
start = Vector3.new(-260,65,-64),
finish = Vector3.new(-120,72,-44),
tp = Vector3.new(-190,69,-102)
},

["Pumpkin Patch (Zone 15)"] = {
start = Vector3.new(-260,65,-148),
finish = Vector3.new(-120,72,-224),
tp = Vector3.new(-190,69,-182)
},

["Pine Tree Forest (Zone 15)"] = {
start = Vector3.new(-380,65,-124),
finish = Vector3.new(-280,72,-256),
tp = Vector3.new(-330,69,-190)
},

["Rose Field (Zone 15)"] = {
start = Vector3.new(-396,17,172),
finish = Vector3.new(-264,24,84),
tp = Vector3.new(-338,21,122)
},

["Hub Field (Zone 20)"] = {
start = Vector3.new(-64,-1,-9940),
finish = Vector3.new(60,6,-10064),
tp = Vector3.new(-2,3,-9990)
},

["Moutain Top Field (Zone 30)"] = {
start = Vector3.new(24,173,-108),
finish = Vector3.new(128,180,-228),
tp = Vector3.new(78,177,-182)
},

["Coconut Field (Zone 35)"] = {
start = Vector3.new(-320,58,512),
finish = Vector3.new(-192,65,420),
tp = Vector3.new(-250,62,482)
},

["Pepper Patch (Zone 35)"] = {
start = Vector3.new(-536,120,592),
finish = Vector3.new(-444,127,476),
tp = Vector3.new(-490,124,534)
}

}

autoFarmButton.MouseButton1Click:Connect(function()

	autoFarmVisible = not autoFarmVisible

	if autoFarmVisible then
		autoFarmFrame.Visible = true
		autoFarmButton.BackgroundColor3 = Color3.fromRGB(0,170,0)

        tudongcay = true

	else
		autoFarmFrame.Visible = false
		autoFarmButton.BackgroundColor3 = Color3.fromRGB(170,0,0)

        tudongcay = false

	end

end)

local function getFieldData(fieldName)
	return fieldData[fieldName]
end

local regionPart
local autoFarmRunning = false
local pollenfull = false
local pollenconvert = false

local function createRegion(startPos,finishPos)

	if regionPart then
		regionPart:Destroy()
	end

	local min = Vector3.new(
		math.min(startPos.X,finishPos.X),
		math.min(startPos.Y,finishPos.Y),
		math.min(startPos.Z,finishPos.Z)
	)

	local max = Vector3.new(
		math.max(startPos.X,finishPos.X),
		math.max(startPos.Y,finishPos.Y),
		math.max(startPos.Z,finishPos.Z)
	)

	local size = max - min
	local center = min + size/2

	regionPart = Instance.new("Part")
	regionPart.Anchored = true
	regionPart.CanCollide = false
	regionPart.Transparency = 0.7
	regionPart.Color = Color3.new(1,1,1)
	regionPart.Size = size
	regionPart.Position = center
	regionPart.Parent = workspace

	local highlight = Instance.new("Highlight")
	highlight.FillColor = Color3.new(1,1,1)
	highlight.FillTransparency = 0.6
	highlight.OutlineTransparency = 0
	highlight.Parent = regionPart

    ignoredTokens = {}

    local parts = workspace:GetPartBoundsInBox(
        regionPart.CFrame,
        regionPart.Size
    )

    for _,part in ipairs(parts) do

        local current = part

        while current do
            if current.Name == "C" then
                ignoredTokens[current] = true
                break
            end
            current = current.Parent
        end

    end

    autoFarmRunning = true

end

local function isInsideRegion(pos,startPos,finishPos)

	local min = Vector3.new(
		math.min(startPos.X,finishPos.X),
		math.min(startPos.Y,finishPos.Y),
		math.min(startPos.Z,finishPos.Z)
	)

	local max = Vector3.new(
		math.max(startPos.X,finishPos.X),
		math.max(startPos.Y,finishPos.Y),
		math.max(startPos.Z,finishPos.Z)
	)

	return (
		pos.X >= min.X and pos.X <= max.X and
		pos.Y >= min.Y and pos.Y <= max.Y and
		pos.Z >= min.Z and pos.Z <= max.Z
	)

end

local function isPlayerInsideRegion(startPos, finishPos)

	local character = player.Character
	if not character then return false end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return false end

	local pos = root.Position

	local min = Vector3.new(
		math.min(startPos.X, finishPos.X),
		math.min(startPos.Y, finishPos.Y),
		math.min(startPos.Z, finishPos.Z)
	)

	local max = Vector3.new(
		math.max(startPos.X, finishPos.X),
		math.max(startPos.Y, finishPos.Y),
		math.max(startPos.Z, finishPos.Z)
	)

	return (
		pos.X >= min.X and pos.X <= max.X and
		pos.Y >= min.Y and pos.Y <= max.Y and
		pos.Z >= min.Z and pos.Z <= max.Z
	)

end

local function hasCInPath(obj)

	local current = obj

	while current do

		if current.Name == "C" then
			return true
		end

		current = current.Parent
	end

	return false

end

local function getTokensInRegion()

	if not regionPart then
		return {}
	end

	local tokens = {}

	local parts = workspace:GetPartBoundsInBox(
		regionPart.CFrame,
		regionPart.Size
	)

	for _,part in ipairs(parts) do

        -- if hasCInPath(part) then
        --     table.insert(tokens, part)
        -- end

        local current = part
        local modelC = nil

        while current do
            if current.Name == "C" then
                modelC = current
                break
            end
            current = current.Parent
        end

        if modelC and not ignoredTokens[modelC] then
            table.insert(tokens,part)
        end

    end

	return tokens

end

local function moveToToken(token)

	local character = player.Character
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")

	if not humanoid or not root then return end

	local target = Vector3.new(
		token.Position.X,
		root.Position.Y,
		token.Position.Z
	)

	if (root.Position - target).Magnitude > 2 then
		humanoid:MoveTo(target)
	end

end

local function getDisplayText()

	local playerFolderPollen = workspace:FindFirstChild(player.Name)
	if not playerFolderPollen then return "" end

	for _,obj in pairs(playerFolderPollen:GetDescendants()) do
		if obj.Name == "Display" then

			for _,v in pairs(obj:GetDescendants()) do
				if v:IsA("TextLabel") then
					return v.Text
				end
			end

		end
	end

	return ""
end

for _,name in ipairs(fields) do

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,-10,0,30)
	btn.Text = name
	btn.TextSize = 11
	btn.BackgroundColor3 = Color3.fromRGB(170,0,0)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Parent = autoFarmFrame

	fieldButtons[name] = btn

	btn.MouseButton1Click:Connect(function()

	    if activeFieldButton == btn then
	        btn.BackgroundColor3 = Color3.fromRGB(170,0,0)
	        activeFieldButton = nil

        	autoFarmRunning = false

            ignoredTokens = {}

    	    if regionPart then
    		    regionPart:Destroy()
    	    end

    	    return
        end

	    if activeFieldButton then
		    activeFieldButton.BackgroundColor3 = Color3.fromRGB(170,0,0)
	    end

	    activeFieldButton = btn
    	btn.BackgroundColor3 = Color3.fromRGB(0,170,0)

    	local data = fieldData[name]

    	if not data then
    		warn("Không có dữ liệu field:",name)
    		return
    	end

    	if data.start == Vector3.new() then
    		warn("Field chưa có tọa độ:",name)
    		return
    	end

    	createRegion(data.start,data.finish)

    end)

end

task.spawn(function()

	while true do

		task.wait(0)

		if not autoFarmRunning then
			continue
		end

		if not activeFieldButton then
			continue
		end

		local fieldName = activeFieldButton.Text
		local data = fieldData[fieldName]

		if not data then
			continue
		end

		if not isPlayerInsideRegion(data.start,data.finish) and not pollenconvert then
	        local character = player.Character
	        if character then
	        	local root = character:FindFirstChild("HumanoidRootPart")
	        	if root then
	        		root.CFrame = CFrame.new(data.tp)
	        	end
	        end
        end

        local tokens = getTokensInRegion()

		if #tokens > 0 and tokens[1] and tokens[1].Parent and not pollenconvert then
	        moveToToken(tokens[1])
        end

        local text = getDisplayText()

		local left,right = string.match(text,"(%d+)%s*/%s*(%d+)")

		if left and right then

			left = tonumber(left)
			right = tonumber(right)

			if left >= right then
				pollenfull = true
            end

            if left < right and not pollenconvert then
				pollenfull = false
			end

		end

        if pollenfull and not pollenconvert then

			hrphive.CFrame = CFrame.new(savedPositionHive)
            task.wait(0.2)
            pressE()

            pollenconvert = true

		end

        if left == 0 then
            pollenconvert = false
        end

	end

end)

-- \\ Tự Động Cày //


-- // Ẩn/Hiện Bảng Đen \\

UIS.InputBegan:Connect(function(input, processed)

	if processed then return end

	if input.KeyCode == Enum.KeyCode.LeftAlt
	or input.KeyCode == Enum.KeyCode.RightAlt then
		frame.Visible = not frame.Visible

        if tudongcay == true then
            autoFarmFrame.Visible = not autoFarmFrame.Visible
        end

	end

end)

-- \\ Ẩn/Hiện Bảng Đen //
