local function RegisterDriveUnit(beacon)
    local new_entry = {
        entity = beacon,
        id = beacon.unit_number, --guaranteed unique to an entity for duration of a game
        last_tick = game.tick,
        stopped = false,
        next = nil,
        prev = nil
    }
    if storage.machine_to_examine then
        --insert after current machine
        new_entry.next = storage.machine_to_examine.next
        new_entry.next.prev = new_entry
        new_entry.prev = storage.machine_to_examine
        storage.machine_to_examine.next = new_entry
    else
        --no machines exist yet
        new_entry.next = new_entry
        new_entry.prev = new_entry
        storage.machine_to_examine = new_entry
    end
    if not storage.drive_unit_lookup then
        storage.drive_unit_lookup = {}
    end
    storage.drive_unit_lookup[beacon.unit_number] = new_entry
end

local function EnableBeacon(entry)
    if entry.stopped then
        entry.stopped = false
        entry.entity.disabled_by_script = false
        entry.entity.update_connections()
        entry.last_tick = game.tick
    end
end

local function DisableBeacon(entry)
    if not entry.stopped then
        entry.stopped = true
        entry.entity.disabled_by_script = true
        entry.entity.update_connections()
    end
    entry.last_tick = game.tick
end

local function SetupCompoundEntities()
    if storage.compound_entities == nil then
        storage.compound_entities = {}
        for k, surf in pairs(game.surfaces) do
            local nexi = surf.find_entities_filtered { name = "torment-nexus" }
            for k2, nexus in pairs(nexi) do
                local new_ent = nexus.surface.create_entity { name = "torment-nexus-hidden-roboport", position = nexus.position, force = nexus.force, quality = nexus.quality }
                storage.compound_entities[nexus.unit_number] = new_ent
                new_ent.backer_name = ""
            end
            local drives = surf.find_entities_filtered { name = "external-drive-unit" }
            for k2, drive in pairs(drives) do
                local new_ent = drive.surface.create_entity { name = "external-drive-unit-lubricant-consumer", position = drive.position, force = drive.force, quality = drive.quality }
                storage.compound_entities[drive.unit_number] = new_ent
                RegisterDriveUnit(drive)
            end
            local stations = surf.find_entities_filtered { name = "superstation" }
            for k2, station in pairs(stations) do
                local new_ent = station.surface.create_entity { name = "superstation-breaker-box", position = station.position, force = station.force, quality = station.quality }
                storage.compound_entities[station.unit_number] = new_ent
            end
        end
    end
end

local function OnBuild(event)
    local e = event.created_entity
    if not e then
        e = event.entity
    end
    if not e.valid then return end
    if storage.compound_entities == nil then
        storage.compound_entities = {}
    end
    if e.name == "torment-nexus" then
        local new_ent = e.surface.create_entity { name = "torment-nexus-hidden-roboport", position = e.position, force = e.force, quality = e.quality }
        storage.compound_entities[e.unit_number] = new_ent
        new_ent.backer_name = ""
    end
    if e.name == "external-drive-unit" then
        local new_ent = e.surface.create_entity { name = "external-drive-unit-lubricant-consumer", position = e.position, force = e.force, quality = e.quality }
        storage.compound_entities[e.unit_number] = new_ent
        RegisterDriveUnit(e)
    end
    if e.name == "superstation" then
        if storage.compound_entities[e.unit_number] then
            storage.compound_entities[e.unit_number].revive()
            local found = e.surface.find_entities_filtered { position = e.position, name = "superstation-breaker-box" }
            storage.compound_entities[e.unit_number] = found[1]
            storage.compound_entities[found[1].unit_number] = e
            found[1].quality = e.quality
        else
            local found = e.surface.find_entities_filtered { position = e.position, ghost_name = "superstation-breaker-box" }
            if found and (#found > 0) then
                found[1].revive()
                local found = e.surface.find_entities_filtered { position = e.position, name = "superstation-breaker-box" }
                storage.compound_entities[e.unit_number] = found[1]
                storage.compound_entities[found[1].unit_number] = e
                found[1].quality = e.quality
            else
                local found = e.surface.find_entities_filtered { position = e.position, name = "superstation-breaker-box" }
                if found and (#found > 0) then
                    storage.compound_entities[e.unit_number] = found[1]
                    storage.compound_entities[found[1].unit_number] = e
                    found[1].quality = e.quality
                else
                    local new_ent = e.surface.create_entity { name = "superstation-breaker-box", position = e.position, force = e.force, quality = e.quality }
                    storage.compound_entities[e.unit_number] = new_ent
                    storage.compound_entities[new_ent.unit_number] = e
                end
            end
        end
    end
    if e.name == "superstation-breaker-box" then
        if storage.compound_entities[e.unit_number] then
            storage.compound_entities[e.unit_number].revive()
        else
            local found = e.surface.find_entities_filtered { position = e.position, ghost_name = "superstation" }
            if found and (#found > 0) then
                found[1].revive()
                local found = e.surface.find_entities_filtered { position = e.position, name = "superstation" }
                storage.compound_entities[e.unit_number] = found[1]
                storage.compound_entities[found[1].unit_number] = e
            else
                local found = e.surface.find_entities_filtered { position = e.position, name = "superstation" }
                if found and (#found > 0) then
                    storage.compound_entities[e.unit_number] = found[1]
                    storage.compound_entities[found[1].unit_number] = e
                else
                    local new_ent = e.surface.create_entity { name = "superstation", position = e.position, force = e.force, quality = e.quality }
                    storage.compound_entities[e.unit_number] = new_ent
                    storage.compound_entities[new_ent.unit_number] = e
                end
            end
        end
    end
end

local function OnRemove(event)
    local e = event.entity
    if not e.valid then return end
    if e.name == "torment-nexus" then
        SetupCompoundEntities()
        if storage.compound_entities[e.unit_number] then
            local fake_port = storage.compound_entities[e.unit_number]
            storage.compound_entities[e.unit_number] = nil
            if fake_port.valid then
                fake_port.destroy()
            end
        end
    end
    if e.name == "external-drive-unit" then
        SetupCompoundEntities()
        if storage.compound_entities[e.unit_number] then
            local fake_port = storage.compound_entities[e.unit_number]
            storage.compound_entities[e.unit_number] = nil
            if fake_port.valid then
                fake_port.destroy()
            end
        end
    end
    if e.name == "superstation-breaker-box" then
        SetupCompoundEntities()
        if storage.compound_entities[e.unit_number] then
            local fake_port = storage.compound_entities[e.unit_number]
            storage.compound_entities[e.unit_number] = nil
            if fake_port.valid then
                storage.compound_entities[fake_port.unit_number] = nil
                fake_port.destroy()
            end
        end
    end
    if e.name == "superstation" then
        SetupCompoundEntities()
        if storage.compound_entities[e.unit_number] then
            local fake_port = storage.compound_entities[e.unit_number]
            storage.compound_entities[e.unit_number] = nil
            if fake_port.valid then
                storage.compound_entities[fake_port.unit_number] = nil
                if fake_port.name == "superstation-breaker-box" and event.buffer then
                    local inv = fake_port.get_inventory(defines.inventory.beacon_modules)
                    local index = 1
                    while index <= #inv do
                        if inv[index] then
                            event.buffer.insert(inv[index])
                        end
                        index = index + 1
                    end
                end
                fake_port.destroy()
            end
        end
    end
end

local function TickDriveUnits(event)
    if not storage.machine_to_examine then
        --no machines have been registered
        return
    end
    local machine = storage.machine_to_examine.entity
    if machine and machine.valid then
        local consumer = storage.compound_entities[machine.unit_number]
        if not consumer.valid then
            consumer = machine.surface.create_entity { name = "external-drive-unit-lubricant-consumer", position = machine.position, force = machine.force, quality = machine.quality }
            storage.compound_entities[machine.unit_number] = consumer
        end
        if machine.is_connected_to_electric_network() then
            if game.tick - storage.machine_to_examine.last_tick > 60 then
                local consumption_rate = (game.tick - storage.machine_to_examine.last_tick) * 0.01 *
                    machine.quality.beacon_power_usage_multiplier
                if consumer.get_fluid_count("lubricant") >= consumption_rate then
                    if machine.effects.speed and (machine.effects.speed > 0) then
                        consumer.remove_fluid(1, consumption_rate)
                        local stats = machine.force.get_fluid_production_statistics(machine.surface)
                        stats.on_flow("lubricant", consumption_rate * -1)
                    end
                    if storage.machine_to_examine.sprite then
                        storage.machine_to_examine.sprite.destroy()
                        storage.machine_to_examine.sprite = nil
                    end
                    storage.machine_to_examine.entity.disabled_by_script = false
                    storage.machine_to_examine.last_tick = game.tick
                else
                    storage.machine_to_examine.entity.disabled_by_script = true
                    if not storage.machine_to_examine.sprite then
                        storage.machine_to_examine.sprite = rendering.draw_sprite { sprite = "pf-fluid-alert", target = machine, surface = machine.surface, x_scale = 0.5, y_scale = 0.5 }
                    end
                    storage.machine_to_examine.last_tick = game.tick
                end
            end
        else
            storage.machine_to_examine.entity.disabled_by_script = false
            if storage.machine_to_examine.sprite then
                storage.machine_to_examine.sprite.destroy()
                storage.machine_to_examine.sprite = nil
            end
            storage.machine_to_examine.last_tick = game.tick
        end
        storage.machine_to_examine = storage.machine_to_examine.next
    else
        --machine has been removed, unregister it
        --debugprint("unregistering machine")
        storage.drive_unit_lookup[storage.machine_to_examine.id] = nil
        if storage.machine_to_examine.id == storage.machine_to_examine.next.id then
            --this is the last machine. remove its self references because i don't trust lua
            storage.machine_to_examine.next = nil
            storage.machine_to_examine.prev = nil
            storage.machine_to_examine = nil
        else
            storage.machine_to_examine.prev.next = storage.machine_to_examine.next
            storage.machine_to_examine.next.prev = storage.machine_to_examine.prev
            storage.machine_to_examine = storage.machine_to_examine.next
        end
    end
end

local function OnPick(event)
    if event.item.name == "superstation-breaker-box" then
        local p = game.players[event.player_index]
        if p.valid then
            p.pipette(prototypes.entity["superstation"], event.quality, true)
        end
    end
end

script.on_event(
    { defines.events.on_space_platform_built_entity, defines.events.on_built_entity, defines.events
        .on_robot_built_entity, defines.events.script_raised_built, defines.events.script_raised_revive },
    OnBuild
)

script.on_event(
    { defines.events.on_space_platform_mined_entity, defines.events.on_player_mined_entity, defines.events
        .on_robot_mined_entity, defines.events.on_entity_died, defines.events.script_raised_destroy },
    OnRemove
)

script.on_event(
    { defines.events.on_tick },
    TickDriveUnits
)

script.on_event(
    { defines.events.on_player_pipette },
    OnPick
)
