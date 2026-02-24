local addonName, addon = ...

-----------------------------------------------------------------------
-- Colors & Formatting
-----------------------------------------------------------------------

addon.colors = {
    blue = "#ff8888ff",
    darkOrange = "#ffff9100",
    gray = "#ff808080",
    green = "#ff44ff44",
    lightBlue = "#ff00BBFF",
    lightGray = "#ffaaaaaa",
    lightGreen = "#ff00ff00",
    lightRed = "#ffff7f7f",
    lightYellow = "#ffffff80",
    orange = "#ffeda55f",
    pink = "#ffff7fff",
    prefix = "#ff259054",
    red = "#ffff4411",
    white = "#ffffffff",
    yellow = "#ffffea00",
}

function addon:Colorize(text, hexColor)
    local rawHex = hexColor:gsub("#", "")
    if #rawHex == 6 then
        rawHex = "ff" .. rawHex
    end
    return "|c" .. rawHex .. text .. "|r"
end

local function print(msg)
    local prefix = addon:Colorize("BugSack", addon.colors.lightBlue) .. addon:Colorize(" // ", addon.colors.lightGray)
    _G.print(prefix .. addon:Colorize(tostring(msg), addon.colors.white))
end

if not LibStub then
    print("BugSack requires LibStub.")
    return
end

local L = addon.L
if not BugGrabber then
    local warningMessage =
        addon:Colorize(
        L["ErrorMessage.RequireGrabber"]:format(addon:Colorize("!BugGrabber", addon.colors.green)),
        addon.colors.red
    )
    local warningFrame = CreateFrame("Frame")
    warningFrame:SetScript(
        "OnEvent",
        function()
            RaidNotice_AddMessage(RaidWarningFrame, warningMessage, {r = 1, g = 0.3, b = 0.1})
            print(warningMessage)
            warningFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
            warningFrame:SetScript("OnEvent", nil)
            warningFrame = nil
        end
    )
    warningFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    return
end

_G[addonName] = addon
addon.healthCheck = true

local sharedMedia = LibStub("LibSharedMedia-3.0")
sharedMedia:Register("sound", "BugSack: Fatality", "Interface\\AddOns\\" .. addonName .. "\\Media\\error.ogg")

addon.ICON_GREEN = 133642
addon.ICON_RED = 133643

-----------------------------------------------------------------------
-- Event Handling
-----------------------------------------------------------------------

local onError
do
    local lastErrorTime = nil
    function onError(event, errorObject)
        if not lastErrorTime or GetTime() > (lastErrorTime + 2) then
            if addon.db.soundEffects then
                local soundFile = sharedMedia:Fetch("sound", addon.db.soundMedia)
                if addon.db.useMaster then
                    PlaySoundFile(soundFile, "Master")
                else
                    PlaySoundFile(soundFile)
                end
            end
            if addon.db.chatframe then
                if not errorObject then
                    local errors = addon:GetErrors(BugGrabber:GetSessionId())
                    errorObject = errors and errors[#errors]
                end

                if errorObject then
                    local text = tostring(errorObject.message)
                    local sourceAddonName = text:match("[Aa][Dd][Dd][Oo][Nn][Ss][/\\]([^/\\]+)")
                    if not sourceAddonName then
                        sourceAddonName = text:match("LUA_WARNING: ([%w%-_]+)/") or text:match("^([%w%-_]+)/")
                    end

                    sourceAddonName = sourceAddonName or "an unknown add-on"
                    local firstLine = text:match("([^\n]+)") or text
                    local count = errorObject.counter or 1

                    local chatMsg =
                        string.format(
                        "There appears to be an issue with %s. (%dx %s).",
                        sourceAddonName,
                        count,
                        firstLine
                    )
                    print(chatMsg)
                else
                    print(L["General.BugInSoup"])
                end
            end
            lastErrorTime = GetTime()
        end
        if (addon.db.auto and not InCombatLockdown()) or (BugSackFrame and BugSackFrame:IsShown()) then
            addon:OpenSack()
        end
        addon:UpdateDisplay()
    end
end

do
    local eventFrame = CreateFrame("Frame")
    eventFrame:SetScript(
        "OnEvent",
        function(self, event, loadedAddon)
            if loadedAddon ~= addonName then
                return
            end
            self:UnregisterEvent("ADDON_LOADED")

            local aceComm = LibStub("AceComm-3.0", true)
            if aceComm then
                aceComm:Embed(addon)
            end

            local aceSerializer = LibStub("AceSerializer-3.0", true)
            if aceSerializer then
                aceSerializer:Embed(addon)
            end

            local popupDialogs = _G.StaticPopupDialogs
            if type(popupDialogs) ~= "table" then
                popupDialogs = {}
            end
            if type(popupDialogs.BugSackSendBugs) ~= "table" then
                popupDialogs.BugSackSendBugs = {
                    text = L["ErrorMessage.SendPrompt"],
                    button1 = L["General.Send"],
                    button2 = CLOSE,
                    timeout = 0,
                    whileDead = true,
                    hideOnEscape = true,
                    hasEditBox = true,
                    OnAccept = function(dialog, data)
                        local recipient = dialog:GetEditBox():GetText()
                        addon:SendBugsToUser(recipient, data)
                    end,
                    OnShow = function(dialog)
                        dialog:GetButton1():Disable()
                    end,
                    EditBoxOnTextChanged = function(editBox)
                        local text = editBox:GetText()
                        local dialog = editBox:GetParent()
                        if text:len() > 2 and not text:find("%s") then
                            dialog:GetButton1():Enable()
                        else
                            dialog:GetButton1():Disable()
                        end
                    end,
                    enterClicksFirstButton = true,
                    preferredIndex = 1
                }
            end

            BugSackDB = BugSackDB or {}
            local db = BugSackDB
            db.profileKeys = nil
            db.profiles = nil

            local defaults = {
                soundEffects = true,
                auto = false,
                chatframe = false,
                soundMedia = "BugSack: Fatality",
                fontSize = "GameFontHighlight",
                useMaster = false
            }

            for k, v in pairs(defaults) do
                if type(db[k]) ~= type(v) then
                    db[k] = v
                end
            end
            addon.db = db

            local sessionErrors = addon:GetErrors(BugGrabber:GetSessionId())
            if #sessionErrors > 0 then
                onError()
            end

            if addon.RegisterComm then
                addon:RegisterComm("BugSack", "OnBugComm")
            end

            BugGrabber.RegisterCallback(addon, "BugGrabber_BugGrabbed", onError)

            if addon.InitializeSettings then
                addon.InitializeSettings()
            end

            SlashCmdList.BugSack = function(message)
                message = message:lower()
                if message == "show" then
                    addon:OpenSack()
                else
                    Settings.OpenToCategory(addon.settingsCategory:GetID())
                end
            end
            SLASH_BugSack1 = "/bugsack"

            self:SetScript("OnEvent", nil)
        end
    )
    eventFrame:RegisterEvent("ADDON_LOADED")
end

-----------------------------------------------------------------------
-- API & Formatting
-----------------------------------------------------------------------

function addon:UpdateDisplay()
end

do
    local filteredErrors = {}
    function addon:GetErrors(sessionId)
        if sessionId then
            wipe(filteredErrors)
            local database = BugGrabber:GetDB()
            for _, errorEntry in next, database do
                if sessionId == errorEntry.session then
                    filteredErrors[#filteredErrors + 1] = errorEntry
                end
            end
            return filteredErrors
        else
            return BugGrabber:GetDB()
        end
    end
end

do
    local function c(hex)
        local rawHex = hex:gsub("#", "")
        if #rawHex == 6 then
            rawHex = "ff" .. rawHex
        end
        return "|c" .. rawHex
    end

    local function colorStack(text)
        text = text:gsub("[%.I][%.n][%.t][%.e][%.r]face/", "")
        text = text:gsub("%.?%.?%.?/?AddOns/", "")
        text = text:gsub("|([^chHr])", "||%1"):gsub("|$", "||")
        text = text:gsub("<(.-)>", c(addon.colors.yellow) .. "<%1>|r")
        text = text:gsub("%[(.-)%]", c(addon.colors.yellow) .. "[%1]|r")
        text = text:gsub('(["`\'])(.-)(["`\'])', c(addon.colors.blue) .. "%1%2%3|r")
        text = text:gsub(":(%d+)([%S\n])", ":" .. c(addon.colors.lightGreen) .. "%1|r%2")
        text = text:gsub("([^/]+%.lua)", c(addon.colors.white) .. "%1|r")
        return text
    end
    addon.ColorStack = colorStack

    local function colorLocals(text)
        text = text:gsub("[%.I][%.n][%.t][%.e][%.r]face/", "")
        text = text:gsub("%.?%.?%.?/?AddOns/", "")
        text = text:gsub("|(%a)", "||%1"):gsub("|$", "||")
        text =
            text:gsub(
            "> %@(.-):(%d+)",
            "> @" .. c(addon.colors.orange) .. "%1|r:" .. c(addon.colors.lightGreen) .. "%2|r"
        )
        text = text:gsub("(%s-)([%a_%(][%a_%d%*%)]+) = ", "%1" .. c(addon.colors.lightYellow) .. "%2|r = ")
        text = text:gsub("= (%-?[%d%p]+)\n", "= " .. c(addon.colors.pink) .. "%1|r\n")
        text = text:gsub("= nil\n", "= " .. c(addon.colors.lightRed) .. "nil|r\n")
        text = text:gsub("= true\n", "= " .. c(addon.colors.darkOrange) .. "true|r\n")
        text = text:gsub("= false\n", "= " .. c(addon.colors.darkOrange) .. "false|r\n")
        text = text:gsub("= <(.-)>", "= " .. c(addon.colors.yellow) .. "<%1>|r")
        return text
    end
    addon.ColorLocals = colorLocals

    local ERROR_FORMAT =
        "Build: %s\nAdd-on: %s\n\n## Reported By\nServer: %s\nCharacter: %s\nStatus: %s\nZone & Subzone: %s\n-- Note this information is pulled from the current character, and may not be relevant.\n\n%dx %s"
    local ERROR_FORMAT_WITH_LOCALS =
        "Build: %s\nAdd-on: %s\n\n## Reported By\nServer: %s\nCharacter: %s\nStatus: %s\nZone & Subzone: %s\n-- Note this information is pulled from the current character, and may not be relevant.\n\n%dx %s\n\nLocals:\n%s"

    local getMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata

    local function GetErrorMetadata(errorEntry)
        local text = tostring(errorEntry.message) .. (errorEntry.stack and "\n" .. tostring(errorEntry.stack) or "")
        local sourceAddonName = text:match("[Aa][Dd][Dd][Oo][Nn][Ss][/\\]([^/\\]+)")

        if sourceAddonName then
            local version = getMetadata and getMetadata(sourceAddonName, "Version")
            if version then
                return sourceAddonName .. " (" .. version .. ")"
            end
            return sourceAddonName
        end

        return "Unknown"
    end

    function addon:FormatError(errorEntry)
        local wowVersion, wowBuild = GetBuildInfo()
        local buildString = wowVersion .. " (" .. wowBuild .. ") - " .. GetLocale()

        local realmName = GetRealmName() or "Unknown"
        local factionLocalized = UnitFactionGroup("player")
        local serverString = realmName .. ", " .. (factionLocalized or "Unknown Faction")

        local charName = UnitName("player") or "Unknown"
        local classLocalized = UnitClass("player") or "Unknown"
        local raceLocalized = UnitRace("player") or "Unknown"
        local level = UnitLevel("player") or "??"
        local charString = charName .. ", " .. classLocalized .. ", " .. raceLocalized .. ", Level " .. level

        local isGhost = UnitIsGhost("player")
        local isDead = UnitIsDead("player")
        local lifeStatus = isGhost and "Ghost" or (isDead and "Dead" or "Alive")
        local pvpStatus = UnitIsPVP("player") and "PVP Enabled" or "PVP Disabled"
        local groupStatus = "Solo"
        if IsInRaid() then
            groupStatus = "Raid"
        elseif IsInGroup() then
            groupStatus = "Party"
        end
        local statusString = lifeStatus .. ", " .. pvpStatus .. ", " .. groupStatus

        local zoneText = GetRealZoneText() or GetZoneText() or "Unknown Zone"
        local mapID = C_Map and C_Map.GetBestMapForUnit("player") or "Unknown"
        local subZoneText = GetSubZoneText()
        if not subZoneText or subZoneText == "" then
            subZoneText = "None"
        end
        local zoneString = zoneText .. " (" .. tostring(mapID) .. "), " .. subZoneText

        local addonString = GetErrorMetadata(errorEntry)
        local coloredStack =
            colorStack(tostring(errorEntry.message) .. (errorEntry.stack and "\n" .. tostring(errorEntry.stack) or ""))
        local coloredLocals = colorLocals(tostring(errorEntry.locals) or "")

        if not errorEntry.locals then
            return ERROR_FORMAT:format(
                buildString,
                addonString,
                serverString,
                charString,
                statusString,
                zoneString,
                errorEntry.counter or -1,
                coloredStack
            )
        else
            return ERROR_FORMAT_WITH_LOCALS:format(
                buildString,
                addonString,
                serverString,
                charString,
                statusString,
                zoneString,
                errorEntry.counter or -1,
                coloredStack,
                coloredLocals
            )
        end
    end
end

-----------------------------------------------------------------------
-- Addon Actions
-----------------------------------------------------------------------

function addon:Reset()
    BugGrabber:Reset()
    self:UpdateDisplay()
    print(L["General.BugsExterminated"])
end

function addon:SendBugsToUser(player, session)
    if type(player) ~= "string" or player:trim():len() < 2 then
        error(L["ErrorMessage.InvalidPlayer"])
    end
    if not self.Serialize then
        return
    end

    local errors = self:GetErrors(session)
    if not errors or #errors == 0 then
        return
    end

    local serializedData = self:Serialize(errors)
    self:SendCommMessage("BugSack", serializedData, "WHISPER", player, "BULK")

    print(L["ErrorMessage.BugsSent"]:format(#errors, player))
end

function addon:OnBugComm(prefix, message, _, sender)
    if prefix ~= "BugSack" or not self.Deserialize then
        return
    end

    local success, deserializedData = self:Deserialize(message)
    if not success then
        print(L["ErrorMessage.DeserializeFail"]:format(sender))
        return
    end

    local currentSessionId = BugGrabber:GetSessionId()
    for _, errorEntry in next, deserializedData do
        errorEntry.source = sender
        errorEntry.session = currentSessionId
        BugGrabber:StoreError(errorEntry)
    end

    print(L["ErrorMessage.BugsReceived"]:format(#deserializedData, sender))

    wipe(deserializedData)
    deserializedData = nil
end