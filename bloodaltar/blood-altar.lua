local term = require("term")
local component = require("component")
local transposer = component.transposer

local bloodAltarTier = 5  -- Change manually depending on your Altar level, Default: 5 (Tier: V)
 
local dualinterfaceSide = 5
local altarSide = 2
  
-- Altar slots do not need to be changed, unless WayOfTime add additional inventory slots or tanks to the Blood Altar
local altarSlot = 1  
local altarTank = 1

-- Configure your AE2 Systems targets here --
-- Setup the Dual Interface to have these in their prrogressional order, if not you can change it here --
local slateConfig = {
    {
        name = "Arcane Slate",
        slot = 1,
        target = 0
    },
    {
        name = "Blank Slate",
        slot = 2,
        target = 64
    },
    {
        name = "Reinforced Slate",
        slot = 3,
        target = 64
    },
    {
        name = "Imbued Slate",
        slot = 4,
        target = 64
    },
    {
        name = "Demonic Slate",
        slot = 5,
        target = 64
    },
    {
        name = "Ethereal Slate",
        slot = 6,
        target = 64
    }   
}
local lifeEssenceTarget = 1000000
local bloodOrbLabel = "Master Blood Orb"
local bloodOrbSlot = 7

-- Configured for GTNH, Higher blood requirements than normal.

local slateInfo = {
    {
        name = "Arcane Slate",
        id = "dreamcraft:ArcaneSlate",
        blood = 0,
        tier = 0
    },
    {
        name = "Blank Slate",
        id = "AWWayOfTime:blankSlate",
        blood = 1000,
        tier = 1
    },
    {
        name = "Reinforced Slate",
        id = "AWWayOfTime:reinforcedSlate",
        blood = 2500,
        tier = 2
    },
    {
        name = "Imbued Slate",
        id = "AWWayOfTime:imbuedSlate",
        blood = 7500,
        tier = 3
    },
    {
        name = "Demonic Slate",
        id = "AWWayOfTime:demonicSlate",
        blood = 20000,
        tier = 4
    },
    {
        name = "Ethereal Slate",
        id = "AWWayOfTime:bloodMagicBaseItems",
        blood = 60000,
        tier = 5
    }   
}

function GetLifeEssence()
    for i, fluid in pairs(component.me_interface.getFluidsInNetwork()) do
        if fluid["label"] == "Life Essence" then
            local a = fluid.amount
            if a == nil then
                return 0
            else
                return fluid.amount
            end
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

function CraftSlate(craft_slot, ingredient_slot)
    local crafting = true
    -- Move Blood Orb Out --
    if transposer.getSlotStackSize(altarSide, altarSlot) == 0 then
        term.write("No Blood Orb in Altar detected\n")
    else
        if transposer.getStackInSlot(altarSide, altarSlot).label == bloodOrbLabel then
            term.write("Found Blood Orb in Altar, moving it out to begin crafting\n")
            if transposer.transferItem(altarSide, dualinterfaceSide, 1, altarSlot, bloodOrbSlot) ~= 1 then
                term.write("Could not move Blood Orb, Failing\n")
            end
        end
    end
    -- Insert a stone into the altar --
    if transposer.transferItem(dualinterfaceSide, altarSide, 1, slateConfig[ingredient_slot]["slot"], altarSlot) ~= 1 then
        term.write("Could not move Slate in, Failing\n")
    else
        term.write(string.format("Crafting: %s using %s mb\n", slateInfo[craft_slot].name, slateInfo[craft_slot].blood))
    end
    while crafting do
        if transposer.getStackInSlot(altarSide, altarSlot).label == slateConfig[craft_slot]["name"] then
            if transposer.transferItem(altarSide, dualinterfaceSide, 1, altarSlot, craft_slot) ~= 1 then
                term.write("Could not move Slate out, Failing\n")
            else
                term.write(string.format("Craft Complete: %s\n", slateInfo[craft_slot].name))
                crafting=false
            end
        end
    end
end


function LifeEssenceStatus()
    if term.isAvailable() then
        term.clearLine()
        term.write(string.format("AE2 Blood Level:  %s mb / %s mb\n", GetLifeEssence(), lifeEssenceTarget))
    end
end

term.clear()
while true do
    LifeEssenceStatus()
    if GetItem("Arcane Slate") ~= nil and GetItem("Blank Slate") ~= nil then
        if GetItem("Arcane Slate") > 0 and GetItem("Blank Slate") < slateConfig[2]["target"] then
            CraftSlate(2, 1)
        end
    end
    if GetItem("Blank Slate") ~= nil and GetItem("Reinforced Slate") ~= nil then
        if bloodAltarTier >= 2 and GetItem("Blank Slate") > 0 and GetItem("Reinforced Slate") < slateConfig[3]["target"] then
            CraftSlate(3, 2)
        end
    end
    if GetItem("Reinforced Slate") ~= nil and GetItem("Imbued Slate") ~= nil then
        if bloodAltarTier >= 3 and GetItem("Reinforced Slate") > 0 and GetItem("Imbued Slate") < slateConfig[4]["target"] then
            CraftSlate(4, 3)
        end
    end
    if GetItem("Imbued Slate") ~= nil and GetItem("Demonic Slate") ~= nil then
        if  bloodAltarTier >= 4 and GetItem("Imbued Slate") > 0 and GetItem("Demonic Slate") < slateConfig[5]["target"] then
            CraftSlate(5, 4)
        end
    end
    if GetItem("Demonic Slate") ~= nil and GetItem("Ethereal Slate") ~= nil then
        if bloodAltarTier >= 5 and GetItem("Demonic Slate") > 0 and GetItem("Ethereal Slate") < slateConfig[6]["target"] then
        CraftSlate(6, 5)
        end
    end
    -- Put Blood Orb _Back In_ --
    -- Check LP levels --
    -- Check Altar Levels --
    -- Repeat --
end