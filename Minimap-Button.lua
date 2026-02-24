local addonName, addon = ...
if not addon.healthCheck then
    return
end
local L = addon.L

local dataBrokerLibrary = LibStub:GetLibrary("LibDataBroker-1.1", true)
if not dataBrokerLibrary then
    return
end

local dataObject =
    dataBrokerLibrary:NewDataObject(
    addonName,
    {
        type = "data source",
        text = "0",
        icon = addon.ICON_GREEN
    }
)

function dataObject.OnClick(self, button)
    if button == "RightButton" then
        Settings.OpenToCategory(addon.settingsCategory:GetID())
    elseif button == "MiddleButton" then
        if IsShiftKeyDown() then
            addon:Reset()
        else
            addon.db.soundEffects = not addon.db.soundEffects
            local prefix =
                addon:Colorize("BugSack", addon.colors.lightBlue) .. addon:Colorize(" // ", addon.colors.lightGray)
            print(
                prefix ..
                    addon:Colorize("Sound Effects " .. (addon.db.soundEffects and "ON." or "OFF."), addon.colors.white)
            )
        end
    else
        if IsShiftKeyDown() then
            ReloadUI()
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
        local errorCount = #addon:GetErrors(BugGrabber:GetSessionId())
        dataObject.text = errorCount
        dataObject.icon = errorCount == 0 and addon.ICON_GREEN or addon.ICON_RED
    end
)

do
    local tooltipLineFormat = "%d. %s (x%d)"
    function dataObject.OnTooltipShow(tooltip)
        local owner = tooltip:GetOwner()
        if owner then
            tooltip:ClearAllPoints()
            tooltip:SetPoint("TOPRIGHT", owner, "BOTTOMLEFT")
        end

        tooltip:AddLine(addonName)
        tooltip:AddLine(" ")

        local errors = addon:GetErrors(BugGrabber:GetSessionId())
        if #errors == 0 then
            tooltip:AddLine(L["General.NoBugs"], 1, 1, 1)
        else
            for index, errorEntry in ipairs(errors) do
                tooltip:AddLine(
                    tooltipLineFormat:format(index, addon.ColorStack(errorEntry.message), errorEntry.counter),
                    0.5,
                    0.5,
                    0.5
                )
                if index > 8 then
                    break
                end
            end
        end

        tooltip:AddLine(" ")
        tooltip:AddDoubleLine(
            addon:Colorize(L["Minimap.Click"], addon.colors.lightBlue),
            addon:Colorize(L["Minimap.ClickAction"], addon.colors.white)
        )
        tooltip:AddLine(" ")
        tooltip:AddDoubleLine(
            addon:Colorize(L["Minimap.RightClick"], addon.colors.lightBlue),
            addon:Colorize(L["Minimap.RightClickAction"], addon.colors.white)
        )
        tooltip:AddLine(" ")
        tooltip:AddDoubleLine(
            addon:Colorize(L["Minimap.MiddleClick"], addon.colors.lightBlue),
            addon:Colorize(L["Minimap.MiddleClickAction"], addon.colors.white)
        )
        tooltip:AddLine(" ")
        tooltip:AddDoubleLine(
            addon:Colorize(L["Minimap.ShiftClick"], addon.colors.lightBlue),
            addon:Colorize(L["Minimap.ShiftClickAction"], addon.colors.white)
        )
        tooltip:AddLine(" ")
        tooltip:AddDoubleLine(
            addon:Colorize(L["Minimap.ShiftMiddleClick"], addon.colors.lightBlue),
            addon:Colorize(L["Minimap.ShiftMiddleClickAction"], addon.colors.white)
        )
    end
end

local registrationFrame = CreateFrame("Frame")
registrationFrame:SetScript(
    "OnEvent",
    function()
        local dataBrokerIcon = LibStub("LibDBIcon-1.0", true)
        if not dataBrokerIcon then
            return
        end

        BugSackLDBIconDB = BugSackLDBIconDB or {}
        dataBrokerIcon:Register(addonName, dataObject, BugSackLDBIconDB)
    end
)
registrationFrame:RegisterEvent("PLAYER_LOGIN")