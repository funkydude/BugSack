local media = LibStub("LibSharedMedia-3.0", true)

local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame.name = "BugSack"
frame:Hide()

-- Credits to Ace3, Tekkub, cladhaire and Tuller for some of the widget stuff.

local function onControlEnter(self)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	GameTooltip:AddLine(self.label)
	GameTooltip:AddLine(self.description, 1, 1, 1, 1)
	GameTooltip:Show()
end
local function onControlLeave() GameTooltip:Hide() end

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

	local fs = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	fs:SetJustifyH("LEFT")
	fs:SetText(label)

	slider:SetPoint("LEFT", fs, "RIGHT", 16, 0)

	return slider, fs
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
		onClick(self, self:GetChecked())
	end)
	check:SetScript("OnEnter", onControlEnter)
	check:SetScript("OnLeave", onControlLeave)
	check.label = label
	check.description = description
	--local r, g, b = GameFontNormal:GetTextColor()
	local fs = check:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	fs:SetPoint("LEFT", check, "RIGHT", 0, 1)
	fs:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
	fs:SetJustifyH("LEFT")
	fs:SetText(label)
	--fs:SetTextColor(r, g, b, 1)
	fs:SetWidth(200)
	--check.label = fs
	--[[local desc = check:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	desc:ClearAllPoints()
	desc:SetPoint("TOPLEFT", check, "TOPRIGHT", 5, -20)
	desc:SetWidth(230)
	desc:SetJustifyH("LEFT")
	desc:SetJustifyV("TOP")
	desc:SetText(description)]]
	return check
end

frame:SetScript("OnShow", function(frame)
	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText("BugSack")

	local subtitle = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	subtitle:SetWidth(frame:GetWidth() - 24)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetJustifyV("TOP")
	subtitle:SetText("BugSack is a sack to stuff all your bugs in, and NOTHING ELSE! Don't think I don't know what you're up to, little schoolboy. Daddy was a little schoolboy, too. Yes, I know this option screen looks really bad at the moment. Give me some time please.")

	local function checkBoxClick(label, value) print(value) end
	local autoPopup = newCheckbox(
		"Auto popup",
		"Makes the BugSack open automatically when an error is encountered.",
		function(self, value)
			BugSack.db.profile.auto = value
		end)
	autoPopup:SetChecked(BugSack.db.profile.auto)
	autoPopup:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", -2, -16)

	local chatFrame = newCheckbox(
		"Chatframe output",
		"Prints a reminder to the chat frame when an error is encountered. Doesn't print the whole error, just a reminder!",
		function(self, value)
			BugSack.db.profile.chatframe = value
		end)
	chatFrame:SetChecked(BugSack.db.profile.chatframe)
	chatFrame:SetPoint("TOPLEFT", autoPopup, "BOTTOMLEFT", 0, -8)

	-- Jeeeeesus christ dropdowns are funky!
	local soundLabel = nil
	if media then
		soundLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		soundLabel:SetPoint("TOPLEFT", chatFrame, "BOTTOMLEFT", 8, -16)
		soundLabel:SetJustifyH("LEFT")
		soundLabel:SetHeight(18)
		soundLabel:SetText("Sound")
		local dropdown = CreateFrame("Frame", "BugSackSoundDropdown", frame, "UIDropDownMenuTemplate")
		dropdown:SetPoint("TOPLEFT", soundLabel, "TOPRIGHT", 16, 0)
		local function itemOnClick(self)
			local selected = self.value
			BugSack.db.profile.soundMedia = selected
			UIDropDownMenu_SetSelectedValue(dropdown, selected)
		end
		UIDropDownMenu_Initialize(dropdown, function()
			local info = UIDropDownMenu_CreateInfo()
			for idx, sound in next, media:List("sound") do
				info.text = sound
				info.value = sound
				info.func = itemOnClick
				info.checked = sound == BugSack.db.profile.soundMedia
				UIDropDownMenu_AddButton(info)
			end
		end)
		UIDropDownMenu_SetSelectedValue(dropdown, BugSack.db.profile.soundMedia)
		UIDropDownMenu_SetWidth(dropdown, 160)
		UIDropDownMenu_JustifyText(dropdown, "LEFT")
	end

	local filter = newCheckbox(
		"Filter addon mistakes",
		"Toggles whether or not BugSack should treat ADDON_ACTION_BLOCKED and ADDON_ACTION_FORBIDDEN events as errors or not. If that doesn't make sense, just ignore this option.",
		function(self, value)
			BugSack:ToggleFilter()
		end)
	filter:SetChecked(BugSack:GetFilter())
	filter:SetPoint("TOPLEFT", soundLabel or chatFrame, "BOTTOMLEFT", soundLabel and -8 or 0, -16)
	
	local throttle = newCheckbox(
		"Throttle at excessive amount",
		"Sometimes addons can generate hundreds of errors within a second, which might lock up your entire user interface. Enabling this option will throttle the errors, so some of them will just get lost in the void, but they're usually identical anyway.",
		function(self, value)
			BugGrabber:UseThrottling(value)
		end)
	throttle:SetPoint("TOPLEFT", filter, "BOTTOMLEFT", 0, -8)
	throttle:SetChecked(BugGrabber:IsThrottling())

	local save = newCheckbox(
		"Save errors",
		"Saves the errors to the database. If this is off, errors will not persist in the sack from session to session.",
		function(self, value)
			BugGrabber:ToggleSave()
			self:SetChecked(BugGrabber:GetSave())
		end)
	save:SetPoint("TOPLEFT", throttle, "BOTTOMLEFT", 0, -16)
	save:SetChecked(BugGrabber:GetSave())
	local limit, limitLabel = newSlider("Limit", 10, MAX_BUGGRABBER_ERRORS or 1000)
	limitLabel:SetPoint("TOPLEFT", save, "BOTTOMLEFT", 0, -8)
	limit:SetValue(BugGrabber:GetLimit())
	limit:SetValueStep(50)
	limit:SetScript("OnValueChanged", function(self, value)
		BugGrabber:SetLimit(math.abs(value))
	end)
	local clear = CreateFrame("Button", "BugSackSaveButton", frame, "UIPanelButtonTemplate2")
	clear:SetText("Clear saved errors")
	clear:SetWidth(160)
	clear:SetPoint("TOPLEFT", limit, "BOTTOMLEFT", 0, -8)
	clear:SetScript("OnClick", function()
		BugSack:Reset()
	end)
	clear:SetScript("OnEnter", onControlEnter)
	clear:SetScript("OnLeave", onControlLeave)
	clear.label = "Clear saved errors"
	clear.description = "Wipes all saved errors from the database."
	
	frame:SetScript("OnShow", nil)
end)
InterfaceOptions_AddCategory(frame)

--[[

	[ ] Auto popup
	[ ] Chatframe output
	
	Sound    [               V ]
	
	[ ] Filter addon mistakes
	[ ] Throttle at excessive amount
	
	[ ] Save errors
	Limit [-----|--------------]
	[ Clear saved errors ]
	
]]

--[[function BugSack:OpenConfig()
	InterfaceOptionsFrame_OpenToCategory(frame)
end]]

