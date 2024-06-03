MaskDefinitions = {}
MaskColors = {}
UsedTextures = {}
AffectedPixels = {}
HueShiftValues = {}
ActionWheel = {}
HueShiftPage = action_wheel:newPage()
local AffectedTextureInt = 1

---@param texture texture
---@param maskTexture texture
---@param MaskColorRGB Vector3
function AssignShiftChannel(texture, maskTexture, MaskColorRGB)
	if #MaskColors == 0 then table.insert(MaskColors, MaskColorRGB) end --This is the first color channel added
	if #UsedTextures == 0 then table.insert(UsedTextures, texture) end --This is the first texture added

	local channelUsed = false --Check if maskTexture color is new
	for i = 1, #MaskColors do if MaskColorRGB == MaskColors[i] then channelUsed = true break end end
	if not channelUsed then table.insert(MaskColors, MaskColorRGB) end
	
	local channelInt --Get color channel for maskTexture if previously used
	for i = 1, #MaskColors do if MaskColorRGB == MaskColors[i] then channelInt = i break end end

	local textureUsed = false --Check if texture is previously used
	for i = 1, #UsedTextures do if texture == UsedTextures[i] then textureUsed = true break end end
	if not textureUsed then table.insert(UsedTextures, texture) end

	table.insert(MaskDefinitions, {AffectedTexture = texture, MaskTexture =  maskTexture, ColorChannel = channelInt})
end

function ApplyHueMasks()
	for i = 1, #MaskDefinitions do
		CurrentIndex = i
		CurrentTexture = MaskDefinitions[i].AffectedTexture
		MaskDefinitions[i].MaskTexture:applyFunc(0, 0, MaskDefinitions[i].MaskTexture:getDimensions().x, MaskDefinitions[i].MaskTexture:getDimensions().y, LearnMaskPositions)
	end
end

function LearnMaskPositions(color, x, y)
	if color.r == MaskColors[MaskDefinitions[CurrentIndex].ColorChannel][1] and
	color.g == MaskColors[MaskDefinitions[CurrentIndex].ColorChannel][2] and
	color.b == MaskColors[MaskDefinitions[CurrentIndex].ColorChannel][3] then
		table.insert(AffectedPixels, {x = x, y = y, ColorChannel = MaskDefinitions[CurrentIndex].ColorChannel, Texture = CurrentTexture})
	end
end

---@param returnPageName string
function AutoCreateActionWheel(returnPageName)
	HueShiftPage:newAction():title("Close & Save"):item("barrier"):onLeftClick(function() pings.updateTexturesOverServer() action_wheel:setPage(action_wheel:getPage()[returnPageName]) end)
	for i = 1, #MaskColors do
		ColorValue = 0
		table.insert(HueShiftValues, ColorValue)
		Action = HueShiftPage:newAction()
		table.insert(ActionWheel, Action)
		local j = math.fmod(i, 11)
		local itemString
		if j == 1 then itemString = "red_dye"
		elseif j == 2 then itemString = "orange_dye"
		elseif j == 3 then itemString = "yellow_dye"
		elseif j == 4 then itemString = "lime_dye"
		elseif j == 5 then itemString = "green_dye"
		elseif j == 6 then itemString = "cyan_dye"
		elseif j == 7 then itemString = "light_blue_dye"
		elseif j == 8 then itemString = "blue_dye"
		elseif j == 9 then itemString = "purple_dye"
		elseif j == 10 then itemString = "magenta_dye"
		elseif j == 11 then itemString = "pink_dye"
		end
		Action:title("Channel " .. i .. ": " .. HueShiftValues[i]):item(itemString):setOnScroll(function(val) Scroll(val, i) end)
	end
	action_wheel:getPage()[returnPageName]:newAction():title("Hue Shifts"):item("painting"):onLeftClick(function() action_wheel:setPage(HueShiftPage) end)
end

function Scroll(val, channel)
	local percent = ": " .. HueShiftValues[channel]
	if val > 0 then
		HueShiftValues[channel] = math.clamp(HueShiftValues[channel] + 0.05, 0, 1)
	else
		HueShiftValues[channel] = math.clamp(HueShiftValues[channel] - 0.05, 0, 1)
	end
	UpdateTexturesLocal()
	ActionWheel[channel]:title(string.sub(ActionWheel[channel]:getTitle(), 1, #ActionWheel[channel]:getTitle() - #percent) .. ": " .. HueShiftValues[channel])
end

function UpdateTexturesLocal()
	for i = 1, #UsedTextures do UsedTextures[i]:restore() end
	Recolor()
	for i = 1, #UsedTextures do UsedTextures[i]:update() end
end

function Recolor()
    for i = 1, #AffectedPixels do
		local rgba = AffectedPixels[i].Texture:getPixel(AffectedPixels[i].x, AffectedPixels[i].y)
		local hsv = RgbToHsv(rgba.r, rgba.g, rgba.b, rgba.a)
        hsv.h = math.fmod(hsv.h + HueShiftValues[AffectedPixels[i].ColorChannel], 1)
        local returnColor = HsvToRgb(hsv.h, hsv.s, hsv.v, hsv.a)
		AffectedPixels[i].Texture:setPixel(AffectedPixels[i].x, AffectedPixels[i].y, vec(returnColor.r, returnColor.g, returnColor.b, returnColor.a))
	end
end

function pings.updateTexturesOverServer()
	for i = 1, #UsedTextures do UsedTextures[i]:restore() end
	Recolor()
	for i = 1, #UsedTextures do UsedTextures[i]:update() end
end

function RgbToHsv(r, g, b, a)
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local h, s, v
	v = max	
	local d = max - min
	if max == 0 then s = 0 else s = d / max end	
	if max == min then
	  h = 0
	else
		if max == r then
		h = (g - b) / d
		if g < b then h = h + 6 end
		elseif max == g then h = (b - r) / d + 2
		elseif max == b then h = (r - g) / d + 4
		end
		h = h / 6
	end
	return {h = h, s = s, v = v, a = a}
end
function HsvToRgb(h, s, v, a)
	local r, g, b
	local i = math.floor(h * 6);
	local f = h * 6 - i;
	local p = v * (1 - s);
	local q = v * (1 - f * s);
	local t = v * (1 - (1 - f) * s);
	i = i % 6
	if i == 0 then r, g, b = v, t, p
	elseif i == 1 then r, g, b = q, v, p
	elseif i == 2 then r, g, b = p, v, t
	elseif i == 3 then r, g, b = p, q, v
	elseif i == 4 then r, g, b = t, p, v
	elseif i == 5 then r, g, b = v, p, q
	end
	return {r = r, g = g, b = b, a = a}
end
