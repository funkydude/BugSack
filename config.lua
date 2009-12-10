if not BugGrabber then return end

local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame.name = "BugSack"
frame:Hide()

-- Credits to Ace3, Tekkub, cladhaire and Tuller for some of the widget stuff.

local function onControlEnter(self)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	GameTooltip:AddLine(self.label)
	GameTooltip:AddLine(self.description, 1, 1, 1, 1)
	GameTooltip:Show()
end
local function onControlLeave() GameTooltip:Hide() end

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
		onClick(self, self:GetChecked() and true or false)
	end)
	check:SetScript("OnEnter", onControlEnter)
	check:SetScript("OnLeave", onControlLeave)
	check.label = label
	check.description = description
	local fs = check:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	fs:SetPoint("LEFT", check, "RIGHT", 0, 1)
	fs:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
	fs:SetJustifyH("LEFT")
	fs:SetText(label)
	fs:SetWidth(200)
	return check
end

frame:SetScript("OnShow", function(frame)
	local L = LibStub("AceLocale-3.0"):GetLocale("BugSack")

	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText("BugSack")

	local subtitle = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	subtitle:SetWidth(frame:GetWidth() - 24)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetJustifyV("TOP")
	subtitle:SetText("BugSack is a sack to stuff all your bugs in, and NOTHING ELSE! Don't think I don't know what you're up to, little schoolboy. Daddy was a little schoolboy, too.")

	local autoPopup = newCheckbox(
		L["Auto popup"],
		L.autoDesc,
		function(self, value) BugSack.db.auto = value end)
	autoPopup:SetChecked(BugSack.db.auto)
	autoPopup:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", -2, -8)

	local chatFrame = newCheckbox(
		L["Chatframe output"],
		L.chatFrameDesc,
		function(self, value) BugSack.db.chatframe = value end)
	chatFrame:SetChecked(BugSack.db.chatframe)
	chatFrame:SetPoint("TOPLEFT", autoPopup, "BOTTOMLEFT", 0, -4)

	local media = LibStub("LibSharedMedia-3.0", true)
	-- Jeeeeesus christ dropdowns are funky!
	local sound = nil
	if media then
		sound = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		sound:SetPoint("TOPLEFT", chatFrame, "BOTTOMLEFT", 8, -16)
		sound:SetJustifyH("LEFT")
		sound:SetHeight(18)
		sound:SetText(L["Sound"])
		local dropdown = CreateFrame("Frame", "BugSackSoundDropdown", frame, "UIDropDownMenuTemplate")
		dropdown:SetPoint("TOPLEFT", sound, "TOPRIGHT", 16, 0)
		local function itemOnClick(self)
			local selected = self.value
			BugSack.db.soundMedia = selected
			UIDropDownMenu_SetSelectedValue(dropdown, selected)
		end
		UIDropDownMenu_Initialize(dropdown, function()
			local info = UIDropDownMenu_CreateInfo()
			for idx, sound in next, media:List("sound") do
				info.text = sound
				info.value = sound
				info.func = itemOnClick
				info.checked = sound == BugSack.db.soundMedia
				UIDropDownMenu_AddButton(info)
			end
		end)
		UIDropDownMenu_SetSelectedValue(dropdown, BugSack.db.soundMedia)
		UIDropDownMenu_SetWidth(dropdown, 160)
		UIDropDownMenu_JustifyText(dropdown, "LEFT")
	else
		sound = newCheckbox(
			L["Mute"],
			L.muteDesc,
			function(self, value) BugSack.db.mute = value end)
		sound:SetChecked(BugSack.db.mute)
		sound:SetPoint("TOPLEFT", chatFrame, "BOTTOMLEFT", 0, -16)
	end

	local filter = newCheckbox(
		L["Filter addon mistakes"],
		L.filterDesc,
		function(self, value)
			BugSack:ToggleFilter()
		end)
	filter:SetChecked(BugSack:GetFilter())
	filter:SetPoint("TOPLEFT", sound, "BOTTOMLEFT", media and -8 or 0, -16)
	
	local throttle = newCheckbox(
		L["Throttle at excessive amount"],
		L.throttleDesc,
		function(self, value)
			BugGrabber:UseThrottling(value)
		end)
	throttle:SetPoint("TOPLEFT", filter, "BOTTOMLEFT", 0, -4)
	throttle:SetChecked(BugGrabber:IsThrottling())

	local save = newCheckbox(
		L["Save errors"],
		L.saveDesc,
		function(self, value)
			BugGrabber:ToggleSave()
			self:SetChecked(BugGrabber:GetSave())
		end)
	save:SetPoint("TOPLEFT", throttle, "BOTTOMLEFT", 0, -16)
	save:SetChecked(BugGrabber:GetSave())

	local sliderLabel = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	sliderLabel:SetJustifyH("LEFT")
	sliderLabel:SetText(L["Limit"])
	sliderLabel:SetPoint("TOPLEFT", save, "BOTTOMLEFT", 8, -8)

	local sliderValue = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	sliderValue:SetJustifyH("LEFT")
	sliderValue:SetText(BugGrabber:GetLimit())

	local slider = CreateFrame("Slider", nil, frame)
	slider:SetHeight(17)
	slider:SetWidth(144)
	slider:SetOrientation("HORIZONTAL")
	slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
	slider:SetBackdrop({
		bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
		edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
		edgeSize = 8, tile = true, tileSize = 8,
		insets = {left = 3, right = 3, top = 6, bottom = 6}
	})
	slider:SetMinMaxValues(10, MAX_BUGGRABBER_ERRORS or 1000)
	slider:SetValue(BugGrabber:GetLimit())
	slider:SetValueStep(20)
	slider:SetScript("OnValueChanged", function(self, value)
		local v = math.abs(value)
		BugGrabber:SetLimit(v)
		sliderValue:SetText(v)
	end)
	slider:SetPoint("LEFT", sliderLabel, "RIGHT", 36, 0)
	sliderValue:SetPoint("LEFT", slider, "RIGHT", 8, 0)
	
	local clear = CreateFrame("Button", "BugSackSaveButton", frame, "UIPanelButtonTemplate2")
	clear:SetText(L["Wipe saved bugs"])
	clear:SetWidth(160)
	clear:SetPoint("TOPLEFT", sliderLabel, "BOTTOMLEFT", -4, -4)
	clear:SetScript("OnClick", function()
		BugSack:Reset()
	end)
	clear:SetScript("OnEnter", onControlEnter)
	clear:SetScript("OnLeave", onControlLeave)
	clear.label = L["Wipe saved bugs"]
	clear.description = L.wipeDesc

	local icon = LibStub("LibDBIcon-1.0", true)
	if icon then
		local minimap = newCheckbox(
			L["Minimap icon"],
			L.minimapDesc,
			function(self, value)
				BugSackLDBIconDB.hide = not value
				if BugSackLDBIconDB.hide then
					icon:Hide("BugSack")
				else
					icon:Show("BugSack")
				end
			end)
		minimap:SetPoint("TOPLEFT", clear, "BOTTOMLEFT", -4, -16)
		minimap:SetChecked(not BugSackLDBIconDB.hide)
	end
	
	frame:SetScript("OnShow", nil)
end)
InterfaceOptions_AddCategory(frame)

