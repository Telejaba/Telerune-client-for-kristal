local character, super = Class(PartyMember, "telejaba")

function character:init()
    super.init(self)

    -- Display name
    self.name = "Telejaba"

    -- Actor (handles overworld/battle sprites)
    self:setActor("telejaba")
    self:setLightActor("telejaba_lw")

    -- Display level (saved to the save file)
    self.level = 2
    -- Default title / class (saved to the save file)
    self.title = "Some unoriginal\nSonic OC"

    -- Determines which character the soul comes from (higher number = higher priority)
    self.soul_priority = 2
    -- The color of this character's soul (optional, defaults to red)
    self.soul_color = {120/255, 29/255, 79/255}

    -- Whether the party member can act / use spells
    self.has_act = true
    self.has_spells = false

    -- Whether the party member can use their X-Action
    self.has_xact = true
    -- X-Action name (displayed in this character's spell menu)
    self.xact_name = "T-Action"

    -- Current health (saved to the save file)
    self.health = 150

    -- Base stats (saved to the save file)
    self.stats = {
        health = 150,
        attack = 15,
        defense = 7,
        magic = 0
    }
    -- Max stats from level-ups
     self.max_stats = {
        health = 300
    }

    -- Weapon icon in equip menu
    self.weapon_icon = "ui/menu/equip/spindash"

    -- Equipment (saved to the save file)
    self:setWeapon(nil)

    self:setArmor(1, nil)
    self:setArmor(2, nil)

    -- Default light world equipment item IDs (saves current equipment)
    self.lw_weapon_default = "light/pencil"
    self.lw_armor_default = "light/bandage"

    -- Character color (for action box outline and hp bar)
    self.color = {255/255, 120/255, 33/255}
    -- Damage color (for the number when attacking enemies) (defaults to the main color)
    self.dmg_color = {255/255, 153/255, 85/255}
    -- Attack bar color (for the target bar used in attack mode) (defaults to the main color)
    self.attack_bar_color = nil
    -- Attack box color (for the attack area in attack mode) (defaults to darkened main color)
    self.attack_box_color = {255/255, 153/255, 85/255}
    -- X-Action color (for the color of X-Action menu items) (defaults to the main color)
    self.xact_color = nil

    -- Head icon in the equip / power menu
    self.menu_icon = "party/telejaba/head"
    -- Path to head icons used in battle
    self.head_icons = "party/telejaba/icon"
    -- Name sprite
    self.name_sprite = "party/telejaba/name"

    -- Effect shown above enemy after attacking it
    self.attack_sprite = "effects/attack/cut"
    -- Sound played when this character attacks
    self.attack_sound = "spindash"
    -- Pitch of the attack sound
    self.attack_pitch = 1

    -- Battle position offset (optional)
    self.battle_offset = {2, 1}
    -- Head icon position offset (optional)
    self.head_icon_offset = nil
    -- Menu icon position offset (optional)
    self.menu_icon_offset = nil

    -- Message shown on gameover (optional)
    self.gameover_message = nil

    -- Character flags (saved to the save file)
    self.flags = {}

    -- Temporary stat buffs in battles
    self.stat_buffs = {}

    -- Light world EXP requirements
    self.lw_exp_needed = {
        [ 1] = 0,
        [ 2] = 10,
        [ 3] = 30,
        [ 4] = 70,
        [ 5] = 120,
        [ 6] = 200,
        [ 7] = 300,
        [ 8] = 500,
        [ 9] = 800,
        [10] = 1200,
        [11] = 1700,
        [12] = 2500,
        [13] = 3500,
        [14] = 5000,
        [15] = 7000,
        [16] = 10000,
        [17] = 15000,
        [18] = 25000,
        [19] = 50000,
        [20] = 99999
    }
end

function character:onLevelUp(level)
    self:increaseStat("health", 2)
    if level % 10 == 0 then
        self:increaseStat("attack", 1)
    end
end

function character:onPowerSelect(menu)
    if Utils.random() < ((Game.chapter == 1) and 0.02 or 0.04) then
        menu.kris_dog = true
    else
        menu.kris_dog = false
    end
end

function character:drawPowerStat(index, x, y, menu)
    if index == 1 then
        local icon = Assets.getTexture("ui/menu/icon/hedgehog")
        Draw.draw(icon, x+125, y+5, 0, 2, 2)
        love.graphics.print("Hedgehog:", x, y)
        return true
    elseif index == 3 then
        local icon = Assets.getTexture("ui/menu/icon/fire")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Cooking:", x, y)
        Draw.draw(icon, x+110, y+6, 0, 2, 2)
        Draw.draw(icon, x+130, y+6, 0, 2, 2)
        return true
    end
end

return character