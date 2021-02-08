
local eq1 = data.raw["movement-bonus-equipment"]["DoubleSpeedSpidertron_exoskeleton-equipment"]
local eq2 = data.raw["generator-equipment"]["DoubleSpeedSpidertron_fusion-reactor-equipment"]

if mods["bobvehicleequipment"] then
    table.insert(eq1.categories, "vehicle-equipment")
    table.insert(eq2.categories, "vehicle-equipment")
end
if mods["vtk-armor-plating"] then
    table.insert(eq1.categories, "vtk-armor-plating")
    table.insert(eq2.categories, "vtk-armor-plating")
end
if mods["Krastorio2"] then
    table.insert(eq1.categories, "universal-equipment")
    table.insert(eq1.categories, "vehicle-equipment")
    table.insert(eq1.categories, "vehicle-motor")
	
    table.insert(eq2.categories, "universal-equipment")
    table.insert(eq2.categories, "vehicle-equipment")
    table.insert(eq2.categories, "vehicle-motor")
end