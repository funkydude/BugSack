local addonName, addon = ...
if not addon.healthCheck then return end
local L = addon.L

local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame.name = addonName
frame:Hide()

-- Credits to Ace3, Tekkub, cladhaire and Tuller for some of the widget stuff.

local function newCheckbox(label, description, onClick)
	local check = CreateFrame("CheckButton", "BugSackCheck" .. label, frame, "InterfaceOptionsCheckButtonTemplate")
	check:SetScript("OnClick", function(self)
		PlaySound(self:GetChecked() and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		onClick(self, self:GetChecked() and true or false)
	end)
	check.label = _G[check:GetName() .. "Text"]
	check.label:SetText(label)
	check.tooltipText = label
	check.tooltipRequirement = description
	return check
end

frame:SetScript("OnShow", function(frame)
	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(addonName)

	local subTitleWrapper = CreateFrame("Frame", nil, frame)
	subTitleWrapper:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	subTitleWrapper:SetPoint("RIGHT", -16, 0)
	local subtitle = subTitleWrapper:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	subtitle:SetPoint("TOPLEFT", subTitleWrapper)
	subtitle:SetWidth(subTitleWrapper:GetRight() - subTitleWrapper:GetLeft())
	subtitle:SetJustifyH("LEFT")
	subtitle:SetNonSpaceWrap(false)
	subtitle:SetJustifyV("TOP")
	subtitle:SetText("BugSack is a sack to stuff all your bugs in, and NOTHING ELSE! Don't think I don't know what you're up to, little schoolboy. Daddy was a little schoolboy, too.")
	subTitleWrapper:SetHeight(subtitle:GetHeight())

	local autoPopup = newCheckbox(
		L["Auto popup"],
		L.autoDesc,
		function(self, value) addon.db.auto = value end)
	autoPopup:SetChecked(addon.db.auto)
	autoPopup:SetPoint("TOPLEFT", subTitleWrapper, "BOTTOMLEFT", -2, -16)

	local chatFrame = newCheckbox(
		L["Chatframe output"],
		L.chatFrameDesc,
		function(self, value) addon.db.chatframe = value end)
	chatFrame:SetChecked(addon.db.chatframe)
	chatFrame:SetPoint("TOPLEFT", autoPopup, "BOTTOMLEFT", 0, -8)

	local icon = LibStub("LibDBIcon-1.0", true)
	local minimap
	if icon then
		minimap = newCheckbox(
			L["Minimap icon"],
			L.minimapDesc,
			function(self, value)
				BugSackLDBIconDB.hide = not value
				if BugSackLDBIconDB.hide then
					icon:Hide(addonName)
				else
					icon:Show(addonName)
				end
			end)
		minimap:SetPoint("TOPLEFT", chatFrame, "BOTTOMLEFT", 0, -8)
		minimap:SetChecked(not BugSackLDBIconDB.hide)
	end

	local filter = newCheckbox(
		L["Filter addon mistakes"],
		L.filterDesc,
		function(self, value)
			addon:ToggleFilter()
		end)
	filter:SetChecked(addon:GetFilter())
	filter:SetPoint("TOPLEFT", subTitleWrapper, "BOTTOMRIGHT", -176, -16)
	
	local throttle = newCheckbox(
		L["Throttle at excessive amount"],
		L.throttleDesc,
		function(self, value)
			BugGrabber:UseThrottling(value)
		end)
	throttle:SetPoint("TOPLEFT", filter, "BOTTOMLEFT", 0, -8)
	throttle:SetChecked(BugGrabber:IsThrottling())

	local media = addon:EnsureLSM3()
	-- Jeeeeesus christ dropdowns are funky!
	local sound = nil
	if media then
		sound = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		sound:SetPoint("TOPLEFT", minimap or chatFrame, "BOTTOMLEFT", 8, -24)
		sound:SetJustifyH("LEFT")
		sound:SetHeight(18)
		sound:SetWidth(70)
		sound:SetText(L["Sound"])
		local dropdown = CreateFrame("Frame", "BugSackSoundDropdown", frame, "UIDropDownMenuTemplate")
		dropdown:SetPoint("TOPLEFT", sound, "TOPRIGHT", 16, 3)
		local function itemOnClick(self)
			local selected = self.value
			addon.db.soundMedia = selected
			UIDropDownMenu_SetSelectedValue(dropdown, selected)
		end
		UIDropDownMenu_Initialize(dropdown, function()
			local info = UIDropDownMenu_CreateInfo()
			for idx, sound in next, media:List("sound") do
				info.text = sound
				info.value = sound
				info.func = itemOnClick
				info.checked = sound == addon.db.soundMedia
				UIDropDownMenu_AddButton(info)
			end
		end)
		UIDropDownMenu_SetSelectedValue(dropdown, addon.db.soundMedia)
		UIDropDownMenu_SetWidth(dropdown, 160)
		UIDropDownMenu_JustifyText(dropdown, "LEFT")
	else
		sound = newCheckbox(
			L["Mute"],
			L.muteDesc,
			function(self, value) addon.db.mute = value end)
		sound:SetChecked(addon.db.mute)
		sound:SetPoint("TOPLEFT", minimap or chatFrame, "BOTTOMLEFT", 0, -8)
	end

	local size = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	size:SetPoint("TOPLEFT", sound, "BOTTOMLEFT", media and 0 or 6, -24)
	size:SetJustifyH("LEFT")
	size:SetHeight(18)
	size:SetWidth(70)
	size:SetText(L["Font size"])
	local dropdown = CreateFrame("Frame", "BugSackFontSize", frame, "UIDropDownMenuTemplate")
	dropdown:SetPoint("TOPLEFT", size, "TOPRIGHT", 16, 3)
	local function itemOnClick(self)
		local selected = self.value
		addon.db.fontSize = selected
		if _G.BugSackFrameScrollText then
			_G.BugSackFrameScrollText:SetFontObject(_G[selected])
		end
		UIDropDownMenu_SetSelectedValue(dropdown, selected)
	end
	UIDropDownMenu_Initialize(dropdown, function()
		local info = UIDropDownMenu_CreateInfo()
		local fonts = {"GameFontHighlightSmall", "GameFontHighlight", "GameFontHighlightMedium", "GameFontHighlightLarge"}
		local names = {L["Small"], L["Medium"], L["Large"], L["X-Large"]}
		for i, font in next, fonts do
			info.text = names[i]
			info.value = font
			info.func = itemOnClick
			info.checked = font == addon.db.fontSize
			UIDropDownMenu_AddButton(info)
		end
	end)
	UIDropDownMenu_SetSelectedValue(dropdown, addon.db.fontSize)
	UIDropDownMenu_SetWidth(dropdown, 160)
	UIDropDownMenu_JustifyText(dropdown, "LEFT")

	local save = newCheckbox(
		L["Save errors"],
		L.saveDesc,
		function(self, value)
			BugGrabber:ToggleSave()
			self:SetChecked(BugGrabber:GetSave())
		end)
	save:SetPoint("TOPLEFT", size, "BOTTOMLEFT", -6, -24)
	save:SetChecked(BugGrabber:GetSave())

	local clear = CreateFrame("Button", "BugSackSaveButton", frame, "UIPanelButtonTemplate2")
	clear:SetText(L["Wipe saved bugs"])
	clear:SetWidth(177)
	clear:SetPoint("TOP", save, "TOP")
	clear:SetPoint("LEFT", save.label, "RIGHT", 24, 0)
	clear:SetScript("OnClick", function()
		addon:Reset()
	end)
	clear.tooltipText = L["Wipe saved bugs"]
	clear.newbieText = L.wipeDesc

	local sliderLabel = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	sliderLabel:SetJustifyH("LEFT")
	sliderLabel:SetText(L["Limit"])
	sliderLabel:SetWidth(70)
	sliderLabel:SetPoint("TOPLEFT", save, "BOTTOMLEFT", 8, -20)

	local slider = CreateFrame("Slider", "BugSackLimitSlider", frame, "OptionsSliderTemplate")
	local sliderValue = _G.BugSackLimitSliderText
	sliderValue:SetText(BugGrabber:GetLimit())
	slider:SetHeight(17)
	slider:SetWidth(175)
	slider:SetMinMaxValues(10, MAX_BUGGRABBER_ERRORS or 1000)
	slider:SetValue(BugGrabber:GetLimit())
	slider:SetValueStep(20)
	slider:SetScript("OnValueChanged", function(self, value)
		local v = math.abs(value)
		BugGrabber:SetLimit(v)
		sliderValue:SetText(v)
	end)
	slider:SetPoint("LEFT", sliderLabel, "RIGHT", 32, 0)

	frame:SetScript("OnShow", nil)
end)
InterfaceOptions_AddCategory(frame)

