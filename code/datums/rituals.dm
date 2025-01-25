/datum/ritual
	/// Linked object
	var/obj/ritual_object
	/// Name of our ritual
	var/name
	/// Description of our ritual. Later be used in tgui
	var/description
	/// If ritual requires more than one invoker
	var/extra_invokers = 0
	/// If invoker species isn't in allowed - he won't do ritual.
	var/list/allowed_species
	/// If invoker special role isn't in allowed - he won't do ritual.
	var/list/allowed_special_role
	/// Required to ritual invoke things are located here
	var/list/required_things
	/// We search for humans in that radius
	var/finding_range = DEFAULT_RITUAL_RANGE_FIND
	/// Amount of maximum ritual uses.
	var/charges = -1
	/// Cooldown for one ritual
	COOLDOWN_DECLARE(ritual_cooldown)
	/// Our cooldown after we casted ritual.
	var/cooldown_after_cast = DEFAULT_RITUAL_COOLDOWN
	/// If our ritual failed on proceed - we'll try to cause disaster.
	var/disaster_prob = DEFAULT_RITUAL_DISASTER_PROB
	/// A chance of failing our ritual.
	var/fail_chance = DEFAULT_RITUAL_FAIL_PROB
	/// After successful ritual we'll destroy used things.
	var/ritual_should_del_things = TRUE
	/// After failed ritual proceed - we'll delete items.
	var/ritual_should_del_things_on_fail = FALSE
	/// If defined - do_after will be added to your ritual
	var/cast_time

/datum/ritual/Destroy(force)
	ritual_object = null
	LAZYNULL(required_things)
	return ..()

/datum/ritual/proc/is_valid_invoker(mob/living/carbon/human/human)
	if(!istype(human))
		return FALSE

	if(LAZYLEN(allowed_species) && !is_type_in_list(human.dna.species, allowed_species))
		return FALSE

	if(LAZYLEN(allowed_special_role) && !LAZYIN(allowed_special_role, human.mind?.special_role))
		return FALSE

	return TRUE

/datum/ritual/proc/handle_ritual_object(stage, silent = FALSE)
	switch(stage)
		if(RITUAL_STARTED)
			playsound(ritual_object.loc, 'sound/effects/ghost2.ogg', 50, TRUE)
		if(RITUAL_ENDED)
			playsound(ritual_object.loc, 'sound/effects/phasein.ogg', 50, TRUE)
		if(RITUAL_FAILED)
			playsound(ritual_object.loc, 'sound/effects/empulse.ogg', 50, TRUE)

/datum/ritual/proc/del_things(list/used_things)
	return

/datum/ritual/proc/check_invokers(mob/living/carbon/human/invoker, list/invokers)
	return TRUE

/datum/ritual/proc/check_contents(mob/living/carbon/human/invoker, list/used_things)
	return TRUE

/datum/ritual/proc/do_ritual(mob/living/carbon/human/invoker, list/invokers, list/used_things) // Do ritual stuff.
	return RITUAL_SUCCESSFUL

/datum/ritual/proc/disaster(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	return

/datum/ritual/ashwalker
	/// If ritual requires extra shaman invokers
	var/extra_shaman_invokers = 0
	/// If ritual can be invoked only by shaman
	var/shaman_only = FALSE
	allowed_species = list(/datum/species/unathi/ashwalker, /datum/species/unathi/draconid)
	/// If our ritual needed any dyes on the body. Use names from code/modules/mining/ash_walkers/lavaland_dye.dm
	var/needed_dye = null
	/// Same, but for totems. This should be made little better, but i have no frackin idea how. Use same file.
	var/totem_dye = null

/datum/ritual/ashwalker/New()
	. = ..()
	AddElement(/datum/element/dye_removal)

/datum/ritual/ashwalker/is_valid_invoker(atom/atom)
	return istype(atom, /obj/structure/ash_totem) || ..()

/datum/ritual/ashwalker/check_invokers(atom/invoker, list/invokers)
	. = ..()

	if(!.)
		return FALSE

	if(shaman_only && !isashwalkershaman(invoker))
		to_chat(invoker, span_warning("Только шаман может выполнить данный ритуал!"))
		return FALSE

	if(needed_dye)
		for(var/mob/living/carbon/human/human in invokers)
			if(human.m_styles["body"] != needed_dye)
				human.balloon_alert(invoker, "нет нужной краски!")
				return FALSE

		for(var/obj/structure/ash_totem/totem in invokers)
			if(totem.applied_dye != totem_dye)
				totem.balloon_alert(invoker, "нет нужной краски!")
				return FALSE

	var/list/shaman_invokers = list()

	if(extra_shaman_invokers)
		for(var/mob/living/carbon/human/human in invokers)
			if(!isashwalkershaman(human))
				continue

			LAZYADD(shaman_invokers, human)

		if(LAZYLEN(shaman_invokers) < (extra_shaman_invokers + 1))
			ritual_object.balloon_alert(invoker, "требуется больше шаманов!")
			return FALSE

	return TRUE

/datum/ritual/ashwalker/summon_ashstorm
	name = "Призыв Пепельной Бури"
	description = "Проведение данного ритуала обрушивает на Лазис суровую пепельную бурю, значительно ухудшая видимость и смешивая планы чужеземцев."
	shaman_only = TRUE
	disaster_prob = 20
	charges = 2
	cooldown_after_cast = 1200 SECONDS
	cast_time = 20 SECONDS
	fail_chance = 20
	extra_invokers = 2
	needed_dye = "Amber Dyes"
	totem_dye = "amber"
	required_things = list(
		/mob/living/simple_animal/hostile/asteroid/goldgrub = 1
	)

/datum/ritual/ashwalker/summon_ashstorm/check_contents(mob/living/carbon/human/invoker, list/used_things)
	. = ..()

	if(!.)
		return FALSE

	for(var/mob/living/living in used_things)
		if(living.stat != DEAD)
			to_chat(invoker, "Существа должны быть мертвы")
			return FALSE

	return TRUE

/datum/ritual/ashwalker/summon_ashstorm/del_things(list/used_things)
	. = ..()

	for(var/mob/living/living in used_things)
		living.gib()

	return

/datum/ritual/ashwalker/summon_ashstorm/do_ritual(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	SSweather.run_weather(/datum/weather/ash_storm)
	message_admins("[key_name(invoker)] accomplished ashstorm ritual and summoned ashstorm")

	return RITUAL_SUCCESSFUL

/datum/ritual/ashwalker/summon_ashstorm/disaster(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	var/list/targets = list()

	for(var/mob/living/carbon/human/human in SSmobs.clients_by_zlevel[invoker.z])
		if(!isashwalker(human))
			continue

		LAZYADD(targets, human)

	if(!LAZYLEN(targets))
		return

	var/mob/living/carbon/human/human = pick(targets)
	var/datum/disease/virus/cadaver/cadaver = new
	cadaver.Contract(human)

	return

/datum/ritual/ashwalker/summon_ashstorm/handle_ritual_object(stage, silent = FALSE)
	switch(stage)
		if(RITUAL_ENDED)
			playsound(ritual_object.loc, 'sound/magic/fleshtostone.ogg', 50, TRUE)
		if(RITUAL_STARTED)
			playsound(ritual_object.loc, 'sound/magic/invoke_general.ogg', 50, TRUE)
		if(RITUAL_FAILED)
			playsound(ritual_object.loc, 'sound/magic/castsummon.ogg', 50, TRUE)

/datum/ritual/ashwalker/transformation
	name = "Ритуал Превращения"
	description = "Проведение данного ритуала обращает тело вторженца в подобного нам. Выбранная жертва должна иметь душу."
	disaster_prob = 30
	fail_chance = 50
	extra_invokers = 1
	cooldown_after_cast = 480 SECONDS
	cast_time = 30 SECONDS
	ritual_should_del_things_on_fail = TRUE
	needed_dye = "Cinnabar Dyes"
	totem_dye = "cinnabar"
	required_things = list(
		/obj/item/organ/internal/regenerative_core = 1,
		/mob/living/carbon/human = 1
	)

/datum/ritual/ashwalker/transformation/do_ritual(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	var/mob/living/carbon/human/human = locate() in used_things

	if(!human || !human.mind || !human.ckey)
		return RITUAL_FAILED_ON_PROCEED // Your punishment

	human.set_species(/datum/species/unathi/ashwalker)
	human.mind.store_memory("Теперь вы пеплоходец, вы часть племени! Вы довольно смутно помните о прошлой жизни, и вы не помните, как пользоваться технологиями!")

	return RITUAL_SUCCESSFUL

/datum/ritual/ashwalker/transformation/disaster(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	invoker.adjustBrainLoss(15)
	invoker.SetKnockdown(5 SECONDS)

	var/mob/living/carbon/human/human = locate() in used_things

	if(QDELETED(human))
		return

	var/list/destinations = list()

	for(var/obj/item/radio/beacon/beacon in GLOB.global_radios)
		LAZYADD(destinations, get_turf(beacon))

	human.forceMove(safepick(destinations))
	playsound(get_turf(human), 'sound/magic/invoke_general.ogg', 50, TRUE)

	return

/datum/ritual/ashwalker/transformation/handle_ritual_object(stage, silent = FALSE)
	if(stage & RITUAL_ENDED)
		playsound(ritual_object.loc, 'sound/effects/clone_jutsu.ogg', 50, TRUE)
		return

	return ..()

/datum/ritual/ashwalker/summon
	name = "Ритуал Призыва"
	description = "Проведение данного ритуала позволяет шаману призвать к руне любого пеплоходца вне зависимости от его текущего состояния."
	disaster_prob = 30
	fail_chance = 30
	shaman_only = TRUE
	needed_dye = "Crimson Dyes"
	totem_dye = "crimson"
	cooldown_after_cast = 900 SECONDS
	cast_time = 30 SECONDS
	extra_invokers = 1

/datum/ritual/ashwalker/summon/do_ritual(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	var/list/ready_for_summoning = list()

	for(var/mob/living/carbon/human/human in GLOB.mob_list)
		if(!human.ckey)
			continue

		if(!isashwalker(human))
			continue

		LAZYADD(ready_for_summoning, human)

	if(!LAZYLEN(ready_for_summoning))
		return RITUAL_FAILED_ON_PROCEED

	var/mob/living/carbon/human/human = tgui_input_list(invoker, "Who will be summoned?", "Summon ritual", ready_for_summoning)

	if(!human)
		return RITUAL_FAILED_ON_PROCEED

	deal_damage()
	summon(human)

	return RITUAL_SUCCESSFUL

/datum/ritual/ashwalker/summon/proc/deal_damage()
	for(var/mob/living/carbon/human/summoner in range(finding_range, ritual_object))
		summoner.AdjustBlood(-(summoner.blood_volume * 0.20))
		summoner.apply_damage(25, def_zone = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))

	return TRUE

/datum/ritual/ashwalker/summon/proc/summon(mob/living/carbon/human/human)
	human.forceMove(get_turf(ritual_object))
	human.vomit()
	human.Weaken(10 SECONDS)

	return TRUE

/datum/ritual/ashwalker/summon/disaster(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	if(!prob(70))
		return

	var/obj/item/organ/external/limb = invoker.get_organ(pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
	limb?.droplimb()

	return

/datum/ritual/ashwalker/summon/handle_ritual_object(stage, silent = FALSE)
	switch(stage)
		if(RITUAL_ENDED)
			playsound(ritual_object.loc, 'sound/weapons/zapbang.ogg', 50, TRUE)
			var/datum/effect_system/smoke_spread/smoke = new
			smoke.set_up(5, FALSE, ritual_object.loc)
			smoke.start()
		if(RITUAL_STARTED)
			playsound(ritual_object.loc, 'sound/magic/forcewall.ogg', 50, TRUE)
		if(RITUAL_FAILED)
			playsound(ritual_object.loc, 'sound/magic/invoke_general.ogg', 50, TRUE)

/datum/ritual/ashwalker/curse
	name = "Ритуал Проклятия"
	description = "Проведение данного ритуала приведёт к наложению страшной, почти неизлечимой болезни на случайного гуманоида, который не принадлежит нашему племени."
	disaster_prob = 30
	fail_chance = 30
	cooldown_after_cast = 600 SECONDS
	cast_time = 30 SECONDS
	charges = 3
	shaman_only = TRUE
	needed_dye = "Crimson Dyes"
	totem_dye = "crimson"
	extra_invokers = 2
	required_things = list(
		/mob/living/carbon/human = 1
	)

/datum/ritual/ashwalker/curse/del_things(list/used_things)
	for(var/mob/living/carbon/human/human in used_things)
		human.gib()

	return

/datum/ritual/ashwalker/curse/check_contents(mob/living/carbon/human/invoker, list/used_things)
	. = ..()

	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/human in used_things)
		if(human.stat != DEAD)
			to_chat(invoker, "Гуманоиды должны быть мертвы.")
			return FALSE

	return TRUE

/datum/ritual/ashwalker/curse/do_ritual(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	var/list/humans = list()

	for(var/mob/living/carbon/human/human in SSmobs.clients_by_zlevel[invoker.z])
		if(!isashwalker(human))
			LAZYADD(humans, human)

	if(!LAZYLEN(humans))
		return RITUAL_FAILED_ON_PROCEED

	var/mob/living/carbon/human/human = pick(humans)
	var/datum/disease/vampire/disease = new

	if(!disease.Contract(human))
		return RITUAL_FAILED_ON_PROCEED

	return RITUAL_SUCCESSFUL

/datum/ritual/ashwalker/curse/disaster(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	var/list/targets = list()

	for(var/mob/living/carbon/human/human in SSmobs.clients_by_zlevel[invoker.z])
		if(!isashwalker(human))
			continue

		LAZYADD(targets, human)

	if(!LAZYLEN(targets))
		return

	var/mob/living/carbon/human/human = pick(targets)
	human.monkeyize()

	return

/datum/ritual/ashwalker/power
	name = "Ритуал Силы"
	description = "Проведение данного ритуала значительно увеличит силу всех его участников, позволяя им таскать тяжести без замедления."
	disaster_prob = 40
	fail_chance = 40
	charges = 1
	cooldown_after_cast = 800 SECONDS
	cast_time = 30 SECONDS
	shaman_only = TRUE
	extra_invokers = 2
	needed_dye = "Indigo Dyes"
	totem_dye = "indigo"
	required_things = list(
		/mob/living/simple_animal/hostile/asteroid/goliath = 1,
		/obj/item/organ/internal/regenerative_core = 1
	)

/datum/ritual/ashwalker/power/del_things(list/used_things)
	for(var/mob/living/living in used_things)
		living.gib()

	return

/datum/ritual/ashwalker/power/check_contents(mob/living/carbon/human/invoker, list/used_things)
	. = ..()

	if(!.)
		return FALSE

	for(var/mob/living/living in used_things)
		if(living.stat != DEAD)
			to_chat(invoker, "Существа должны быть мертвы.")
			return FALSE

	return TRUE

/datum/ritual/ashwalker/power/do_ritual(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	LAZYADD(invokers, invoker)

	for(var/mob/living/carbon/human/human in invokers)
		if(LAZYIN(human.dna?.default_blocks, GLOB.weakblock))
			human.force_gene_block(GLOB.weakblock)

		human.force_gene_block(GLOB.strongblock, TRUE)

	return RITUAL_SUCCESSFUL

/datum/ritual/ashwalker/power/disaster(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	var/list/targets = list()

	for(var/mob/living/carbon/human/human in SSmobs.clients_by_zlevel[invoker.z])
		if(!isashwalker(human))
			continue

		LAZYADD(targets, human)

	if(!LAZYLEN(targets))
		return

	invoker.force_gene_block(pick(GLOB.bad_blocks), TRUE)
	for(var/mob/living/carbon/human/human in invokers)
		human.force_gene_block(pick(GLOB.bad_blocks), TRUE)

	var/mob/living/carbon/human/human = pick(targets)
	human.force_gene_block(pick(GLOB.bad_blocks), TRUE)

	return

/datum/ritual/ashwalker/power/handle_ritual_object(stage, silent =  FALSE)
	switch(stage)
		if(RITUAL_ENDED)
			playsound(ritual_object.loc, 'sound/magic/castsummon.ogg', 50, TRUE)
		if(RITUAL_STARTED)
			playsound(ritual_object.loc, 'sound/magic/smoke.ogg', 50, TRUE)
		if(RITUAL_FAILED)
			playsound(ritual_object.loc, 'sound/magic/strings.ogg', 50, TRUE)

/datum/ritual/ashwalker/resurrection
	name = "Ритуал Воскрешения"
	description = "Проведение данного ритуала позволит оживить погибшего гуманоида, находящегося на руне."
	charges = 3
	extra_invokers = 2
	cooldown_after_cast = 180 SECONDS
	cast_time = 30 SECONDS
	shaman_only = TRUE
	disaster_prob = 25
	fail_chance = 35
	needed_dye = "Mint Dyes"
	totem_dye = "mint"
	required_things = list(
		/obj/item/organ/internal/regenerative_core = 2,
		/mob/living/carbon/human = 1,
		/obj/item/reagent_containers/food/snacks/grown/ash_flora/fireblossom = 2
	)

/datum/ritual/ashwalker/resurrection/check_contents(mob/living/carbon/human/invoker, list/used_things)
	. = ..()

	if(!.)
		return FALSE

	for(var/mob/living/living in used_things)
		if(living.stat != DEAD)
			to_chat(invoker, "Существа должны быть мертвы.")
			return FALSE

	var/mob/living/carbon/human/human = locate() in used_things

	if(!human.mind || !human.ckey)
		return FALSE

	if(!isashwalker(human))
		fail_chance = 15

	return TRUE

/datum/ritual/ashwalker/resurrection/do_ritual(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	var/mob/living/carbon/human/human = locate() in used_things
	human.revive()
	human.adjustBrainLoss(20)

	return RITUAL_SUCCESSFUL

/datum/ritual/ashwalker/resurrection/disaster(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	for(var/mob/living/carbon/human/human in range(10, ritual_object))
		if(!isashwalker(human) || human.stat == DEAD)
			continue

		human.adjustBrainLoss(15)

	return

/datum/ritual/ashwalker/resurrection/handle_ritual_object(stage, silent =  FALSE)
	switch(stage)
		if(RITUAL_ENDED)
			playsound(ritual_object.loc, 'sound/magic/clockwork/reconstruct.ogg', 50, TRUE)
		if(RITUAL_STARTED)
			playsound(ritual_object.loc, 'sound/magic/disable_tech.ogg', 50, TRUE)
		if(RITUAL_FAILED)
			playsound(ritual_object.loc, 'sound/magic/invoke_general.ogg', 50, TRUE)

/datum/ritual/ashwalker/recharge
	name = "Ритуал Восстановления"
	description = "Проведение данного ритуала позволит восстановить заряды у ритуалов, имеющих ограниченное количество зарядов."
	extra_invokers = 3
	disaster_prob = 30
	fail_chance = 50
	cooldown_after_cast = 360 SECONDS
	cast_time = 30 SECONDS
	shaman_only = TRUE
	needed_dye = "Amber Dyes"
	totem_dye = "amber"
	required_things = list(
		/mob/living/simple_animal/hostile/asteroid/basilisk/watcher = 1,
		/mob/living/simple_animal/hostile/asteroid/goliath = 1,
		/obj/item/organ/internal/regenerative_core = 1,
	)
	var/list/blacklisted_rituals = list(/datum/ritual/ashwalker/power)

/datum/ritual/ashwalker/recharge/del_things(list/used_things)
	. = ..()

	for(var/mob/living/living in used_things)
		living.gib()

	return

/datum/ritual/ashwalker/recharge/check_contents(mob/living/carbon/human/invoker, list/used_things)
	. = ..()

	if(!.)
		return FALSE

	for(var/mob/living/living in used_things)
		if(living.stat != DEAD)
			to_chat(invoker, "Существа должны быть мертвы.")
			return FALSE

	return TRUE

/datum/ritual/ashwalker/recharge/do_ritual(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	var/datum/component/ritual_object/component = ritual_object.GetComponent(/datum/component/ritual_object)

	if(!component)
		return RITUAL_FAILED_ON_PROCEED

	for(var/datum/ritual/ritual as anything in component.rituals)
		if(is_type_in_list(ritual, blacklisted_rituals))
			continue

		if(ritual.charges < 0)
			continue

		ritual.charges++

	return RITUAL_SUCCESSFUL

/datum/ritual/ashwalker/recharge/disaster(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	var/list/targets = list()

	for(var/mob/living/carbon/human/human in SSmobs.clients_by_zlevel[invoker.z])
		if(!isashwalker(human))
			continue

		LAZYADD(targets, human)

	if(!LAZYLEN(targets))
		return

	var/mob/living/carbon/human/human = pick(targets)
	new /obj/item/organ/internal/legion_tumour(human)

	return

/datum/ritual/ashwalker/recharge/handle_ritual_object(stage, silent =  FALSE)
	switch(stage)
		if(RITUAL_ENDED)
			playsound(ritual_object.loc, 'sound/magic/castsummon.ogg', 50, TRUE)
		if(RITUAL_STARTED)
			playsound(ritual_object.loc, 'sound/magic/cult_spell.ogg', 50, TRUE)
		if(RITUAL_FAILED)
			playsound(ritual_object.loc, 'sound/magic/invoke_general.ogg', 50, TRUE)

/datum/ritual/ashwalker/population
	name = "Ритуал Населения"
	description = "Проведение данного ритуала позволит племени пеплоходцев получить второго шамана."
	extra_invokers = 2
	charges = 1
	cooldown_after_cast = 120 SECONDS
	cast_time = 30 SECONDS
	ritual_should_del_things_on_fail = TRUE
	needed_dye = "Cinnabar Dyes"
	totem_dye = "cinnabar"
	required_things = list(
		/obj/item/reagent_containers/food/snacks/grown/ash_flora/cactus_fruit = 1,
		/obj/item/reagent_containers/food/snacks/grown/ash_flora/fireblossom = 1,
		/obj/item/reagent_containers/food/snacks/grown/ash_flora/mushroom_leaf = 1,
	)

/datum/ritual/ashwalker/population/check_invokers(mob/living/carbon/human/invoker, list/invokers)
	. = ..()

	if(!.)
		return FALSE

	if(!isashwalkershaman(invoker))
		disaster_prob = 40
		fail_chance = 40

	return TRUE

/datum/ritual/ashwalker/population/del_things(list/used_things)
	for(var/mob/living/living in used_things)
		living.gib()

	return

/datum/ritual/ashwalker/population/check_contents(mob/living/carbon/human/invoker, list/used_things)
	. = ..()

	if(!.)
		return FALSE

	for(var/mob/living/living in used_things)
		if(living.stat != DEAD)
			to_chat(invoker, "Существа должны быть мертвы.")
			return FALSE

	return TRUE

/datum/ritual/ashwalker/population/do_ritual(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	new /obj/effect/mob_spawn/human/ash_walker/shaman(ritual_object.loc)

	return RITUAL_SUCCESSFUL

/datum/ritual/ashwalker/population/disaster(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	for(var/mob/living/carbon/human/human in SSmobs.clients_by_zlevel[invoker.z])
		if(!isashwalker(human) || !prob(disaster_prob))
			continue

		if(!isturf(human.loc))
			continue

		var/datum/effect_system/smoke_spread/smoke = new
		smoke.set_up(5, FALSE, get_turf(human.loc))
		smoke.start()

		for(var/obj/item/obj as anything in human.get_equipped_items(TRUE, TRUE))
			human.drop_item_ground(obj)

	return

/datum/ritual/ashwalker/population/handle_ritual_object(stage, silent =  FALSE)
	switch(stage)
		if(RITUAL_ENDED)
			playsound(ritual_object.loc, 'sound/magic/demon_consume.ogg', 50, TRUE)
			var/datum/effect_system/smoke_spread/smoke = new
			smoke.set_up(5, FALSE, get_turf(ritual_object.loc))
			smoke.start()
		if(RITUAL_STARTED)
			playsound(ritual_object.loc, 'sound/magic/cult_spell.ogg', 50, TRUE)
		if(RITUAL_FAILED)
			playsound(ritual_object.loc, 'sound/magic/teleport_diss.ogg', 50, TRUE)

/datum/ritual/ashwalker/soul
	name = "Ритуал Души"
	description = "Проведение данного ритуала позволяет призывающему возвыситься до драконида."
	extra_invokers = 3
	cooldown_after_cast = 1200 SECONDS
	cast_time = 30 SECONDS
	needed_dye = "Crimson Dyes"
	totem_dye = "crimson"
	required_things = list(
		/mob/living/carbon/human = 3,
		/obj/item/stack/sheet/animalhide/ashdrake = 1
	)

/datum/ritual/ashwalker/soul/check_invokers(mob/living/carbon/human/invoker, list/invokers)
	. = ..()

	if(!.)
		return FALSE

	if(!isashwalkershaman(invoker))
		disaster_prob = 40
		fail_chance = 70

	return TRUE

/datum/ritual/ashwalker/population/del_things(list/used_things)
	var/obj/item/stack/sheet/animalhide/ashdrake/stack = locate() in used_things
	stack.use(1)

	for(var/mob/living/living in used_things)
		living.gib()

	return

/datum/ritual/ashwalker/soul/check_contents(mob/living/carbon/human/invoker, list/used_things)
	. = ..()

	if(!.)
		return FALSE

	for(var/mob/living/living in used_things)
		if(living.stat != DEAD)
			to_chat(invoker, "Существа должны быть мертвы.")
			return FALSE

	return TRUE

/datum/ritual/ashwalker/soul/do_ritual(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(5, FALSE, get_turf(invoker.loc))
	smoke.start()
	invoker.set_species(/datum/species/unathi/draconid)

	return RITUAL_SUCCESSFUL

/datum/ritual/ashwalker/soul/disaster(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	for(var/mob/living/carbon/human/human in SSmobs.clients_by_zlevel[invoker.z])
		if(!isashwalker(human) || !prob(disaster_prob))
			continue

		if(!isturf(human.loc))
			continue

		human.SetKnockdown(10 SECONDS)
		var/turf/turf = human.loc
		new /obj/effect/hotspot(turf)
		turf.hotspot_expose(700, 50, 1)

	return

/datum/ritual/ashwalker/soul/handle_ritual_object(stage, silent =  FALSE)
	switch(stage)
		if(RITUAL_ENDED)
			playsound(ritual_object.loc, 'sound/effects/whoosh.ogg', 50, TRUE)
		if(RITUAL_STARTED)
			playsound(ritual_object.loc, 'sound/effects/bamf.ogg', 50, TRUE)
		if(RITUAL_FAILED)
			playsound(ritual_object.loc, 'sound/effects/blobattack.ogg', 50, TRUE)

/datum/ritual/ashwalker/transmutation
	name = "Ритуал Трансмутации"
	description = "Проведение данного ритуала позволяет трансмутировать 10 единиц любой руды в другую случайную руду."
	cooldown_after_cast = 20 SECONDS
	cast_time = 10 SECONDS
	required_things = list(
		/obj/item/stack/ore = 10
	)

/datum/ritual/ashwalker/transmutation/check_invokers(mob/living/carbon/human/invoker, list/invokers)
	. = ..()

	if(!.)
		return FALSE

	if(!isashwalkershaman(invoker))
		disaster_prob = 30
		fail_chance = 50

	return TRUE

/datum/ritual/ashwalker/transmutation/do_ritual(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	var/ore_type = pick(subtypesof(/obj/item/stack/ore))

	var/obj/item/stack/ore/ore = new ore_type(get_turf(ritual_object))
	ore.add(10)

	return RITUAL_SUCCESSFUL

/datum/ritual/ashwalker/transmutation/disaster(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	for(var/mob/living/carbon/human/human in SSmobs.clients_by_zlevel[invoker.z])
		if(!isashwalker(human) || !prob(disaster_prob))
			continue

		if(!isturf(human.loc))
			continue

		human.SetKnockdown(10 SECONDS)
		var/turf/turf = human.loc
		new /obj/effect/hotspot(turf)
		turf.hotspot_expose(700, 50, 1)

	return

/datum/ritual/ashwalker/transmutation/handle_ritual_object(stage, silent =  FALSE)
	switch(stage)
		if(RITUAL_ENDED)
			playsound(ritual_object.loc, 'sound/effects/bin_close.ogg', 50, TRUE)
		if(RITUAL_STARTED)
			playsound(ritual_object.loc, 'sound/magic/cult_spell.ogg', 50, TRUE)
		if(RITUAL_FAILED)
			playsound(ritual_object.loc, 'sound/magic/knock.ogg', 50, TRUE)

/datum/ritual/ashwalker/interrogation
	name = "Ритуал Допроса"
	description = "Проведение данного ритуала позволяет получить информацию о чувствах и мыслях вашей жертвы."
	cooldown_after_cast = 50 SECONDS
	shaman_only = TRUE
	cast_time = 10 SECONDS
	required_things = list(
		/mob/living/carbon/human = 1
	)

/datum/ritual/ashwalker/interrogation/check_invokers(mob/living/carbon/human/invoker, list/invokers)
	. = ..()

	if(!.)
		return FALSE

	if(invoker.health > 10)
		disaster_prob = 30
		fail_chance = 30

	return TRUE

/datum/ritual/ashwalker/interrogation/check_contents(mob/living/carbon/human/invoker, list/used_things)
	. = ..()

	if(!.)
		return FALSE

	var/mob/living/carbon/human/human = locate() in used_things
	if(!human || QDELETED(human))
		return RITUAL_FAILED_ON_PROCEED

	if(human.stat == DEAD || !human.mind)
		to_chat(invoker, "Гуманоид должен быть жив и иметь разум.")
		return FALSE

	return TRUE

/datum/ritual/ashwalker/interrogation/do_ritual(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	var/obj/effect/proc_holder/spell/empath/empath = new
	if(!empath.cast(used_things, invoker))
		return RITUAL_FAILED_ON_PROCEED

	return RITUAL_SUCCESSFUL

/datum/ritual/ashwalker/interrogation/disaster(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	for(var/mob/living/carbon/human/human in SSmobs.clients_by_zlevel[invoker.z])
		if(!isashwalker(human))
			continue

		if(!isturf(human.loc))
			continue

		var/turf/turf = human.loc
		to_chat(human, "<font color='red' size='7'>HONK</font>")
		SEND_SOUND(turf, sound('sound/items/airhorn.ogg'))
		human.AdjustHallucinate(150 SECONDS)
		human.EyeBlind(5 SECONDS)
		var/datum/effect_system/smoke_spread/smoke = new
		smoke.set_up(5, FALSE, turf)
		smoke.start()

	return

/datum/ritual/ashwalker/interrogation/handle_ritual_object(stage, silent =  FALSE)
	switch(stage)
		if(RITUAL_ENDED)
			playsound(ritual_object.loc, 'sound/effects/anvil_start.ogg', 50, TRUE)
		if(RITUAL_STARTED)
			playsound(ritual_object.loc, 'sound/effects/hulk_hit_airlock.ogg', 50, TRUE)
		if(RITUAL_FAILED)
			playsound(ritual_object.loc, 'sound/effects/forge_destroy.ogg', 50, TRUE)

/datum/ritual/ashwalker/creation
	name = "Ритуал Создания"
	description = "Проведение данного ритуала позволяет призвать двух случайных враждебных существ к руне."
	cooldown_after_cast = 150 SECONDS
	shaman_only = TRUE
	extra_invokers = 2
	cast_time = 30 SECONDS
	needed_dye = "Indigo Dyes"
	totem_dye = "indigo"
	required_things = list(
		/mob/living/carbon/human = 2
	)

/datum/ritual/ashwalker/creation/check_invokers(mob/living/carbon/human/invoker, list/invokers)
	. = ..()

	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/human in invokers)
		if(human.stat != UNCONSCIOUS)
			disaster_prob += 20
			fail_chance += 20

	return TRUE

/datum/ritual/ashwalker/creation/check_contents(mob/living/carbon/human/invoker, list/used_things)
	. = ..()

	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/human in used_things)
		if(human.stat != DEAD)
			to_chat(invoker, "Гуманоиды должны быть мертвы.")
			return FALSE

		if(!isashwalker(human))
			to_chat(invoker, "Гуманоиды должны быть пеплоходцами.")
			return FALSE

	return TRUE

/datum/ritual/ashwalker/creation/do_ritual(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	for(var/mob/living/mob as anything in subtypesof(/mob/living/simple_animal/hostile/asteroid))
		if(prob(30))
			mob = new(get_turf(ritual_object))

	return RITUAL_SUCCESSFUL

/datum/ritual/ashwalker/creation/disaster(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	for(var/mob/living/carbon/human/human in SSmobs.clients_by_zlevel[invoker.z])
		if(!isashwalker(human) || !prob(disaster_prob))
			continue

		if(!isturf(human.loc))
			continue

		human.SetKnockdown(10 SECONDS)
		var/turf/turf = human.loc
		new /obj/effect/hotspot(turf)
		turf.hotspot_expose(700, 50, 1)

	return

/datum/ritual/ashwalker/creation/handle_ritual_object(stage, silent =  FALSE)
	switch(stage)
		if(RITUAL_ENDED)
			playsound(ritual_object.loc, 'sound/magic/demon_consume.ogg', 50, TRUE)
		if(RITUAL_STARTED)
			playsound(ritual_object.loc, 'sound/magic/blind.ogg', 50, TRUE)
		if(RITUAL_FAILED)
			playsound(ritual_object.loc, 'sound/magic/castsummon.ogg', 50, TRUE)

/datum/ritual/ashwalker/command
	name = "Ритуал Коммандования"
	description = "Проведение данного ритуала позволяет получить в ваше подчинение местную фауну."
	cooldown_after_cast = 150 SECONDS
	shaman_only = TRUE
	disaster_prob = 35
	extra_invokers = 1
	cast_time = 30 SECONDS
	needed_dye = "Mint Dyes"
	totem_dye = "mint"
	required_things = list(
		/mob/living/simple_animal = 1,
		/obj/item/organ/internal/regenerative_core = 1,
	)

/datum/ritual/ashwalker/command/check_contents(mob/living/carbon/human/invoker, list/used_things)
	. = ..()

	if(!.)
		return FALSE

	for(var/mob/living/simple_animal/living in used_things)
		if(living.client)
			to_chat(invoker, "Существо должно быть бездушным.")
			return FALSE

		if(living.sentience_type == SENTIENCE_BOSS)
			to_chat(invoker, "Ритуал не может воздействовать на мегафауну.")
			return FALSE

		if(living.stat != DEAD)
			to_chat(invoker, "Существа должны быть мертвы.")
			return FALSE

	return TRUE

/datum/ritual/ashwalker/command/do_ritual(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	var/mob/living/simple_animal/animal = locate() in used_things

	if(QDELETED(animal))
		return RITUAL_FAILED_ON_PROCEED

	animal.faction = invoker.faction
	animal.revive()
	var/list/candidates = SSghost_spawns.poll_candidates("Вы хотите сыграть за раба пеплоходцев?", ROLE_SENTIENT, TRUE, source = animal)

	if(!LAZYLEN(candidates) || QDELETED(animal)) // no travelling into nullspace
		return RITUAL_FAILED_ON_PROCEED // no mercy guys. But you got friendly creature

	var/mob/mob = pick(candidates)
	animal.key = mob.key
	animal.universal_speak = 1
	animal.sentience_act()
	animal.can_collar = 1
	animal.maxHealth = max(animal.maxHealth, 200)
	animal.del_on_death = FALSE
	animal.master_commander = invoker

	animal.mind.store_memory("<B>Мой хозяин [invoker.name], выполню [genderize_ru(invoker.gender, "его", "её", "этого", "их")] цели любой ценой!</B>")
	to_chat(animal, chat_box_green("Вы - раб пеплоходцев. Всегда подчиняйтесь и помогайте им."))
	add_game_logs("стал питомцем игрока [key_name(invoker)]", animal)

	return RITUAL_SUCCESSFUL

/datum/ritual/ashwalker/command/disaster(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	for(var/mob/living/carbon/human/human in SSmobs.clients_by_zlevel[invoker.z])
		if(!isashwalker(human) || !prob(disaster_prob))
			continue

		if(!isturf(human.loc))
			continue

		var/datum/effect_system/smoke_spread/smoke = new
		smoke.set_up(5, FALSE, get_turf(human.loc))
		smoke.start()

	var/mob/living/simple_animal/mob = locate() in used_things
	qdel(mob)

	new /mob/living/simple_animal/hostile/asteroid/goliath/beast/ancient(get_turf(ritual_object))

	return

/datum/ritual/ashwalker/command/handle_ritual_object(stage, silent = FALSE)
	switch(stage)
		if(RITUAL_ENDED)
			playsound(ritual_object.loc, 'sound/magic/demon_consume.ogg', 50, TRUE)
		if(RITUAL_STARTED)
			playsound(ritual_object.loc, 'sound/magic/invoke_general.ogg', 50, TRUE)
		if(RITUAL_FAILED)
			playsound(ritual_object.loc, 'sound/magic/castsummon.ogg', 50, TRUE)
