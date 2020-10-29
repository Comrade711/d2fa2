-- where the misc functios gather
heroList = LoadKeyValues("scripts/npc/herolist.txt")

softdispellable = {
    "modifier_aspd_increase",
    "modifier_derange",
    --"modifier_courage_attack_damage_debuff",
    --"modifier_courage_damage_stack_indicator",
    --"modifier_courage_stackable_buff",
    "modifier_berserk_self_buff",
    "modifier_self_mod",
    "modifier_berserk_scroll",
    "modifier_share_damage",
    "modifier_a_plus_armor",
    "modifier_speed_gem",
    "modifier_share_damage",
    "modifier_rule_breaker",
    "modifier_c_rule_breaker",
    "modifier_heart_of_harmony",
    "modifier_l_rule_breaker",
    "modifier_double_edge",
    "modifier_double_spearsmanship",
    "modifier_gordius_wheel_speed_boost",
    "nero_gladiusanus_blauserum",
    "nero_tres_fontaine_ardent",
    "modifier_invigorating_ray_ally",
    "modifier_invigorating_ray_armor_buff",
    "modifier_blade_of_the_devoted",
    "modifier_lishuwen_cosmic_orbit",
    "modifier_lishuwen_concealment",
    "modifier_jeanne_charisma_str",
    "modifier_jeanne_charisma_agi",
    "modifier_jeanne_charisma_int",
    "modifier_atalanta_last_spurt",
    "modifier_battle_continuation_heal",
    "modifier_argos_armor",
    "modifier_ambush_invis",
    "modifier_true_assassin_selfmod",
    "modifier_selfmod_agility",
    "modifier_replenishment_heal",
    "modifier_master_intervention",
    "modifier_shukuchi_ms",
    "modifier_shukuchi_agi",
    "modifier_tennen_bonus",
    "modifier_mordred_mb",
}

strongdispellable = {
    -- softdispellable
    "modifier_aspd_increase",
    "modifier_derange",
    "modifier_courage_attack_damage_debuff",
    "modifier_courage_damage_stack_indicator",
    "modifier_courage_stackable_buff",
    "modifier_berserk_self_buff",
    "modifier_ta_self_mod",
    "modifier_berserk_scroll",
    "modifier_share_damage",
    "modifier_a_plus_armor",
    "modifier_speed_gem",
    "modifier_share_damage",
    "modifier_rule_breaker",
    "modifier_c_rule_breaker",
    "modifier_heart_of_harmony",
    "modifier_l_rule_breaker",
    "modifier_double_edge",
    "modifier_murderous_instinct",
    "modifier_double_spearsmanship",
    "modifier_gordius_wheel_speed_boost",
    "nero_gladiusanus_blauserum",
    "nero_tres_fontaine_ardent",
    "modifier_invigorating_ray_ally",
    "modifier_invigorating_ray_armor_buff",
    "modifier_blade_of_the_devoted",
    "modifier_lishuwen_cosmic_orbit",
    "modifier_lishuwen_concealment",
    "modifier_jeanne_charisma_str",
    "modifier_jeanne_charisma_agi",
    "modifier_jeanne_charisma_int",
    "modifier_atalanta_last_spurt",
    "modifier_cursed_lance",
    "modifier_battle_continuation_heal",
    "modifier_argos_armor",
    "modifier_ambush_invis",
    "modifier_true_assassin_selfmod",
    "modifier_selfmod_agility",
    "modifier_mordred_mb",

    -- Strong Dispelable
    "modifier_b_scroll",
    "modifier_argos_shield",
    "modifier_rho_aias",
    "modifier_gordius_wheel_mitigation_tier1",
    "modifier_gordius_wheel_mitigation_tier2",
    "modifier_gordius_wheel_mitigation_tier3",
    "tamamo_mantra",
    "modifier_lishuwen_cosmic_orbit_momentary_resistance",
    "modifier_cursed_lance_bp",
    "modifier_replenishment_heal",
    "modifier_heracles_berserk",
    "modifier_master_intervention",
    "modifier_shukuchi_ms",
    "modifier_shukuchi_agi",
    "modifier_tennen_base",
    "modifier_tennen_bonus",
    "modifier_military_tactic_cannon",
    "modifier_boarding_ship",
    "modifier_golden_hind_drive",
    "modifier_golden_hind_bombard",
    "modifier_storm_aura",
    "modifier_voyager_lucky",
    "modifier_crossing_fire_buff",
    "modifier_gate_of_sky_pull_aura",
    "modifier_gate_of_sky_pull_aura",
    "modifier_gate_of_sky_pull_aura",
    "modifier_gate_of_sky_pull_aura",
}

revokes = {
    "modifier_ubw_chronosphere",
    "modifier_ubw_chronosphere_self",
    "modifier_enkidu_hold",
    "jump_pause",
    "pause_sealdisabled",
    "rb_sealdisabled",
    "revoked",
    --"modifier_command_seal_2",
    --"modifier_command_seal_3",
    --"modifier_command_seal_4",
    "round_pause",
    "modifier_nss_shock",
    "modifier_tres_fontaine_nero"
}

locks = {
    --"modifier_purge",
    "modifier_sex_scroll_root",
    "locked",
    "dragged",
    "jump_pause_postlock",
    "modifier_aestus_domus_aurea_enemy",
    "modifier_aestus_domus_aurea_ally",
    "modifier_aestus_domus_aurea_nero",
    "modifier_rho_aias",
    "modifier_binding_chains",
    "modifier_whitechapel_murderer",
    "modifier_whitechapel_murderer_ally",
    "modifier_whitechapel_murderer_enemy",
    "modifier_gate_of_sky_no_blink",
    "modifier_scathach_freeze",
}


goesthruB = {
    "saber_avalon",
    "saber_avalon_upgrade",
    "sasaki_quickdraw",
    "gilgamesh_gate_of_babylon",
    "gilgamesh_gate_of_babylon_upgrade",
    "lancer_gae_bolg",
    "lancer_gae_bolg_upgrade",
    "lancer_wesen_gae_bolg",
    "lancer_wesen_gae_bolg_upgrade",

    "avenger_berg_avesta",
    
    
    "avenger_verg_avesta",
    
    "lancelot_gae_bolg",
    "scathach_gae_bolg"
}

invis = {
    "modifier_ambush",
    "modifier_ta_invis",
    "modifier_shukuchi_ms",
    "modifier_fa_invis",
}

cleansable = {
    -- Slows
    "modifier_slow_tier1",
    "modifier_slow_tier2",
    "modifier_caliburn_slow",
    "modifier_barrage_retreat_shot_slow",
    "modifier_breaker_gorgon",
    "modifier_weakening_venom_debuff",
    "modifier_double_edge_slow",
    "modifier_tawrich_slow",
    "modifier_battle_horn_movespeed_debuff",
    "modifier_aestus_domus_aurea_debuff_slow",
    "modifier_warriors_charge_slow",
    "modifier_fissure_strike_slow",
    "modifier_amaterasu_witchcraft_slow",
    "modifier_gust_heaven_purge_slow_tier1",
    "modifier_gust_heaven_purge_slow_tier2",
    "modifier_raging_dragon_strike_1_slow",
    "modifier_fierce_tiger_strike_1_slow",
    "modifier_fierce_tiger_strike_3_slow",
    "modifier_purge_the_unjust_slow",
    "modifier_gods_resolution_slow",
    "modifier_down_with_a_touch_slow",
    "modifier_down_with_a_touch_slow_2",
    "modifier_down_with_a_touch_slow_3",
    "modifier_la_black_luna_slow",
    "modifier_nursery_rhyme_shapeshift_slow",
    "modifier_doppelganger_lookaway_slow",
    "modifier_cobweb_slow",
    "modifier_tauropolos_slow",
    "modifier_calydonian_hunt_slow",
    "modifier_storm_slow",
    "modifier_golden_wild_hunt_slow",
    "modifier_dance_macabre_knock_back_1",
    "modifier_dance_macabre_knock_back_2",
    "modifier_dance_macabre_knock_back_3",
    "modifier_blizzard_slow",
    "modifier_golden_wild_hunt_burn",
    "modifier_scathach_fire_burn",
    "modifier_scathach_fire_burn_multiply",
    "modifier_mordred_mb_silence",
    -- Other CCs
    "modifier_stunned",
    "modifier_rule_breaker",
    "modifier_c_rule_breaker",
    "modifier_l_rule_breaker",
    "modifier_purge",
    "rb_sealdisabled",
    "modifier_dagger_of_treachery",
    "modifier_silence",
    "modifier_disarmed",
    "modifier_enkidu_hold", -- enkidu
    "modifier_tentacle_wrap",
    "modifier_gust_heaven_purge",
    "modifier_subterranean_grasp",
    "revoked",
    "locked",
    "rooted",
    "stunned",
    "silenced",
    "modifier_sting_shot",
    "modifier_sex_scroll_slow",
    "modifier_sex_scroll_root",
    "modifier_scathach_freeze",
    "modifier_scathach_fire_burn",
    "modifier_scathach_fire_burn_multiply",

    -- Debuffs
    "modifier_gust_heaven_indicator_enemy",
    "modifier_tamamo_wind_debuff",
    "modifier_tamamo_ice_debuff",
    "modifier_sharing_of_pain_enemy_target",
    "modifier_sharing_of_pain_ally_target",
}

slowmodifier = {
    "modifier_slow_tier1",
    "modifier_slow_tier2",
    "modifier_caliburn_slow",
    "modifier_barrage_retreat_shot_slow",
    "modifier_breaker_gorgon",
    "modifier_weakening_venom_debuff",
    "modifier_double_edge_slow",
    "modifier_tawrich_slow",
    "modifier_battle_horn_movespeed_debuff",
    "modifier_aestus_domus_aurea_debuff_slow",
    "modifier_warriors_charge_slow",
    "modifier_fissure_strike_slow",
    "modifier_amaterasu_witchcraft_slow",
    "modifier_gust_heaven_purge_slow_tier1",
    "modifier_gust_heaven_purge_slow_tier2",
    "modifier_raging_dragon_strike_1_slow",
    "modifier_fierce_tiger_strike_1_slow",
    "modifier_fierce_tiger_strike_3_slow",
    "modifier_purge_the_unjust_slow",
    "modifier_gods_resolution_slow",
    "modifier_down_with_a_touch_slow",
    "modifier_down_with_a_touch_slow_2",
    "modifier_down_with_a_touch_slow_3",
    "modifier_la_black_luna_slow",
    "modifier_nursery_rhyme_shapeshift_slow",
    "modifier_doppelganger_lookaway_slow",
    "modifier_ceremonial_purge_slow",
    "modifier_cobweb_slow",
    "modifier_tauropolos_slow",
    "modifier_sex_scroll_slow",
    "modifier_rosa_slow",
    "modifier_dirk_poison_slow",
    "modifier_blizzard_slow",
    "modifier_storm_slow",
    "modifier_golden_wild_hunt_slow",
    "modifier_gate_of_sky_no_blink",
    "modifier_scathach_fire_burn",
    "modifier_scathach_fire_burn_multiply",
}

donotlevel = {
    "attribute_bonus_custom",
    "attribute_bonus_custom_no_int",
    "saber_improved_instinct",
    "saber_alter_darklight_passive",
    "archer_rho_aias",  
    "archer_sword_barrage_retreat_shot", 
    "archer_sword_barrage_confine", 
    "archer_gae_bolg", 
    "archer_sword_barrage", 
    "archer_nine_lives", 
    "archer_shroud_of_martin",
    "lancer_protection_from_arrows",  
    "lancer_rune_of_disengage",  
    "lancer_rune_of_combat",  
    "lancer_rune_of_ferocity",  
    "lancer_rune_of_flame",   
    "lancer_rune_of_protection",   
    "medusa_monstrous_strength_passive",
    "medusa_riding_passive",
    "heracles_reincarnation",
    "heracles_god_hand",
    "sasaki_presence_concealment",
    "hassan_protection_from_wind",
    "hassan_self_modification_str",
    "hassan_self_modification_agi",
    "hassan_self_modification_int",
    
    
    "avenger_overdrive",
 
    
    "gawain_saint",
    "gawain_blessing_of_fairy",
    "diarmuid_minds_eye",
    "tamamo_castration_fist",
    "angra_mainyu_demon_incarnate_passive",
    "arturia_alter_mana_shroud_attribute_passive",
    "astolfo_monstrous_strength_passive",
    "nero_aestus_estus_passive",
    "jtr_information_erase",
    "jtr_holy_mother_passive",
    "jtr_mental_pollution_passive",
    "jtr_surgical_procedure_passive",
    "lancelot_arms_mastership",
    "medusa_riding_passive",
    "gilgamesh_rain_of_swords_passive",
    "heracles_mad_enhancement_passive",
    "gilles_eye_for_art_passive",
    "jtr_efficient_killer_passive",
    "tamamo_witchcraft_passive",
    "lishuwen_berserk",
    "drake_crossing_fire",
    "drake_dance_macabre_2",
    "drake_dance_macabre_3",
    "drake_military_tactic_summon_cannon",
    "drake_military_tactic_summon_boarding_ship",
    "drake_military_tactic_summon_golden_anchor",
    "drake_sword",
    "kuro_crane_wing",
    "kuro_excalibur",
    "kuro_gae_bolg",
    "kuro_fake_nine_live",
    "kuro_rho_aias",
    "kuro_rosa_ichthys",
    "scathach_pinning_god",
    "scathach_rune_fire",
    "scathach_rune_frost",
    "scathach_rune_blast",
    "scathach_rune_teleport",
    "scathach_rune_heal",
    "scathach_wisdom_of_haunt_ground",
    "scathach_immortal",
    "okita_coat_of_oaths",
    "mordred_curse_passive"
}

tModifierCooldown = {
    "modifier_strike_air_cooldown",
    "modifier_instinct_cooldown",
    "modifier_max_excalibur_cooldown",
    "modifier_hrunting_cooldown",
    "modifier_arrow_rain_cooldown",
    "modifier_battle_continuation_cooldown",
    "modifier_wesen_cooldown",
    "modifier_max_mana_burst_cooldown",
    "modifier_hippogriff_ride_cooldown",
    "modifier_mordred_mmb_cooldown",
    "modifier_gate_of_sky_cooldown",
    "modifier_combo_double_gae_bolg_cooldown",
    "modifier_fake_ubw_cooldown",
    "modifier_golden_wild_hunt_cooldown",
    "modifier_zekken_cooldown",
    "modifier_arondite_overload_cooldown",
    "modifier_gilgamesh_final_hour_cooldown",
    "modifier_whitechapel_cooldown",
    "modifier_tamamo_combo_cooldown",
    "modifier_combo_vasavi_cooldown",
    
    "modifier_laus_saint_claudius_cooldown",
    
    "modifier_hecatic_graea_powered_cooldown",
    
    "modifier_bellerophon_2_cooldown",
    "modifier_madmans_roar_cooldown",
    "modifier_tsubame_mai_cooldown",
    "modifier_story_for_someones_sake_cooldown",
    "modifier_la_pucelle_cooldown",
    "modifier_max_enuma_elish_cooldown",
    "modifier_nuke_cooldown",
    "modifier_endless_loop_cooldown",
    "modifier_rampant_warrior_cooldown",
    "modifier_annihilate_cooldown",
    "modifier_larret_de_mort_cooldown",
    "modifier_meltdown_cooldown",
    "modifier_supernova_cooldown",
    "modifier_raging_dragon_strike_cooldown",
    "modifier_phoebus_catastrophe_cooldown",
}

CannotReset = {
    "saber_improved_instinct",
    "saber_strike_air",
    "saber_max_excalibur",
    "saber_max_excalibur_upgrade",
    "saber_alter_unleashed_ferocity",
    "saber_alter_unleashed_ferocity_upgrade",
    "saber_alter_max_mana_burst",
    "saber_alter_max_mana_burst_upgrade",
    "archer_hrunting",
    "archer_hrunting_upgrade",
    "archer_arrow_rain",
    "lancer_battle_continuation",
    "lancer_battle_continuation_upgrade",
    "lancer_protection_from_arrows",
    "lancer_wesen_gae_bolg",
    "lancer_wesen_gae_bolg_upgrade",
    "medusa_bellerophon_2",
    "medusa_bellerophon_2_upgrade",
    "heracles_madmans_roar",
    "heracles_madmans_roar_upgrade_1",
    "heracles_madmans_roar_upgrade_2",
    "heracles_madmans_roar_upgrade_3",
    "sasaki_hiken_enbu",
    "sasaki_hiken_enbu_upgrade",
    "sasaki_quickdraw",
    "hassan_combo",
    "hassan_combo_upgrade",
    "gilgamesh_max_enuma_elish",
    "gilgamesh_max_enuma_elish_upgrade",
    "gilgamesh_combo_final_hour",







    "tamamo_combo",  
    "gawain_blessing_proxy",
    "medea_hecatic_graea_combo",
    "lancelot_blessing_of_fairy",
    "lancelot_arms_mastership_improved",
    "lancelot_nuke",
    "avenger_endless_loop",
    "avenger_dark_passage",
    "diarmuid_love_spot",
    "diarmuid_double_spear_strike",
    "diarmuid_rampant_warrior",
    "diarmuid_minds_eye",
    "iskander_annihilate",
    "gille_spellbook_of_prelati",
    "gille_larret_de_mort",
    "nero_fiery_finale",
    "nero_imperial_privilege",
    "gawain_blessing_of_fairy",
    "gawain_divine_meltdown",
    "gawain_supernova",
    "gawain_excalibur_galatine_combo",
    "tamamo_armed",
    "tamamo_fates_call",
    "lishuwen_martial_arts",
    "lishuwen_raging_dragon_strike",
    "lishuwen_raging_dragon_strike_2",
    "lishuwen_raging_dragon_strike_3",
    "lishuwen_berserk",
    "jeanne_combo_la_pucelle",
    "jeanne_identity_discernment",
    "tamamo_mystic_shackle",
    "astolfo_casa_di_logistilla",
    "astolfo_hippogriff_ride",
    "astolfo_hippogriff_rush",
    "nursery_rhyme_shapeshift",
    "nursery_rhyme_shapeshift_swap",
    "nursery_rhyme_nameless_forest",
    "nursery_rhyme_reminiscence",
    "nursery_rhyme_story_for_somebodys_sake",
    "atalanta_golden_apple",
    "atalanta_last_spurt",
    "atalanta_phoebus_catastrophe_snipe",
    "caster_5th_sacrifice",
    "vlad_transfusion",
    "vlad_impale",
    "vlad_battle_continuation",
    "vlad_combo",
    "vlad_protection_of_faith_cd",
    --"phoebus_catastrophe_barrage",
    "lancer_5th_soaring_spear",
    "nero_laus_saint_claudius",
    "karna_combo_vasavi",
    "karna_discern_poor",
    "jeanne_la_pucelle",
    --"kuro_crane_wings_combo",
    "tamamo_castration_fist",
    "jtr_information_erase",
    "jtr_mental_pollution_passive",
    "jtr_whitechapel_murderer",
    
    "lancelot_combo_arondite_overload",
    "nursery_rhyme_queens_glass_game_activate",
    "okita_focus",
    "okita_mind_eye",
    "okita_zekken",
    "okita_weak_constitution",
    "drake_voyager_of_storm",
    "drake_combo_golden_wild_hunt",
    "drake_military_tactic_summon_golden_hind",
    "drake_military_tactic_summon_cannon",
    "drake_military_tactic_summon_boarding_ship",
    "drake_military_tactic_summon_golden_anchor",
    "drake_golden_hind_voyager_of_storm",
    "jtr_surgery",
    "kuro_sharing_pain",
    "kuro_clairvoyance",
    "kuro_fake_ubw",
    "scathach_pinning_god",
    "scathach_rune_fire",
    "scathach_rune_frost",
    "scathach_rune_blast",
    "scathach_rune_teleport",
    "scathach_rune_heal",
    "scathach_combo_double_gae_bolg",
    "scathach_combo_gate_of_sky",
    "mordred_mmb_lightning",
}

femaleservant = {
    "npc_dota_hero_legion_commander",
    "npc_dota_hero_spectre",
    "npc_dota_hero_templar_assassin",
    "npc_dota_hero_crystal_maiden",
    "npc_dota_hero_lina",
    "npc_dota_hero_enchantress",
    "npc_dota_hero_mirana",
    "npc_dota_hero_windrunner",
    "npc_dota_hero_drow_ranger",
    "npc_dota_hero_phantom_assassin",
    "npc_dota_hero_naga_siren",
    "npc_dota_hero_riki",
    "npc_dota_hero_dark_willow",
    "npc_dota_hero_troll_warlord",
    "npc_dota_hero_monkey_king",
    "npc_dota_hero_tusk",
}

tCannotDetect = {
    "npc_dota_hero_juggernaut",
    "npc_dota_hero_bounty_hunter",
    "npc_dota_hero_bloodseeker",
    "npc_dota_hero_riki"
}

tDangerousBuffs = {
    "modifier_gae_buidhe",
    "modifier_zabaniya_curse",
    "modifier_gae_buidhe"
}

itemComp = {
    {"item_c_scroll","item_c_scroll", "item_b_scroll"},
    {"item_b_scroll", "item_b_scroll", "item_a_scroll"},
    {"item_a_scroll", "item_a_scroll", "item_s_scroll"},
    {"item_s_scroll", "item_s_scroll", "item_ex_scroll"},
    {"item_mana_essence", "item_mana_essence", "item_condensed_mana_essence"},
    {"item_mana_essence", "item_recipe_healing_scroll", "item_healing_scroll"},
    {"item_a_scroll", "item_recipe_a_plus_scroll", "item_a_plus_scroll"}
}

tItemComboTable = {
    item_c_scroll = "item_b_scroll",
    item_b_scroll = "item_a_scroll",
    item_a_scroll = "item_s_scroll",
    item_s_scroll = "item_ex_scroll",
    item_mana_essence = "item_condensed_mana_essence",
    item_a_plus_recipe = "item_a_plus_scroll"
}

tIsekaiAbuser = {
    "npc_dota_hero_lina",
    "npc_dota_hero_juggernaut",
    "npc_dota_hero_windrunner",
    "npc_dota_hero_skywrath_mage",
    "npc_dota_hero_queenofpain",
    "npc_dota_hero_sven",
    "npc_dota_hero_dark_willow",
}

tMount = {
    "modifier_board_drake",
    "modifier_mount_caster",
    "modifier_integrate_gille",
}

tModifierKBImmune = {
    "modifier_avalon",
    "modifier_gate_of_sky_buff",
    "modifier_enkidu_hold",
}

tTrueInvis = {
    "modifier_ambush_invis",
    "modifier_murderer_mist_invis",
    "modifier_whitechapel_murderer",
}

tUnExecute = {
    "modifier_immortal_revive",
    "modifier_voyager_lucky",
    "modifier_avalon",
}

tManalessHero = {
    "npc_dota_hero_juggernaut",
    "npc_dota_hero_shadow_shaman"
}

tRemoveTheseModifiers = {
    "modifier_aestus_domus_aurea_enemy",
    "modifier_aestus_domus_aurea_ally",
    "modifier_aestus_domus_aurea_nero",
    "modifier_unlimited_bladeworks",
    "modifier_army_of_the_king_death_checker",
    "modifier_gae_buidhe",
    "modifier_gae_dearg",
    "modifier_golden_hind_check",
    "modifier_fake_ubw_dummy",
    "modifier_sharing_of_pain_tracker",
    "modifier_sharing_of_pain_enemy_target",
    "modifier_sharing_of_pain_ally_target",
}

tBeamAbilities = {
    "saber_max_excalibur",
    "saber_excalibur",
    "saber_excalibur_upgrade",
    "gilgamesh_max_enuma_elish",
    "gilgamesh_enuma_elish",
    "saber_alter_excalibur",
    "mordred_clarent",
}

tDivineHeroes = {
    "npc_dota_hero_doom_bringer",
    "npc_dota_hero_phantom_lancer",
    "npc_dota_hero_templar_assassin",
    "npc_dota_hero_skywrath_mage",
    "npc_dota_hero_chen",
    "npc_dota_hero_enchantress",
    "npc_dota_hero_phantom_assassin",
    "npc_dota_hero_beastmaster",
}

tArthurHeroes = {
    "npc_dota_hero_legion_commander",
    "npc_dota_hero_spectre",
}

tDragonHeroes = {
    "npc_dota_hero_legion_commander",
    "npc_dota_hero_spectre",
    "npc_dota_hero_tusk",
    "caster_5th_ancient_dragon",
}

tKnightClass = {
    "npc_dota_hero_legion_commander",
    "npc_dota_hero_spectre",
    "npc_dota_hero_phantom_lancer",
    "npc_dota_hero_ember_spirit",
    "npc_dota_hero_skywrath_mage",
    "npc_dota_hero_huskar",
    "npc_dota_hero_lina",
    "npc_dota_hero_omniknight",
    "npc_dota_hero_drow_ranger",
    "npc_dota_hero_tidehunter",
    "npc_dota_hero_beastmaster",
    "npc_dota_hero_dark_willow",
    "npc_dota_hero_naga_siren",
    "npc_dota_hero_monkey_king",
    "npc_dota_hero_tusk",
}

tHorsemanClass = {
    "npc_dota_hero_templar_assassin",
    "npc_dota_hero_crystal_maiden",
    "npc_dota_hero_juggernaut",
    "npc_dota_hero_bounty_hunter",
    "npc_dota_hero_doom_bringer",
    "npc_dota_hero_sven",
    "npc_dota_hero_shadow_shaman",
    "npc_dota_hero_chen",
    "npc_dota_hero_enchantress",
    "npc_dota_hero_bloodseeker",
    "npc_dota_hero_queenofpain",
    "npc_dota_hero_windrunner",
    "npc_dota_hero_phantom_assassin",
    "npc_dota_hero_troll_warlord",
}

tipTable = { "<font color='#58ACFA'>Tip : C Scroll</font> is everyone's bread-and-butter item that you should be carrying at all times. Use it to guarantee your skill combo, or help your teammate by interrupting enemy.",
    "<font color='#58ACFA'>Tip : </font>Work towards gathering 20 all stats in order to acquire <font color='#58ACFA'>Combo</font>, a defining move of hero that can turn the tides of battle. You can level  Stat Bonus of your hero or buy stats with Master's mana  to boost the timing of acquisition.",
    "<font color='#58ACFA'>Tip : </font>To increase your survivability, consider carrying <font color='#58ACFA'>A Scroll and B Scroll</font> that grant you significant damage mitigation for duration.",
    "<font color='#58ACFA'>Tip : </font>Using <font color='#58ACFA'>Scout Familiar and Ward Familiar</font> is an excellent way to develop a vision control, allowing your team to plan ahead for enemy moves.",
    "<font color='#58ACFA'>Tip : </font>You will get a warning ping when enemy Servant's presence is detected within 2500 range around your hero.",
    "<font color='#58ACFA'>Tip : </font>Master can cast only up to 12 Command Seals per 10 minutes due to limited health, which resets every 10 minutes.",
    "<font color='#58ACFA'>Tip : </font>Bind your Master to key unit via [CTRL+Number Key] in order to provide quick support to your hero by transfering items or casting Command Seal.",
    "<font color='#58ACFA'>Tip : </font>Upon dying 7 times, player will be granted a chance to use Shard of Holy Grail that offers diverse array of advantages. Check the details in Master 2.",
    "<font color='#58ACFA'>Tip : </font>You can check the detail and cooldown of your Combo on Master 2.",
    "<font color='#58ACFA'>Tip : </font>When you are desperately short on gold, consider using <font color='#58ACFA'>-goldpls</font> command to ask for a financial assistance from your team.",
    "<font color='#58ACFA'>Tip : </font>A well-timed use of <font color='#58ACFA'>Command Seal</font> can give you decisive advantage over your foes, both defensively and offensively."
}
-- Calculates the angle from caster to target(in radian, multiply it by 180/math.pi for degree)
function CalculateAngle(u, v)
    local angle = 0
    local dotproduct = u.x * v.x + u.y * v.y
    local cosangle = dotproduct/(u:Length2D()*v:Length2D()) 
    return math.acos(cosangle)
end

function SpawnVisionDummy(owner, location, radius, duration, bTrueSight)
    local visiondummy = CreateUnitByName("sight_dummy_unit", location, false, owner, owner, owner:GetTeamNumber())
    visiondummy:SetDayTimeVisionRange(radius)
    visiondummy:SetNightTimeVisionRange(radius)
    local unseen = visiondummy:FindAbilityByName("dummy_unit_passive")
    unseen:SetLevel(1)

    if bTrueSight then
        visiondummy:AddNewModifier(owner, owner, "modifier_item_ward_true_sight", {true_sight_range = radius}) 
    end
    Timers:CreateTimer(duration, function() visiondummy:RemoveSelf() return end)
    return visiondummy
end

function SpawnAttachedVisionDummy(owner, target, radius, duration, bTrueSight)
    local visiondummy = CreateUnitByName("sight_dummy_unit", target:GetAbsOrigin(), false, owner, owner, owner:GetTeamNumber())
    visiondummy:SetDayTimeVisionRange(radius)
    visiondummy:SetNightTimeVisionRange(radius)
    local unseen = visiondummy:FindAbilityByName("dummy_unit_passive")
    unseen:SetLevel(1)

    if bTrueSight then
        visiondummy:AddNewModifier(owner, owner, "modifier_item_ward_true_sight", {true_sight_range = radius}) 
    end

    local counter = 0
    Timers:CreateTimer(function()
        counter = counter + 0.10
        if (counter > duration) then
            visiondummy:RemoveSelf()
            return
        end
        visiondummy:SetAbsOrigin(target:GetAbsOrigin())
        return 0.10
    end)
    return visiondummy
end

-- Apply a modifier from item
function giveUnitDataDrivenModifier(source, target, modifier,dur)
    if not source:IsHero() then 
        source = source:GetPlayerOwner():GetAssignedHero() 
    end
    local dummyAbility = source:FindAbilityByName("presence_detection_passive")
    dummyAbility:ApplyDataDrivenModifier( source, target, modifier, {duration=dur} )
end

function DoCompositeDamage(source, target, dmg, dmg_type, dmg_flag, abil, isLoop)
    DoDamage(source, target , dmg/3, DAMAGE_TYPE_MAGICAL, dmg_flag, abil, isLoop)
    DoDamage(source, target , dmg/3, DAMAGE_TYPE_PHYSICAL, dmg_flag, abil, isLoop)
    DoDamage(source, target , dmg/3, DAMAGE_TYPE_PURE, dmg_flag, abil, isLoop)
end

function ApplyAirborne(source, target, duration)
    if target:HasModifier("modifier_wind_protection_passive") then return end
    target:AddNewModifier(source, source, "modifier_stunned", {Duration = duration})
    --if target:GetName() == "npc_dota_hero_legion_commander" and target:HasModifier("modifier_avalon") then return end
    --[[local ascendCounter = 0
    Timers:CreateTimer(function()
        if ascendCounter > duration/2 then return end
        target:SetAbsOrigin(target:GetAbsOrigin() + Vector(0,0,25))
        ascendCounter = ascendCounter + 0.033
        return 0.033
    end)
    local descendCounter = 0
    Timers:CreateTimer(duration/2, function()
        if descendCounter > duration/2 then return end
        target:SetAbsOrigin(target:GetAbsOrigin() + Vector(0,0,-25))
        descendCounter = descendCounter + 0.033
        return 0.033
    end)]]
    local knockupSpeed = 1500
    ApplyAirborneOnly(target, knockupSpeed, duration)
end

function ApplyAirborneOnly(target, knockupSpeed, duration, Acc)
    --if target:HasModifier("modifier_wind_protection_passive") then return end
    if target:GetName() == "npc_dota_hero_legion_commander" and target:HasModifier("modifier_avalon") then return end

    local knockupAcc = knockupSpeed/duration * 2
    if Acc then
        knockupAcc = Acc
    end

    Physics:Unit(target)
    target:PreventDI()
    target:SetPhysicsVelocity(Vector(0,0,knockupSpeed))
    target:SetPhysicsAcceleration(Vector(0,0,-knockupAcc))
    target:SetNavCollisionType(PHYSICS_NAV_NOTHING)
    target:FollowNavMesh(false)
    target:Hibernate(false)

    Timers:CreateTimer(duration, function()
        target:PreventDI(false)
        target:SetPhysicsVelocity(Vector(0,0,0))
        target:SetPhysicsAcceleration(Vector(0,0,0))
        target:OnPhysicsFrame(nil)
        target:Hibernate(true)
    end)
end

function DummyEnd(dummy)
    dummy:RemoveSelf()
    return nil
end

function GiveGold(senderID, receiverID, amount)
    if PlayerResource:GetReliableGold(senderID) > amount and senderID ~= receiverID then
        local senderHero = PlayerResource:GetSelectedHeroEntity(senderID)
        local receiverHero = PlayerResource:GetSelectedHeroEntity(receiverID)
        --senderHero:SetGold(senderHero:GetGold() - amount, true)
        senderHero:ModifyGold(-amount, true , 0) 
        --receiverHero:SetGold(receiverHero:GetGold() + amount, true)
        receiverHero:ModifyGold(amount, true, 0)

        return true
    else 
        return false
    end
end

function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

function HasLeaversInTeam(hero)
    local leaverCount = 0
    LoopOverPlayers(function(ply, plyID, playerHero)
        if playerHero:GetTeamNumber() == hero:GetTeamNumber() then 
            if playerHero:HasOwnerAbandoned() then
                leaverCount = leaverCount + 1
            end
        end
    end)
    return leaverCount
end

function SumTable(table) --sums a freaking table why do I have to write primitive stuff like these
    local sum = 0
    for k,v in pairs(table) do
        sum = sum + v
    end

    return sum
end

function MaxNumTable(table) --sorts a table and return first value in the table which is the highest and also its table index
    for k,curGold in spairs(table, function(t,a,b) return t[b] < t[a] end) do
        return k, curGold
    end
end

function round(num, numDecimalPlaces)
    if numDecimalPlaces and numDecimalPlaces>0 then
        local mult = 10^numDecimalPlaces
        return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end
 
function StartQuestTimer(questname, questtitle, questendtime)
  local entQuest = SpawnEntityFromTableSynchronous( "quest", { name = questname, title = questtitle } )
  --add   "QuestTimer"  "Survive for %quest_current_value% seconds"   in addon_english
  
  local questTimeEnd = GameRules:GetGameTime() + questendtime --Time to Finish the quest

  --bar system
  local entKillCountSubquest = SpawnEntityFromTableSynchronous( "subquest_base", {
    show_progress_bar = true
  } )
  entQuest:AddSubquest( entKillCountSubquest )
  entQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, questendtime ) --text on the quest timer at start
  entQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, questendtime ) --text on the quest timer
  entKillCountSubquest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, questendtime ) --value on the bar at start
  entKillCountSubquest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, questendtime ) --value on the bar
  
  Timers:CreateTimer(0.9, function()
    if entQuest:IsNull() then return end
    if (questTimeEnd - GameRules:GetGameTime())<=0 then
      UTIL_RemoveImmediate( entQuest )
      entKillCountSubquest = nil
      return
    end
    entQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, questTimeEnd - GameRules:GetGameTime() )
    entKillCountSubquest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, questTimeEnd - GameRules:GetGameTime() ) --update the bar with the time passed        
    return 1      
  end
  )

  return entQuest
end

choice = 0 --
function PlayBGM(player)
    local delayInBetween = 2.0
    
    Timers:CreateTimer("BGMTimer" .. player:GetPlayerID(), {
        endTime = 0,
        callback = function()
            choice = RandomInt(1,8)
            if choice == lastChoice then return 0.1 end
            print("Playing BGM No. " .. choice)
            local songName = "BGM." .. choice
            player.CurrentBGM = songName
            if choice == 1 then EmitSoundOnClient(songName, player) lastChoice = 1 return 186+delayInBetween
            elseif choice == 2 then EmitSoundOnClient(songName, player) lastChoice = 2 return 327+delayInBetween
            elseif choice == 3 then EmitSoundOnClient(songName, player) lastChoice = 3 return 138+delayInBetween
            elseif choice == 4 then EmitSoundOnClient(songName, player) lastChoice = 4 return 149+delayInBetween
            elseif choice == 5 then EmitSoundOnClient(songName, player) lastChoice = 5 return 183+delayInBetween
            elseif choice == 6 then EmitSoundOnClient(songName, player) lastChoice = 6 return 143+delayInBetween
            elseif choice == 7 then EmitSoundOnClient(songName, player) lastChoice = 7 return 184+delayInBetween
        else EmitSoundOnClient(songName, player) lastChoice = 8 return 181+delayInBetween end
    end})
end

function LevelAllAbility(hero)
    for i=0, 23 do
        local ability = hero:GetAbilityByIndex(i)
        if ability == nil then return end
        local level0 = false -- whether ability should be kept level 0 or not
        -- If skill shouldn't be leveled, do not set level to 1
        for i=1, #donotlevel do
            if ability:GetName() == donotlevel[i] then level0 = true end
        end
        -- If skill is actually a talent, do not level it
        if string.match(ability:GetName(),"special_bonus") then level0 = true end
        if not level0 then ability:SetLevel(1) end
        -- if skill should not be reset when using command seal, flag it as unresetable
        for i=1, #CannotReset do
            if ability:GetName() == CannotReset[i] then ability.IsResetable = false break end
        end
        
    end
end

--[[function EmitSoundOnAllClient(songname)
    for i=0, 11 do
        local player = PlayerResource:GetPlayer(i)
        if player ~= nil then
            EmitSoundOnClient(songname, player)
        end
    end
end]]

function EmitSoundOnAllClient(sound)
    --[[for i=0, 11 do
        local player = PlayerResource:GetPlayer(i)
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "emit_client_sound", {sound=sound})
        end
    end]]
    Sounds:EmitSoundOnAllClient(sound)
end

function CheckItemCombination(hero)
    local bIsMatchingFound = false

    --print("Checking item combination")

    -- loop through stash
    for i=0,5 do
        if bIsMatchingFound then break end
        local currentItem = hero:GetItemInSlot(i)
        if currentItem then
            local currentItemName1 = currentItem:GetName()
            local currentItemIndex1 = i
            if GetMatchingItem(currentItemName1) then
                -- first component found, find second component
                for j=0,5 do
                    if bIsMatchingFound then break end

                    if j == currentItemIndex1 then goto continue end -- just continue if we are looking at the same slot as first component
                    local currentItem2 = hero:GetItemInSlot(j)
                    if currentItem2 ~= nil then
                        local currentItemName2 = currentItem2:GetName()
                        -- match found, combine item 1 and item 2
                        if currentItemName1 == currentItemName2 then
                            if currentItemName1 == "item_a_plus_recipe" and currentItemName2 == "item_a_plus_recipe" then return end
                            bIsMatchingFound = true
                            if not currentItem:IsNull() then currentItem:RemoveSelf() end
                            if not currentItem2:IsNull() then currentItem2:RemoveSelf() end
                            CreateItemAtSlot(hero, tItemComboTable[currentItemName1], 0, -1, true, false)
                        elseif (currentItemName1 == "item_a_plus_recipe" and currentItemName2 == "item_a_scroll") 
                            or (currentItemName1 == "item_a_scroll" and currentItemName2 == "item_a_plus_recipe") then
                            bIsMatchingFound = true
                            if not currentItem:IsNull() then currentItem:RemoveSelf() end
                            if not currentItem2:IsNull() then currentItem2:RemoveSelf() end
                            CreateItemAtSlot(hero, tItemComboTable["item_a_plus_recipe"], 0, -1, true, false)
                        end
                    end
                    ::continue::
                end
            end

        end
    end
end

function CheckItemCombinationInStash(hero)
    local bIsMatchingFound = false

    -- loop through stash
    for i=9,14 do
        if bIsMatchingFound then break end

        local currentItem = hero:GetItemInSlot(i)
        if currentItem then
            local currentItemName1 = currentItem:GetName()
            local currentItemIndex1 = i
            --print("Current")
            --print(currentItemIndex1, currentItemName1)
            if GetMatchingItem(currentItemName1) then
                -- first component found, find second component
                for j=10,15 do
                    if bIsMatchingFound then break end

                    if j == currentItemIndex1 then goto continue end -- just continue if we are looking at the same slot as first component
                    local currentItem2 = hero:GetItemInSlot(j)
                    --local currentItemIndex2 = j
                    if currentItem2 then
                        local currentItemName2 = currentItem2:GetName()
                        -- match found, combine item 1 and item 2
                        if currentItemName1 == currentItemName2 then            
							if currentItemName1 == "item_a_plus_recipe" and currentItemName2 == "item_a_plus_recipe" then return end
                            bIsMatchingFound = true
                            --print("Match with")
                            --print(currentItemIndex2 ,currentItemName2)
                            if not currentItem:IsNull() then currentItem:RemoveSelf() end
                            if not currentItem2:IsNull() then currentItem2:RemoveSelf() end
                            CreateItemAtSlot(hero, tItemComboTable[currentItemName1], 9, -1, false, true)
                        elseif (currentItemName1 == "item_a_plus_recipe" and currentItemName2 == "item_a_scroll") 
                            or (currentItemName1 == "item_a_scroll" and currentItemName2 == "item_a_plus_recipe") then
                            bIsMatchingFound = true
                            if not currentItem:IsNull() then currentItem:RemoveSelf() end
                            if not currentItem2:IsNull() then currentItem2:RemoveSelf() end
                            CreateItemAtSlot(hero, tItemComboTable["item_a_plus_recipe"], 10, -1, true, false)
                        end
                    end
                    ::continue::
                end
            end

        end
    end
end

function GetMatchingItem(name)
    for k,v in pairs(tItemComboTable) do
        if k == name then
            return true
        end
    end
    return false
end


function CreateItemAtSlot(hero, itemname, slot, charges, bIsInventoryChecked, bIsStashChecked)
    local dummyitemtable = {}
    for i = 0, slot-1 do
        if hero:GetItemInSlot(i) == nil then
            local dummyitem = CreateItem("item_dummy_item", nil, nil)
            table.insert(dummyitemtable, dummyitem)
            hero:AddItem(dummyitem)
        end
    end
    local newItem = CreateItem(itemname, nil, nil)
    if charges ~= -1 then
        newItem:SetCurrentCharges(charges)
    end
    hero:AddItem(newItem)

    for i = 1, #dummyitemtable do
        hero:RemoveItem(dummyitemtable[i]) 
    end
    if bIsInventoryChecked then CheckItemCombination(hero) end 
    if bIsStashChecked then CheckItemCombinationInStash(hero) end
end

function AddValueToTable(table, value)
    for i=1, 100 do
        if table[i] == nil then 
            table[i] = value
        end
    end
    return table
end

function CreateSlashFx(source, backpoint, frontpoint)
    local slash1ParticleIndex = ParticleManager:CreateParticle( "particles/custom/archer/archer_overedge_slash.vpcf", PATTACH_CUSTOMORIGIN, source )
    ParticleManager:SetParticleControl( slash1ParticleIndex, 2, backpoint )
    ParticleManager:SetParticleControl( slash1ParticleIndex, 3, frontpoint )
end

function IsSpellBlocked(target)
    if target:HasModifier("modifier_instinct_active") then  --This abililty is blocked by the active/targeted Linken's effect.
        EmitSoundWithCooldown("DOTA_Item.LinkensSphere.Activate", target, 1)
        ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_ABSORIGIN, target)
        target:RemoveModifierByName("modifier_instinct_active")
        return true
    --elseif target:HasModifier("modifier_arondite") then
      --  EmitSoundWithCooldown("DOTA_Item.LinkensSphere.Activate", target, 1)
        --ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_ABSORIGIN, target)
        --return true
    elseif target:HasModifier("modifier_diarmuid_minds_eye") then
        EmitSoundWithCooldown("DOTA_Item.LinkensSphere.Activate", target, 1)
        ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_ABSORIGIN, target)
        target:RemoveModifierByName("modifier_diarmuid_minds_eye")
        return true
    elseif target:HasModifier("modifier_rune_of_protection") then
        EmitSoundWithCooldown("DOTA_Item.LinkensSphere.Activate", target, 1)
        ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_ABSORIGIN, target)
        target:RemoveModifierByName("modifier_rune_of_protection")
        return true
    elseif target:HasModifier("modifier_jtr_mental_pollution_shield") then
        EmitSoundWithCooldown("DOTA_Item.LinkensSphere.Activate", target, 1)
        ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_ABSORIGIN, target)
        target:RemoveModifierByName("modifier_jtr_mental_pollution_shield")
        return true
    elseif target:HasModifier("modifier_okita_mind_eye") then
        EmitSoundWithCooldown("DOTA_Item.LinkensSphere.Activate", target, 1)
        ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_ABSORIGIN, target)
        target:RemoveModifierByName("modifier_okita_mind_eye")
        return true
    elseif target:HasModifier("modifier_wisdom_spell_block") then
        EmitSoundWithCooldown("DOTA_Item.LinkensSphere.Activate", target, 1)
        ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_ABSORIGIN, target)
        target:RemoveModifierByName("modifier_wisdom_spell_block")
        return true
    else
        return false
    end
end

function EmitSoundWithCooldown(soundname, target, cooldown)
    if not target.bIsSoundOnCooldown then
        target:EmitSound(soundname)
        target.bIsSoundOnCooldown = true
        Timers:CreateTimer(cooldown, function()
            target.bIsSoundOnCooldown = false
        end)
    end
end

function IsRevoked(target)
    for i=1, #revokes do
        if target:HasModifier(revokes[i]) then return true end
    end
    return false
end

function IsLocked(target)
    for i=1, #locks do
        if target:HasModifier(locks[i]) then return true end
    end
    return false
end

function IsRevivePossible(target)
    if target:HasModifier("can_be_executed") then
        --print("cannot revive")
        return false
    end
    return true
end

function IsFemaleServant(target)
    for i=1, #femaleservant do
        if target:GetName() == femaleservant[i] then
            return true
        end
    end
    
    return false
end

function IsIsekaiAbuser(target)
    for i=1, #tIsekaiAbuser do
        if target:GetName() == tIsekaiAbuser[i] then
            return true
        end
    end
    
    return false
end

function IsImmuneToCC(target)
    if target:HasModifier("modifier_heracles_berserk") and target:HasModifier("modifier_mad_enhancement_attribute") then
        return true 
    elseif target:HasModifier("modifier_forward") then
        return true
    else
        return false
    end
end

function IsImmuneToSlow(target)
    if target:HasModifier("modifier_heracles_berserk") and target:HasModifier("modifier_mad_enhancement_attribute") then
        return true 
    elseif target:HasModifier("modifier_forward") then
        return true
    else
        return false
    end
end

function IsFacingUnit(source, target, angle)
    local sourceangle = math.abs(RotationDelta(VectorToAngles((target:GetAbsOrigin() - source:GetAbsOrigin()):Normalized()), VectorToAngles(source:GetForwardVector())).y)
    if sourceangle < angle/2 then
        return true
    else
        return false
    end
end

-- 
function OnExperienceZoneThink(keys)
    local hero = keys.target
    if hero:IsRealHero() and not hero:IsIllusion() then
        hero:AddExperience(hero:GetLevel()*2+15, false, false)
        hero:ModifyGold(20, true, 0)
    end
end

function HardCleanse(target)
    for i=1, #cleansable do
        if target:HasModifier(cleansable[i]) then
            target:RemoveModifierByName(cleansable[i])
        end
    end

    for i=1, #slowmodifier do
        if target:HasModifier(slowmodifier[i]) then
            target:RemoveModifierByName(slowmodifier[i])
        end
    end
end

function RemoveSlowEffect(target)
    for i=1, #slowmodifier do
        if target:HasModifier(slowmodifier[i]) then
            target:RemoveModifierByName(slowmodifier[i])
        end
    end
end

function GetPhysicalDamageReduction(armor)
    local reduction = 0.06*armor / (1+0.06*armor)
    return reduction
    --[[if armor >= 0 then 
        return reduction
    else
        return -reduction
    end]]
end

-- Does what it says. damage post reduction -> pre reduction
function CalculateDamagePreReduction(eDamageType, fDamage, hUnit)
	if eDamageType == DAMAGE_TYPE_PHYSICAL then
		local fArmor = hUnit:GetPhysicalArmorValue(false)
		local multiplier = 1 + 0.06 * fArmor / (1 + 0.06 * math.abs(fArmor))
		return fDamage * multiplier
	end
	
	if eDamageType == DAMAGE_TYPE_MAGICAL then
		local fMagicRes = hUnit:GetMagicalArmorValue()
		return fDamage * (1 + fMagicRes)
	end
	
	return fDamage
end

function CalculateDamagePostReduction(eDamageType, fDamage, hUnit)
	if eDamageType == DAMAGE_TYPE_PHYSICAL then
		local fArmor = hUnit:GetPhysicalArmorValue(false)
		local multiplier = 1 - 0.06 * fArmor / (1 + 0.06 * math.abs(fArmor))
		return fDamage * multiplier
	end
	
	if eDamageType == DAMAGE_TYPE_MAGICAL then
		local fMagicRes = hUnit:GetMagicalArmorValue()
		return fDamage * (1 - fMagicRes)
	end
	
	return fDamage
end


function ReduceCooldown(ability, reduction)
    local remainingCD = ability:GetCooldownTimeRemaining() 
    ability:EndCooldown()
    ability:StartCooldown(remainingCD - reduction)
end

lastTipChoice = 0
function DisplayTip()
    print("Displaying tip!")
    local tipchoice = 0
    local tipRef = ""
    while tipchoice == lastTipChoice do
        --print("Rerolling tip choice")
        tipchoice = RandomInt(1, 10) 
        tipRef = ("#Fate_Tip" .. tipchoice)
    end

    GameRules:SendCustomMessage(tipRef, 0, 0) 
    lastTipChoice = tipchoice
end

-- ten_min_timer
-- round_timer
-- pregame_timer
-- ubw_timer
-- aotk_timer
function CreateUITimer(message, duration, description)
    local timerData = {
        timerMsg = message,
        timerDuration = duration,
        timerDescription = description
    }
    CustomGameEventManager:Send_ServerToAllClients( "display_timer", timerData ) 
end

-- Create a particle that is visible by anyone in both teams
-- example: CreateGlobalParticle("particles/custom/iskandar/iskandar_aotk.vpcf", {[0] = caster:GetAbsOrigin()}, 2)
function CreateGlobalParticle(particle_name, controlpoints, duration)
    for i=2,13 do
        local particle = ParticleManager:CreateParticleForTeam(particle_name, PATTACH_CUSTOMORIGIN, nil, i)
        for k,v in pairs(controlpoints) do
            ParticleManager:SetParticleControl(particle, k, v)
        end
        Timers:CreateTimer(duration, function()
            ParticleManager:DestroyParticle( particle, false )
            ParticleManager:ReleaseParticleIndex( particle )
        end)
    end
end
-- check whether two locations belong in same realm
-- loc 1 = vector
-- loc 2 = vector
function IsInSameRealm(loc1, loc2)
    -- above -2000 normal map
    if loc1.y > -2000 and loc2.y > -2000 then
      -- both are in normal map
      return true
    elseif not (loc1.y <= -2000 and loc2.y <= -2000) then
      return false
    end
    -- 3300 split between AotK and UBW
    if loc1.x < 3300 and loc2.x < 3300 then
      -- both are in AotK
      return true
    elseif not (loc1.x >= 3300 and loc2.x >= 3300) then
      return false
    end
    -- below -6300 master location
    if loc1.y > -6300 and loc2.y > -6300 then
      -- both are in UBW
      return true
    elseif not (loc1.y <= -6300 and loc2.y <= -6300) then
      return false
    end
    -- both are in master area
    return true
end

function SendErrorMessage(playerID, string)
   CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "error_message_fired", {message=string}) 
end

function SendMountStatus(hero)
    local bMounted = false
    if hero:GetName() == "npc_dota_hero_shadow_shaman" then 
        bMounted = hero.IsIntegrated
    elseif hero:GetName() == "npc_dota_hero_crystal_maiden" then 
        bMounted = hero.IsMounted
    elseif hero:GetName() == "npc_dota_hero_troll_warlord" then 
        bMounted = hero.IsBoarded
    end

    local playerData = {
        bIsMounted = bMounted
    }
    CustomGameEventManager:Send_ServerToPlayer( hero:GetPlayerOwner(), "player_mount_status_changed", playerData )
end

function DoDamage(source, target , dmg, dmg_type, dmg_flag, abil, isLoop)
   -- if target == nil then return end 
    local IsAbsorbed = false
    local IsBScrollIgnored = false
    local MR = target:GetMagicalArmorValue() 
    dmg_flag = bit.bor(dmg_flag, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION)

    if target:GetName() == "npc_dota_ward_base" then return end
    if target:GetUnitName() == "okita_flag" then return end

    -- Records skill damage PRE-REDUCTION. For the rest, refer to OnHeroTakeDamage() below.
    if isLoop == false then
        if GetMapName() == "fate_tutorial" then 
        else
            if not source:IsHero() then --Account for neutral attacker
                if IsValidEntity(source:GetPlayerOwner()) then
                    sourceHero = source:GetPlayerOwner():GetAssignedHero()
                end
            else
                sourceHero = source
            end

            if not target:IsHero() and not target.IsNurseryClone then --Account for neutral target
                if IsValidEntity(target:GetPlayerOwner()) then
                    targetHero = target:GetPlayerOwner():GetAssignedHero()
                end
            else
                targetHero = target
            end        
            
            if not target.IsNurseryClone then

                sourceHero.ServStat:doDamageBeforeReduction(dmg)
                if not targetHero:IsIllusion() then -- band aid for NR's shapeshift.
        	        targetHero.ServStat:takeDamageBeforeReduction(dmg)
        	    end
            end  
        end  
    end
    -- END
    if abil:GetAbilityName() == "karna_vasavi_shakti" or abil:GetAbilityName() == "karna_combo_vasavi" then
    else
        if IsDivineServant(target) then
            --print('Divine Servant')
            if CheckDivinity(target) == 1 then 
                --print('Divine Servant Rank A')
                dmg = dmg * 0.95
            elseif CheckDivinity(target) == 2 then 
                --print('Divine Servant Rank B')
                dmg = dmg
            end
        end
    end

    -- on mount
    if IsMountedHero(target) then 
        dmg = 0
    end

    -- Bonus damage to Squid
    if IsBeam(abil) then 
        if target:GetUnitName() == "gille_gigantic_horror" then 
            dmg = dmg * 1.3 
        end
    end

    if dmg_type == DAMAGE_TYPE_MAGICAL then
        -- Process B scroll
        for k,v in pairs(goesthruB) do
            if abil:GetAbilityName() == v then IsBScrollIgnored = true break end
        end

        --[[if (abil:GetAbilityName() == "karna_combo_vasavi" 
            or abil:GetAbilityName() == "karna_vasavi_shakti")
            and source.IndraAttribute then
            IsBScrollIgnored = true
        else]]
        if (abil:GetAbilityName() == "karna_brahmastra" 
            or abil:GetAbilityName() == "karna_brahmastra_kundala")
            and source.ManaBurstAttribute then
            IsBScrollIgnored = true
        end

        if IsBScrollIgnored == false and target:HasModifier("modifier_b_scroll") then 
            local originalDamage = dmg - target.BShieldAmount --* 1/(1-MR)
            target.BShieldAmount = target.BShieldAmount - dmg --* (1-MR)
            if target.BShieldAmount <= 0 then
                dmg = originalDamage
                target:RemoveModifierByName("modifier_b_scroll")
            else 
                dmg = 0
                IsAbsorbed = true
            end
        end
    end

    -- check if target has Rho Aias shield 
    if not IsAbsorbed and target:HasModifier("modifier_rho_aias") then
        local reduction = 0
        if target:HasModifier("modifier_l_rule_breaker") or target:HasModifier ("modifier_c_rule_breaker") and (dmg_type == DAMAGE_TYPE_PURE or dmg_type == DAMAGE_TYPE_PHYSICAL) then
            reduction = 1
        elseif dmg_type == DAMAGE_TYPE_PHYSICAL then
            reduction = GetPhysicalDamageReduction(target:GetPhysicalArmorValue(false))
        elseif dmg_type == DAMAGE_TYPE_MAGICAL then
            reduction = target:GetMagicalArmorValue() 
        end 
        local originalDamage = dmg - target.rhoShieldAmount * 1/(1-reduction)
        target.rhoShieldAmount = target.rhoShieldAmount - dmg * (1-reduction)

        -- if damage is beyond the shield's block amount, update remaining damage
        if target.rhoShieldAmount <= 0 then
            --print("Rho Aias has been broken through by " .. -target.rhoShieldAmount)
            dmg = originalDamage
            target:RemoveModifierByName("modifier_rho_aias")
            target.argosShieldAmount = 0
        -- if shield has enough durability, set a flag that the damage is fully absorbed
        else 
            --print("Rho Aias absorbed full damage")
            dmg = 0
            IsAbsorbed = true
        end
    end
  
    -- check if target has Cursed Lance
    if not IsAbsorbed and (target:HasModifier("modifier_cursed_lance") or target:HasModifier("modifier_cursed_lance_bp")) then
  	    local modifier = target:FindModifierByName("modifier_cursed_lance") or target:FindModifierByName("modifier_cursed_lance_bp")
        local reduction = 0
        if dmg_type == DAMAGE_TYPE_PHYSICAL then
            reduction = GetPhysicalDamageReduction(target:GetPhysicalArmorValue(false))
        elseif dmg_type == DAMAGE_TYPE_MAGICAL then
            reduction = target:GetMagicalArmorValue()
        end
        local originalDamage = dmg - modifier.CL_SHIELDLEFT * 1/(1-reduction)
        modifier.CL_SHIELDLEFT = modifier.CL_SHIELDLEFT - dmg * (1-reduction)
        if modifier.CL_SHIELDLEFT <= 0 then
            dmg = originalDamage
            if not target.InstantCurseAcquired then
                target:RemoveModifierByName("modifier_cursed_lance")
            end
            modifier.CL_SHIELDLEFT = 0
        else
            dmg = 0
            IsAbsorbed = true
        end
    end

    -- check if target has Mordred Shield
    if not IsAbsorbed and target:HasModifier("modifier_mordred_shield") then
        local reduction = 0
        if dmg_type == DAMAGE_TYPE_PHYSICAL then
            reduction = GetPhysicalDamageReduction(target:GetPhysicalArmorValue(false))
        elseif dmg_type == DAMAGE_TYPE_MAGICAL then
            reduction = target:GetMagicalArmorValue() 
        end 
        local originalDamage = dmg - target.argosShieldAmount * 1/(1-reduction)
        target.argosShieldAmount = target.argosShieldAmount - dmg * (1-reduction)
        if target.argosShieldAmount <= 0 then
            dmg = originalDamage
            target:RemoveModifierByName("modifier_mordred_shield") 
            target.argosShieldAmount = 0
        else
            dmg = 0
            IsAbsorbed = true
        end
    end

    -- Check if target has Avalon up
    if target:GetName() == "npc_dota_hero_legion_commander" and target:HasModifier("modifier_avalon") then
        local incomingDmg = dmg
        local reduction = 0

        if target:HasModifier("modifier_l_rule_breaker") or target:HasModifier ("modifier_c_rule_breaker") and (dmg_type == DAMAGE_TYPE_PURE or dmg_type == DAMAGE_TYPE_PHYSICAL) then
            incomingDmg = incomingDmg * 0
        elseif dmg_type == DAMAGE_TYPE_MAGICAL then
            incomingDmg = incomingDmg * (1-MR)
        elseif dmg_type == DAMAGE_TYPE_PHYSICAL then
            reduction = GetPhysicalDamageReduction(target:GetPhysicalArmorValue(false))
            incomingDmg = incomingDmg * (1-reduction) 
        end
        if dmg_flag == (DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION) then
            if abil:GetAbilityName() == "sasaki_tsubame_gaeshi" or abil:GetAbilityName() == "okita_mumyo" or abil:GetAbilityName() == "okita_zekken" then
                target.IsAvalonPenetrated = true
                target.IsAvalonProc = false
            end
        else
            if incomingDmg > 300 then 
                target.IsAvalonProc = true
            else 
                target.IsAvalonProc = false
            end
            dmg = 0
            target.IsAvalonPenetrated = false
        end
    end 
    -- check if target has Argos
    if not IsAbsorbed and target:HasModifier("modifier_argos_shield") then
        local reduction = 0
        if dmg_type == DAMAGE_TYPE_PHYSICAL then
            reduction = GetPhysicalDamageReduction(target:GetPhysicalArmorValue(false))
        elseif dmg_type == DAMAGE_TYPE_MAGICAL then
            reduction = target:GetMagicalArmorValue() 
        end 
        local originalDamage = dmg - target.argosShieldAmount * 1/(1-reduction)
        target.argosShieldAmount = target.argosShieldAmount - dmg * (1-reduction)
        if target.argosShieldAmount <= 0 then
            dmg = originalDamage
            target:RemoveModifierByName("modifier_argos_shield") 
            target.argosShieldAmount = 0
        else
            dmg = 0
            IsAbsorbed = true
        end
    end

    --[[if IsFemaleServant(source) and target:HasModifier("modifier_love_spot") and source:HasModifier("modifier_love_spot_charmed") then
        dmg = dmg * 0.5
    end]]

    -- if damage was not fully absorbed by shield, deal residue damage 
    if IsAbsorbed == true then
        local dmgtable = {
            attacker = source,
            victim = target,
            damage = 0,
            damage_type = dmg_type,
            damage_flags = dmg_flag,
            ability = abil
        }
        ApplyDamage(dmgtable)
        return 
    else
        local dmgtable = {
            attacker = source,
            victim = target,
            damage = dmg,
            damage_type = dmg_type,
            damage_flags = dmg_flag,
            ability = abil
        }
        
        -- if target is linked, distribute damages 
        if target:HasModifier("modifier_share_damage")
          and not isLoop
          and not (abil:GetName() == "avenger_verg_avesta" and source:GetTeam() == target:GetTeam())
         --Queens glass game attribute fix
          and not (target:HasModifier("modifier_queens_glass_game_check_link") and not target:HasModifier("modifier_qgg_oracle"))
          and target.linkTable ~= nil
        then
            -- Calculate the damage to secondary targets separately, in order to prevent MR from being twice as effective on primary target.
            local damageToAllies =  dmgtable.damage
            damageToAllies = damageToAllies/#target.linkTable -- * (1 + 0.1 * #target.linkTable - (#target.linkTable == 1 and 1 or 0) * 0.1) --damage/person is now 100/60/43.3/35/30 after instead of 100/50/33.3/25/20
            dmgtable.damage = dmgtable.damage/#target.linkTable -- * (1 + 0.1 * #target.linkTable - (#target.linkTable == 1 and 1 or 0) * 0.1)
            -- Loop through linked heroes
            for i=#target.linkTable,1,-1 do
                local hLinkTarget = target.linkTable[i]
                -- do ApplyDamage if it's primary target since the shield processing is already done
                if target.linkTable[i] == target then
                    ApplyDamage(dmgtable)
                -- for other linked targets, we need DoDamage
                else
                    if target.linkTable[i] ~= nil then
                        if hLinkTarget:GetHealth() == 1 then
                            hLinkTarget:SetHealth(1)
                            hLinkTarget:RemoveModifierByName("modifier_share_damage")
                            RemoveHeroFromLinkTables(hLinkTarget)
                        elseif hLinkTarget:GetHealth() >= CalculateDamagePostReduction(DAMAGE_TYPE_MAGICAL, damageToAllies, hLinkTarget) then
                            --DoDamage(source, hLinkTarget, damageToAllies,  DAMAGE_TYPE_MAGICAL, 0, abil, true)
                            DoDamage(target, hLinkTarget, damageToAllies,  DAMAGE_TYPE_MAGICAL, 0, abil, true)
                        elseif hLinkTarget:GetHealth() < CalculateDamagePostReduction(DAMAGE_TYPE_MAGICAL, damageToAllies, hLinkTarget) then
                            hLinkTarget:SetHealth(1)
                            hLinkTarget:RemoveModifierByName("modifier_share_damage")
                            RemoveHeroFromLinkTables(hLinkTarget)
                        end
                    end 
                end
            end
        -- if target is not linked, apply damage normally
        else 
            dmgtable.victim = target
            ApplyDamage(dmgtable)
        end        
    end
end

function RandomPositionAtRadius(center, radius)
    local point = center
    local random = RandomInt(0, 360)
    point.x = center.x + (radius * math.cos(random))
    point.y = center.y + (radius * math.sin(random))
    return Vector(point.x, point.y, 0)
end

-- Check if anyone on this hero's team is still alive. 
function IsTeamWiped(hero)
    if _G.GameMap == "fate_ffa" or _G.GameMap == "fate_trio_rumble_3v3v3v3" then return false end

    for i=0, 13 do
        local player = PlayerResource:GetPlayer(i)
        local playerHero = PlayerResource:GetSelectedHeroEntity(i)
        if playerHero ~= nil then 
            servant = playerHero
            if servant:GetTeam() == hero:GetTeam() and servant:IsAlive() then 
                return false
            end
        end
    end
    return true
end

function ApplyPurge(target)
    for k,v in pairs(softdispellable) do
        if v == "modifier_courage_stackable_buff" then
            local currentStack = target:GetModifierStackCount("modifier_courage_stackable_buff", target:FindAbilityByName("berserker_5th_courage"))
            if currentStack <= 2 then
                target:RemoveModifierByName("modifier_courage_stackable_buff")
            else
                target:SetModifierStackCount("modifier_courage_stackable_buff", target:FindAbilityByName("berserker_5th_courage"), currentStack-2)
            end
        elseif v == "modifier_tennen_bonus" then
            target:SetModifierStackCount("modifier_tennen_bonus", target:FindAbilityByName("okita_tennen"), 0)
        else
            if v == "modifier_share_damage" then
                RemoveHeroFromLinkTables(target)
            end
            target:RemoveModifierByName(v)
        end
    end
end

function ApplyStrongDispel(target)
    for k,v in pairs(strongdispellable) do
        if v == "modifier_share_damage" then
            RemoveHeroFromLinkTables(target)
        end
        target:RemoveModifierByName(v)
    end
end

-- Fills inventory with unusable placeholders
function FillInventory(entity)
    for i=0, 5 do
        local hero_item = entity:GetItemInSlot(i)
        if hero_item == nil then
            entity:AddItem(CreateItem("item_dummy_item_unusable" , nil, nil))
        end
    end
end


function ProcessShield()
    for k,v in pairs(goesthruB) do
        if ability == v then return else 
            -- process shield here
        end
    end
end


function PrintTable(t, indent, done)
	--print ( string.format ('PrintTable type %s', type(keys)) )
    if type(t) ~= "table" then return end

    done = done or {}
    done[t] = true
    indent = indent or 0

    local l = {}
    for k, v in pairs(t) do
        table.insert(l, k)
    end

    table.sort(l)
    for k, v in ipairs(l) do
        -- Ignore FDesc
        if v ~= 'FDesc' then
            local value = t[v]

            if type(value) == "table" and not done[value] then
                done [value] = true
                print(string.rep ("\t", indent)..tostring(v)..":")
                PrintTable (value, indent + 2, done)
            elseif type(value) == "userdata" and not done[value] then
                done [value] = true
                print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
                PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
            else
                if t.FDesc and t.FDesc[v] then
                    print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
                else
                    print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
                end
            end
        end
    end
end

function SendKVToFatepedia(player)
    local abilKV = LoadKeyValues('scripts/npc/npc_abilities_custom.txt')
    local heroKV = LoadKeyValues('scripts/npc/npc_heroes_custom.txt')
    local KVData = {abilKV, heroKV}
    CustomGameEventManager:Send_ServerToPlayer( player, "fatepedia_kv_sent", KVData )
    print("KV sent")
end

function CreateClientsideSpellbook(hero)
    --[[local pID = hero:GetPlayerID()
    local ply = PlayerResource:GetPlayer(pID)
    local heroName = hero:GetName()
    local spellbookData = {
        heroEnt = hero:entindex()
    }
    CustomGameEventManager:Send_ServerToPlayer( ply, "spellbook_created", playerData )]]

end

function CreateTemporaryStatTable(hero)
    local statTable = {
        STR = 0,
        AGI = 0,
        INT = 0,
        DMG = 0,
        ARMOR = 0,
        HPREG = 0,
        MPREG = 0,
        MS = 0,
        ShardAmount = 0
    }
    statTable.STR = hero.STRgained 
    statTable.AGI = hero.AGIgained
    statTable.INT = hero.INTgained
    statTable.DMG = hero.DMGgained
    statTable.ARMOR = hero.ARMORgained
    statTable.HPREG = hero.HPREGgained
    statTable.MPREG = hero.MPREGgained
    statTable.MS = hero.MSgained
    statTable.ShardAmount = hero.ShardAmount
    return statTable
end
-- hi i'm here to implement math i don't really understand and hope it works
function RandomPointInCircle(origin, radius)
    t = 2*math.pi*RandomFloat(0,radius)
    u = RandomFloat(0, radius)+RandomFloat(0, radius)
    if u > radius then u = radius * 2 - u end
    return Vector(u*math.cos(t), u*math.sin(t),0) + origin
end

-- Colors
COLOR_NONE = '\x06'
COLOR_GRAY = '\x06'
COLOR_GREY = '\x06'
COLOR_GREEN = '\x0C'
COLOR_DPURPLE = '\x0D'
COLOR_SPINK = '\x0E'
COLOR_DYELLOW = '\x10'
COLOR_PINK = '\x11'
COLOR_RED = '\x12'
COLOR_LGREEN = '\x15'
COLOR_BLUE = '\x16'
COLOR_DGREEN = '\x18'
COLOR_SBLUE = '\x19'
COLOR_PURPLE = '\x1A'
COLOR_ORANGE = '\x1B'
COLOR_LRED = '\x1C'
COLOR_GOLD = '\x1D'


--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
--
--=============================================================================

--/////////////////////////////////////////////////////////////////////////////
-- Debug helpers
--
--  Things that are really for during development - you really should never call any of this
--  in final/real/workshop submitted code
--/////////////////////////////////////////////////////////////////////////////

-- if you want a table printed to console formatted like a table (dont we already have this somewhere?)
scripthelp_LogDeepPrintTable = "Print out a table (and subtables) to the console"
logFile = "log/log.txt"

function LogDeepSetLogFile( file )
	logFile = file
end

function LogEndLine ( line )
	AppendToLogFile(logFile, line .. "\n")
end

function _LogDeepPrintMetaTable( debugMetaTable, prefix )
	_LogDeepPrintTable( debugMetaTable, prefix, false, false )
	if getmetatable( debugMetaTable ) ~= nil and getmetatable( debugMetaTable ).__index ~= nil then
		_LogDeepPrintMetaTable( getmetatable( debugMetaTable ).__index, prefix )
	end
end

function _LogDeepPrintTable(debugInstance, prefix, isOuterScope, chaseMetaTables ) 
    prefix = prefix or ""
    local string_accum = ""
    if debugInstance == nil then 
		LogEndLine( prefix .. "<nil>" )
		return
    end
	local terminatescope = false
	local oldPrefix = ""
    if isOuterScope then  -- special case for outer call - so we dont end up iterating strings, basically
        if type(debugInstance) == "table" then 
            LogEndLine( prefix .. "{" )
			oldPrefix = prefix
            prefix = prefix .. "   "
			terminatescope = true
        else 
            LogEndLine( prefix .. " = " .. (type(debugInstance) == "string" and ("\"" .. debugInstance .. "\"") or debugInstance))
        end
    end
    local debugOver = debugInstance

	-- First deal with metatables
	if chaseMetaTables == true then
		if getmetatable( debugOver ) ~= nil and getmetatable( debugOver ).__index ~= nil then
			local thisMetaTable = getmetatable( debugOver ).__index 
			if vlua.find(_LogDeepprint_alreadyseen, thisMetaTable ) ~= nil then 
				LogEndLine( string.format( "%s%-32s\t= %s (table, already seen)", prefix, "metatable", tostring( thisMetaTable ) ) )
			else
				LogEndLine(prefix .. "metatable = " .. tostring( thisMetaTable ) )
				LogEndLine(prefix .. "{")
				table.insert( _LogDeepprint_alreadyseen, thisMetaTable )
				_LogDeepPrintMetaTable( thisMetaTable, prefix .. "   ", false )
				LogEndLine(prefix .. "}")
			end
		end
	end

	-- Now deal with the elements themselves
	-- debugOver sometimes a string??
    for idx, data_value in pairs(debugOver) do
        if type(data_value) == "table" then 
            if vlua.find(_LogDeepprint_alreadyseen, data_value) ~= nil then 
                LogEndLine( string.format( "%s%-32s\t= %s (table, already seen)", prefix, idx, tostring( data_value ) ) )
            else
                local is_array = #data_value > 0
				local test = 1
				for idx2, val2 in pairs(data_value) do
					if type( idx2 ) ~= "number" or idx2 ~= test then
						is_array = false
						break
					end
					test = test + 1
				end
				local valtype = type(data_value)
				if is_array == true then
					valtype = "array table"
				end
                LogEndLine( string.format( "%s%-32s\t= %s (%s)", prefix, idx, tostring(data_value), valtype ) )
                LogEndLine(prefix .. (is_array and "[" or "{"))
                table.insert(_LogDeepprint_alreadyseen, data_value)
                _LogDeepPrintTable(data_value, prefix .. "   ", false, true)
                LogEndLine(prefix .. (is_array and "]" or "}"))
            end
		elseif type(data_value) == "string" then 
            LogEndLine( string.format( "%s%-32s\t= \"%s\" (%s)", prefix, idx, data_value, type(data_value) ) )
		else 
            LogEndLine( string.format( "%s%-32s\t= %s (%s)", prefix, idx, tostring(data_value), type(data_value) ) )
        end
    end
	if terminatescope == true then
		LogEndLine( oldPrefix .. "}" )
	end
end


function LogDeepPrintTable( debugInstance, prefix, isPublicScriptScope ) 
    prefix = prefix or ""
    _LogDeepprint_alreadyseen = {}
    table.insert(_LogDeepprint_alreadyseen, debugInstance)
    _LogDeepPrintTable(debugInstance, prefix, true, isPublicScriptScope )
end


--/////////////////////////////////////////////////////////////////////////////
-- Fancy new LogDeepPrint - handles instances, and avoids cycles
--
--/////////////////////////////////////////////////////////////////////////////

-- @todo: this is hideous, there must be a "right way" to do this, im dumb!
-- outside the recursion table of seen recurses so we dont cycle into our components that refer back to ourselves
_LogDeepprint_alreadyseen = {}


-- the inner recursion for the LogDeep print
function _LogDeepToString(debugInstance, prefix) 
    local string_accum = ""
    if debugInstance == nil then 
        return "LogDeep Print of NULL" .. "\n"
    end
    if prefix == "" then  -- special case for outer call - so we dont end up iterating strings, basically
        if type(debugInstance) == "table" or type(debugInstance) == "table" or type(debugInstance) == "UNKNOWN" or type(debugInstance) == "table" then 
            string_accum = string_accum .. (type(debugInstance) == "table" and "[" or "{") .. "\n"
            prefix = "   "
        else 
            return " = " .. (type(debugInstance) == "string" and ("\"" .. debugInstance .. "\"") or debugInstance) .. "\n"
        end
    end
    local debugOver = type(debugInstance) == "UNKNOWN" and getclass(debugInstance) or debugInstance
    for idx, val in pairs(debugOver) do
        local data_value = debugInstance[idx]
        if type(data_value) == "table" or type(data_value) == "table" or type(data_value) == "UNKNOWN" or type(data_value) == "table" then 
            if vlua.find(_LogDeepprint_alreadyseen, data_value) ~= nil then 
                string_accum = string_accum .. prefix .. idx .. " ALREADY SEEN " .. "\n"
            else 
                local is_array = type(data_value) == "table"
                string_accum = string_accum .. prefix .. idx .. " = ( " .. type(data_value) .. " )" .. "\n"
                string_accum = string_accum .. prefix .. (is_array and "[" or "{") .. "\n"
                table.insert(_LogDeepprint_alreadyseen, data_value)
                string_accum = string_accum .. _LogDeepToString(data_value, prefix .. "   ")
                string_accum = string_accum .. prefix .. (is_array and "]" or "}") .. "\n"
            end
        else 
            --string_accum = string_accum .. prefix .. idx .. "\t= " .. (type(data_value) == "string" and ("\"" .. data_value .. "\"") or data_value) .. "\n"
			string_accum = string_accum .. prefix .. idx .. "\t= " .. "\"" .. tostring(data_value) .. "\"" .. "\n"
        end
    end
    if prefix == "   " then 
        string_accum = string_accum .. (type(debugInstance) == "table" and "]" or "}") .. "\n" -- hack for "proving" at end - this is DUMB!
    end
    return string_accum
end


scripthelp_LogDeepString = "Convert a class/array/instance/table to a string"

function LogDeepToString(debugInstance, prefix) 
    prefix = prefix or ""
    _LogDeepprint_alreadyseen = {}
    table.insert(_LogDeepprint_alreadyseen, debugInstance)
    return _LogDeepToString(debugInstance, prefix)
end


scripthelp_LogDeepPrint = "Print out a class/array/instance/table to the console"

function LogDeepPrint(debugInstance, prefix) 
    prefix = prefix or ""
    LogEndLine(LogDeepToString(debugInstance, prefix))
end

function LoopOverHeroes(callback)
    for i=0, 13 do
        local hero = PlayerResource:GetSelectedHeroEntity(i)
        if hero ~= nil then 
            if callback(hero) then
                break
            end 
        end
    end
end

function LoopOverPlayers(callback)
    for i=0, 13 do
        local playerID = i
        local player = PlayerResource:GetPlayer(i)
        local playerHero = PlayerResource:GetSelectedHeroEntity(playerID)
        if playerHero then
            --print("Looping through hero " .. playerHero:GetName())
            if callback(player, playerID, playerHero) then
                break
            end
        end 
    end
end


function RemoveHeroFromLinkTables(targethero)
    LoopOverHeroes(function(hero)
        if hero.linkTable ~= nil then
            for i=1, #hero.linkTable do
                if hero.linkTable[i] == targethero then
                    --print("Removed " .. hero.linkTable[i]:GetName() .. "from", hero:GetName(), " from table")
                    table.remove(hero.linkTable, i)
                end
            end
        end
    end)
    --For debugging
    --[[LoopOverHeroes(function(hero)
        if hero.linkTable ~= nil then
            for i=1, #hero.linkTable do
                print(hero:GetName(),hero.linkTable[i]:GetName())
            end
        end
    end)]]
end

function SaveStashState(hero)
    local stashState = {}
    local stashChargeState = {}
    for i=1, 6 do
        local item = hero:GetItemInSlot(i + 9)
        table.insert(stashState, i, item and item:GetName())
        table.insert(stashChargeState, i, item and item:GetCurrentCharges())
    end
    hero.stashState = stashState
    hero.stashChargeState = stashChargeState
end

function LoadStashState(hero)
    local stashState = hero.stashState or {}
    local stashChargeState = hero.stashChargeState or {}
    -- fill inventory with dummy items so AddItem adds to correct index
    for i=0,5 do
        local item = hero:GetItemInSlot(i)
        if item == nil then
            local dummyItem = CreateItem("item_dummy_item", nil, nil)
            hero:AddItem(dummyItem)
        end
    end
    for i=1,6 do
        local item = hero:GetItemInSlot(i + 10)
        hero:RemoveItem(item)

        local savedItemName = stashState[i]
        local newItem = CreateItem(savedItemName or "item_dummy_item", nil, nil)
        hero:AddItem(newItem)

        local charges = stashChargeState[i]
        if charges ~= nil then
            newItem:SetCurrentCharges(charges)
        end
    end
    -- clear dummy items
    for i=0,15 do
        local item = hero:GetItemInSlot(i)
        if item:GetName() == "item_dummy_item" then
            hero:RemoveItem(item)
        end
    end
end

function CheckDummyCollide(unit)
	local origin = unit:GetAbsOrigin()
	local targets = Entities:FindAllByNameWithin("npc_dota_creature", origin, 500)
	for k,v in pairs(targets) do
		if v:GetUnitName() == "ubw_sword_confine_dummy" and IsFacingUnit(unit, v, 180) and (origin - v:GetAbsOrigin()):Length2D() < 80 then
			return true
		end
	end
	return false
end

local substitutions = {
    -- colours
    ["_gray_"] = "",
    ["_silver_"] = "	",
    ["_default_"] = "",
    ["_yellow_"] = "",
    ["_gold_"] = "",
    ["_orange_"] = "",
    ["_lightred_"] = "",
    ["_red_"] = "",
    ["_magenta_"] = "",
    ["_pink_"] = "",
    ["_violet_"] = "",
    ["_purple_"] = "",
    ["_blue_"] = "",
    ["_darkgreen_"] = "",
    ["_olive_"] = "",
    ["_lightgreen_"] = "",
    ["_green_"] = "",

    --symbols
    ["_arrow_"] = "▶",
}

local heroNames = {
    ["npc_dota_hero_legion_commander"] = "Arturia Pendragon",
    ["npc_dota_hero_phantom_lancer"] = "Cu Chulain",
    ["npc_dota_hero_spectre"] = "Arturia Alter",
    ["npc_dota_hero_ember_spirit"] = "Emiya",
    ["npc_dota_hero_templar_assassin"] = "Medusa",
    ["npc_dota_hero_doom_bringer"] = "Heracles",
    ["npc_dota_hero_juggernaut"] = "Sasaki Kojiro",
    ["npc_dota_hero_bounty_hunter"] = "Hassan-i-Sabbah",
    ["npc_dota_hero_crystal_maiden"] = "Medea",
    ["npc_dota_hero_skywrath_mage"] = "Gilgamesh",
    ["npc_dota_hero_sven"] = "Lancelot",
    ["npc_dota_hero_vengefulspirit"] = "Angra Mainyu",
    ["npc_dota_hero_huskar"] = "Diarmuid",
    ["npc_dota_hero_chen"] = "Iskander",
    ["npc_dota_hero_shadow_shaman"] = "Gilles de Rais",
    ["npc_dota_hero_lina"] = "Nero Claudius",
    ["npc_dota_hero_omniknight"] = "Gawain",
    ["npc_dota_hero_enchantress"] = "Tamamo no Mae",
    ["npc_dota_hero_bloodseeker"] = "Li Shuwen",
    ["npc_dota_hero_mirana"] = "Jeanne",
    ["npc_dota_hero_queenofpain"] = "Astolfo",
    ["npc_dota_hero_windrunner"] = "Nursery Rhyme",
    ["npc_dota_hero_drow_ranger"] = "Atalanta",
    ["npc_dota_hero_tidehunter"] = "Vlad",
    ["npc_dota_hero_phantom_assassin"] = "Semiramis",
    ["npc_dota_hero_beastmaster"] = "Karna",
    ["npc_dota_hero_naga_siren"] = "Chloe von Einzbern",
    ["npc_dota_hero_riki"] = "Jack the Ripper",
    ["npc_dota_hero_dark_willow"] = "Okita Souji",
    ["npc_dota_hero_troll_warlord"] = "Francis Drake",
    ["npc_dota_hero_monkey_king"] = "Scathach",
    ["npc_dota_hero_tusk"] = "Mordred",
}


function SubstituteMessageCodes(message)
    for k,v in pairs(substitutions) do
        message = string.gsub(message, k , v)
    end
    for k,v in pairs(heroNames) do
        message = string.gsub(message, k , v)
    end
    return message
end

function FindName(name)
    return heroNames[name] or "Undefined"
end

local heroCombos = {
    ["npc_dota_hero_legion_commander"] = "saber_max_excalibur",
    ["npc_dota_hero_phantom_lancer"] = "lancer_5th_wesen_gae_bolg",
    ["npc_dota_hero_spectre"] = "saber_alter_max_mana_burst",
    ["npc_dota_hero_ember_spirit"] = "archer_5th_arrow_rain",
    ["npc_dota_hero_templar_assassin"] = "rider_5th_bellerophon_2",
    ["npc_dota_hero_doom_bringer"] = "berserker_5th_madmans_roar",
    ["npc_dota_hero_juggernaut"] = "false_assassin_hiken_enbu",
    ["npc_dota_hero_bounty_hunter"] = "true_assassin_combo",
    ["npc_dota_hero_crystal_maiden"] = "medea_hecatic_graea_combo",
    ["npc_dota_hero_skywrath_mage"] = "gilgamesh_max_enuma_elish",
    ["npc_dota_hero_sven"] = "lancelot_nuke",
    ["npc_dota_hero_vengefulspirit"] = "avenger_endless_loop",
    ["npc_dota_hero_huskar"] = "diarmuid_rampant_warrior",
    ["npc_dota_hero_chen"] = "iskander_annihilate",
    ["npc_dota_hero_shadow_shaman"] = "gille_larret_de_mort",
    ["npc_dota_hero_lina"] = "nero_laus_saint_claudius",
    ["npc_dota_hero_omniknight"] = "gawain_supernova",
    ["npc_dota_hero_enchantress"] = "tamamo_polygamist_castration_fist",
    ["npc_dota_hero_bloodseeker"] = "lishuwen_raging_dragon_strike",
    ["npc_dota_hero_mirana"] = "jeanne_combo_la_pucelle",
    ["npc_dota_hero_queenofpain"] = "astolfo_hippogriff_ride",
    ["npc_dota_hero_windrunner"] = "nursery_rhyme_story_for_somebodys_sake",
    ["npc_dota_hero_drow_ranger"] = "atalanta_phoebus_catastrophe_barrage",
    ["npc_dota_hero_tidehunter"] = "vlad_combo",
    ["npc_dota_hero_phantom_assassin"] = "vlad_combo",
    ["npc_dota_hero_beastmaster"] = "karna_combo_vasavi",
    ["npc_dota_hero_naga_siren"] = "kuro_crane_wings_combo",
    ["npc_dota_hero_riki"] = "jtr_whitechapel_murderer",
    ["npc_dota_hero_dark_willow"] = "okita_zekken",
    ["npc_dota_hero_troll_warlord"] = "drake_combo_golden_wild_hunt",
    ["npc_dota_hero_monkey_king"] = "scathach_combo_gate_of_sky",
}

function GetHeroCombo(hero)
    local name = hero:GetName()
    return heroCombos[name] or ""
end

-- returns -1 if combo is not available
-- returns 0 if combo is available and ready
-- otherwise returns cooldown remaning on combo
function GetComboAvailability(hero)
    local heroName = hero:GetName()
    if heroName == "npc_dota_hero_juggernaut" then
        if hero:GetStrength() < 24.1 or hero:GetAgility() < 24.1 then
            return -1
        end
    else
        local statreq = 19.1
        if heroName == "npc_dota_hero_sven" then
            local ability = hero:FindAbilityByName("lancelot_arondite")
            if hero:HasModifier("modifier_arondite") then
                statreq = statreq + ability:GetLevelSpecialValueFor("bonus_allstat", ability:GetLevel() - 1)
            end
        end
        if hero:GetStrength() < statreq
            or hero:GetAgility() < statreq
            or hero:GetIntellect() < statreq
        then
            return -1
        end
    end
    local comboName = GetHeroCombo(hero)
    if comboName == "" then
        return -1
    end
    local combo = hero:FindAbilityByName(comboName)
    if combo == nil then
        return -1
    end
    return combo:GetCooldownTimeRemaining()
end

--Function records EMPIRICAL damage and also PRE-REDUCTION right click damage, PRE-REDUCTION skill damage is handled at line 906 to 910.
function OnHeroTakeDamage(keys)
    local hero = keys.caster:GetPlayerOwner():GetAssignedHero()
    local attacker = keys.attacker
    local damageTaken = keys.DamageTaken

    if not attacker:IsHero() and not attacker.TempestDouble then --Account neutral attackers
        if IsValidEntity(attacker:GetPlayerOwner()) then
            attackerHero = attacker:GetPlayerOwner():GetAssignedHero()
        elseif attacker:GetUnitName() == "okita_shinsengumi" then 
            attackerHero = PlayerResource:GetPlayer(attacker:GetMainControllingPlayer()):GetAssignedHero()
        end
    elseif attacker.TempestDouble then
        attackerHero = attacker.NurseryRhyme
    else
        attackerHero = attacker
    end
    if GetMapName() == "fate_tutorial" then 
    else
        if attacker:GetAttackTarget() == hero then
            --print("Right click before armor reductions", damageTaken * 1/(1-GetPhysicalDamageReduction(hero:GetPhysicalArmorValue(false))))
            attackerHero.ServStat:doDamageBeforeReduction(damageTaken * 1/(1-GetPhysicalDamageReduction(hero:GetPhysicalArmorValue(false))))
            hero.ServStat:takeDamageBeforeReduction(damageTaken * 1/(1-GetPhysicalDamageReduction(hero:GetPhysicalArmorValue(false))))
        end
        --print("Actual damage from KV:", damageTaken)
        attackerHero.ServStat:doActualDamage(damageTaken)
        hero.ServStat:takeActualDamage(damageTaken)
    end
end

function FxDestroyer(PIndex,instant)
  if PIndex ~= nil and type(PIndex) == "table" then
    --PrintTable(PIndex)
    for i,j in pairs(PIndex) do
      --print("destroy",PIndex[i])
      ParticleManager:DestroyParticle(PIndex[i], instant)
      ParticleManager:ReleaseParticleIndex(PIndex[i])
    end
    PIndex = nil
    return PIndex
  elseif PIndex ~= nil then
    --print("destroy1",PIndex)
    ParticleManager:DestroyParticle(PIndex, instant)
    ParticleManager:ReleaseParticleIndex(PIndex)
    PIndex = nil
    return PIndex
  end
end

function FxCreator(effectname,pattach,target,cp,attach,amount)
  if amount ~= nil then
    local FXIndex = {}
    for i=amount,1,-1 do
      FXIndex[i] = ParticleManager:CreateParticle(effectname,pattach,target)
      ParticleManager:SetParticleControlEnt(FXIndex[i],cp,target,pattach,attach,target:GetAbsOrigin(),false)
      --print("create            ",FXIndex[i])
    end
    return FXIndex
  else         
    local FXIndex = ParticleManager:CreateParticle(effectname,pattach,target)
    ParticleManager:SetParticleControlEnt(FXIndex,cp,target,pattach,attach,target:GetAbsOrigin(),false)
    --print("create                ", FXIndex)
    return FXIndex
  end
end


function WrapAttributes(ability, attributeName, callback)
    function ability:OnSpellStart()
        local caster = self:GetCaster()
        local player = caster:GetPlayerOwner()
        local hero = caster:GetPlayerOwner():GetAssignedHero()

        hero[attributeName] = true

        local master = hero.MasterUnit
        master:SetMana(master:GetMana() - self:GetManaCost(1))

        if callback then
            callback(self, hero)
        end
    end
end

-- Spaghetti and hax as fuck.
function HotkeyPurchaseItem(iSource, args)
    local item = args['item']
    local cost = GetItemCost(item)
    local entity = EntIndexToHScript(iSource)
    local id = entity:GetPlayerID()
    local hero = entity:GetAssignedHero()

    if not hero or hero:GetUnitName() == "npc_dota_hero_wisp" then return end

    local mode = GameRules.AddonTemplate
    local gold = hero:GetGold()
    local keys = {
        PlayerID = id,
        itemname = item,
        itemcost = cost,
    }

    local hItem = nil

    local target = nil
    for j = 10, 15 do
        if hero:GetItemInSlot(j) == nil then target = j break end
    end
    if not target then return end

    local purchase = function()
        hItem = hero:AddItemByName(item)
        hero:SpendGold(cost, 4)
        mode:OnItemPurchased(keys)
    end

    if hero.IsInBase and gold >= cost then
        purchase()
    elseif gold >= cost * 1.5 then
        purchase()
    else
        return
    end

    local index = nil
    for i = 0, 5 do
        if hero:GetItemInSlot(i) == hItem then index = i break end
    end

    if index ~= nil and target ~= nil then
        hero:SwapItems(index, target)
    end
end
CustomGameEventManager:RegisterListener("hotkey_purchase_item", HotkeyPurchaseItem)

function SpawnDummy(hCaster,vOrigin,vFacing)
  local hDummy = CreateUnitByName("visible_dummy_unit", vOrigin or hCaster:GetAbsOrigin(), false, hCaster, hCaster, hCaster:GetTeamNumber())
  hDummy:FindAbilityByName("dummy_visible_unit_passive"):SetLevel(1)
  hDummy:SetDayTimeVisionRange(0)
  hDummy:SetNightTimeVisionRange(0)
  hDummy:SetAbsOrigin(vOrigin or hCaster:GetAbsOrigin())
  hDummy:SetForwardVector(vFacing or hCaster:GetForwardVector())
  return hDummy
end

--atr1's way to fix shooting arrows backward
function ForwardVForPointGround(hCaster,vTarget)
  local vOrigin = hCaster:GetAbsOrigin()
  local vDisplacement, vFacing = vTarget - vOrigin
  if math.abs(vDisplacement.x) < 0.05 then
    vDisplacement.x = 0
  end
  if math.abs(vDisplacement.y) < 0.05 then
    vDisplacement.y = 0
  end
  vDisplacement.z = 0
  if vDisplacement == Vector(0, 0, 0) then
    vFacing = hCaster:GetForwardVector()
  else
    vFacing = vDisplacement:Normalized()
  end  
  return vFacing
end

function UpdateAbilityLayout(hHero, tAbilities)
    local tAbilities = tAbilities or hHero.AbilityLayout
    for i = 1, hHero:GetAbilityCount() do
        if hHero:GetAbilityByIndex(i - 1) == nil then
        elseif i > #tAbilities then
            hHero:GetAbilityByIndex(i - 1):SetHidden(true)
        elseif hHero:GetAbilityByIndex(i - 1):GetAbilityName() ~= tAbilities[i] then
            hHero:SwapAbilities(hHero:GetAbilityByIndex(i - 1):GetAbilityName(), tAbilities[i], true, true)
        end
    end
end

function CanBeDetected(hHero)
    for i=1, #tCannotDetect do
        if hHero:GetName() == tCannotDetect[i] then
            return false
        end
    end
    
    return true
end

function RemoveDebuffsForRevival(hTarget)
    for i=1, #tDangerousBuffs do
        print(tDangerousBuffs[i])
        hTarget:RemoveModifierByName(tDangerousBuffs[i])
    end
end

function IsBeam(ability)
    for i = 1, #tBeamAbilities do
        if ability:GetAbilityName() == tBeamAbilities[i] then
            return true
        end
    end
    
    return false
end

function IsKnockbackImmune(hTarget)
    for i=1, #tModifierKBImmune do
        if hTarget:HasModifier(tModifierKBImmune[i]) then
            return true
        end
    end
    if hTarget:GetUnitName() == "okita_flag" then return true end
    return false
end

function IsManaLess(hTarget)
    for i = 1, #tManalessHero do
        if hTarget:GetName() == tManalessHero[i] then
            return true
        end
    end
    
    return false
end

function IsTrueInvis(hTarget)
    for i = 1, #tTrueInvis do
        if hTarget:HasModifier(tTrueInvis[i]) then
            return true
        end
    end
    
    return false
end

function RemoveInVis(hTarget)
    for i = 1, #invis do
        hTarget:RemoveModifierByName(invis[i])
    end
end

function IsUnExecute(hTarget)
    for i = 1, #tUnExecute do
        if hTarget:HasModifier(tUnExecute[i]) then
            return true
        end
    end
    
    return false
end

function RemoveComboCD(hTarget)
    for i = 1, #tModifierCooldown do
        if hTarget:HasModifier(tModifierCooldown[i]) then
            hTarget:RemoveModifierByName(tModifierCooldown[i])
        end
    end
end

function IsArthur(hTarget)
    for i = 1, #tArthurHeroes do
        if hTarget:GetName() == tArthurHeroes[i] then
            return true
        end
    end
    
    return false
end

function IsDragon(hTarget)
    for i = 1, #tDragonHeroes do
        if hTarget:GetUnitName() == tDragonHeroes[i] then
            return true
        end
    end
    
    return false
end

function IsMountedHero(hTarget)
    for i = 1, #tMount do
        if hTarget:HasModifier(tMount[i]) then
            return true
        end
    end
    
    return false
end

function IsDivineServant(hTarget)
    if not hTarget:IsHero() then return false end

    for i = 1, #tDivineHeroes do
        if hTarget:GetName() == tDivineHeroes[i] then
            return true
        end
    end

    return false
end

function CheckDivinity (hTarget)
    if hTarget:GetName() == "npc_dota_hero_chen" or hTarget:GetName() == "npc_dota_hero_phantom_assassin" or hTarget:GetName() == "npc_dota_hero_enchantress" or hTarget:GetName() == "npc_dota_hero_templar_assassin" or hTarget:GetName() == "npc_dota_hero_skywrath_mage" or hTarget:GetName() == "npc_dota_hero_phantom_lancer" then 
        return 1
    elseif hTarget:GetName() == "npc_dota_hero_doom_bringer" or hTarget:GetName() == "npc_dota_hero_beastmaster" then 
        return 2
    end
end

function RemoveTroublesomeModifiers(hTarget)
    for i = 1, #tRemoveTheseModifiers do
        hTarget:RemoveModifierByName(tRemoveTheseModifiers[i])
    end
end

function IsKnightClass(hTarget)
    if not hTarget:IsHero() then return false end

    for i = 1, #tKnightClass do
        if hTarget:GetName() == tKnightClass[i] then
            return true
        end
    end

    return false
end

function IsHorsemanClass(hTarget)
    if not hTarget:IsHero() then return false end

    for i = 1, #tHorsemanClass do
        if hTarget:GetName() == tHorsemanClass[i] then
            return true
        end
    end

    return false
end

function PickRandomEnemy(hHero)
    local enemy

    for i=0, 13 do
        local playerID = i
        local player = PlayerResource:GetPlayer(i)
        local playerHero = PlayerResource:GetSelectedHeroEntity(playerID)

        if playerHero then        
            if playerHero:GetTeamNumber() ~= hHero:GetTeamNumber() and playerHero:IsAlive() then
                enemy = playerHero
                break
            end
        else
            break
        end
    end

    return enemy
end

LinkLuaModifier("modifier_winner_inertia", "abilities/general/modifiers/modifier_winner_inertia", LUA_MODIFIER_MOTION_NONE)

function AddInertiaModifier(hHero)
    hHero:AddNewModifier(hHero, nil, "modifier_winner_inertia", { Duration = 25 })
end