-- AE2 Wrapper -- 
-- 

function GetLifeEssence()
    for i, fluid in pairs(component.me_interface.getFluidsInNetwork()) do
        if fluid["label"] == "Life Essence" then
            return fluid.amount
        end
    end
end