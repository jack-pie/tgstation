#define DRONE_PRODUCTION "production"
#define DRONE_RECHARGING "recharging"
#define DRONE_READY "ready"

/obj/machinery/droneDispenser //Most customizable machine 2015
	name = "drone shell dispenser"
	desc = "Maszyna która automatycznie produkuje drony po załadowaniu żelazem, szkłem, złotem i miedzią. NanoTrasen nie odpowiada za zaginione kredki."

	icon = 'icons/obj/machines/droneDispenser.dmi'
	icon_state = "on"
	density = TRUE
	max_integrity = 250
	integrity_failure = 80

	// These allow for different icons when creating custom dispensers
	var/icon_off = "off"
	var/icon_on = "on"
	var/icon_recharging = "recharge"
	var/icon_creating = "make"
	var/icon_open = "open"
	//10 drones from one ingot of gold and copper and a full stack of glass and iron
	var/has_parts
	has_parts = TRUE
	var/list/using_materials
	var/starting_amount = 0
	var/iron_cost = 10000
	var/glass_cost = 10000
	var/power_used = 1000
	var/gold_cost = 200
	var/copper_cost = 200

	var/mode = DRONE_READY
	var/timer
	var/cooldownTime = 2100 //600 - 1 minute
	var/production_time = 30
	//The item the dispenser will create
	var/dispense_type = /obj/item/drone_shell

	// The maximum number of "idle" drone shells it will make before
	// ceasing production. Set to 0 for infinite.
	var/maximum_idle = 3

	var/work_sound = 'sound/items/rped.ogg'
	var/create_sound = 'sound/items/deconstruct.ogg'
	var/recharge_sound = 'sound/machines/ping.ogg'

	var/begin_create_message = "whirs to life!"
	var/end_create_message = "dispenses a drone shell."
	var/recharge_message = "pings."
	var/recharging_text = "It is whirring and clicking. It seems to be recharging."

	var/break_message = "lets out a tinny alarm before falling dark."
	var/break_sound = 'sound/machines/warning-buzzer.ogg'

/obj/machinery/droneDispenser/Initialize()
	. = ..()
	var/datum/component/material_container/materials = AddComponent(/datum/component/material_container, list(/datum/material/iron, /datum/material/glass,  /datum/material/copper, /datum/material/gold), MINERAL_MATERIAL_AMOUNT * MAX_STACK_SIZE * 2, TRUE, /obj/item/stack)
	materials.insert_amount_mat(starting_amount)
	materials.precise_insertion = TRUE
	using_materials = list(/datum/material/iron = iron_cost, /datum/material/glass = glass_cost, /datum/material/copper = copper_cost, /datum/material/gold = gold_cost)
	if(has_parts)
		component_parts = list(new /obj/item/circuitboard/machine/droneDispenser,
		new /obj/item/mmi/posibrain,
		new /obj/item/stack/sheet/glass,
		new /obj/item/stock_parts/matter_bin,
		new /obj/item/stock_parts/matter_bin,
		new /obj/item/stock_parts/manipulator,
		new /obj/item/stock_parts/manipulator,
		new /obj/item/stock_parts/manipulator)
	else
		component_parts = list(new /obj/item/stack/sheet/iron/twenty)

/obj/machinery/droneDispenser/preloaded
	has_parts = TRUE
	starting_amount = 100000

/obj/machinery/droneDispenser/syndrone //Please forgive me
	name = "syndrone shell dispenser"
	desc = "Krwistoczerwony dyspenser automatycznie produkujący syndrony po załadowaniu żelazem, szkłem, złotem i miedzią. Syndykat odpowiada za zaginione kredki i załogę."
	icon = 'icons/obj/machines/droneDispenser.dmi'
	icon_off = "syndrone_off"
	icon_on = "syndrone_on"
	icon_recharging = "syndrone_recharge"
	icon_creating = "syndrone_make"
	icon_open = "syndrone_open"
	dispense_type = /obj/item/drone_shell/syndrone
	has_parts = TRUE
	end_create_message = "dispenses a suspicious drone shell."

/obj/machinery/droneDispenser/syndrone/badass //Please forgive me
	name = "badass syndrone shell dispenser"
	desc = "A suspicious machine that will create Syndicate exterminator drones when supplied with iron and glass. Disgusting. This one seems ominous."
	icon_off = "syndrone_off"
	icon_on = "syndrone_on"
	icon_recharging = "syndrone_recharge"
	icon_creating = "syndrone_make"
	icon_open = "syndrone_open"
	dispense_type = /obj/item/drone_shell/syndrone/badass
	has_parts = TRUE
	end_create_message = "dispenses an ominous suspicious drone shell."

// I don't need your forgiveness, this is awesome.
/obj/machinery/droneDispenser/snowflake
	name = "snowflake drone shell dispenser"
	desc = "Maszyna która automatycznie produkuje drony po załadowaniu żelazem, szkłem, miedzią i złotem. NanoTrasen nie odpowiada za zaginione kredki."
	dispense_type = /obj/item/drone_shell/snowflake
	end_create_message = "dispenses a snowflake drone shell."
	// Those holoprojectors aren't cheap
	has_parts = TRUE
	iron_cost = 10000
	glass_cost = 10000
	power_used = 1000
	gold_cost = 200
	copper_cost = 200
	starting_amount = 2000

// An example of a custom drone dispenser.
// This one requires no materials and creates basic hivebots
/obj/machinery/droneDispenser/hivebot
	name = "hivebot fabricator"
	desc = "A large, bulky machine that whirs with activity, steam hissing from vents in its sides."
	icon = 'icons/obj/objects.dmi'
	icon_state = "hivebot_fab"
	icon_off = "hivebot_fab"
	icon_on = "hivebot_fab"
	icon_recharging = "hivebot_fab"
	icon_creating = "hivebot_fab_on"
	has_parts = FALSE
	iron_cost = 0
	glass_cost = 0
	gold_cost = 0
	copper_cost = 0
	power_used = 0
	starting_amount = 1
	cooldownTime = 10 //Only 1 second - hivebots are extremely weak
	dispense_type = /mob/living/simple_animal/hostile/hivebot
	begin_create_message = "closes and begins fabricating something within."
	end_create_message = "slams open, revealing a hivebot!"
	recharge_sound = null
	recharge_message = null

/obj/machinery/droneDispenser/swarmer
	name = "swarmer fabricator"
	desc = "An alien machine of unknown origin. It whirs and hums with green-blue light, the air above it shimmering."
	icon = 'icons/obj/machines/gateway.dmi'
	icon_state = "toffcenter"
	icon_off = "toffcenter"
	icon_on = "toffcenter"
	icon_recharging = "toffcenter"
	icon_creating = "offcenter"
	has_parts = FALSE
	iron_cost = 0
	glass_cost = 0
	gold_cost = 0
	copper_cost = 0
	power_used = 0
	starting_amount = 1
	cooldownTime = 300 //30 seconds
	maximum_idle = 0 // Swarmers have no restraint
	dispense_type = /obj/effect/mob_spawn/swarmer
	begin_create_message = "hums softly as an interface appears above it, scrolling by at unreadable speed."
	end_create_message = "materializes a strange shell, which drops to the ground."
	recharging_text = "Its lights are slowly increasing in brightness."
	work_sound = 'sound/effects/empulse.ogg'
	create_sound = 'sound/effects/phasein.ogg'
	break_sound = 'sound/effects/empulse.ogg'
	break_message = "slowly falls dark, lights stuttering."

/obj/machinery/droneDispenser/examine(mob/user)
	. = ..()
	if((mode == DRONE_RECHARGING) && !stat && recharging_text)
		. += "<span class='warning'>[recharging_text]</span>"

/obj/machinery/droneDispenser/power_change()
	..()
	if(powered())
		stat &= ~NOPOWER
	else
		stat |= NOPOWER
	update_icon()

/obj/machinery/droneDispenser/process()
	..()
	if((stat & (NOPOWER|BROKEN)) || !anchored)
		return

	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	if(!materials.has_materials(using_materials))
		return // We require more minerals

	// We are currently in the middle of something
	if(timer > world.time)
		return

	switch(mode)
		if(DRONE_READY)
			// If we have X drone shells already on our turf
			if(maximum_idle && (count_shells() >= maximum_idle))
				return // then do nothing; check again next tick
			if(begin_create_message)
				visible_message("<span class='notice'>[src] [begin_create_message]</span>")
			if(work_sound)
				playsound(src, work_sound, 50, 1)
			mode = DRONE_PRODUCTION
			timer = world.time + production_time
			update_icon()

		if(DRONE_PRODUCTION)
			materials.use_materials(using_materials)
			if(power_used)
				use_power(power_used)

			var/atom/A = new dispense_type(loc)
			A.flags_1 |= (flags_1 & ADMIN_SPAWNED_1)

			if(create_sound)
				playsound(src, create_sound, 50, 1)
			if(end_create_message)
				visible_message("<span class='notice'>[src] [end_create_message]</span>")

			mode = DRONE_RECHARGING
			timer = world.time + cooldownTime
			update_icon()

		if(DRONE_RECHARGING)
			if(recharge_sound)
				playsound(src, recharge_sound, 50, 1)
			if(recharge_message)
				visible_message("<span class='notice'>[src] [recharge_message]</span>")

			mode = DRONE_READY
			update_icon()

/obj/machinery/droneDispenser/proc/count_shells()
	. = 0
	for(var/a in loc)
		if(istype(a, dispense_type))
			.++

//When alt-clicked the dispenser will drop stored mats.
/obj/machinery/droneDispenser/AltClick(mob/user)
	if(user.canUseTopic(src, !issilicon(usr)))
		var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
		materials.retrieve_all()
		to_chat(user, "<span class='notice'>You retrieve the materials from [src].</span>")

/obj/machinery/droneDispenser/attackby(obj/item/I, mob/living/user)
	if(I.tool_behaviour == TOOL_WELDER)
		if(!(stat & BROKEN))
			to_chat(user, "<span class='warning'>[src] doesn't need repairs.</span>")
			return

		if(!I.tool_start_check(user, amount=1))
			return

		user.visible_message(
			"<span class='notice'>[user] begins patching up [src] with [I].</span>",
			"<span class='notice'>You begin restoring the damage to [src]...</span>")

		if(!I.use_tool(src, user, 40, volume=50, amount=1))
			return

		user.visible_message(
			"<span class='notice'>[user] fixes [src]!</span>",
			"<span class='notice'>You restore [src] to operation.</span>")

		stat &= ~BROKEN
		obj_integrity = max_integrity
		update_icon()
	else
		return ..()
//When Deconstructed, dispenser will drop stored mats.
/obj/machinery/droneDispenser/on_deconstruction()
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	materials.retrieve_all()

/obj/machinery/droneDispenser/obj_break(damage_flag)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(!(stat & BROKEN))
			if(break_message)
				audible_message("<span class='warning'>[src] [break_message]</span>")
			if(break_sound)
				playsound(src, break_sound, 50, 1)
			stat |= BROKEN
			update_icon()

/obj/machinery/droneDispenser/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, icon_open, icon_on, I))
		return
	if(default_pry_open(I))
		return
	if(default_deconstruction_crowbar(I))
		var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
		materials.retrieve_all()
		return
	return ..()

/obj/machinery/droneDispenser/update_icon()
	if(stat & (BROKEN|NOPOWER))
		icon_state = icon_off
	else if((stat & MAINT) || panel_open)
		icon_state = icon_open
	else if(mode == DRONE_RECHARGING)
		icon_state = icon_recharging
	else if(mode == DRONE_PRODUCTION)
		icon_state = icon_creating
	else
		icon_state = icon_on

//KODZIE KURWO JEBANA, PRZESTAŃ MI KURWA COOLDOWN OBNIŻAĆ
/obj/machinery/droneDispenser/RefreshParts()
	var/T = 0
	var/cdT = 0
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		T += MB.rating*102000
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	materials.max_amount = T
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		cdT = M.rating * 300
		cooldownTime = 2100 - cdT //chuj, może zadziała ze stałym cooldownem, nie wiem już kurwa

#undef DRONE_PRODUCTION
#undef DRONE_RECHARGING
#undef DRONE_READY
