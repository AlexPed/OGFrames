local function colour(statusbar, unit)
    local _, class, c
    if UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == statusbar.unit and UnitClass(unit) then
        _, class = UnitClass(unit)
        c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
        statusbar:SetStatusBarColor(c.r, c.g, c.b)

    end
end

hooksecurefunc("UnitFrameHealthBar_Update", colour)
hooksecurefunc("HealthBar_OnValueChanged", function(self)
    colour(self, self.unit)
end)

local frame = CreateFrame("FRAME")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("PLAYER_FOCUS_CHANGED")
frame:RegisterEvent("UNIT_FACTION")

local function eventHandler(self, event, ...)
    if UnitIsPlayer("target") then
        c = RAID_CLASS_COLORS[select(2, UnitClass("target"))]
        if TargetFrame.Background == not nil then
            TargetFrame.Background:SetVertexColor(c.r, c.g, c.b)
        end

    end
    if UnitIsPlayer("focus") then
        c = RAID_CLASS_COLORS[select(2, UnitClass("focus"))]
        if FocusFrame.Background == not nil then
        FocusFrame.Background:SetVertexColor(c.r, c.g, c.b)
        end
    end

    if PlayerFrame:IsShown() and not PlayerFrame.bg then
        c = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
        bg = PlayerFrame:CreateTexture()
        bg:SetPoint("TOPLEFT", PlayerFrameBackground)
        bg:SetPoint("BOTTOMRIGHT", PlayerFrameBackground, 0, 22)
        if TargetFrame.TargetFrameContainer.nameBackground == not nil then
            bg:SetTexture(TargetFrame.TargetFrameContainer.nameBackground:GetTexture())
        end
        bg:SetVertexColor(c.r, c.g, c.b)
        PlayerFrame.bg = true
    end
end

frame:SetScript("OnEvent", eventHandler)

for _, BarTextures in pairs({ TargetFrameNameBackground, FocusFrameNameBackground }) do
    BarTextures:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
end
