local item_sounds = require("__base__.prototypes.item_sounds")
local rm = require("__pf-functions__/recipe-manipulation")
local tm = require("__pf-functions__/technology-manipulation")

local qual_boost = 0.025
if mods["tuner-upper"] then
    if settings.startup["tuner-upper-nerf-quality-power"].value then
        qual_boost = 0.05
    else
        qual_boost = 0.04
    end
end

local function recycling_icon(icon)
    if mods["recycler"] then
        return {
            {
                icon = "__recycler__/graphics/icons/recycling.png",
                icon_size = 64
            },
            {
                icon = icon,
                icon_size = 64,
                scale = 0.37
            },
            {
                icon = "__recycler__/graphics/icons/recycling-top.png",
                icon_size = 64
            }
        }
    else
        return {
            {
                icon = icon,
                icon_size = 64
            },
            {
                icon = "__pf-beacon-rework__/graphics/icons/recycle-overlay.png",
                icon_size = 64
            }
        }
    end
end

data:extend({
    {
        type = "module-category",
        name = "overclocked-speed"
    },
    {
        type = "module-category",
        name = "overclocked-efficiency"
    },
    {
        type = "module",
        name = "overclocked-speed-module",
        icon = "__pf-beacon-rework__/graphics/icons/overclocked-speed-module.png",
        icon_size = 64,
        stack_size = 50,
        subgroup = "module",
        order = "a[speed]-d[overclocked]",
        effect = { speed = 0.75, consumption = 1.25 },
        spoil_ticks = minute * 15,
        spoil_result = "burnt-out-speed-module",
        category = "overclocked-speed",
        tier = 4,
        weight = 20 * kg,
        art_style = "vanilla",
        beacon_tint = {
            primary = { 0, 0, 1, 1.000 },
            secondary = { 0.4, 0.4, 1.000, 1.000 }
        },
        auto_recycle = false,
        inventory_move_sound = item_sounds.module_inventory_move,
        pick_sound = item_sounds.module_inventory_pickup,
        drop_sound = item_sounds.module_inventory_move
    },
    {
        type = "module",
        name = "overclocked-efficiency-module",
        icon = "__pf-beacon-rework__/graphics/icons/overclocked-efficiency-module.png",
        icon_size = 64,
        stack_size = 50,
        subgroup = "module",
        order = "c[efficiency]-d[overclocked]",
        effect = { consumption = -1, pollution = -0.15, speed = 0.05 },
        spoil_ticks = minute * 60,
        spoil_result = "burnt-out-efficiency-module",
        category = "overclocked-efficiency",
        tier = 4,
        weight = 20 * kg,
        art_style = "vanilla",
        beacon_tint = {
            primary = { 1, 1, 0 },
            secondary = { 1, 1.000, 0.5, 1.000 }
        },
        auto_recycle = false,
        inventory_move_sound = item_sounds.module_inventory_move,
        pick_sound = item_sounds.module_inventory_pickup,
        drop_sound = item_sounds.module_inventory_move
    },
    {
        type = "module",
        name = "burnt-out-speed-module",
        icon = "__pf-beacon-rework__/graphics/icons/burnt-out-speed-module.png",
        icon_size = 64,
        stack_size = 50,
        effect = {},
        category = "overclocked-speed",
        tier = 0,
        weight = 20 * kg,
        subgroup = "module",
        order = "a[speed]-e[burnt]",
        art_style = "vanilla",
        beacon_tint = {
            primary = { 0, 0, 1, 1.000 },
            secondary = { 0.4, 0.4, 1.000, 1.000 }
        },
        auto_recycle = false,
        inventory_move_sound = item_sounds.module_inventory_move,
        pick_sound = item_sounds.module_inventory_pickup,
        drop_sound = item_sounds.module_inventory_move
    },
    {
        type = "module",
        name = "burnt-out-efficiency-module",
        icon = "__pf-beacon-rework__/graphics/icons/burnt-out-efficiency-module.png",
        icon_size = 64,
        stack_size = 50,
        effect = {},
        category = "overclocked-efficiency",
        tier = 0,
        weight = 20 * kg,
        subgroup = "module",
        order = "c[efficiency]-e[burnt]",
        art_style = "vanilla",
        beacon_tint = {
            primary = { 1, 1, 0 },
            secondary = { 1, 1.000, 0.5, 1.000 }
        },
        auto_recycle = false,
        inventory_move_sound = item_sounds.module_inventory_move,
        pick_sound = item_sounds.module_inventory_pickup,
        drop_sound = item_sounds.module_inventory_move
    },
    {
        type = "recipe",
        name = "overclocked-speed-module",
        ingredients = {
            { type = "item", name = "speed-module-3",  amount = 1 },
            { type = "item", name = "processing-unit", amount = 1 }
        },
        results = {
            { type = "item", name = "overclocked-speed-module", amount = 1 }
        },
        enabled = false,
        maximum_productivity = 0,
        allow_quality = false,
        auto_recycle = false,
        localised_description = { mods["space-age"] and "recipe-description.overclock-dlc" or "recipe-description.overclock-vanilla" },
        energy_required = 20,
        preserve_products_in_machine_output = true,
        categories = { mods["space-age"] and "electromagnetics" or "crafting" }
    },
    {
        type = "recipe",
        name = "overclocked-efficiency-module",
        ingredients = {
            { type = "item", name = "efficiency-module-3", amount = 1 },
            { type = "item", name = "processing-unit",     amount = 1 }
        },
        results = {
            { type = "item", name = "overclocked-efficiency-module", amount = 1 }
        },
        enabled = false,
        maximum_productivity = 0,
        allow_quality = false,
        auto_recycle = false,
        localised_description = { mods["space-age"] and "recipe-description.overclock-dlc" or "recipe-description.overclock-vanilla" },
        energy_required = 20,
        preserve_products_in_machine_output = true,
        categories = { mods["space-age"] and "electromagnetics" or "crafting" }
    },
    {
        type = "recipe",
        name = "burnt-out-speed-module-recycling",
        localised_name = { "recipe-name.recycling", { "item-name.burnt-out-speed-module" } },
        icons = recycling_icon("__pf-beacon-rework__/graphics/icons/burnt-out-speed-module.png"),
        subgroup = "module",
        order = "a[speed]-f[recycle]",
        ingredients = {
            { type = "item", name = "burnt-out-speed-module", amount = 1 }
        },
        results = {
            { type = "item", name = "speed-module-3",     amount = 1, independent_probability = 0.95 },
            { type = "item", name = "electronic-circuit", amount = 1, independent_probability = 0.1 },
            { type = "item", name = "advanced-circuit",   amount = 1, independent_probability = 0.05 },
            { type = "item", name = "processing-unit",    amount = 1, independent_probability = 0.025 }
        },
        enabled = true,
        hidden = not not mods["recycler"],
        energy_required = 10,
        preserve_products_in_machine_output = true,
        categories = { mods["recycler"] and "recycling" or "advanced-crafting" }
    },
    {
        type = "recipe",
        name = "burnt-out-efficiency-module-recycling",
        subgroup = "module",
        order = "c[efficiency]-f[recycle]",
        icons = recycling_icon("__pf-beacon-rework__/graphics/icons/burnt-out-efficiency-module.png"),
        localised_name = { "recipe-name.recycling", { "item-name.burnt-out-efficiency-module" } },
        ingredients = {
            { type = "item", name = "burnt-out-efficiency-module", amount = 1 }
        },
        results = {
            { type = "item", name = "efficiency-module-3", amount = 1, independent_probability = 0.95 },
            { type = "item", name = "electronic-circuit",  amount = 1, independent_probability = 0.1 },
            { type = "item", name = "advanced-circuit",    amount = 1, independent_probability = 0.05 },
            { type = "item", name = "processing-unit",     amount = 1, independent_probability = 0.025 }
        },
        enabled = true,
        hidden = not not mods["recycler"],
        energy_required = 10,
        preserve_products_in_machine_output = true,
        categories = { mods["recycler"] and "recycling" or "advanced-crafting" }
    },
    {
        type = "technology",
        name = "overclocked-speed-module",
        icon = "__pf-beacon-rework__/graphics/technology/overclocked-speed-module.png",
        icon_size = 256,
        unit = {
            count = 2000,
            time = 60,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                { "chemical-science-pack",   1 },
                { "production-science-pack", 1 },
                { "utility-science-pack",    1 },
                { "space-science-pack",      1 }
            }
        },
        prerequisites = { "space-science-pack", "speed-module-3" },
        effects = {
            {
                type = "unlock-recipe",
                recipe = "overclocked-speed-module"
            },
            {
                type = "unlock-recipe",
                recipe = "burnt-out-speed-module-recycling"
            }
        }
    },
    {
        type = "technology",
        name = "overclocked-efficiency-module",
        icon = "__pf-beacon-rework__/graphics/technology/overclocked-efficiency-module.png",
        icon_size = 256,
        unit = {
            count = 2000,
            time = 60,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                { "chemical-science-pack",   1 },
                { "production-science-pack", 1 },
                { "utility-science-pack",    1 },
                { "space-science-pack",      1 }
            }
        },
        prerequisites = { "space-science-pack", "efficiency-module-3" },
        effects = {
            {
                type = "unlock-recipe",
                recipe = "overclocked-efficiency-module"
            },
            {
                type = "unlock-recipe",
                recipe = "burnt-out-efficiency-module-recycling"
            }
        }
    }
})

if mods["recycler"] then
    data:extend({
        {
            type = "recipe",
            name = "overclocked-speed-module-recycling",
            localised_name = { "recipe-name.recycling", { "item-name.overclocked-speed-module" } },
            icons = recycling_icon("__pf-beacon-rework__/graphics/icons/overclocked-speed-module.png"),
            ingredients = {
                { type = "item", name = "overclocked-speed-module", amount = 1 }
            },
            results = {
                { type = "item", name = "speed-module-3",     amount = 1, independent_probability = 0.95 },
                { type = "item", name = "electronic-circuit", amount = 1, independent_probability = 0.1 },
                { type = "item", name = "advanced-circuit",   amount = 1, independent_probability = 0.05 },
                { type = "item", name = "processing-unit",    amount = 1, independent_probability = 0.025 }
            },
            enabled = true,
            hidden = true,
            energy_required = 10,
            preserve_products_in_machine_output = true,
            categories = { mods["recycler"] and "recycling" or "advanced-crafting" }
        },
        {
            type = "recipe",
            name = "overclocked-efficiency-module-recycling",
            localised_name = { "recipe-name.recycling", { "item-name.overclocked-efficiency-module" } },
            icons = recycling_icon("__pf-beacon-rework__/graphics/icons/overclocked-efficiency-module.png"),
            ingredients = {
                { type = "item", name = "overclocked-efficiency-module", amount = 1 }
            },
            results = {
                { type = "item", name = "efficiency-module-3", amount = 1, independent_probability = 0.95 },
                { type = "item", name = "electronic-circuit",  amount = 1, independent_probability = 0.1 },
                { type = "item", name = "advanced-circuit",    amount = 1, independent_probability = 0.05 },
                { type = "item", name = "processing-unit",     amount = 1, independent_probability = 0.025 }
            },
            enabled = true,
            hidden = true,
            energy_required = 10,
            preserve_products_in_machine_output = true,
            categories = { mods["recycler"] and "recycling" or "advanced-crafting" }
        }
    })
    data.raw.module["overclocked-speed-module"].localised_description = { "item-description.hint-nonstandard-recycling" }
    data.raw.module["overclocked-efficiency-module"].localised_description = {
        "item-description.hint-nonstandard-recycling" }

    if not mods["space-age"] then
        tm.AddPrerequisite("overclocked-speed-module", "recycling")
        tm.AddPrerequisite("overclocked-efficiency-module", "recycling")
    end
end

table.insert(data.raw.beacon.beacon.allowed_module_categories, "overclocked-speed")
table.insert(data.raw.beacon["torment-nexus"].allowed_module_categories, "overclocked-speed")
table.insert(data.raw.beacon.beacon.allowed_module_categories, "overclocked-efficiency")
table.insert(data.raw.beacon["torment-nexus"].allowed_module_categories, "overclocked-efficiency")
table.insert(data.raw.beacon["breaker-box"].allowed_module_categories, "overclocked-efficiency")
--table.insert(data.raw.beacon["superstation-breaker-box"].allowed_module_categories, "overclocked-efficiency")

if mods["quality"] then
    data:extend({
        {
            type = "module-category",
            name = "overclocked-quality"
        },
        {
            type = "module",
            name = "overclocked-quality-module",
            icon = "__pf-beacon-rework__/graphics/icons/overclocked-quality-module.png",
            icon_size = 64,
            stack_size = 50,
            weight = 20 * kg,
            subgroup = "module",
            order = "d[quality]-d[overclocked]",
            effect = { quality = qual_boost, consumption = 0.1 },
            spoil_ticks = minute * 15,
            spoil_result = "burnt-out-quality-module",
            category = "overclocked-quality",
            tier = 4,
            art_style = "vanilla",
            beacon_tint = {
                primary = { 0.5, 0, 1.000, 1.000 },
                secondary = { 0.75, 0.5, 1.000, 1.000 }
            },
            auto_recycle = false,
            inventory_move_sound = item_sounds.module_inventory_move,
            pick_sound = item_sounds.module_inventory_pickup,
            drop_sound = item_sounds.module_inventory_move
        },
        {
            type = "module",
            name = "burnt-out-quality-module",
            icon = "__pf-beacon-rework__/graphics/icons/burnt-out-quality-module.png",
            localised_description = { "item-description.hint-nonstandard-recycling" },
            icon_size = 64,
            stack_size = 50,
            weight = 20 * kg,
            subgroup = "module",
            order = "d[quality]-e[burnt]",
            effect = {},
            category = "overclocked-quality",
            tier = 0,
            art_style = "vanilla",
            beacon_tint = {
                primary = { 0.5, 0, 1.000, 1.000 },
                secondary = { 0.75, 0.5, 1.000, 1.000 }
            },
            auto_recycle = false,
            inventory_move_sound = item_sounds.module_inventory_move,
            pick_sound = item_sounds.module_inventory_pickup,
            drop_sound = item_sounds.module_inventory_move
        },
        {
            type = "recipe",
            name = "overclocked-quality-module",
            ingredients = {
                { type = "item", name = "quality-module-3", amount = 1 },
                { type = "item", name = "processing-unit",  amount = 1 }
            },
            results = {
                { type = "item", name = "overclocked-quality-module", amount = 1 }
            },
            enabled = false,
            maximum_productivity = 0,
            allow_quality = false,
            auto_recycle = false,
            localised_description = { mods["space-age"] and "recipe-description.overclock-dlc" or "recipe-description.overclock-vanilla" },
            energy_required = 20,
            preserve_products_in_machine_output = true,
            categories = { mods["space-age"] and "electromagnetics" or "crafting" }
        },
        {
            type = "recipe",
            name = "burnt-out-quality-module-recycling",
            localised_name = { "recipe-name.recycling", { "item-name.burnt-out-quality-module" } },
            icons = recycling_icon("__pf-beacon-rework__/graphics/icons/burnt-out-quality-module.png"),
            subgroup = "module",
            order = "d[quality]-f[recycle]",
            ingredients = {
                { type = "item", name = "burnt-out-quality-module", amount = 1 }
            },
            results = {
                { type = "item", name = "quality-module-3",   amount = 1, independent_probability = 0.95 },
                { type = "item", name = "electronic-circuit", amount = 1, independent_probability = 0.1 },
                { type = "item", name = "advanced-circuit",   amount = 1, independent_probability = 0.05 },
                { type = "item", name = "processing-unit",    amount = 1, independent_probability = 0.025 }
            },
            enabled = true,
            hidden = not not mods["recycler"],
            energy_required = 10,
            preserve_products_in_machine_output = true,
            categories = { mods["recycler"] and "recycling" or "advanced-crafting" }
        },
        {
            type = "recipe",
            name = "overclocked-quality-module-recycling",
            localised_name = { "recipe-name.recycling", { "item-name.overclocked-quality-module" } },
            icons = recycling_icon("__pf-beacon-rework__/graphics/icons/overclocked-quality-module.png"),
            ingredients = {
                { type = "item", name = "overclocked-quality-module", amount = 1 }
            },
            results = {
                { type = "item", name = "quality-module-3",   amount = 1, independent_probability = 0.95 },
                { type = "item", name = "electronic-circuit", amount = 1, independent_probability = 0.1 },
                { type = "item", name = "advanced-circuit",   amount = 1, independent_probability = 0.05 },
                { type = "item", name = "processing-unit",    amount = 1, independent_probability = 0.025 }
            },
            enabled = true,
            hidden = true,
            energy_required = 10,
            preserve_products_in_machine_output = true,
            categories = { mods["recycler"] and "recycling" or "advanced-crafting" }
        },
        {
            type = "technology",
            name = "overclocked-quality-module",
            icon = "__pf-beacon-rework__/graphics/technology/overclocked-quality-module.png",
            icon_size = 256,
            unit = {
                count = 4000,
                time = 60,
                ingredients = {
                    { "automation-science-pack", 1 },
                    { "logistic-science-pack",   1 },
                    { "chemical-science-pack",   1 },
                    { "production-science-pack", 1 },
                    { "utility-science-pack",    1 },
                    { "space-science-pack",      1 }
                }
            },
            prerequisites = { "space-science-pack", "quality-module-3", mods["space-age"] and "electromagnetic-science-pack" or "recycling" },
            effects = {
                {
                    type = "unlock-recipe",
                    recipe = "overclocked-quality-module"
                },
                {
                    type = "unlock-recipe",
                    recipe = "burnt-out-quality-module-recycling"
                }
            }
        }
    })

    table.insert(data.raw.beacon.beacon.allowed_module_categories, "overclocked-quality")
    table.insert(data.raw.beacon["torment-nexus"].allowed_module_categories, "overclocked-quality")
end

if mods["space-age"] then
    rm.AddIngredient("overclocked-speed-module", "tungsten-plate", 2)
    rm.AddIngredient("overclocked-efficiency-module", "carbon-fiber", 1)
    rm.AddIngredient("overclocked-quality-module", "supercapacitor", 1)

    tm.AddSciencePack("overclocked-speed-module", "electromagnetic-science-pack")
    tm.AddSciencePack("overclocked-speed-module", "metallurgic-science-pack")
    tm.AddPrerequisite("overclocked-speed-module", "electromagnetic-science-pack")
    tm.AddSciencePack("overclocked-efficiency-module", "electromagnetic-science-pack")
    tm.AddSciencePack("overclocked-efficiency-module", "agricultural-science-pack")
    tm.AddPrerequisite("overclocked-efficiency-module", "electromagnetic-science-pack")
    tm.AddSciencePack("overclocked-quality-module", "electromagnetic-science-pack")
end

data:extend({
    {
        type = "tips-and-tricks-item",
        name = "overclocked-modules",
        tag = "[item=overclocked-speed-module]",
        order = "ob",
        indent = 0,
        trigger =
        {
            type = "or",
            triggers =
            {
                {
                    type = "unlock-recipe",
                    recipe = "overclocked-speed-module"
                },
                {
                    type = "unlock-recipe",
                    recipe = "overclocked-efficiency-module"
                },
                {
                    type = "unlock-recipe",
                    recipe = mods["quality"] and  "overclocked-quality-module" or "burnt-out-efficiency-module-recycling"
                }
            }
        },
        simulation = {
            init_update_count = 600,
            init =
            [[
        game.simulation.camera_zoom = 2
        game.simulation.camera_alt_info = true
        game.surfaces[1].build_checkerboard{{-80, -80}, {80, 80}}
        game.surfaces[1].create_entities_from_blueprint_string
        {
          string = "0eNrVnN1yozgQhd+FazyFpBagVO2TpFwujOUMNRi8/GQ3m/K7r7AT25NgT5+eXOzmJrGBr6UjtVDTTV6jdT36fVc1Q/TwGlVl2/TRw+Nr1FdPTVFP3zXFzkcP0dAVTb9vu2Gx9vUQHeKoajb+7+hBHZZx5JuhGip/uvb44WXVjLu178IJ8TujarZVEw4tyu++H6I42rd9uKxtJjsTKrHfbBy9hL8sfbNHG6crVr0fhqp56qczO79rn/1qDMfqwXd+s6oGvwuHtkXd+zg6fX1qy5vlfdeWvu8DYTEGXjBdtuPUZ5UkcbRrN9NJxbCofXFs2KVvh0P8qUf63KO6LTbhm7s9SUM/NlXny9PxPI6Gl/10cTsO+3GS8pMBE9+Q/a6h7CjZlSmaQRPUdndgtNZKBjhNvnSA+733m0UYyLH2C3MZXysY3hRQP8XUzwB0hqFzAJ1jaHdG+zqc11Xlwje+e3pZhHXDd9ui9HNW3JuNycJ63G59t+qrf/zR6d5/ZqypBOiJw3qiFJ+tEpB9WRb6cd0PxfHUGa466zJHAXxfKbCFBLA1yAZWgSu2+9JVoOraZrGvi8H/5gqvUklvvnhN+7reZKLeqP9ob4CVThlwFrtf3x4nL7qau9dExs1SJ3wLb/MJtaAAC0pkQQMjQNgIaGT9A/c+mkRsx2JbCXtmhOfYqYitWGxgS6LA3Y7ORWye3k7C5ultEhGbpbdBdiDgFtBoEZultzESNlNvErF5eiN+Ce6LTSpi8/TOJGym3rmIzdMb8Utw906JiM3Sm5SEzdObtIjN0psAv9RgREMkYvP0thI2U+9UxObpDfilBuMzykVsnt5OwubpbRMRm6W3BfxSgzGr1SI2S29rJGym3iRi8/RG/BKMrmwqYvP0ziRspt65iM3TG/FLMJZKExGbpXeqJGye3qkWsVl6pxe/3Bb9sKia3nfDbJCs74SXSs+xEb8E48vUSthMvVMRm6c34pdgDJjmEjZTEydiszTJLn5Z9L3frespMbUryu9Vc8pefLLwMRIM/Or0lObZd2Xdlj/8ZnGdBInez1n9ORZ1sB7ObdpuV9TTA7bTw7rH16jaXOX4PiRRDucTw3nNqmqeQz/a7uV04eVTmPX9UJQ/oofj4/zZI+rmEX3ziJme/y3n9LusPeux/nHXh++EubM+nGkB+/OUmmcbCVvx2MTLPmh3L/uQWf7q6MDVMUvhWf8xzjrP+uPD5H6owjQRzPN9F6Z4aOrz9CD8fzDdL0vo2hfl7LCan0ONOUrOnnxGoU7jBGym0+SJhM1zmhzYxBgwAMi1hM27OeVGxGbdnHJiLwHG3FsCfs4Cved0rgaza4ZFOw4fb1szfly2u33RFcFjwrd/RFPFydj71Zk/dKOf6wqwZzJgvJGnEjZzeDMRmze8wJ7JgPFG7kRslt4ukbB5ejslYrP0dsgyAOaznBGxeXqThM3U24rYPL0RvwTzWS4TsXl65xI2U28nYrP0Pqbw2XAwoaUSJYI7HlxL4DzJVWJEcKbmiHPmqOZWBGdqnkrgXM0zEZypOeKgaFla4kRwnuZIQZ0BU1sKqagzYG5LKcBDCS3XQyrtKEE1Jwmcq7kVwZmaAx5KaAGiykRwpua5BM7V3IngPM014KGEFmZqJYLzNEdKwQiMchVSC0Ya1RzxULSMEKkGI4NqnkrgXM0zEZypOeKhhGruRHCe5khJGIHhp0JqwgiMPxVSFEZgAKqQqjCyqOYkgXM1tyI4U3PEQ1NU80wEZ2qeS+BczZ0IztP8qjjsbgJkKuC58/oFUgdGaDiLFIIRGs4ilWCEhrNIKRih4SxSC0ZoOIsUgxEaziLVYISGs0g5GKHhLFIPRmg4ixSEERrOIhVhhIazSEkYoeEsUhNm0XAWKQqzaDiLVIVZNJxFysIsGs5e1YXdfBtmGvQbSp/fhqmaGy/DqKvqsF9bcCILjm/h3jtDty2kCWBBiSwAr4Hbj+EW9g7aMRs42wYtaoP70jYYSRtEbxbebgOJ2qDEbVjG0V9hukyZ4EelYxtnFNtl/Dj9iqedm10uT9UXU2L4/B8J4ujZd/2xMTbVzpImlxqTOX04/AvXSvs6",
          position = {0,0},
        }

        game.forces.player.technologies["overclocked-speed-module"].researched = true
        game.forces.player.technologies["railway"].researched = true
        game.forces.player.technologies["inserter-capacity-bonus-1"].researched = true
        game.forces.player.technologies["inserter-capacity-bonus-2"].researched = true
        game.forces.player.technologies["inserter-capacity-bonus-3"].researched = true
        game.forces.player.technologies["inserter-capacity-bonus-4"].researched = true
        game.forces.player.technologies["inserter-capacity-bonus-5"].researched = true
        game.forces.player.technologies["inserter-capacity-bonus-6"].researched = true
        game.forces.player.technologies["inserter-capacity-bonus-7"].researched = true

      ]]
        }
    }
})
