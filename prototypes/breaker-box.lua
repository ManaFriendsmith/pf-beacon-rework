local item_sounds = require("__base__.prototypes.item_sounds")

local n = 1
local profile = {}

while n < 100 do
    table.insert(profile, 1 / n)
    n = n + 1
end

local distribution_per_quality = 0.05
if mods["tuner-upper"] then
    if settings.startup["tuner-upper-nerf-quality-power"].value then
        distribution_per_quality = 0.1
    end
end

data:extend({
    {
        type = "beacon",
        name = "breaker-box",
        icon = "__pf-beacon-rework__/graphics/icons/breaker-box.png",
        icon_size = 64,
        max_health = 200,
        flags = { "placeable-neutral", "placeable-player", "player-creation" },
        fast_replaceable_group = "breaker-box",
        minable = { mining_time = 0.3, result = "breaker-box" },
        dying_explosion = "beacon-explosion",
        corpse = "beacon-remnants",
        damaged_trigger_effect = table.deepcopy(data.raw.beacon.beacon.damaged_trigger_effect),
        collision_box = { { -0.8, -0.8 }, { 0.8, 0.8 } },
        selection_box = { { -1, -1 }, { 1, 1 } },
        module_slots = 4,
        allowed_effects = { "consumption", "speed", "quality", "productivity", "pollution" },
        allowed_module_categories = { "efficiency" },
        animation = {
            layers = {
                {
                    filename = "__pf-beacon-rework__/graphics/entity/breaker-box.png",
                    width = 128,
                    height = 128,
                    frame_count = 1,
                    line_length = 1,
                    scale = 0.5
                }
            }
        },
        icons_positioning = { { inventory_index = defines.inventory.beacon_modules, shift = { 0, 0 }, scale = 0.5, max_icons_per_row = 2 } },
        radius_visualisation_picture = table.deepcopy(data.raw.beacon.beacon.radius_visualisation_picture),
        impact_category = "metal-large",
        open_sound = { filename = "__base__/sound/open-close/electric-large-open.ogg", volume = 0.5 },
        close_sound = { filename = "__base__/sound/open-close/electric-large-close.ogg", volume = 0.5 },
        energy_usage = "1W",
        energy_source = { type = "void" },
        distribution_effectivity = 0.5,
        distribution_effectivity_bonus_per_quality_level = distribution_per_quality,
        quality_affects_supply_area_distance = true,
        profile = profile,
        supply_area_distance = 8,
        beacon_counter = "same_type"
    },
    {
        type = "recipe",
        name = "breaker-box",
        ingredients = {
            { type = "item", name = "steel-plate",    amount = 5 },
            { type = "item", name = "electronic-circuit", amount = 5 },
            { type = "item", name = "copper-cable",   amount = 60 }
        },
        results = {
            { type = "item", name = "breaker-box", amount = 1 }
        },
        energy_required = 3,
        categories = mods["space-age"] and { "crafting", "electromagnetics" } or { "crafting" },
        enabled = false
    },
    {
        type = "item",
        name = "breaker-box",
        icon = "__pf-beacon-rework__/graphics/icons/breaker-box.png",
        icon_size = 64,
        subgroup = "module",
        order = "a[beacon]b",
        place_result = "breaker-box",
        stack_size = 50,
        weight = 50 * kg,
        inventory_move_sound = item_sounds.electric_large_inventory_move,
        pick_sound = item_sounds.electric_large_inventory_pickup,
        drop_sound = item_sounds.electric_large_inventory_move
    },
    {
        type = "technology",
        name = "breaker-box",
        icon = "__pf-beacon-rework__/graphics/technology/breaker-box.png",
        icon_size = 256,
        unit = {
            count = 100,
            time = 30,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 }
            }
        },
        prerequisites = { "efficiency-module" },
        effects = {
            {
                type = "unlock-recipe",
                recipe = "breaker-box"
            }
        }
    }
})

--superstations may be re-added if i can figure out a way to make their runtime code not super janky
--the issue is they're a compound entity and both entities need to be blueprintable and interactable
--and they need to be fast-replaceable without deleting inventory/wires, and accessible to inserters
--i'm sure someone smarter than me has figured out how to do this sort of thing but i don't know how

--[[

data:extend({
    {
        type = "item",
        name = "superstation-breaker-box",
        icon = "__pf-beacon-rework__/graphics/icons/breaker-box.png",
        icon_size = 64,
        stack_size = 50,
        weight = 50 * kg,
        hidden = true,
        hidden_in_factoriopedia = true,
        inventory_move_sound = item_sounds.electric_large_inventory_move,
        pick_sound = item_sounds.electric_large_inventory_pickup,
        drop_sound = item_sounds.electric_large_inventory_move
    },
    {
        type = "item",
        name = "superstation",
        icons = {
            {
                icon = "__base__/graphics/icons/substation.png",
                icon_size = 64,
                tint = { r = 0.8, g = 0.5, b = 1 }
            }
        },
        subgroup = "module",
        order = "a[beacon]b",
        place_result = "superstation",
        stack_size = 50,
        weight = 50 * kg,
        inventory_move_sound = item_sounds.electric_large_inventory_move,
        pick_sound = item_sounds.electric_large_inventory_pickup,
        drop_sound = item_sounds.electric_large_inventory_move
    },
    {
        type = "recipe",
        name = "superstation",
        ingredients = {
            { type = "item", name = "substation",                                            amount = 1 },
            { type = "item", name = "breaker-box",                                           amount = 1 },
            { type = "item", name = mods["space-age"] and "superconductor" or "processing-unit", amount = mods["space-age"] and 10 or 5 }
        },
        results = {
            { type = "item", name = "superstation", amount = 1 }
        },
        energy_required = 3,
        categories = mods["space-age"] and { "crafting", "electromagnetics" } or { "crafting" },
        enabled = false
    }
})

data.raw["electric-pole"]["substation"].fast_replaceable_group = "breaker-box"

local superstation = table.deepcopy(data.raw["electric-pole"]["substation"])
superstation.name = "superstation"
superstation.pictures.layers[1].tint = {r=0.8, g=0.5, b=1}
superstation.minable.result = "superstation"
superstation.icons = {
            {
                icon = "__base__/graphics/icons/substation.png",
                icon_size = 64,
                tint = {r=0.8, g=0.5, b=1}
            }
        }
superstation.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
superstation.selection_priority = 51
superstation.quality_indicator_shift = {-0.5, 0.5}

local collision = table.deepcopy(data.raw["utility-constants"].default.default_collision_masks["beacon"])
collision.not_colliding_with_itself = true
collision.layers = {}

local superstation_breaker_box = table.deepcopy(data.raw.beacon["breaker-box"])
superstation_breaker_box.name = "superstation-breaker-box"
superstation_breaker_box.fast_replaceable_group = nil
superstation_breaker_box.animation = nil
superstation_breaker_box.collision_mask = collision
superstation_breaker_box.icons = {
            {
                icon = "__base__/graphics/icons/substation.png",
                icon_size = 64,
                tint = {r=0.8, g=0.5, b=1}
            }
        }
superstation_breaker_box.minable.result = "superstation"
superstation_breaker_box.flags = {"placeable-neutral", "placeable-player", "player-creation", "not-flammable", "not-upgradable", "not-in-kill-statistics"}
superstation_breaker_box.placeable_by = {item="superstation-breaker-box", count=1}

data:extend(
    {superstation, superstation_breaker_box}
)

if mods["space-age"] then
    data:extend({
        {
            type = "technology",
            name = "superstation",
            icons = {{
                icon = "__base__/graphics/technology/electric-energy-distribution-2.png",
                icon_size = 256,
                tint = {r=0.8, g=0.5, b=1}
            }},
            unit = {
                count = 500,
                time = 60,
                ingredients = {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1},
                    {"chemical-science-pack", 1},
                    {"utility-science-pack", 1},
                    {"space-science-pack", 1},
                    {"electromagnetic-science-pack", 1}
                }
            },
            prerequisites = {"electromagnetic-science-pack", "utility-science-pack", "electric-energy-distribution-2", "breaker-box"},
            effects = {
                {
                    type = "unlock-recipe",
                    recipe = "superstation"
                }
            }
        }
    })
else
    data:extend({
        {
            type = "technology",
            name = "superstation",
            icons = {{
                icon = "__base__/graphics/technology/electric-energy-distribution-2.png",
                icon_size = 256,
                tint = {r=0.8, g=0.5, b=1}
            }},
            unit = {
                count = 200,
                time = 60,
                ingredients = {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1},
                    {"chemical-science-pack", 1},
                    {"utility-science-pack", 1}
                }
            },
            prerequisites = {"utility-science-pack", "electric-energy-distribution-2", "breaker-box"},
            effects = {
                {
                    type = "unlock-recipe",
                    recipe = "superstation"
                }
            }
        }
    })
end
]] --
