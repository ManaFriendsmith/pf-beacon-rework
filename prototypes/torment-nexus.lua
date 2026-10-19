local item_sounds = require("__base__.prototypes.item_sounds")

local n = 1
local profile = {}

while n < 100 do
    table.insert(profile, 1 / n)
    n = n + 1
end

data:extend({
    {
        type = "beacon",
        name = "torment-nexus",
        icon = "__pf-beacon-rework__/graphics/icons/torment-nexus.png",
        icon_size = 64,
        max_health = 400,
        flags = { "placeable-neutral", "placeable-player", "player-creation" },
        fast_replaceable_group = "torment-nexus",
        minable = { mining_time = 0.3, result = "torment-nexus" },
        dying_explosion = "beacon-explosion",
        corpse = "beacon-remnants",
        damaged_trigger_effect = table.deepcopy(data.raw.beacon.beacon.damaged_trigger_effect),
        heating_energy = mods["space-age"] and "100kW" or nil,
        collision_box = { { -1.8, -1.8 }, { 1.8, 1.8 } },
        selection_box = { { -2, -2 }, { 2, 2 } },
        module_slots = 6,
        allowed_effects = { "consumption", "speed", "quality", "productivity", "pollution" },
        allowed_module_categories = { "speed", "efficiency" },
        icons_positioning = { { inventory_index = defines.inventory.beacon_modules, max_icons_per_row = 6 } },
        graphics_set = {
            animation_progress = 1,
            no_modules_tint = { 1, 0, 0 },
            module_tint_mode = "single-module",
            apply_module_tint = "primary",
            animation_list = {
                {
                    animation = {
                        layers = {
                            {
                                filename = "__pf-beacon-rework__/graphics/entity/torment-nexus/torment-nexus.png",
                                width = 256,
                                height = 256,
                                frame_count = 1,
                                line_length = 1,
                                scale = 0.5
                            },
                            {
                                filename = "__pf-beacon-rework__/graphics/entity/torment-nexus/eye7.png",
                                width = 256,
                                height = 256,
                                frame_count = 1,
                                line_length = 1,
                                scale = 0.5,
                                draw_as_glow = true
                            }
                        }
                    }
                },
                {
                    apply_tint = true,
                    animation = {
                        filename = "__pf-beacon-rework__/graphics/entity/torment-nexus/torment-nexus-light.png",
                        width = 256,
                        height = 256,
                        frame_count = 26,
                        line_length = 8,
                        scale = 0.5,
                        draw_as_glow = true
                    }
                }
            },
            module_visualisations = { {
                art_style = "vanilla",
                use_for_empty_slots = true,
                tier_offset = 0,
                slots = {
                    {
                        {
                            apply_module_tint = "primary",
                            render_layer = "cargo-hatch",
                            pictures = {
                                width = 256,
                                height = 256,
                                scale = 0.5,
                                variation_count = 1,
                                line_length = 1,
                                draw_as_glow = true,
                                filename = "__pf-beacon-rework__/graphics/entity/torment-nexus/eye1.png"
                            }
                        },
                        {
                            apply_module_tint = "primary",
                            render_layer = "cargo-hatch",
                            pictures = {
                                width = 256,
                                height = 256,
                                scale = 0.5,
                                variation_count = 1,
                                line_length = 1,
                                filename = "__pf-beacon-rework__/graphics/entity/torment-nexus/eye1.png",
                                draw_as_light = true
                            }
                        },
                    },
                    {
                        {
                            apply_module_tint = "primary",
                            render_layer = "object",
                            pictures = {
                                width = 256,
                                height = 256,
                                scale = 0.5,
                                variation_count = 1,
                                line_length = 1,
                                draw_as_glow = true,
                                filename = "__pf-beacon-rework__/graphics/entity/torment-nexus/eye2.png"
                            }
                        },
                        {
                            apply_module_tint = "primary",
                            render_layer = "object",
                            pictures = {
                                width = 256,
                                height = 256,
                                scale = 0.5,
                                variation_count = 1,
                                line_length = 1,
                                filename = "__pf-beacon-rework__/graphics/entity/torment-nexus/eye2.png",
                                draw_as_light = true
                            }
                        },
                    },
                    {
                        {
                            apply_module_tint = "primary",
                            render_layer = "object",
                            pictures = {
                                width = 256,
                                height = 256,
                                scale = 0.5,
                                variation_count = 1,
                                line_length = 1,
                                draw_as_glow = true,
                                filename = "__pf-beacon-rework__/graphics/entity/torment-nexus/eye3.png"
                            }
                        },
                        {
                            apply_module_tint = "primary",
                            render_layer = "object",
                            pictures = {
                                width = 256,
                                height = 256,
                                scale = 0.5,
                                variation_count = 1,
                                line_length = 1,
                                filename = "__pf-beacon-rework__/graphics/entity/torment-nexus/eye3.png",
                                draw_as_light = true
                            }
                        },
                    },
                    {
                        {
                            apply_module_tint = "primary",
                            render_layer = "object",
                            pictures = {
                                width = 256,
                                height = 256,
                                scale = 0.5,
                                variation_count = 1,
                                line_length = 1,
                                draw_as_glow = true,
                                filename = "__pf-beacon-rework__/graphics/entity/torment-nexus/eye4.png"
                            }
                        },
                        {
                            apply_module_tint = "primary",
                            render_layer = "object",
                            pictures = {
                                width = 256,
                                height = 256,
                                scale = 0.5,
                                variation_count = 1,
                                line_length = 1,
                                filename = "__pf-beacon-rework__/graphics/entity/torment-nexus/eye4.png",
                                draw_as_light = true
                            }
                        },
                    },
                    {
                        {
                            apply_module_tint = "primary",
                            render_layer = "cargo-hatch",
                            pictures = {
                                width = 256,
                                height = 256,
                                scale = 0.5,
                                variation_count = 1,
                                line_length = 1,
                                draw_as_glow = true,
                                filename = "__pf-beacon-rework__/graphics/entity/torment-nexus/eye5.png"
                            }
                        },
                        {
                            apply_module_tint = "primary",
                            render_layer = "cargo-hatch",
                            pictures = {
                                width = 256,
                                height = 256,
                                scale = 0.5,
                                variation_count = 1,
                                line_length = 1,
                                filename = "__pf-beacon-rework__/graphics/entity/torment-nexus/eye5.png",
                                draw_as_light = true
                            }
                        },
                    },
                    {
                        {
                            has_empty_slot = true,
                            render_layer = "higher-object-under",
                            pictures = {
                                width = 64,
                                height = 64,
                                scale = 0.5,
                                variation_count = 1,
                                line_length = 1,
                                draw_as_glow = true,
                                filename = "__pf-beacon-rework__/graphics/entity/void.png"
                            }
                        },
                        {
                            apply_module_tint = "primary",
                            render_layer = "higher-object-under",
                            pictures = {
                                width = 256,
                                height = 256,
                                scale = 0.5,
                                variation_count = 1,
                                line_length = 1,
                                draw_as_glow = true,
                                filename = "__pf-beacon-rework__/graphics/entity/torment-nexus/eye6.png"
                            }
                        },
                        {
                            apply_module_tint = "primary",
                            render_layer = "higher-object-under",
                            pictures = {
                                width = 256,
                                height = 256,
                                scale = 0.5,
                                variation_count = 1,
                                line_length = 1,
                                filename = "__pf-beacon-rework__/graphics/entity/torment-nexus/eye6.png",
                                draw_as_light = true
                            }
                        },
                    }
                }
            } }
        },
        radius_visualisation_picture = table.deepcopy(data.raw.beacon.beacon.radius_visualisation_picture),
        impact_category = "metal-large",
        open_sound = { filename = "__base__/sound/open-close/beacon-open.ogg", volume = 0.5 },
        close_sound = { filename = "__base__/sound/open-close/beacon-close.ogg", volume = 0.5 },
        working_sound = table.deepcopy(data.raw["decider-combinator"]["decider-combinator"].working_sound),
        energy_usage = "8MW",
        energy_source = { type = "electric", emissions_per_minute = { pollution = 20 }, usage_priority = "secondary-input" },
        distribution_effectivity = mods["quality"] and 0.75 or 0.5,
        distribution_effectivity_bonus_per_quality_level = 0.05,
        profile = profile,
        supply_area_distance = 18,
        beacon_counter = "same_type"
    },
    {
        type = "item",
        name = "torment-nexus",
        icon = "__pf-beacon-rework__/graphics/icons/torment-nexus.png",
        icon_size = 64,
        subgroup = "module",
        order = "a[beacon]d",
        place_result = "torment-nexus",
        stack_size = 5,
        weight = 1000 * kg,
        inventory_move_sound = item_sounds.mechanical_large_inventory_move,
        pick_sound = item_sounds.mechanical_large_inventory_pickup,
        drop_sound = item_sounds.mechanical_large_inventory_move
    }
})

local no_texture = {
    layers =
    {
        {
            filename = "__pf-beacon-rework__/graphics/entity/void.png",
            width = 64,
            height = 64
        }
    }
}

local hidden_roboport = table.deepcopy(data.raw.roboport.roboport)

hidden_roboport.name = "torment-nexus-hidden-roboport"
hidden_roboport.icon = "__pf-beacon-rework__/graphics/icons/torment-nexus.png"

hidden_roboport.fast_replaceable_group = "torment-nexus"

hidden_roboport.robot_slots_count = 0
hidden_roboport.material_slots_count = 0

hidden_roboport.collision_mask = table.deepcopy(data.raw["utility-constants"].default.default_collision_masks
    ["roboport"])
hidden_roboport.collision_mask.not_colliding_with_itself = true
hidden_roboport.collision_mask.layers = {}

hidden_roboport.base = no_texture
hidden_roboport.base_patch = no_texture
hidden_roboport.base_animation = no_texture
hidden_roboport.door_animation_up = no_texture
hidden_roboport.door_animation_down = no_texture
hidden_roboport.water_reflection = nil
hidden_roboport.flags = { "not-blueprintable", "not-deconstructable", "placeable-off-grid", "no-automated-item-removal",
    "no-automated-item-insertion", "not-flammable", "not-upgradable", "not-selectable-in-game", "not-in-kill-statistics",
    "no-copy-paste" }
hidden_roboport.max_logistic_slots = 0
hidden_roboport.minable = nil
hidden_roboport.selection_box = { { 0, 0 }, { 0, 0 } }
hidden_roboport.selection_priority = 1
hidden_roboport.quality_indicator_scale = 0

data:extend({ hidden_roboport })

if mods["space-age"] then
    data:extend({
        {
            type = "recipe",
            name = "torment-nexus",
            ingredients = {
                { type = "item",  name = "quantum-processor",     amount = 200 },
                { type = "item",  name = "superconductor",        amount = 200 },
                { type = "item",  name = "productivity-module-3", amount = 10 },
                { type = "item",  name = "roboport",              amount = 10 },
                { type = "item",  name = "beacon",                amount = 10 },
                { type = "fluid", name = "fluoroketone-cold",     amount = 500 },
            },
            results = {
                { type = "item", name = "torment-nexus", amount = 1 }
            },
            energy_required = 20,
            categories = { "cryogenics" },
            enabled = false
        },
        {
            type = "technology",
            name = "torment-nexus",
            icon = "__pf-beacon-rework__/graphics/entity/torment-nexus/torment-nexus.png",
            icon_size = 256,
            unit = {
                count = 10000,
                time = 60,
                ingredients = {
                    { "automation-science-pack",      1 },
                    { "logistic-science-pack",        1 },
                    { "chemical-science-pack",        1 },
                    { "production-science-pack",      1 },
                    { "utility-science-pack",         1 },
                    { "military-science-pack",        1 },
                    { "space-science-pack",           1 },
                    { "metallurgic-science-pack",     1 },
                    { "electromagnetic-science-pack", 1 },
                    { "agricultural-science-pack",    1 },
                    { "cryogenic-science-pack",       1 }
                }
            },
            prerequisites = { "quantum-processor" },
            effects = {
                {
                    type = "unlock-recipe",
                    recipe = "torment-nexus"
                }
            }
        }
    })
else
    data:extend({
        {
            type = "recipe",
            name = "torment-nexus",
            ingredients = {
                { type = "item", name = "processing-unit",       amount = 200 },
                { type = "item", name = "space-science-pack",    amount = 100 },
                { type = "item", name = "productivity-module-3", amount = 10 },
                { type = "item", name = "roboport",              amount = 10 },
                { type = "item", name = "beacon",                amount = 10 }
            },
            results = {
                { type = "item", name = "torment-nexus", amount = 1 }
            },
            energy_required = 20,
            categories = { "crafting" },
            enabled = false
        },
        {
            type = "technology",
            name = "torment-nexus",
            icon = "__pf-beacon-rework__/graphics/entity/torment-nexus/torment-nexus.png",
            icon_size = 256,
            unit = {
                count = 5000,
                time = 30,
                ingredients = {
                    { "automation-science-pack", 1 },
                    { "logistic-science-pack",   1 },
                    { "chemical-science-pack",   1 },
                    { "production-science-pack", 1 },
                    { "utility-science-pack",    1 },
                    { "military-science-pack",   1 },
                    { "space-science-pack",      1 },
                }
            },
            prerequisites = { "space-science-pack" },
            effects = {
                {
                    type = "unlock-recipe",
                    recipe = "torment-nexus"
                }
            }
        }
    })
end
