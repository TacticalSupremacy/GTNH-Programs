local config = require('blood-altar-config')
local slates = require('blood-altar-slates')

local term = require("term")
local component = require("component")

local transposer = component.transposer
local ae2 = require("blood-altar-ae2")

function CraftSlate(craft, ingredient)
    local crafting = true
    -- Move Blood Orb Out --
    if transposer.getStackInSlot(config.altarSide, config.altarSlot).label == config.BloodOrbLabel then
        term.write("Found Blood Orb in Altar, moving it out to begin crafting\n")
        if transposer.transferItem(config.altarSide, config.dualinterfaceSide, 1, config.altarSlot, config.BloodOrbSlot) ~= 1 then
            term.write("Could not move Blood Orb, Failing\n")
        end
    end
    -- Insert a stone into the altar --
    if transposer.transferItem(config.dualinterfaceSide, config.altarSide, 1, config.SlateConfig[ingredient]["slot"], config.altarSlot) ~= 1 then
        term.write("Could not move Slate in, Failing\n")
    end
    while crafting do
        if transposer.getStackInSlot(config.altarSide, config.altarSlot).label == config.SlateConfig[craft]["slot"] then
            if transposer.transferItem(config.altarSide, config.dualinterfaceSide, 1, config.altarSlot, config.BloodOrbSlot) ~= 1 then
                term.write("Could not move Slate out, Failing\n")
            else
                term.write(string.format("Craft Complete: %s", craft))
                crafting=false
            end
        end
    end
end


function LifeEssenceStatus()
    if term.isAvailable() then
        term.clearLine()
        term.write(string.format("AE2 Blood Level: %.2f %%, %.0d mb / %.0d mb\n", ae2.GetLifeEssence() / config.LifeEssenceTarget *100, ae2.GetLifeEssence(), config.LifeEssenceTarget))
    end
end

term.clear()
while true do
    LifeEssenceStatus()

    if ae2.GetItem("Arcane Slate") > 0 and ae2.GetItem("Blank Slate") < config.SlateConfig["Blank Slate"]["target"] then
        CraftSlate("Arcane Slate", "Blank Slate")

    elseif config.BloodAltarTier >= 2 and ae2.GetItem("Blank Slate") > 0 and ae2.GetItem("Reinforced Slate") < config.SlateConfig["Reinforced Slate"]["target"] then
        CraftSlate("Blank Slate", "Reinforced Slate")

    elseif config.BloodAltarTier >= 3 and ae2.GetItem("Reinforced Slate") > 0 and ae2.GetItem("Imbued Slate") < config.SlateConfig["Imbued Slate"]["target"] then
        CraftSlate("Reinforced Slate", "Imbued Slate")

    elseif  config.BloodAltarTier >= 4 and ae2.GetItem("Imbued Slate") > 0 and ae2.GetItem("Demonic Slate") < config.SlateConfig["Demonic Slate"]["target"] then
        CraftSlate("Imbued Slate", "Demonic Slate")

    elseif config.BloodAltarTier >= 5 and ae2.GetItem("Demonic Slate") > 0 and ae2.GetItem("Ethereal Slate") < config.SlateConfig["Ethereal Slate"]["target"] then
        CraftSlate("Demonic Slate", "Ethereal Slate")
    end
end