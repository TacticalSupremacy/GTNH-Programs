local config = require('blood-altar-config')
local slates = require('blood-altar-slates')

local term = require("term")
local component = require("component")

local transposer = component.transposer

function GetLifeEssence()
    for i, fluid in pairs(component.me_interface.getFluidsInNetwork()) do
        if fluid["label"] == "Life Essence" then
            return fluid.amount
        end
    end
end

function GetItem(name)
    for i, item in pairs(component.me_interface.getItemsInNetwork({label = name})) do
        return item.size
    end
end

function ConfigureFluidInterface()
end

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
        term.write(string.format("AE2 Blood Level:  %s mb / %s mb\n", GetLifeEssence(), config.LifeEssenceTarget))
    end
end

term.clear()
while true do
    LifeEssenceStatus()

    if GetItem("Arcane Slate") > 0 and GetItem("Blank Slate") < config.SlateConfig["Blank Slate"]["target"] then
        CraftSlate("Arcane Slate", "Blank Slate")

    elseif config.BloodAltarTier >= 2 and GetItem("Blank Slate") > 0 and GetItem("Reinforced Slate") < config.SlateConfig["Reinforced Slate"]["target"] then
        CraftSlate("Blank Slate", "Reinforced Slate")

    elseif config.BloodAltarTier >= 3 and GetItem("Reinforced Slate") > 0 and GetItem("Imbued Slate") < config.SlateConfig["Imbued Slate"]["target"] then
        CraftSlate("Reinforced Slate", "Imbued Slate")

    elseif  config.BloodAltarTier >= 4 and GetItem("Imbued Slate") > 0 and GetItem("Demonic Slate") < config.SlateConfig["Demonic Slate"]["target"] then
        CraftSlate("Imbued Slate", "Demonic Slate")

    elseif config.BloodAltarTier >= 5 and GetItem("Demonic Slate") > 0 and GetItem("Ethereal Slate") < config.SlateConfig["Ethereal Slate"]["target"] then
        CraftSlate("Demonic Slate", "Ethereal Slate")
    end
end