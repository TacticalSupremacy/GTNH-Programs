-- AE2 Wrapper -- 
-- 

local component = require("component")

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