local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame.name = "BugSack"
frame:Hide()

-- Credits to Ace3 and Tekkub for lots of the widget stuff!

local sliderBg = {
	bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
	edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
	edgeSize = 8, tile = true, tileSize = 8,
	insets = {left = 3, right = 3, top = 6, bottom = 6}
}
local function newSlider(label, low, high)
	local slider = CreateFrame("Slider", nil, frame)
	slider:SetHeight(17)
	slider:SetWidth(144)
	slider:SetOrientation("HORIZONTAL")
	slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal") -- Dim: 32x32... can't find API to set this?
	slider:SetBackdrop(sliderBg)
	slider:SetMinMaxValues(low, high)

	local fs = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	fs:SetJustifyH("LEFT")
	fs:SetText(label)

	slider:SetPoint("LEFT", fs, "RIGHT", 16, 0)

	return fs
end

local function newCheckbox(label, description, onClick)
	local check = CreateFrame("CheckButton", nil, frame)
	check:SetWidth(26)
	check:SetHeight(26)
	check:SetHitRectInsets(0, -100, 0, 0)
	check:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
	check:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
	check:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
	check:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
	check:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
	check:SetScript("OnClick", function(self)
		PlaySound(self:GetChecked() and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		onClick(self)
	end)
	local r, g, b = GameFontNormal:GetTextColor()
	local fs = check:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	fs:SetPoint("LEFT", check, "RIGHT", 0, 1)
	fs:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
	fs:SetJustifyH("LEFT")
	fs:SetText(label)
	fs:SetTextColor(r, g, b, 1)
	fs:SetWidth(200)
	local desc = check:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	desc:ClearAllPoints()
	desc:SetPoint("TOPLEFT", check, "TOPRIGHT", 5, -20)
	desc:SetWidth(230)
	desc:SetJustifyH("LEFT")
	desc:SetJustifyV("TOP")
	desc:SetText(description)
	return check
end

--[[
proposed interface options design
	[ ] Auto popup
	[ ] Chatframe output
	
	Sound    [               V ]
	
	[ ] Filter addon mistakes
	[ ] Throttle at excessive amount
	
	[ ] Save errors
	Limit [-----|--------------]
	[ Clear saved errors ]
	
]]

frame:SetScript("OnShow", function(frame)
	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText("BugSack")

	local subtitle = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	subtitle:SetWidth(frame:GetWidth() - 24)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetJustifyV("TOP")
	subtitle:SetText("BugSack is a sack to stuff all your bugs in, and NOTHING ELSE! Don't think I don't know what you're up to, little schoolboy. Daddy was a little schoolboy, too.")

	local function apClick() print("apclick!") end
	local autoPopup = newCheckbox(
		"Auto popup",
		"Makes the BugSack open automatically when an error is encountered.",
		apClick)
	autoPopup:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", -2, -16)
	
	local chatFrame = newCheckbox(
		"Chatframe output",
		"Prints a reminder to the chat frame when an error is encountered. Doesn't print the whole error, just a reminder!",
		apClick)
	chatFrame:SetPoint("TOPLEFT", autoPopup, "BOTTOMLEFT", 0, -16)
	
	local limit = newSlider("Limit", 10, MAX_BUGGRABBER_ERRORS or 1000)
	limit:SetPoint("TOPLEFT", chatFrame, "BOTTOMLEFT", 0, -32)
end)
InterfaceOptions_AddCategory(frame)

--[[function BugSack:OpenConfig()
	InterfaceOptionsFrame_OpenToCategory(frame)
end]]

