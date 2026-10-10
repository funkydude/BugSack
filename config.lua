local addonName, addon = ...
if not addon.healthCheck then
	return
end
local L = addon.L
local ldbi = LibStub("LibDBIcon-1.0")
local media = LibStub("LibSharedMedia-3.0")
-- Checkboxes toggle addon.db[key], unless a getter and setter are given
local function CreateCheckbox(parent, anchor, label, tooltip, key, getter, setter)
	getter = getter or function() return addon.db[key] end
	setter = setter or function(value) addon.db[key] = value end

	local check = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
	check:SetSize(26, 26)
	check:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -2)
	check.Text:SetText(label)
	check:SetHitRectInsets(0, -check.Text:GetStringWidth() - 4, 0, 0)

	check:SetScript("OnClick", function(self)
		setter(self:GetChecked() and true or false)
	end)
	check:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(label)
		GameTooltip:AddLine(tooltip, 1, 1, 1, 1)
		GameTooltip:Show()
	end)
	check:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	check:SetScript("OnShow", function(self)
		self:SetChecked(getter())
	end)
	return check
end

local function CreateDropdown(parent, anchor, label)
	local row = CreateFrame("Frame", nil, parent)
	row:SetSize(340, 26)
	row:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -8)

	local text = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	text:SetPoint("LEFT", 4, 0)
	text:SetText(label)

	local dropdown = CreateFrame("DropdownButton", nil, row, "WowStyle1DropdownTemplate")
	dropdown:SetPoint("RIGHT")
	dropdown:SetWidth(200)
	return row, dropdown
end

function addon:CreateOptionsTab(parent)
	local anchor = CreateFrame("Frame", nil, parent)
	anchor:SetSize(1, 1)
	anchor:SetPoint("TOPLEFT", 8, 0)

	-- Auto popup setting
	local last = CreateCheckbox(parent, anchor, L["Auto popup"], L.autoDesc, "auto")

	-- Chatframe output setting
	last = CreateCheckbox(parent, last, L["Chatframe output"], L.chatFrameDesc, "chatframe")

	-- Minimap icon setting
	last = CreateCheckbox(parent, last, L["Minimap icon"], L.minimapDesc, nil, function()
		return not BugSackLDBIconDB.hide
	end, function(value)
		BugSackLDBIconDB.hide = not value
		if BugSackLDBIconDB.hide then
			ldbi:Hide(addonName)
		else
			ldbi:Show(addonName)
		end
	end)

	-- Addon compartment setting (if available)
	if ldbi:IsButtonCompartmentAvailable() then
		last = CreateCheckbox(parent, last, L.addonCompartment, L.addonCompartment_desc, nil, function()
			return ldbi:IsButtonInCompartment("BugSack")
		end, function(value)
			if value then
				ldbi:AddButtonToCompartment("BugSack")
			else
				ldbi:RemoveButtonFromCompartment("BugSack")
			end
		end)
	end

	-- Mute setting
	last = CreateCheckbox(parent, last, L["Mute"], L.muteDesc, "mute")

	-- Use Master sound channel setting
	last = CreateCheckbox(parent, last, L.useMaster, L.useMasterDesc, "useMaster")

	-- Alt-click wipe setting
	last = CreateCheckbox(parent, last, L["Minimap icon alt-click wipe"], L.altWipeDesc, "altwipe")

	-- Font size and sound go in a column on the right
	local rightAnchor = CreateFrame("Frame", nil, parent)
	rightAnchor:SetSize(1, 1)
	rightAnchor:SetPoint("TOPLEFT", parent, "TOP", -60, 0)

	-- Font size setting
	local fonts = { "GameFontHighlightSmall", "GameFontHighlight", "GameFontHighlightMedium", "GameFontHighlightLarge" }
	local names = { L["Small"], L["Medium"], L["Large"], L["X-Large"] }
	local fontRow, fontDropdown = CreateDropdown(parent, rightAnchor, L["Font size"])
	fontDropdown:SetupMenu(function(dropdown, rootDescription)
		for i, name in next, names do
			rootDescription:CreateRadio(name, function()
				return addon.db.fontSize == fonts[i]
			end, function()
				addon.db.fontSize = fonts[i]
				if _G.BugSackScrollText then
					_G.BugSackScrollText:SetFontObject(_G[fonts[i]])
				end
			end)
		end
	end)

	-- Sound dropdown with scrolling support
	local soundRow, soundDropdown = CreateDropdown(parent, fontRow, L["Sound"])
	soundDropdown:SetupMenu(function(dropdown, rootDescription)
		rootDescription:SetScrollMode(200)
		for _, sound in next, media:List("sound") do
			rootDescription:CreateRadio(sound, function()
				return addon.db.soundMedia == sound
			end, function()
				addon.db.soundMedia = sound
			end)
		end
	end)

	-- Sound preview button
	local previewButton = CreateFrame("Button", nil, soundRow)
	previewButton:SetSize(20, 20)
	previewButton:SetPoint("RIGHT", soundDropdown, "LEFT", -6, 0)

	local previewIcon = previewButton:CreateTexture(nil, "ARTWORK")
	previewIcon:SetAllPoints()
	previewIcon:SetTexture("Interface\\Common\\VoiceChat-Speaker")
	previewIcon:SetVertexColor(0.8, 0.8, 0.8)

	previewButton:SetScript("OnEnter", function(control)
		previewIcon:SetVertexColor(1, 1, 1)
		GameTooltip:SetOwner(control, "ANCHOR_TOP")
		GameTooltip:SetText(L["Preview Sound"])
		GameTooltip:Show()
	end)
	previewButton:SetScript("OnLeave", function(control)
		previewIcon:SetVertexColor(0.8, 0.8, 0.8)
		GameTooltip:Hide()
	end)

	-- Play current sound on click
	previewButton:SetScript("OnClick", function(control)
		local soundFile = media:Fetch("sound", addon.db.soundMedia)
		if soundFile then
			if addon.db.useMaster then
				PlaySoundFile(soundFile, "Master")
			else
				PlaySoundFile(soundFile)
			end
		end
	end)
end

local function InitializeBlizzSettings()
	-- The interface options panel only holds a button that opens the Options tab of the sack
	local panel = CreateFrame("Frame")

	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(addonName)

	local open = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	open:SetSize(160, 26)
	open:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -12)
	open:SetText(L["Open BugSack"])
	open:SetScript("OnClick", function()
		addon:OpenConfig()
	end)

	local category = Settings.RegisterCanvasLayoutCategory(panel, addonName)
	addon.settingsCategory = category
	Settings.RegisterAddOnCategory(category)
end

addon.InitializeBlizzSettings = InitializeBlizzSettings
