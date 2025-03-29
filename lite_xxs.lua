--made by Zarto in 30min w/ chatgpt.
--date: 29/03/2025

local UserInputService = game:GetService("UserInputService")

local function CreateDrawing(Type, Props)
    local drw = Drawing.new(Type)
    if drw then
        for i, v in next, Props do
            drw[i] = v
        end
    end
    return drw
end

local Lib = {
    Items = {},
    Toggles = {},
    PointerIdx = 1,
    SelectorKey = Enum.KeyCode.End,
    Active = true,
    StartPosition = Vector2.new(250, 100),
    Spacing = 20,
    Flags = {}
}

function Lib:CreateToggle(flag, cfg)
    local Name = cfg.Name or "Unnamed"
    local Default = cfg.Default or false

    local Toggle = {
        Value = Default,
        Name = Name
    }

    local Text = CreateDrawing("Text", {
        Size = 15,
        Font = 2,
        Color = Default and Color3.new(0,1,0) or Color3.new(1,0,0),
        Text = "[OFF] " .. Name,
        Outline = true,
        OutlineColor = Color3.new(0,0,0),
        Position = Lib.StartPosition + Vector2.new(0, #Lib.Items * Lib.Spacing),
        Visible = true,
    })
    
    table.insert(Lib.Items, Text)
    table.insert(Lib.Toggles, Toggle)
    Lib.Flags[flag] = Toggle
    local function update_text()
        local prefix = (Lib.Active and Toggle == Lib.Toggles[Lib.PointerIdx]) and "> " or ""
        Text.Text = prefix .. Name .. (Toggle.Value and " [ON]" or " [OFF]")
    end

    function Toggle:SetValue(v)
        Toggle.Value = not not v
        Text.Color = Toggle.Value and Color3.new(0,1,0) or Color3.new(1,0,0)
        update_text()
    end

    update_text()
    return Toggle
end

function Lib:update_display()
    for i, toggle in ipairs(Lib.Toggles) do
        local text = Lib.Items[i]
        local prefix = (Lib.Active and i == Lib.PointerIdx) and "> " or ""
        text.Text = prefix .. toggle.Name .. (toggle.Value and " [ON]" or " [OFF]")
        text.Position = Lib.StartPosition + Vector2.new(0, (i - 1) * Lib.Spacing)
    end
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Lib.SelectorKey then 
        Lib.Active = not Lib.Active
        Lib:update_display()
    end

    if not Lib.Active then return end
    if input.KeyCode == Enum.KeyCode.Up then
        Lib.PointerIdx = (Lib.PointerIdx - 1 < 1) and #Lib.Items or Lib.PointerIdx - 1
        Lib:update_display()
    elseif input.KeyCode == Enum.KeyCode.Down then
        Lib.PointerIdx = (Lib.PointerIdx + 1 > #Lib.Items) and 1 or Lib.PointerIdx + 1
        Lib:update_display()
    elseif input.KeyCode == Enum.KeyCode.Return then
        local selectedToggle = Lib.Toggles[Lib.PointerIdx]
        selectedToggle:SetValue(not selectedToggle.Value)
        Lib:update_display()
    end
end)

return Lib
