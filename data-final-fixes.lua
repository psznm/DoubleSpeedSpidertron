
local eq1 = data.raw["movement-bonus-equipment"]["DoubleSpeedSpidertron_exoskeleton-equipment"]
local eq2 = data.raw["generator-equipment"]["DoubleSpeedSpidertron_fusion-reactor-equipment"]

for index, spider in pairs(data.raw["spider-vehicle"]) do
    local gridName = spider.equipment_grid

    local grid = data.raw["equipment-grid"][gridName]
    if (grid ~= nil and grid.equipment_categories ~= nil ) then
        for index, eqCategory in pairs(grid.equipment_categories) do
            table.insert(eq1.categories, eqCategory)
            table.insert(eq2.categories, eqCategory)
        end
    end
end