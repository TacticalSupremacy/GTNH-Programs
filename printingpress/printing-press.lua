local term = require("term")
local component = require("component")
local transposer = component.transposer

local fortunebookcraft = 256

local meinterfaceside = 3
local meibookslot = 1
local meiinkslot = 2
local meiplateslot = 3
local meidamagedplateslot = 4
local meioutputslot = 5

local printingpressside = 5
local ppinkslot = 1
local ppplateslot = 2
local ppbookslot = 3
local ppoutputslot = 4


function AE2GetItem(label)
    for i, item in pairs(component.me_interface.getItemsInNetwork({label = label})) do
        return item.size
    end
end

function AE2GetItemWithDamage(label, damage)
    for i, item in pairs(component.me_interface.getItemsInNetwork({label = label, damage = damage})) do
        return item.size
    end
end

function CraftBook()
    --Handle Plates--
    if transposer.getSlotStackSize(printingpressside, ppplateslot) == 0 then
        if transposer.transferItem(meinterfaceside, printingpressside, 1, meiplateslot, ppplateslot) ~= 1
            term.write("Plate Inserted")
        else 
            term.write("Plate did not get inserted, please investigate")
            os.exit()
        end
    else
        if transposer.getStackInSlot(printingpressside, ppplateslot)["damage"] == 2 then
            -- remove a damaged plate
            if transposer.transferItem(printingpressside, meinterfaceside, 1, ppplateslot, meidamagedplateslot) ~= 1
                term.write("Damaged Plate Removed")
            else 
                term.write("Damaged Plate did not get removed, please investigate")
                os.exit()
            end
        else if transposer.getStackInSlot(printingpressside,2)["damage"] == 1 then
            -- eh this is fine --
        end
    end

    -- Check Ink -- 
    if transposer.getStackInSlot(printingpressside, ppinkslot)["size"] < 32 then
        transposer.transferItem(meinterfaceside, printingpressside, 16, meiinkslot, ppinkslot)
    end
    -- Check Books --
    if transposer.getStackInSlot(printingpressside, ppbookslot)["size"] < 32 then
        transposer.transferItem(meinterfaceside, printingpressside, 16, meibookslot, ppbookslot)
    end

    -- Now we wait on a book and remove it --
    local crafting = true
    while crafting is true
        if transposer.getStackInSlot(5,3) ~= nil then
            transposer.transferItem(printingpressside, meinterfaceside, 1, ppoutoutslot, meioutputslot)
            crafting = false
        end
    end
end

-- Check AE2 for FortuneBooks? if less than target continue. Apparently NBT data is not exposed. Press F

if AE2GetItem("Ink Sac") < fortunebookcraft
    term.write("Not Enough Ink Sac's to craft target")
    os.exit()
end

if AE2GetItem("Book") < fortunebookcraft
    term.write("Not Enough Book's to craft target")
    os.exit()
end

if AE2GetItemWithDamage("Enchanted Plate", 0) < (fortunebookcraft / 2)
    term.write("Not enough undamaged plates are detected in AE2 to craft target")
    os.exit()
end

for i = 1, fortunebookcraft, 1 do
    term.write("Crafting Book Number:")
    CraftBook()
end

term.write("Program Finished")