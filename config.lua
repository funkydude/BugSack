
local addonName, addon = ...
if not addon.healthCheck then return end
local L = addon.L

local frame = addon.frame
frame.name = addonName
frame:Hide()
local ldbi = LibStub("LibDBIcon-1.0")

frame:SetScript("OnShow", function(frame)
	local function newCheckbox(label, description, onClick)
		local check = CreateFrame("CheckButton", "BugSackCheck" .. label, frame, "InterfaceOptionsCheckButtonTemplate")
		check:SetScript("OnClick", function(self)
			local tick = self:GetChecked()
			onClick(self, tick and true or false)
			if tick then
				PlaySound(856) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
			else
				PlaySound(857) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
			end
		end)
		check.label = _G[check:GetName() .. "Text"]
		check.label:SetText(label)
		check.tooltipText = label
		check.tooltipRequirement = description
		return check
	end

	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(addonName)

	local autoPopup = newCheckbox(
		L["Auto popup"],
		L.autoDesc,
		function(self, value) addon.db.auto = value end)
	autoPopup:SetChecked(addon.db.auto)
	autoPopup:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -2, -16)

	local chatFrame = newCheckbox(
		L["Chatframe output"],
		L.chatFrameDesc,
		function(self, value) addon.db.chatframe = value end)
	chatFrame:SetChecked(addon.db.chatframe)
	chatFrame:SetPoint("TOPLEFT", autoPopup, "BOTTOMLEFT", 0, -8)

	local minimap = newCheckbox(
		L["Minimap icon"],
		L.minimapDesc,
		function(self, value)
			BugSackLDBIconDB.hide = not value
			if BugSackLDBIconDB.hide then
				ldbi:Hide(addonName)
			else
				ldbi:Show(addonName)
			end
		end)
	minimap:SetPoint("TOPLEFT", chatFrame, "BOTTOMLEFT", 0, -8)
	minimap:SetChecked(not BugSackLDBIconDB.hide)

	if ldbi:IsButtonCompartmentAvailable() then
		local addonCompartment = newCheckbox(
			L.addonCompartment,
			L.addonCompartment_desc,
			function(self, value)
				if value then
					ldbi:AddButtonToCompartment("BugSack")
				else
					ldbi:RemoveButtonFromCompartment("BugSack")
				end
			end)
		addonCompartment:SetPoint("LEFT", minimap, "RIGHT", 150, 0)
		addonCompartment:SetChecked(ldbi:IsButtonInCompartment("BugSack"))
	end

	local mute = newCheckbox(
		L["Mute"],
		L.muteDesc,
		function(self, value) addon.db.mute = value end)
	mute:SetChecked(addon.db.mute)
	mute:SetPoint("TOPLEFT", minimap, "BOTTOMLEFT", 0, -8)

	local info = {}
	local fontSizeDropdown = CreateFrame("Frame", "BugSackFontSize", frame, "UIDropDownMenuTemplate")
	fontSizeDropdown:SetPoint("TOPLEFT", mute, "BOTTOMLEFT", -15, -10)
	fontSizeDropdown.initialize = function()
		wipe(info)
		local fonts = {"GameFontHighlightSmall", "GameFontHighlight", "GameFontHighlightMedium", "GameFontHighlightLarge"}
		local names = {L["Small"], L["Medium"], L["Large"], L["X-Large"]}
		for i, font in next, fonts do
			info.text = names[i]
			info.value = font
			info.func = function(self)
				addon.db.fontSize = self.value
				if _G.BugSackFrameScrollText then
					_G.BugSackFrameScrollText:SetFontObject(_G[self.value])
				end
				BugSackFontSizeText:SetText(self:GetText())
			end
			info.checked = font == addon.db.fontSize
			UIDropDownMenu_AddButton(info)
		end
	end
	BugSackFontSizeText:SetText(L["Font size"])

	local soundDropdown = CreateFrame("Frame", "BugSackSoundDropdown", frame, "UIDropDownMenuTemplate")
	soundDropdown:SetPoint("LEFT", fontSizeDropdown, "RIGHT", 150, 0)
	soundDropdown.initialize = function()
		wipe(info)
		for _, sound in next, LibStub("LibSharedMedia-3.0"):List("sound") do
			info.text = sound
			info.value = sound
			info.func = function(self)
				addon.db.soundMedia = self.value
				soundDropdown.Text:SetText(self:GetText())
			end
			info.checked = sound == addon.db.soundMedia
			UIDropDownMenu_AddButton(info)
		end
	end
	soundDropdown.Text:SetText(L["Sound"])

	local master = newCheckbox(
		L.useMaster,
		L.useMasterDesc,
		function(self, value) addon.db.useMaster = value end)
		master:SetChecked(addon.db.useMaster)
		master:SetPoint("LEFT", soundDropdown, "RIGHT", 140, 0)

	local clear = CreateFrame("Button", "BugSackSaveButton", frame, "UIPanelButtonTemplate")
	clear:SetText(L["Wipe saved bugs"])
	clear:SetWidth(177)
	clear:SetHeight(24)
	clear:SetPoint("TOPLEFT", fontSizeDropdown, "BOTTOMLEFT", 17, -25)
	clear:SetScript("OnClick", function()
		addon:Reset()
	end)
	clear.tooltipText = L["Wipe saved bugs"]
	clear.newbieText = L.wipeDesc

	local altWipe = newCheckbox(
		L["Minimap icon alt-click wipe"],
		L.altWipeDesc,
		function(self, value) addon.db.altwipe = value end)
	altWipe:SetChecked(addon.db.altwipe)
	altWipe:SetPoint("LEFT", clear, "RIGHT", 10, 0)

	frame:SetScript("OnShow", nil)
end)
InterfaceOptions_AddCategory(frame)

