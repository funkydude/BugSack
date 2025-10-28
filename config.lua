local addonName, addon = ...
if not addon.healthCheck then
	return
end
local L = addon.L
local ldbi = LibStub("LibDBIcon-1.0")

local category, layout = Settings.RegisterVerticalLayoutCategory(addonName)
addon.settingsCategory = category

local function InitializeSettings()
	-- Auto popup setting
	local autoPopupSetting = Settings.RegisterAddOnSetting(
		category,
		"BUGSACK_AUTO_POPUP",
		"auto",
		addon.db,
		Settings.VarType.Boolean,
		L["Auto popup"],
		Settings.Default.False
	)
	Settings.CreateCheckbox(category, autoPopupSetting, L.autoDesc)

	-- Chatframe output setting
	local chatFrameSetting = Settings.RegisterAddOnSetting(
		category,
		"BUGSACK_CHATFRAME_OUTPUT",
		"chatframe",
		addon.db,
		Settings.VarType.Boolean,
		L["Chatframe output"],
		Settings.Default.False
	)
	Settings.CreateCheckbox(category, chatFrameSetting, L.chatFrameDesc)

	-- Minimap icon setting
	local function GetMinimapValue()
		return not BugSackLDBIconDB.hide
	end

	local function SetMinimapValue(value)
		BugSackLDBIconDB.hide = not value
		if BugSackLDBIconDB.hide then
			ldbi:Hide(addonName)
		else
			ldbi:Show(addonName)
		end
	end

	local minimapSetting = Settings.RegisterProxySetting(
		category,
		"BUGSACK_MINIMAP_ICON",
		Settings.VarType.Boolean,
		L["Minimap icon"],
		Settings.Default.True,
		GetMinimapValue,
		SetMinimapValue
	)
	Settings.CreateCheckbox(category, minimapSetting, L.minimapDesc)

	-- Addon compartment setting (if available)
	if ldbi:IsButtonCompartmentAvailable() then
		local function GetCompartmentValue()
			return ldbi:IsButtonInCompartment("BugSack")
		end

		local function SetCompartmentValue(value)
			if value then
				ldbi:AddButtonToCompartment("BugSack")
			else
				ldbi:RemoveButtonFromCompartment("BugSack")
			end
		end

		local compartmentSetting = Settings.RegisterProxySetting(
			category,
			"BUGSACK_ADDON_COMPARTMENT",
			Settings.VarType.Boolean,
			L.addonCompartment,
			Settings.Default.False,
			GetCompartmentValue,
			SetCompartmentValue
		)
		Settings.CreateCheckbox(category, compartmentSetting, L.addonCompartment_desc)
	end

	-- Mute setting
	local muteSetting = Settings.RegisterAddOnSetting(
		category,
		"BUGSACK_MUTE",
		"mute",
		addon.db,
		Settings.VarType.Boolean,
		L["Mute"],
		Settings.Default.False
	)
	Settings.CreateCheckbox(category, muteSetting, L.muteDesc)

	-- Font size setting
	local function GetFontSizeValue()
		local fonts =
			{ "GameFontHighlightSmall", "GameFontHighlight", "GameFontHighlightMedium", "GameFontHighlightLarge" }
		for i, font in next, fonts do
			if font == addon.db.fontSize then
				return i
			end
		end
		return 2 -- Default to Medium
	end

	local function SetFontSizeValue(value)
		local fonts =
			{ "GameFontHighlightSmall", "GameFontHighlight", "GameFontHighlightMedium", "GameFontHighlightLarge" }
		addon.db.fontSize = fonts[value]
		if _G.BugSackScrollText then
			_G.BugSackScrollText:SetFontObject(_G[fonts[value]])
		end
	end

	local function GetFontSizeOptions()
		local container = Settings.CreateControlTextContainer()
		local names = { L["Small"], L["Medium"], L["Large"], L["X-Large"] }
		for i, name in next, names do
			container:Add(i, name)
		end
		return container:GetData()
	end

	local fontSizeSetting = Settings.RegisterProxySetting(
		category,
		"BUGSACK_FONT_SIZE",
		Settings.VarType.Number,
		L["Font size"],
		2,
		GetFontSizeValue,
		SetFontSizeValue
	)
	Settings.CreateDropdown(category, fontSizeSetting, GetFontSizeOptions)

	-- Custom sound dropdown with scrolling support
	local function GetSoundValue()
		return addon.db.soundMedia or "BugSack: Fatality"
	end

	local function SetSoundValue(value)
		addon.db.soundMedia = value
	end

	local function IsSoundSelected(sound)
		return addon.db.soundMedia == sound
	end

	local soundSetting = Settings.RegisterProxySetting(
		category,
		"BUGSACK_SOUND",
		Settings.VarType.String,
		L["Sound"],
		"BugSack: Fatality",
		GetSoundValue,
		SetSoundValue
	)

	-- Create custom sound dropdown initializer with scrolling
	local BugSackSoundDropdownInitializer = CreateFromMixins(
		ScrollBoxFactoryInitializerMixin,
		SettingsElementHierarchyMixin,
		SettingsSearchableElementMixin
	)

	function BugSackSoundDropdownInitializer:Init()
		ScrollBoxFactoryInitializerMixin.Init(self, "SettingsListElementTemplate")
		self.data = {
			name = L["Sound"],
			tooltip = L["Sound"],
		}
		self:AddSearchTags(L["Sound"])
	end

	function BugSackSoundDropdownInitializer:GetExtent()
		return 26 -- Height of the control
	end

	function BugSackSoundDropdownInitializer:InitFrame(frame)
		-- Set frame size
		frame:SetSize(280, 26)

		-- Initialize the SettingsListElementMixin properly
		if not frame.cbrHandles then
			frame.cbrHandles = Settings.CreateCallbackHandleContainer()
		end

		-- Set up the standard element display
		frame.data = self.data
		frame.Text:SetFontObject("GameFontNormal")
		frame.Text:SetText(L["Sound"])
		frame.Text:SetPoint("LEFT", 37, 0)
		frame.Text:SetPoint("RIGHT", frame, "CENTER", -85, 0)

		-- Update button text function
		local function UpdateDropdownText()
			if frame.soundDropdown then
				frame.soundDropdown:OverrideText(GetSoundValue())
			end
		end

		-- sound preview button
		if not frame.previewButton then
			frame.previewButton = CreateFrame("Button", nil, frame)
			frame.previewButton:SetSize(20, 20)
			frame.previewButton:SetPoint("LEFT", frame, "CENTER", -74, 0)
			frame.previewButton:SetHeight(26)

			local previewIcon = frame.previewButton:CreateTexture(nil, "ARTWORK")
			previewIcon:SetAllPoints()
			previewIcon:SetTexture("Interface\\Common\\VoiceChat-Speaker")
			previewIcon:SetVertexColor(0.8, 0.8, 0.8)

			frame.previewButton:SetScript("OnEnter", function(control)
				previewIcon:SetVertexColor(1, 1, 1)
				GameTooltip:SetOwner(control, "ANCHOR_TOP")
				GameTooltip:SetText(L["Preview Sound"])
				GameTooltip:Show()
			end)

			frame.previewButton:SetScript("OnLeave", function(control)
				previewIcon:SetVertexColor(0.8, 0.8, 0.8)
				GameTooltip:Hide()
			end)

			-- Play current sound on click
			frame.previewButton:SetScript("OnClick", function(control)
				local media = LibStub("LibSharedMedia-3.0")
				local currentSound = GetSoundValue()
				local soundFile = media:Fetch("sound", currentSound)
				if soundFile then
					if addon.db.useMaster then
						PlaySoundFile(soundFile, "Master")
					else
						PlaySoundFile(soundFile)
					end
				end
			end)
		end

		if not frame.soundDropdown then
			frame.soundDropdown = CreateFrame("DropdownButton", nil, frame, "WowStyle1DropdownTemplate")
			frame.soundDropdown:SetPoint("LEFT", frame.previewButton, "RIGHT", 5, 0)
			frame.soundDropdown:SetPoint("RIGHT", frame, "RIGHT", -20, 0)
			frame.soundDropdown:SetHeight(26)

			-- Setup menu with scrolling
			frame.soundDropdown:SetupMenu(function(dropdown, rootDescription)
				rootDescription:SetScrollMode(200)

				local sounds = LibStub("LibSharedMedia-3.0"):List("sound")
				for _, sound in next, sounds do
					local function OnSelection(soundValue)
						SetSoundValue(soundValue)
						UpdateDropdownText()
					end
					rootDescription:CreateRadio(sound, IsSoundSelected, OnSelection, sound)
				end
			end)
		end

		-- Initial text update
		UpdateDropdownText()

		-- Register callback for external changes
		frame.cbrHandles:SetOnValueChangedCallback(soundSetting:GetVariable(), UpdateDropdownText)
	end

	function BugSackSoundDropdownInitializer:Resetter(frame)
		if frame.cbrHandles then
			frame.cbrHandles:Unregister()
		end
	end

	-- Create and add the initializer
	local customSoundInitializer = CreateFromMixins(BugSackSoundDropdownInitializer)
	customSoundInitializer:Init()
	layout:AddInitializer(customSoundInitializer)

	-- Use Master sound channel setting
	local masterSetting = Settings.RegisterAddOnSetting(
		category,
		"BUGSACK_USE_MASTER",
		"useMaster",
		addon.db,
		Settings.VarType.Boolean,
		L.useMaster,
		Settings.Default.False
	)
	Settings.CreateCheckbox(category, masterSetting, L.useMasterDesc)

	-- Alt-click wipe setting
	local altWipeSetting = Settings.RegisterAddOnSetting(
		category,
		"BUGSACK_ALT_WIPE",
		"altwipe",
		addon.db,
		Settings.VarType.Boolean,
		L["Minimap icon alt-click wipe"],
		Settings.Default.False
	)
	Settings.CreateCheckbox(category, altWipeSetting, L.altWipeDesc)

	local wipeButtonInitializer = CreateSettingsButtonInitializer(
		L["Wipe saved bugs"], -- name
		L["Wipe saved bugs"], -- buttonText
		function()
			addon:Reset()
		end, -- buttonClick
		L.wipeDesc, -- tooltip
		true, -- addSearchTags
		nil, -- newTagID
		nil -- gameDataFunc
	)

	local addonLayout = SettingsPanel:GetLayout(category)
	addonLayout:AddInitializer(wipeButtonInitializer)

	Settings.RegisterAddOnCategory(category)
end

addon.InitializeSettings = InitializeSettings
