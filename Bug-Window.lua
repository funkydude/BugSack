local addonName, addon = ...
if not addon.healthCheck then
    return
end
local L = addon.L
local isRetail = addon.isRetail

local window
local activeTabState = "BugSackTabAll"
local searchResults = {}
local searchSourceErrors
local currentErrorIndex
local currentSackContents
local currentSackSession
local currentErrorObject
local tabButtons
local countLabel, sessionLabel, textArea
local nextButton, previousButton, sendButton
local searchLabel, searchBox

local SESSION_FORMAT =
    "%s - " .. addon:Colorize("%s", addon.colors.red) .. " - " .. addon:Colorize("%d", addon.colors.green)
local COUNT_FORMAT = "%d/%d"

-----------------------------------------------------------------------
-- Display Management
-----------------------------------------------------------------------

local previousTabState
local function updateSackDisplay(forceRefresh)
    if activeTabState ~= previousTabState then
        forceRefresh = true
    end
    previousTabState = activeTabState

    if forceRefresh then
        currentErrorObject = nil
        currentErrorIndex = nil
    else
        currentErrorObject = currentSackContents and currentSackContents[currentErrorIndex]
    end

    if activeTabState == "BugSackTabAll" then
        currentSackContents = addon:GetErrors()
        currentSackSession = BugGrabber:GetSessionId()
    elseif activeTabState == "BugSackTabSession" then
        local sessionId = BugGrabber:GetSessionId()
        currentSackContents = addon:GetErrors(sessionId)
        currentSackSession = sessionId
    elseif activeTabState == "BugSackTabLast" then
        local sessionId = BugGrabber:GetSessionId() - 1
        currentSackContents = addon:GetErrors(sessionId)
        currentSackSession = sessionId
    elseif activeTabState == "BugSackSearch" then
        currentSackSession = -1
        currentSackContents = searchResults
    end

    local totalCount = #currentSackContents

    if forceRefresh then
        currentErrorIndex = totalCount
    else
        local found = false
        for index, entry in ipairs(currentSackContents) do
            if entry == currentErrorObject then
                currentErrorIndex = index
                found = true
                break
            end
        end
        if not found then
            currentErrorIndex = totalCount
        end
    end

    local errorObject = currentSackContents[currentErrorIndex]
    if currentSackSession == -1 and errorObject then
        currentSackSession = errorObject.session
    end

    if totalCount > 0 then
        local sourceText
        if errorObject.source then
            sourceText = L["General.SentBy"]:format(errorObject.source, "error")
        else
            sourceText = L["General.Local"]:format("error")
        end

        if errorObject.session == BugGrabber:GetSessionId() then
            sessionLabel:SetText(SESSION_FORMAT:format(L["General.Today"], sourceText, errorObject.session))
        else
            sessionLabel:SetText(SESSION_FORMAT:format(errorObject.time, sourceText, errorObject.session))
        end

        countLabel:SetText(COUNT_FORMAT:format(currentErrorIndex, totalCount))
        textArea:SetText(addon:FormatError(errorObject))

        nextButton:SetEnabled(currentErrorIndex < totalCount)
        previousButton:SetEnabled(currentErrorIndex > 1)
        if sendButton then
            sendButton:Enable()
        end
    else
        countLabel:SetText()
        if currentSackSession == BugGrabber:GetSessionId() then
            sessionLabel:SetText(("%s (%d)"):format(L["General.Today"], BugGrabber:GetSessionId()))
        else
            sessionLabel:SetText(("%d"):format(currentSackSession or 0))
        end
        textArea:SetText(L["General.NoBugs"])
        nextButton:Disable()
        previousButton:Disable()
        if sendButton then
            sendButton:Disable()
        end
    end

    for _, tab in ipairs(tabButtons) do
        if activeTabState == tab:GetName() then
            PanelTemplates_SelectTab(tab)
        else
            PanelTemplates_DeselectTab(tab)
        end
    end
end

hooksecurefunc(
    addon,
    "UpdateDisplay",
    function()
        if not window or not window:IsShown() then
            return
        end
        local forceRefresh = currentErrorIndex and currentSackContents and currentErrorIndex == #currentSackContents
        updateSackDisplay(forceRefresh)
    end
)

-----------------------------------------------------------------------
-- Navigation & Search
-----------------------------------------------------------------------

local function setActiveTab(tab)
    searchLabel:Hide()
    searchBox:Hide()
    sessionLabel:Show()
    wipe(searchResults)
    activeTabState = type(tab) == "table" and tab:GetName() or tab
    updateSackDisplay(true)
end

local function clearSearch()
    setActiveTab("BugSackTabAll")
end

local function filterSack(editBox)
    for _, tab in ipairs(tabButtons) do
        PanelTemplates_DeselectTab(tab)
    end
    wipe(searchResults)

    local filterText = editBox:GetText()
    if not searchSourceErrors or not filterText or filterText:trim():len() == 0 then
        activeTabState = "BugSackTabAll"
    else
        for _, errorEntry in ipairs(searchSourceErrors) do
            if
                (errorEntry.message and errorEntry.message:find(filterText)) or
                    (errorEntry.stack and errorEntry.stack:find(filterText)) or
                    (errorEntry.locals and errorEntry.locals:find(filterText))
             then
                searchResults[#searchResults + 1] = errorEntry
            end
        end
        activeTabState = "BugSackSearch"
    end
    updateSackDisplay(true)
end

-----------------------------------------------------------------------
-- UI Construction
-----------------------------------------------------------------------

local function createBugSackWindow()
    window = CreateFrame("Frame", "BugSackFrame", UIParent)
    window:Hide()

    window:SetFrameStrata("DIALOG")
    window:SetWidth(800)
    window:SetHeight(310)
    window:SetPoint("CENTER")
    window:SetMovable(true)
    window:EnableMouse(true)
    window:RegisterForDrag("LeftButton")
    window:SetClampedToScreen(true)
    window:SetScript("OnDragStart", window.StartMoving)
    window:SetScript("OnDragStop", window.StopMovingOrSizing)
    window:SetScript(
        "OnShow",
        function()
            PlaySound(844)
        end
    )
    window:SetScript(
        "OnHide",
        function()
            currentErrorObject = nil
            currentSackSession = nil
            currentSackContents = nil
            PlaySound(845)
        end
    )

    local titleBackground = window:CreateTexture(nil, "BORDER")
    titleBackground:SetTexture(251966)
    titleBackground:SetPoint("TOPLEFT", 9, -6)
    titleBackground:SetPoint("BOTTOMRIGHT", window, "TOPRIGHT", -28, -24)

    local dialogBackground = window:CreateTexture(nil, "BACKGROUND")
    dialogBackground:SetTexture(136548)
    dialogBackground:SetPoint("TOPLEFT", 8, -12)
    dialogBackground:SetPoint("BOTTOMRIGHT", -6, 8)
    dialogBackground:SetTexCoord(0.255, 1, 0.29, 1)

    local borderTexture = 251963

    local topLeftBorder = window:CreateTexture(nil, "BORDER")
    topLeftBorder:SetTexture(borderTexture)
    topLeftBorder:SetWidth(64)
    topLeftBorder:SetHeight(64)
    topLeftBorder:SetPoint("TOPLEFT")
    topLeftBorder:SetTexCoord(0.501953125, 0.625, 0, 1)

    local topRightBorder = window:CreateTexture(nil, "BORDER")
    topRightBorder:SetTexture(borderTexture)
    topRightBorder:SetWidth(64)
    topRightBorder:SetHeight(64)
    topRightBorder:SetPoint("TOPRIGHT")
    topRightBorder:SetTexCoord(0.625, 0.75, 0, 1)

    local topBorder = window:CreateTexture(nil, "BORDER")
    topBorder:SetTexture(borderTexture)
    topBorder:SetHeight(64)
    topBorder:SetPoint("TOPLEFT", topLeftBorder, "TOPRIGHT")
    topBorder:SetPoint("TOPRIGHT", topRightBorder, "TOPLEFT")
    topBorder:SetTexCoord(0.25, 0.369140625, 0, 1)

    local bottomLeftBorder = window:CreateTexture(nil, "BORDER")
    bottomLeftBorder:SetTexture(borderTexture)
    bottomLeftBorder:SetWidth(64)
    bottomLeftBorder:SetHeight(64)
    bottomLeftBorder:SetPoint("BOTTOMLEFT")
    bottomLeftBorder:SetTexCoord(0.751953125, 0.875, 0, 1)

    local bottomRightBorder = window:CreateTexture(nil, "BORDER")
    bottomRightBorder:SetTexture(borderTexture)
    bottomRightBorder:SetWidth(64)
    bottomRightBorder:SetHeight(64)
    bottomRightBorder:SetPoint("BOTTOMRIGHT")
    bottomRightBorder:SetTexCoord(0.875, 1, 0, 1)

    local bottomBorder = window:CreateTexture(nil, "BORDER")
    bottomBorder:SetTexture(borderTexture)
    bottomBorder:SetHeight(64)
    bottomBorder:SetPoint("BOTTOMLEFT", bottomLeftBorder, "BOTTOMRIGHT")
    bottomBorder:SetPoint("BOTTOMRIGHT", bottomRightBorder, "BOTTOMLEFT")
    bottomBorder:SetTexCoord(0.376953125, 0.498046875, 0, 1)

    local leftBorder = window:CreateTexture(nil, "BORDER")
    leftBorder:SetTexture(borderTexture)
    leftBorder:SetWidth(64)
    leftBorder:SetPoint("TOPLEFT", topLeftBorder, "BOTTOMLEFT")
    leftBorder:SetPoint("BOTTOMLEFT", bottomLeftBorder, "TOPLEFT")
    leftBorder:SetTexCoord(0.001953125, 0.125, 0, 1)

    local rightBorder = window:CreateTexture(nil, "BORDER")
    rightBorder:SetTexture(borderTexture)
    rightBorder:SetWidth(64)
    rightBorder:SetPoint("TOPRIGHT", topRightBorder, "BOTTOMRIGHT")
    rightBorder:SetPoint("BOTTOMRIGHT", bottomRightBorder, "TOPRIGHT")
    rightBorder:SetTexCoord(0.1171875, 0.2421875, 0, 1)

    local closeButton = CreateFrame("Button", nil, window, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", isRetail and -3 or 2, isRetail and -3 or 1)
    closeButton:SetScript("OnClick", addon.CloseSack)

    countLabel = window:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    countLabel:SetPoint("TOPRIGHT", titleBackground, -6, -3)
    countLabel:SetJustifyH("RIGHT")
    countLabel:SetTextColor(1, 1, 1, 1)

    sessionLabel = CreateFrame("Button", nil, window)
    sessionLabel:SetNormalFontObject("GameFontNormalLeft")
    sessionLabel:SetHighlightFontObject("GameFontHighlightLeft")
    sessionLabel:SetPoint("TOPLEFT", titleBackground, 6, -1)
    sessionLabel:SetPoint("BOTTOMRIGHT", titleBackground, "BOTTOMRIGHT", -26, 1)
    sessionLabel:RegisterForClicks("LeftButtonUp", "LeftButtonDown", "RightButtonUp", "RightButtonDown")
    sessionLabel:SetScript(
        "OnHide",
        function()
            window:StopMovingOrSizing()
        end
    )
    sessionLabel:SetScript(
        "OnMouseUp",
        function()
            window:StopMovingOrSizing()
        end
    )
    sessionLabel:SetScript(
        "OnMouseDown",
        function()
            window:StartMoving()
        end
    )
    sessionLabel:SetScript(
        "OnDoubleClick",
        function()
            sessionLabel:Hide()
            searchLabel:Show()
            searchBox:Show()
            searchSourceErrors = currentSackContents
        end
    )
    sessionLabel:SetScript(
        "OnClick",
        function(self, button)
            if button ~= "RightButton" then
                return
            end
            window:Hide()
            Settings.OpenToCategory(addon.settingsCategory:GetID())
        end
    )
    sessionLabel:SetScript(
        "OnEnter",
        function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", -8, 8)
            GameTooltip:AddLine(L["General.QuickTipsTitle"])
            GameTooltip:AddLine(L["General.QuickTipsDesc"], 1, 1, 1, 1)
            GameTooltip:Show()
        end
    )
    sessionLabel:SetScript(
        "OnLeave",
        function(self)
            if GameTooltip:IsOwned(self) then
                GameTooltip:Hide()
            end
        end
    )

    searchLabel = window:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    searchLabel:SetText(L["General.Filter"] .. ":")
    searchLabel:SetJustifyH("LEFT")
    searchLabel:SetPoint("TOPLEFT", titleBackground, 6, -3)
    searchLabel:SetTextColor(1, 1, 1, 1)
    searchLabel:Hide()

    searchBox = CreateFrame("EditBox", nil, window, "BackdropTemplate")
    searchBox:SetTextInsets(4, 4, 0, 0)
    searchBox:SetMaxLetters(50)
    searchBox:SetFontObject("ChatFontNormal")
    searchBox:SetBackdrop(
        {
            edgeFile = nil,
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            insets = {left = 0, right = 0, top = 0, bottom = 0},
            tile = true,
            tileSize = 16,
            edgeSize = 1
        }
    )
    searchBox:SetBackdropColor(0, 0, 0, 0.5)
    searchBox:SetScript(
        "OnShow",
        function(self)
            self:SetFocus()
        end
    )
    searchBox:SetScript(
        "OnHide",
        function(self)
            self:ClearFocus()
            self:SetText("")
        end
    )
    searchBox:SetScript("OnEscapePressed", clearSearch)
    searchBox:SetScript("OnTextChanged", filterSack)
    searchBox:SetAutoFocus(false)
    searchBox:SetPoint("TOPLEFT", searchLabel, "TOPRIGHT", 6, 1)
    searchBox:SetPoint("BOTTOMRIGHT", titleBackground, "BOTTOMRIGHT", -26, 1)
    searchBox:Hide()

    nextButton = CreateFrame("Button", "BugSackNextButton", window, "UIPanelButtonTemplate")
    nextButton:SetPoint("BOTTOMRIGHT", window, -11, 16)
    nextButton:SetFrameStrata("FULLSCREEN")
    nextButton:SetHeight(40)
    nextButton:SetWidth(200)
    nextButton:SetText(L["General.Next"])
    nextButton:SetScript(
        "OnClick",
        function()
            if IsShiftKeyDown() then
                currentErrorIndex = #currentSackContents
            else
                currentErrorIndex = currentErrorIndex + 1
            end
            updateSackDisplay()
        end
    )

    previousButton = CreateFrame("Button", "BugSackPrevButton", window, "UIPanelButtonTemplate")
    previousButton:SetPoint("BOTTOMLEFT", window, 14, 16)
    previousButton:SetFrameStrata("FULLSCREEN")
    previousButton:SetHeight(40)
    previousButton:SetWidth(200)
    previousButton:SetText(L["General.Previous"])
    previousButton:SetScript(
        "OnClick",
        function()
            if IsShiftKeyDown() then
                currentErrorIndex = 1
            else
                currentErrorIndex = currentErrorIndex - 1
            end
            updateSackDisplay()
        end
    )

    if addon.Serialize then
        sendButton = CreateFrame("Button", "BugSackSendButton", window, "UIPanelButtonTemplate")
        sendButton:SetPoint("LEFT", previousButton, "RIGHT")
        sendButton:SetPoint("RIGHT", nextButton, "LEFT")
        sendButton:SetFrameStrata("FULLSCREEN")
        sendButton:SetHeight(40)
        sendButton:SetText(L["General.SendBugs"])
        sendButton:SetScript(
            "OnClick",
            function()
                local errorObject = currentSackContents[currentErrorIndex]
                local popup = StaticPopup_Show("BugSackSendBugs", errorObject.session)
                popup.data = errorObject.session
                window:Hide()
            end
        )
    end

    local scrollFrame = CreateFrame("ScrollFrame", "BugSackScroll", window, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", window, "TOPLEFT", 16, -36)
    scrollFrame:SetPoint("BOTTOMRIGHT", nextButton, "TOPRIGHT", -24, 8)

    textArea = CreateFrame("EditBox", "BugSackScrollText", scrollFrame)
    textArea:SetTextColor(0.5, 0.5, 0.5, 1)
    textArea:SetAutoFocus(false)
    textArea:SetMultiLine(true)
    textArea:SetFontObject(_G[addon.db.fontSize] or GameFontHighlightSmall)
    textArea:SetMaxLetters(99999)
    textArea:EnableMouse(true)
    textArea:SetScript("OnEscapePressed", textArea.ClearFocus)
    textArea:SetWidth(750)

    scrollFrame:SetScrollChild(textArea)

    local tabTemplate = isRetail and "CharacterFrameTabTemplate" or "CharacterFrameTabButtonTemplate"

    local allBugsTab = CreateFrame("Button", "BugSackTabAll", window, tabTemplate)
    allBugsTab:SetFrameStrata("FULLSCREEN")
    allBugsTab:SetPoint("TOPLEFT", window, "BOTTOMLEFT", isRetail and 10 or 0, isRetail and 6 or 8)
    allBugsTab:SetText(L["General.AllBugs"])
    allBugsTab:SetScript("OnClick", setActiveTab)
    allBugsTab.bugs = "all"

    local currentSessionTab = CreateFrame("Button", "BugSackTabSession", window, tabTemplate)
    currentSessionTab:SetFrameStrata("FULLSCREEN")
    currentSessionTab:SetPoint("LEFT", allBugsTab, "RIGHT")
    currentSessionTab:SetText(L["General.CurrentSession"])
    currentSessionTab:SetScript("OnClick", setActiveTab)
    currentSessionTab.bugs = "currentSession"

    local previousSessionTab = CreateFrame("Button", "BugSackTabLast", window, tabTemplate)
    previousSessionTab:SetFrameStrata("FULLSCREEN")
    previousSessionTab:SetPoint("LEFT", currentSessionTab, "RIGHT")
    previousSessionTab:SetText(L["General.PreviousSession"])
    previousSessionTab:SetScript("OnClick", setActiveTab)
    previousSessionTab.bugs = "previousSession"

    tabButtons = {allBugsTab, currentSessionTab, previousSessionTab}
    local tabWidth = (isRetail and 480 or 500) / 3
    for index, tab in ipairs(tabButtons) do
        PanelTemplates_TabResize(tab, nil, tabWidth, tabWidth)
        if index == 1 then
            PanelTemplates_SelectTab(tab)
        else
            PanelTemplates_DeselectTab(tab)
        end
    end
end

-----------------------------------------------------------------------
-- Public API
-----------------------------------------------------------------------

local function showWindow()
    if createBugSackWindow then
        createBugSackWindow()
        createBugSackWindow = nil
    end
    updateSackDisplay(true)
    window:Show()
end

function addon:CloseSack()
    window:Hide()
end

function addon:OpenSack()
    if window and window:IsShown() then
        return
    end
    showWindow()
end