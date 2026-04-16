local UserInputService = game:GetService("UserInputService"); local Players = game:GetService("Players"); local RunService = game:GetService("RunService"); local player = Players.LocalPlayer; local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui"); screenGui.ResetOnSpawn = false; screenGui.IgnoreGuiInset = true; screenGui.DisplayOrder = 999999; screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global; screenGui.Parent = playerGui
local bangden = Instance.new("Frame"); bangden.AnchorPoint = Vector2.new(1, 0); bangden.Position = UDim2.new(1, 0, 0, 0); bangden.Size = UDim2.new(0, 200, 1, 0); bangden.BackgroundColor3 = Color3.new(0, 0, 0); bangden.BorderSizePixel = 0; bangden.Visible = true; bangden.Parent = screenGui
-- // Nhận Tổ \\
local vimhive = game:GetService("VirtualInputManager"); local characterhive, hrphive, humanoid; local function updateChar(char) characterhive = char; hrphive = char:WaitForChild("HumanoidRootPart"); humanoid = char:WaitForChild("Humanoid") end; updateChar(player.Character or player.CharacterAdded:Wait()); player.CharacterAdded:Connect(updateChar); local ntgn = Instance.new("TextButton"); ntgn.Size = UDim2.new(1,0,0,-30); ntgn.Position = UDim2.new(0,0,0,30); ntgn.Text = "Nhận Tổ (Nhận Rồi Cũng Ấn)"; ntgn.TextSize = 11; ntgn.BackgroundColor3 = Color3.fromRGB(170,0,0); ntgn.TextColor3 = Color3.new(1,1,1); ntgn.Parent = bangden; local boxList = { { min = Vector3.new(-167.3,-2,317.1), max = Vector3.new(-204.9,18,347.4), teleportPos = Vector3.new(-186.5,6.2,331.1) }, { min = Vector3.new(-130.8,-2,317.1), max = Vector3.new(-167.8,18,347.4), teleportPos = Vector3.new(-149.9,6.2,331.1) }, { min = Vector3.new(-94.6,-2,317.1), max = Vector3.new(-131.4,18,347.4), teleportPos = Vector3.new(-113.3,6.2,331.1) }, { min = Vector3.new(-57.8,-2,317.1), max = Vector3.new(-95.2,18,347.4), teleportPos = Vector3.new(-76.7,6.2,331.1) }, { min = Vector3.new(-21.8,-2,317.1), max = Vector3.new(-58.6,18,347.4), teleportPos = Vector3.new(-40.1,6.2,331.1) }, { min = Vector3.new(15.6,-2,317.1), max = Vector3.new(-21.4,18,347.4), teleportPos = Vector3.new(-3.5,6.2,331.1) } }; local function isArrow(part) return string.match(string.lower(part:GetFullName()), "localpatharrow") end; local function findBoxWithArrow() for i=1,#boxList do local box=boxList[i]; local center=(box.min+box.max)/2; local size=box.max-box.min; for _,part in ipairs(workspace:GetPartBoundsInBox(CFrame.new(center),size)) do if part:IsA("BasePart") and isArrow(part) then return box end end end return nil end; local function findBoxWithPlayer() for _,box in ipairs(boxList) do local center=(box.min+box.max)/2; local size=box.max-box.min; for _,part in ipairs(workspace:GetPartBoundsInBox(CFrame.new(center),size)) do local gui=part:FindFirstAncestorWhichIsA("BillboardGui") or part:FindFirstAncestorWhichIsA("SurfaceGui"); if gui then for _,v in ipairs(gui:GetDescendants()) do if v:IsA("TextLabel") and v.Text==player.Name then return box end end end end end return nil end; local function pressE() vimhive:SendKeyEvent(true, Enum.KeyCode.E, false, game); vimhive:SendKeyEvent(false, Enum.KeyCode.E, false, game) end; local usedhive = false; local savedPositionHive = nil; local function claimHive() if not usedhive then local box = findBoxWithArrow(); if box then hrphive.CFrame = CFrame.new(box.teleportPos); task.wait(0.5); pressE(); ntgn.Text = "Đã Nhận Tổ (Nhấn Để Trở Về)"; ntgn.BackgroundColor3 = Color3.fromRGB(204,204,0); usedhive = true else local humanoid = characterhive:FindFirstChild("Humanoid"); if humanoid then humanoid.Health = 0 end; local char = player.CharacterAdded:Wait(); updateChar(char); task.wait(0.5); local playerBox = findBoxWithPlayer(); if playerBox then hrphive.CFrame = CFrame.new(playerBox.teleportPos) end; ntgn.Text = "Đã Nhận Tổ (Nhấn Để Trở Về)"; ntgn.BackgroundColor3 = Color3.fromRGB(204,204,0); usedhive = true end; savedPositionHive = hrphive.Position else hrphive.CFrame = CFrame.new(savedPositionHive) end end; ntgn.MouseButton1Click:Connect(claimHive)
-- \\ Nhận Tổ //
-- // Giảm Đồ Hoạ \\
local Lighting = game:GetService("Lighting"); local Workspace = game:GetService("Workspace"); local gdh = Instance.new("TextButton"); gdh.Size = UDim2.new(1, 0, 0, -30); gdh.Position = UDim2.new(0, 0, 0, 60); gdh.Text = "Giảm Đồ Hoạ"; gdh.TextSize = 11;  gdh.BackgroundColor3 = Color3.fromRGB(170,0,0);  gdh.TextColor3 = Color3.new(1,1,1); gdh.Parent = bangden; local enabled = false; local whitelist = { workspace:FindFirstChild("Decorations") and workspace.Decorations:FindFirstChild("Stump"), workspace:FindFirstChild("Decorations") and workspace.Decorations:FindFirstChild("30BeeZone") }; local deleteDescendants = { workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Fences"), workspace:FindFirstChild("Decorations"), workspace:FindFirstChild("FieldDecos"), workspace:FindFirstChild("Invisible Walls"), workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("OuterInvisWalls"), workspace:FindFirstChild("Model"), workspace:FindFirstChild("HiveDeco"), workspace:FindFirstChild("SpiderWeb") }; local deleteExact = { workspace:FindFirstChild("Gates") }; local whitelistSet = {}; local function buildWhitelist() for _, obj in ipairs(whitelist) do if obj then whitelistSet[obj] = true; for _, v in ipairs(obj:GetDescendants()) do whitelistSet[v] = true end end end end; local function isWhitelisted(obj) return whitelistSet[obj] == true end; local function deleteDesc(obj) if not obj then return end; for _, v in ipairs(obj:GetDescendants()) do if not isWhitelisted(v) then pcall(function() v:Destroy() end) end end end; local function deleteSelf(obj) if obj and not isWhitelisted(obj) then pcall(function() obj:Destroy() end) end end; local function optimize(obj) if obj:FindFirstAncestor("C") then return end; if obj:IsA("Texture") or obj:IsA("Decal") then obj:Destroy() end; if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then obj:Destroy() end; if obj:IsA("BasePart") then obj.CastShadow = false; obj.Material = Enum.Material.Plastic; obj.Reflectance = 0 end end; local function reduceLighting() for _,v in ipairs(Lighting:GetChildren()) do v:Destroy() end; Lighting.GlobalShadows = false; Lighting.Technology = Enum.Technology.Compatibility end; local function applyLowGraphics() reduceLighting(); for _,v in ipairs(Workspace:GetDescendants()) do optimize(v) end end; Workspace.DescendantAdded:Connect(function(obj) if enabled then optimize(obj) end end); gdh.MouseButton1Click:Connect(function() if not enabled then gdh.BackgroundColor3 = Color3.fromRGB(50,50,50); applyLowGraphics(); buildWhitelist(); for _, obj in ipairs(deleteDescendants) do deleteDesc(obj) end; for _, obj in ipairs(deleteExact) do deleteSelf(obj) end; enabled = true end end)
-- \\ Giảm Đồ Hoạ //
-- // Bay \\
local bay = Instance.new("TextButton"); bay.Size = UDim2.new(1, 0, 0, -30); bay.Position = UDim2.new(0, 0, 0, 90); bay.Text = "Bay"; bay.TextSize = 11 ; bay.TextColor3 = Color3.new(1,1,1); bay.BackgroundColor3 = Color3.fromRGB(170,0,0); bay.Parent = bangden; local flying = false; local bodyVel, bodyGyro, conn; local speed = 90; local move = { W=false, A=false, S=false, D=false, Up=false, Down=false }; UserInputService.InputBegan:Connect(function(input, gp) if gp then return end; if input.KeyCode == Enum.KeyCode.W then move.W = true end; if input.KeyCode == Enum.KeyCode.A then move.A = true end; if input.KeyCode == Enum.KeyCode.S then move.S = true end; if input.KeyCode == Enum.KeyCode.D then move.D = true end; if input.KeyCode == Enum.KeyCode.Space then move.Up = true end; if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then move.Down = true end end); UserInputService.InputEnded:Connect(function(input) if input.KeyCode == Enum.KeyCode.W then move.W = false end; if input.KeyCode == Enum.KeyCode.A then move.A = false end; if input.KeyCode == Enum.KeyCode.S then move.S = false end; if input.KeyCode == Enum.KeyCode.D then move.D = false end; if input.KeyCode == Enum.KeyCode.Space then move.Up = false end; if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then move.Down = false end end); local function startFly() local char = player.Character or player.CharacterAdded:Wait(); local hrp = char:WaitForChild("HumanoidRootPart"); bodyVel = Instance.new("BodyVelocity"); bodyVel.MaxForce = Vector3.new(1e5,1e5,1e5); bodyVel.Velocity = Vector3.zero; bodyVel.Parent = hrp; bodyGyro = Instance.new("BodyGyro"); bodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5); bodyGyro.CFrame = hrp.CFrame; bodyGyro.Parent = hrp; conn = RunService.RenderStepped:Connect(function() local cam = workspace.CurrentCamera; local dir = Vector3.zero; if move.W then dir += cam.CFrame.LookVector end; if move.S then dir -= cam.CFrame.LookVector end; if move.A then dir -= cam.CFrame.RightVector end; if move.D then dir += cam.CFrame.RightVector end; if move.Up then dir += Vector3.new(0,1,0) end; if move.Down then dir -= Vector3.new(0,1,0) end; if dir.Magnitude > 0 then dir = dir.Unit * speed end; bodyVel.Velocity = dir; bodyGyro.CFrame = cam.CFrame end) end; local function stopFly() if conn then conn:Disconnect() conn = nil end; if bodyVel then bodyVel:Destroy() bodyVel = nil end; if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end end; bay.MouseButton1Click:Connect(function() flying = not flying; if flying then bay.BackgroundColor3 = Color3.fromRGB(0,170,0); startFly() else bay.BackgroundColor3 = Color3.fromRGB(170,0,0); stopFly() end end)
-- \\ Bay //
-- // Xuyên Tường \\
local xt = Instance.new("TextButton"); xt.Size = UDim2.new(1, 0, 0, -30); xt.Position = UDim2.new(0, 0, 0, 120); xt.Text = "Xuyên Tường"; xt.TextSize = 11; xt.BackgroundColor3 = Color3.fromRGB(170,0,0); xt.TextColor3 = Color3.new(1,1,1); xt.Parent = bangden; local noclip = false; local function setNoclip(state) local char = player.Character; if not char then return end; for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = not state end end end; xt.MouseButton1Click:Connect(function() noclip = not noclip; xt.BackgroundColor3 = noclip and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0) end); RunService.Stepped:Connect(function() if noclip then setNoclip(true) end end)
-- \\ Xuyên Tường //
-- // Tốc Độ \\
local speedBtn = Instance.new("TextButton"); speedBtn.Size = UDim2.new(0.6, 0, 0, -30); speedBtn.Position = UDim2.new(0, 0, 0, 150); speedBtn.Text = "Tốc Độ"; speedBtn.TextSize = 11; speedBtn.BackgroundColor3 = Color3.fromRGB(170,0,0); speedBtn.TextColor3 = Color3.new(1,1,1); speedBtn.Parent = bangden; local speedBox = Instance.new("TextBox"); speedBox.Size = UDim2.new(0.4, 0, 0, -30); speedBox.Position = UDim2.new(0.6, 0, 0, 150); speedBox.PlaceholderText = "0-140"; speedBox.Text = ""; speedBox.TextSize = 11; speedBox.Parent = bangden; local function setupNumberBox(box) box:GetPropertyChangedSignal("Text"):Connect(function() box.Text = box.Text:gsub("%D", ""); local num = tonumber(box.Text); if num then if num > 140 then box.Text = "140" end end end) end; local speedOn = false; local defaultSpeed = 50; local function getSpeed() local n = tonumber(speedBox.Text); if not n then return 0 end; return math.clamp(n, 0, 140) end; local speedLoop; local function startFastRun() setupNumberBox(speedBox); if speedLoop then return end; speedLoop = task.spawn(function() while speedOn do humanoid.WalkSpeed = getSpeed(); task.wait(0.2) end end) end; speedBtn.MouseButton1Click:Connect(function() speedOn = not speedOn; if speedOn then startFastRun(); speedBtn.BackgroundColor3 = Color3.fromRGB(0,170,0) else speedLoop = nil; humanoid.WalkSpeed = defaultSpeed; speedBtn.BackgroundColor3 = Color3.fromRGB(170,0,0) end end)
-- \\ Tốc độ //
-- // Sức Bật \\
local jumpBtn = Instance.new("TextButton"); jumpBtn.Size = UDim2.new(0.6, 0, 0, -30); jumpBtn.Position = UDim2.new(0, 0, 0, 180); jumpBtn.Text = "Sức Bật"; jumpBtn.TextSize = 11; jumpBtn.BackgroundColor3 = Color3.fromRGB(170,0,0); jumpBtn.TextColor3 = Color3.new(1,1,1); jumpBtn.Parent = bangden; local jumpBox = Instance.new("TextBox"); jumpBox.Size = UDim2.new(0.4, 0, 0, -30); jumpBox.Position = UDim2.new(0.6, 0, 0, 180); jumpBox.PlaceholderText = "0-140"; jumpBox.Text = ""; jumpBox.TextSize = 11; jumpBox.Parent = bangden; local jumpOn = false; local defaultJump = 70; local function getJump() local n = tonumber(jumpBox.Text); if not n then return 0 end; return math.clamp(n, 0, 140) end; setupNumberBox(jumpBox); local jumpLoop; local function startJump() if jumpLoop then return end; jumpLoop = task.spawn(function() while jumpOn do humanoid.JumpPower = getJump(); task.wait(0.2); end end) end; jumpBtn.MouseButton1Click:Connect(function() jumpOn = not jumpOn; if jumpOn then startJump(); jumpBtn.BackgroundColor3 = Color3.fromRGB(0,170,0); else jumpLoop = nil; humanoid.JumpPower = defaultJump; jumpBtn.BackgroundColor3 = Color3.fromRGB(170,0,0); end end)
-- \\ Sức Bật //
-- // Trở Về Điểm Hồi Sinh \\
local spawnButton = Instance.new("TextButton"); spawnButton.Size = UDim2.new(1,0,0,-30); spawnButton.Position = UDim2.new(0,0,0,210); spawnButton.Text = "Trở Về Điểm Hồi Sinh"; spawnButton.TextSize = 11; spawnButton.BackgroundColor3 = Color3.fromRGB(80,80,200); spawnButton.TextColor3 = Color3.new(1,1,1); spawnButton.Parent = bangden; spawnButton.MouseButton1Click:Connect(function() local char = player.Character; if not char then return end; local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end; local spawn = workspace:FindFirstChildWhichIsA("SpawnLocation"); if spawn then hrp.CFrame = spawn.CFrame + Vector3.new(0,5,0) end end)
-- \\ Trở Về Điểm Hồi Sinh //
-- // Tự Động Cày \\
local autoFarmBtn = Instance.new("TextButton"); autoFarmBtn.Size = UDim2.new(0.5,0,0,-30); autoFarmBtn.Position = UDim2.new(0,0,0,240); autoFarmBtn.Text = "Tự Động Cày"; autoFarmBtn.TextSize = 11; autoFarmBtn.BackgroundColor3 = Color3.fromRGB(170,0,0); autoFarmBtn.TextColor3 = Color3.new(1,1,1); autoFarmBtn.Parent = bangden; 
local modeBtn = Instance.new("TextButton"); modeBtn.Size = UDim2.new(0.5,0,0,-30); modeBtn.Position = UDim2.new(0.5,0,0,240); modeBtn.Text = "Dịch Chuyển"; modeBtn.TextSize = 11; modeBtn.BackgroundColor3 = Color3.fromRGB(170,0,0); modeBtn.TextColor3 = Color3.new(1,1,1); modeBtn.Parent = bangden; 
modeBtn.MouseButton1Click:Connect(function() useLerp = not useLerp; if useLerp then modeBtn.BackgroundColor3 = Color3.fromRGB(0,170,0) else modeBtn.BackgroundColor3 = Color3.fromRGB(170,0,0) end end); 
local autoFarmUI = Instance.new("Frame"); autoFarmUI.Size = UDim2.new(0,200,1,0); autoFarmUI.AnchorPoint = Vector2.new(1,0); autoFarmUI.Position = UDim2.new(1, -200, 0, 0); autoFarmUI.BackgroundColor3 = Color3.new(0,0,0); autoFarmUI.Visible = false; autoFarmUI.Parent = screenGui; 

local activeButton = nil
local fieldConnection = nil
local autoFarmEnabled = false
local currentField = nil
local targetList = {}

local fields = { { name = "Sunflower Field (Zone 0)", min = Vector3.new(-256,0,244), max = Vector3.new(-168,7,104) }, { name = "Dandelion Field (Zone 0)", min = Vector3.new(-108,0,260), max = Vector3.new(44,7,180) }, { name = "Mushroom Field (Zone 0)", min = Vector3.new(-160,0,160), max = Vector3.new(-24,7,60) }, { name = "Blue Flower Field (Zone 0)", min = Vector3.new(56,0,136), max = Vector3.new(236,7,60) }, { name = "Clover Field (Zone 0)", min = Vector3.new(100,30,256), max = Vector3.new(212,37,132) }, { name = "Strawberry Field (Zone 5)", min = Vector3.new(-226,17,44), max = Vector3.new(-132,24,-68) }, { name = "Bamboo Field (Zone 5)", min = Vector3.new(48,17,12), max = Vector3.new(212,24,-68) }, { name = "Spider Field (Zone 5)", min = Vector3.new(-104,17,40), max = Vector3.new(16,24,-68) }, { name = "Pineapple Patch (Zone 10)", min = Vector3.new(184,65,-160), max = Vector3.new(324,72,-260) }, { name = "Stump Field (Zone 10)", min = Vector3.new(368,93,-116), max = Vector3.new(476,100,-232) }, { name = "Cactus Field (Zone 15)", min = Vector3.new(-260,65,-64), max = Vector3.new(-120,72,-144) }, { name = "Pumpkin Patch (Zone 15)", min = Vector3.new(-260,65,-148), max = Vector3.new(-120,72,-224) }, { name = "Pine Tree Forest (Zone 15)", min = Vector3.new(-380,65,-124), max = Vector3.new(-280,72,-256) }, { name = "Rose Field (Zone 15)", min = Vector3.new(-396,17,172), max = Vector3.new(-264,24,84) }, { name = "Hub Field (Zone 20)", min = Vector3.new(-64,-1,-10064), max = Vector3.new(60,6,-9940) }, { name = "Moutain Top Field (Zone 30)", min = Vector3.new(24,173,-108), max = Vector3.new(128,180,-228) }, { name = "Coconut Field (Zone 35)", min = Vector3.new(-320,67,512), max = Vector3.new(-192,74,420) }, { name = "Pepper Patch (Zone 35)", min = Vector3.new(-536,120,592), max = Vector3.new(-444,127,476) } }

local pollenfull = false
local pollenconvert = false

local function getDisplayText() local playerFolderPollen = workspace:FindFirstChild(player.Name); if not playerFolderPollen then return "" end; for _,obj in pairs(playerFolderPollen:GetDescendants()) do if obj.Name == "Display" then for _,v in pairs(obj:GetDescendants()) do if v:IsA("TextLabel") then return v.Text end end end end; return "" end; 
local function press1() vimhive:SendKeyEvent(true, Enum.KeyCode.One, false, game); vimhive:SendKeyEvent(false, Enum.KeyCode.One, false, game) end; 
local function isInside(pos, min, max) return pos.X >= math.min(min.X, max.X) and pos.X <= math.max(min.X, max.X) and pos.Y >= math.min(min.Y, max.Y) and pos.Y <= math.max(min.Y, max.Y) and pos.Z >= math.min(min.Z, max.Z) and pos.Z <= math.max(min.Z, max.Z) end; 
local function getCenter(min, max) return (min + max)/2 end; 
local function scanField(field) targetList = {}; local center = getCenter(field.min, field.max); local size = field.max - field.min; for _, part in ipairs(workspace:GetPartBoundsInBox(CFrame.new(center), size)) do if part.Name == "C" then table.insert(targetList, part) end end end; 

local function watchField(field)
    if fieldConnection then
        fieldConnection:Disconnect()
        fieldConnection = nil
    end

    fieldConnection = workspace.DescendantAdded:Connect(function(obj)
        if autoFarmEnabled and obj.Name == "C" and currentField == field then
            local pos = obj.Position
            if isInside(pos, field.min, field.max) then
                table.insert(targetList, obj)
            end
        end
    end)
end

local function moveToTargets()
    if moving then return end
    moving = true

    task.spawn(function()
        while autoFarmEnabled do

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
				task.wait(1)
				pressE()
				pollenconvert = true
				task.wait(1)

			end

			if left == 0 then
				pollenconvert = false
			end

			if not currentField or not hrphive then
                task.wait(0.1)
                continue
            end

            if not isInside(hrphive.Position, currentField.min, currentField.max) and not pollenfull and not pollenconvert then
                hrphive.CFrame = CFrame.new(getCenter(currentField.min, currentField.max))
                task.wait(0.2)
                press1()
            end

            for i, obj in ipairs(targetList) do
				if obj and obj.Parent then
					local pos = obj.Position
					local start = hrphive.Position
					local goal = Vector3.new(pos.X, start.Y, pos.Z)

					if useLerp and not pollenfull and not pollenconvert then
						local start = hrphive.Position
						local goal = Vector3.new(obj.Position.X, start.Y, obj.Position.Z)

						local speed = 90
						local dist = (goal - start).Magnitude
						local duration = dist / speed

						local t = 0
						while t < 1 do
							local dt = task.wait()
							t += dt / duration
							hrphive.CFrame = CFrame.new(start:Lerp(goal, math.clamp(t,0,1)))
						end
					elseif not useLerp and not pollenfull and not pollenconvert then
						local humanoid = hrphive.Parent:FindFirstChildOfClass("Humanoid")
						if humanoid then
							humanoid:MoveTo(goal)

							local reached = false
							local startTime = tick()
							local timeout = 0.05

						while autoFarmEnabled and not reached do
							local dist = (hrphive.Position - goal).Magnitude

							if dist < 1 then
								reached = true
							end

							if tick() - startTime > timeout then
								break
							end

							task.wait(0.05)
						end
					end
				end
			end
			targetList[i] = nil
		end
            task.wait(0.05)
        end

        moving = false
    end)
end

local y = 0
for _, field in ipairs(fields) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,30)
    btn.Position = UDim2.new(0,0,0,y)
    btn.Text = field.name
    btn.TextSize = 11
    btn.BackgroundColor3 = Color3.fromRGB(170,0,0)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = autoFarmUI

	btn.MouseButton1Click:Connect(function()
		if activeButton and activeButton ~= btn then
			activeButton.BackgroundColor3 = Color3.fromRGB(170,0,0)
		end

		activeButton = btn
		btn.BackgroundColor3 = Color3.fromRGB(0,170,0)

		targetList = {}
		currentField = field

		currentField = field
		scanField(field)
		watchField(field)

		if autoFarmEnabled then
			moveToTargets()
		end
	end)

    y = y + 30
end

autoFarmBtn.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    autoFarmUI.Visible = autoFarmEnabled

    autoFarmBtn.BackgroundColor3 = autoFarmEnabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)

	if autoFarmEnabled and currentField then
		moveToTargets()
	end

    if not autoFarmEnabled then
        currentField = nil
        targetList = {}

        if activeButton then
            activeButton.BackgroundColor3 = Color3.fromRGB(170,0,0)
            activeButton = nil
        end

        if fieldConnection then
            fieldConnection:Disconnect()
            fieldConnection = nil
        end
    end
end)

-- \\ Tự Động Cày //
-- // Tự Động Giữ Chuột \\
local tdgc = Instance.new("TextButton"); tdgc.Size = UDim2.new(1,0,0,-30); tdgc.Position = UDim2.new(0,0,0,270); tdgc.Text = "Tự Động Giữ Chuột"; tdgc.TextSize = 11; tdgc.BackgroundColor3 = Color3.fromRGB(170,0,0); tdgc.TextColor3 = Color3.new(1,1,1); tdgc.Parent = bangden; local UIS = game:GetService("UserInputService"); local VIM = game:GetService("VirtualInputManager"); local player = game.Players.LocalPlayer; local playerGui = player:WaitForChild("PlayerGui"); local holding = false; tdgc.MouseButton1Click:Connect(function() holding = not holding; if holding then VIM:SendMouseButtonEvent(0,0,0,true,game,0); tdgc.BackgroundColor3 = Color3.fromRGB(0,170,0) else VIM:SendMouseButtonEvent(0,0,0,false,game,0); tdgc.BackgroundColor3 = Color3.fromRGB(170,0,0) end end); local pause = false; UIS.InputEnded:Connect(function(input, gp) if input.UserInputType ~= Enum.UserInputType.MouseButton1 and gp then return end; if holding and input.UserInputType == Enum.UserInputType.MouseButton1 then if pause then return end; pause = true; task.spawn(function() VIM:SendMouseButtonEvent(0,0,0,false,game,0); task.wait(1); if holding then VIM:SendMouseButtonEvent(0,0,0,true,game,0) end; pause = false end) end end)
-- \\ Tự Động Giữ Chuột //
-- // Thu-phóng màn hình + luôn nhìn thấy nhân vật \\
local Players = game:GetService("Players"); local p = Players.LocalPlayer; local function applyCamera() p.CameraMaxZoomDistance = 150; p.CameraMinZoomDistance = 0; p.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam end; applyCamera(); p.CharacterAdded:Connect(function() task.wait(0.5); applyCamera() end)
-- \\ Thu-phóng màn hình + luôn nhìn thấy nhân vật //
-- // Chống rời máy chủ \\
local VirtualUser = game:GetService("VirtualUser"); game:GetService("Players").LocalPlayer.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new(0,0)) end)
-- \\ Chống rời máy chủ //
-- // Ẩn/Hiện bảng đen \\
local ah = false; UserInputService.InputBegan:Connect(function(input, gameProcessed) if gameProcessed then return end; if input.KeyCode == Enum.KeyCode.LeftAlt then ah = true end; if ah == false then return end; bangden.Visible = not bangden.Visible; 
if autoFarmUI.Visible == false and autoFarmEnabled == true then autoFarmUI.Visible = true; elseif autoFarmUI.Visible == true then autoFarmUI.Visible = false end; ah = false 
end)
-- \\ Ẩn/Hiện bảng đen //
