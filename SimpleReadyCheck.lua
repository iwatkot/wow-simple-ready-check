local button

local function eventHandler(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "SimpleReadyCheck" then
        -- Create the button here
        button = CreateFrame("Button", nil, UIParent, "GameMenuButtonTemplate")
        local buttonPosition = SimpleReadyCheck_Position or { "CENTER" }
        button:SetPoint(unpack(buttonPosition))
        button:SetSize(20, 20)

        button:SetNormalFontObject("GameFontNormal")
        button:SetHighlightFontObject("GameFontHighlight")
        button:SetNormalTexture("Interface\\RaidFrame\\ReadyCheck-Ready")

        -- Make the button draggable
        button:EnableMouse(true)
        button:SetMovable(true)
        button:RegisterForDrag("LeftButton")

        -- Add a flag to track whether the button is being dragged
        button.isDragging = false

        -- Set the flag to true when the button is dragged
        button:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" and IsShiftKeyDown() then
                self:StartMoving()
                self.isDragging = true
            end
        end)

        -- Set the flag to false when the button is dropped
        button:SetScript("OnMouseUp", function(self, button)
            if button == "LeftButton" and self.isDragging then
                self:StopMovingOrSizing()
                C_Timer.After(0, function() 
                    self.isDragging = false 
                    SimpleReadyCheck_Position = { self:GetPoint() }
                end)
            end
        end)

        -- Only execute the click action if the button is not being dragged
        button:SetScript("OnClick", function(self)
            if not self.isDragging then
                -- Code to execute when the button is clicked
                DoReadyCheck()
            end
        end)

        -- Hide the button initially
        button:Hide()
    elseif event == "GROUP_ROSTER_UPDATE" then
        if IsInGroup() then
            button:Show()
        else
            button:Hide()
        end
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:SetScript("OnEvent", eventHandler)