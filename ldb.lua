local addonName, addon = ...
if not addon.healthCheck then
    return
end
local L = addon.L

local ldb = LibStub:GetLibrary("LibDataBroker-1.1", true)
if not ldb then
    return
end

local plugin =
    ldb:NewDataObject(
    addonName,
    {
        type = "data source",
        text = "0",
        icon = "Interface\\AddOns\\" .. addonName .. "\\Media\\icon"
    }
)

local BugGrabber = BugGrabber

function plugin.OnClick(self, button)
    if button == "RightButton" then
        Settings.OpenToCategory(addon.settingsCategory:GetID())
    elseif button == "MiddleButton" then
        if IsShiftKeyDown() then
            -- Shift + Middle-Click: Clear bugs
            addon:Reset()
        else
            -- Middle-Click: Toggle mute
            addon.db.mute = not addon.db.mute
            -- Optional: Print a message to chat so the user knows it toggled
            print("|cff259054BugSack:|r Mute " .. (addon.db.mute and "ON" or "OFF"))
        end
    else
        if IsShiftKeyDown() then
            ReloadUI()
        elseif IsAltKeyDown() and (addon.db.altwipe == true) then
            addon:Reset()
        elseif BugSackFrame and BugSackFrame:IsShown() then
            addon:CloseSack()
        else
            addon:OpenSack()
        end
    end
end

hooksecurefunc(
    addon,
    "UpdateDisplay",
    function()
        local count = #addon:GetErrors(BugGrabber:GetSessionId())
        plugin.text = count
        plugin.icon =
            count == 0 and "Interface\\AddOns\\" .. addonName .. "\\Media\\icon" or
            "Interface\\AddOns\\" .. addonName .. "\\Media\\icon_red"
    end
)

do
    local line = "%d. %s (x%d)"
    function plugin.OnTooltipShow(tt)
        local errs = addon:GetErrors(BugGrabber:GetSessionId())
        if #errs == 0 then
            tt:AddLine(L["You have no bugs, yay!"])
        else
            tt:AddLine(addonName)
            for i, err in next, errs do
                tt:AddLine(line:format(i, addon.ColorStack(err.message), err.counter), 0.5, 0.5, 0.5)
                if i > 8 then
                    break
                end
            end
        end

        tt:AddLine(" ")

        tt:AddDoubleLine("|cffeda55fClick|r", "Open")
        tt:AddLine(" ")

        tt:AddDoubleLine("|cffeda55fRight-Click|r", "Options")
        tt:AddLine(" ")

        tt:AddDoubleLine("|cffeda55fMiddle-Click|r", "Toggle Mute")
        tt:AddLine(" ")

        tt:AddDoubleLine("|cffeda55fShift + Click|r", "Reload Interface")
        tt:AddLine(" ")

        tt:AddDoubleLine("|cffeda55fShift + Middle-Click|r", "Clear Bugs")
    end
end

local f = CreateFrame("Frame")
f:SetScript(
    "OnEvent",
    function()
        local icon = LibStub("LibDBIcon-1.0", true)
        if not icon then
            return
        end
        if not BugSackLDBIconDB then
            BugSackLDBIconDB = {}
        end
        icon:Register(addonName, plugin, BugSackLDBIconDB)
    end
)
f:RegisterEvent("PLAYER_LOGIN")
