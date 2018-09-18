class azm_zombie_config
{
    // 1 equals to true ------- 0 equals to false
    debug_mode = 0;

    /*General settings*/
    tempo_tra_ondate = 15;


    /*money*/
    moneystart = 500;
    soldi_per_hit_head = 50;
    soldi_per_hit_body = 10;
    money_body_parts_head[] = {"head"};

    /* costo perk*/
    costo_perk_dt = 2000;
    msg_perk_dt = "Hai comprato il perk del double tap la tua velocità di fuoco è aumentata";
    costo_perk_jug = 2500;
    msg_perk_jug = "Hai comprato il perk di juggernout la tua vita è aumentata";
    costo_perk_stamina = 1500;
    msg_perk_stamina = "Hai comprato il perk stamina ora puoi correre all'infinito";



    kaboom_range = 60;

    /* Weapons */
    //random crate weapons
    random_crate_price = 950;
    time_to_take_weapon = 15;
    random_weapons[] = {{"FOW_WG_GER_MG34","fow_w_mg34","[GER] MG34"}, {"FOW_WG_GER_MG42","fow_w_mg42","[GER] MG42"}, {"FOW_WG_GER_STG44","fow_w_stg44","[GER] STG 44"}, {"FOW_WG_IJA_Type99","fow_w_type99_lmg","[IJA] Type 99 LMG"}, {"FOW_WG_US_M1918A2","fow_w_m1918a2","[US] M1918A2 B.A.R."}, {"FOW_WG_US_M1A1","fow_w_m1a1_thompson","[US] M4A1  Thompson"}};
    //wall weapons
    number_magazines = 10;





    /*spawn*/
    spawnmarker = "p_spawn";
    zombie_spanw_zones[] = {{0,{"0_sz_1","0_sz_2","0_sz_3","0_sz_4","0_sz_5"}},{1,{"1_sz_1","1_sz_2"}},{2,{"1_sz_1","1_sz_2"}},{3,{"3_sz_1"}},{4,{"4_sz_1","4_sz_2","4_sz_3"}},{5,{"5_sz_1","5_sz_2","5_sz_3","5_sz_4"}}};




    /*loadout manager*/
    classe_npc_player = "B_Survivor_F";
    pistol_unlimited_ammo = 1;
    unlimited_ammo_pistol_class = "fow_w_p08";
    loadout[] = {{},{},{"fow_w_p08","","","",{"fow_8Rnd_9x19",8},{},""},{"fow_u_us_m37_02_private",{}},{"fow_v_us_ab_bar",{}},{},"","",{},{"","","","","",""}};




    /*zombie types */
    mid_zombie[] = {"RyanZombieC_man_1mediumOpfor","RyanZombieC_man_hunter_1_FmediumOpfor","RyanZombie15mediumOpfor","RyanZombieC_man_polo_2_FmediumOpfor","RyanZombieC_man_polo_4_FmediumOpfor","RyanZombieC_OrestesmediumOpfor"};
    slow_zombie[] = {"RyanZombieC_OrestesslowOpfor", "RyanZombie23slowOpfor", "RyanZombie26slowOpfor", "RyanZombieC_scientist_FslowOpfor", "RyanZombie19slowOpfor", "RyanZombieC_man_pilot_FslowOpfor", "RyanZombieC_man_hunter_1_FslowOpfor", "RyanZombieC_man_1slowOpfor", "RyanZombieC_NikosslowOpfor", "RyanZombie16slowOpfor", "RyanZombie18slowOpfor", "RyanZombie27slowOpfor"};
    load_zombie[] = {{{},{},{},{"fow_u_ger_m43_ss_01_private",{}},{"fow_v_ija_bayonet",{}},{},"fow_h_ger_m40_fall_01","",{},{"ItemMap","","ItemRadio","ItemCompass","ItemWatch",""}},{{},{},{},{"fow_u_ger_tankcrew_01",{}},{"fow_v_ija_bayonet",{}},{},"fow_h_ger_m38_feldmutze_panzer","",{},{"ItemMap","","ItemRadio","ItemCompass","ItemWatch",""}},{{},{},{},{"fow_u_ger_fall_04_lance_corporal",{}},{"fow_v_ija_nco",{}},{"fow_b_ammoboxes",{}},"fow_h_ger_m40_ss_02","",{},{"ItemMap","","ItemRadio","ItemCompass","ItemWatch",""}},{{},{},{},{"fow_u_ger_m43_peadot_03_private",{}},{"fow_v_ija_nco",{}},{"fow_b_uk_p37_shovel",{}},"fow_h_ger_m40_ss_02","",{},{"ItemMap","","ItemRadio","ItemCompass","ItemWatch",""}},{{},{},{},{"fow_u_ger_tankcrew_02_unteroffizier",{}},{"fow_v_ija_nco",{}},{"fow_b_grenadebag",{}},"fow_h_ger_headset","",{},{"ItemMap","","ItemRadio","ItemCompass","ItemWatch",""}}};




};
