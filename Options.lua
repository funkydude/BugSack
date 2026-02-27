local addonName, addon = ...
if not addon.healthCheck then
    return
end
local L = addon.L
local dataBrokerIcon = LibStub("LibDBIcon-1.0")

local category, layout = Settings.RegisterVerticalLayoutCategory(addonName)
addon.settingsCategory = category

local function InitializeSettings()
    local addonLayout = SettingsPanel:GetLayout(category)

    local autoPopupSetting =
        Settings.RegisterAddOnSetting(
        category,
        "BUGSACK_AUTO_POPUP",
        "auto",
        addon.db,
        Settings.VarType.Boolean,
        L["Options.EnablePopup"],
        Settings.Default.False
    )
    Settings.CreateCheckbox(category, autoPopupSetting, L["Options.EnablePopupDesc"])

    local chatFrameSetting =
        Settings.RegisterAddOnSetting(
        category,
        "BUGSACK_CHATFRAME_OUTPUT",
        "chatframe",
        addon.db,
        Settings.VarType.Boolean,
        L["Options.EnablePrintMessages"],
        Settings.Default.False
    )
    Settings.CreateCheckbox(category, chatFrameSetting, L["Options.EnablePrintMessagesDesc"])

    local function GetMinimapValue()
        return not BugSackLDBIconDB.hide
    end
    local function SetMinimapValue(value)
        BugSackLDBIconDB.hide = not value
        if BugSackLDBIconDB.hide then
            dataBrokerIcon:Hide(addonName)
        else
            dataBrokerIcon:Show(addonName)
        end
    end

    local minimapSetting =
        Settings.RegisterProxySetting(
        category,
        "BUGSACK_MINIMAP_ICON",
        Settings.VarType.Boolean,
        L["Options.EnableMinimapButton"],
        Settings.Default.True,
        GetMinimapValue,
        SetMinimapValue
    )
    Settings.CreateCheckbox(category, minimapSetting, L["Options.EnableMinimapButtonDesc"])

    local compartmentSetting
    if dataBrokerIcon:IsButtonCompartmentAvailable() then
        local function GetCompartmentValue()
            return dataBrokerIcon:IsButtonInCompartment("BugSack")
        end
        local function SetCompartmentValue(value)
            if value then
                dataBrokerIcon:AddButtonToCompartment("BugSack")
            else
                dataBrokerIcon:RemoveButtonFromCompartment("BugSack")
            end
        end

        compartmentSetting =
            Settings.RegisterProxySetting(
            category,
            "BUGSACK_ADDON_COMPARTMENT",
            Settings.VarType.Boolean,
            L["Options.AddonCompartment"],
            Settings.Default.False,
            GetCompartmentValue,
            SetCompartmentValue
        )
        Settings.CreateCheckbox(category, compartmentSetting, L["Options.AddonCompartmentDesc"])
    end

    local soundEffectsSetting =
        Settings.RegisterAddOnSetting(
        category,
        "BUGSACK_SOUND_EFFECTS",
        "soundEffects",
        addon.db,
        Settings.VarType.Boolean,
        L["Options.EnableSoundEffects"],
        Settings.Default.True
    )
    Settings.CreateCheckbox(category, soundEffectsSetting, L["Options.EnableSoundEffectsDesc"])

    local function GetSoundValue()
        return addon.db.soundMedia or "BugSack: Fatality"
    end
    local function SetSoundValue(value)
        addon.db.soundMedia = value
    end
    local function IsSoundSelected(sound)
        return addon.db.soundMedia == sound
    end

    local soundSetting =
        Settings.RegisterProxySetting(
        category,
        "BUGSACK_SOUND",
        Settings.VarType.String,
        L["Options.Sound"],
        "BugSack: Fatality",
        GetSoundValue,
        SetSoundValue
    )

    local BugSackSoundDropdownInitializer =
        CreateFromMixins(
        ScrollBoxFactoryInitializerMixin,
        SettingsElementHierarchyMixin,
        SettingsSearchableElementMixin
    )

    function BugSackSoundDropdownInitializer:Init()
        ScrollBoxFactoryInitializerMixin.Init(self, "SettingsListElementTemplate")
        self.data = {name = L["Options.Sound"], tooltip = L["Options.Sound"]}
        self:AddSearchTags(L["Options.Sound"])
    end

    function BugSackSoundDropdownInitializer:GetExtent()
        return 26
    end

    function BugSackSoundDropdownInitializer:InitFrame(frame)
        frame:SetSize(280, 26)

        if not frame.cbrHandles then
            frame.cbrHandles = Settings.CreateCallbackHandleContainer()
        end

        frame.data = self.data
        frame.Text:SetFontObject("GameFontNormal")
        frame.Text:SetText(L["Options.Sound"])
        frame.Text:SetPoint("LEFT", 37, 0)
        frame.Text:SetPoint("RIGHT", frame, "CENTER", -85, 0)

        local function UpdateDropdownText()
            if frame.soundDropdown then
                frame.soundDropdown:OverrideText(GetSoundValue())
            end
        end

        if not frame.previewButton then
            frame.previewButton = CreateFrame("Button", nil, frame)
            frame.previewButton:SetSize(20, 20)
            frame.previewButton:SetPoint("LEFT", frame, "CENTER", -74, 0)
            frame.previewButton:SetHeight(26)

            local previewIcon = frame.previewButton:CreateTexture(nil, "ARTWORK")
            previewIcon:SetAllPoints()
            previewIcon:SetTexture("Interface\\Common\\VoiceChat-Speaker")
            previewIcon:SetVertexColor(0.8, 0.8, 0.8)

            frame.previewButton:SetScript(
                "OnEnter",
                function(control)
                    previewIcon:SetVertexColor(1, 1, 1)
                    GameTooltip:SetOwner(control, "ANCHOR_TOP")
                    GameTooltip:SetText(L["Options.SoundPreview"])
                    GameTooltip:Show()
                end
            )
            frame.previewButton:SetScript(
                "OnLeave",
                function(control)
                    previewIcon:SetVertexColor(0.8, 0.8, 0.8)
                    GameTooltip:Hide()
                end
            )
            frame.previewButton:SetScript(
                "OnClick",
                function(control)
                    local media = LibStub("LibSharedMedia-3.0")
                    local soundFile = media:Fetch("sound", GetSoundValue())
                    if soundFile then
                        if addon.db.useMaster then
                            PlaySoundFile(soundFile, "Master")
                        else
                            PlaySoundFile(soundFile)
                        end
                    end
                end
            )
        end

        if not frame.soundDropdown then
            frame.soundDropdown = CreateFrame("DropdownButton", nil, frame, "WowStyle1DropdownTemplate")
            frame.soundDropdown:SetPoint("LEFT", frame.previewButton, "RIGHT", 5, 0)
            frame.soundDropdown:SetPoint("RIGHT", frame, "RIGHT", -20, 0)
            frame.soundDropdown:SetHeight(26)

            frame.soundDropdown:SetupMenu(
                function(dropdown, rootDescription)
                    rootDescription:SetScrollMode(200)
                    local sounds = LibStub("LibSharedMedia-3.0"):List("sound")
                    for _, soundName in ipairs(sounds) do
                        local function OnSelection(selectedSound)
                            SetSoundValue(selectedSound)
                            UpdateDropdownText()
                        end
                        rootDescription:CreateRadio(soundName, IsSoundSelected, OnSelection, soundName)
                    end
                end
            )
        end

        UpdateDropdownText()
        frame.cbrHandles:SetOnValueChangedCallback(soundSetting:GetVariable(), UpdateDropdownText)
    end

    function BugSackSoundDropdownInitializer:Resetter(frame)
        if frame.cbrHandles then
            frame.cbrHandles:Unregister()
        end
    end

    local customSoundInitializer = CreateFromMixins(BugSackSoundDropdownInitializer)
    customSoundInitializer:Init()
    layout:AddInitializer(customSoundInitializer)

    local masterChannelSetting =
        Settings.RegisterAddOnSetting(
        category,
        "BUGSACK_USE_MASTER",
        "useMaster",
        addon.db,
        Settings.VarType.Boolean,
        L["Options.UseMaster"],
        Settings.Default.False
    )
    Settings.CreateCheckbox(category, masterChannelSetting, L["Options.UseMasterDesc"])

    local fontSizeNames = {
        "GameFontHighlightSmall",
        "GameFontHighlight",
        "GameFontHighlightMedium",
        "GameFontHighlightLarge"
    }

    local function GetFontSizeValue()
        for index, fontName in ipairs(fontSizeNames) do
            if fontName == addon.db.fontSize then
                return index
            end
        end
        return 2
    end

    local function SetFontSizeValue(value)
        addon.db.fontSize = fontSizeNames[value]
        if _G.BugSackScrollText then
            _G.BugSackScrollText:SetFontObject(_G[fontSizeNames[value]])
        end
    end

    local function GetFontSizeOptions()
        local container = Settings.CreateControlTextContainer()
        local displayNames = {L["FontSize.Small"], L["FontSize.Medium"], L["FontSize.Large"], L["FontSize.XLarge"]}
        for index, displayName in ipairs(displayNames) do
            container:Add(index, displayName)
        end
        return container:GetData()
    end

    local fontSizeSetting =
        Settings.RegisterProxySetting(
        category,
        "BUGSACK_FONT_SIZE",
        Settings.VarType.Number,
        L["Options.BugWindowFontSize"],
        2,
        GetFontSizeValue,
        SetFontSizeValue
    )
    Settings.CreateDropdown(category, fontSizeSetting, GetFontSizeOptions)

    local wipeButtonInitializer =
        CreateSettingsButtonInitializer(
        L["Options.EraseBugs"],
        L["Options.EraseBugs"],
        function()
            addon:Reset()
        end,
        L["Options.EraseBugsDesc"],
        true
    )
    addonLayout:AddInitializer(wipeButtonInitializer)

    local defaultsButtonInitializer =
        CreateSettingsButtonInitializer(
        L["Options.RestoreDefaults"],
        L["Options.RestoreDefaults"],
        function()
            autoPopupSetting:SetValue(false)
            chatFrameSetting:SetValue(false)
            minimapSetting:SetValue(true)
            if compartmentSetting then
                compartmentSetting:SetValue(false)
            end
            soundEffectsSetting:SetValue(true)
            soundSetting:SetValue("BugSack: Fatality")
            masterChannelSetting:SetValue(false)
            fontSizeSetting:SetValue(2)
        end,
        L["Options.RestoreDefaultsDesc"],
        true
    )
    addonLayout:AddInitializer(defaultsButtonInitializer)

    Settings.RegisterAddOnCategory(category)
end

addon.InitializeSettings = InitializeSettings