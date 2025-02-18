////////////////////////////////////////////////////////////////////////////////
/// (Mixing)Glass.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/glass
	name = " "
	var/base_name = " "
	desc = " "
	icon = 'icons/obj/chemical.dmi'
	icon_state = "null"
	item_state = "null"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,50)
	volume = 50
	container_type = OPENCONTAINER
	has_lid = TRUE
	resistance_flags = ACID_PROOF
	blocks_emissive = FALSE
	var/label_text = ""

/obj/item/reagent_containers/glass/New()
	..()
	base_name = name

/obj/item/reagent_containers/glass/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 2 && !is_open_container())
		. += span_notice("Закрыто герметичной крышкой.")

	. += span_notice("Вмещает до <b>[reagents.maximum_volume]</b> единиц[declension_ru(reagents.maximum_volume, "ы", "", "")] вещества.")


/obj/item/reagent_containers/glass/attack(mob/living/carbon/target, mob/living/user, params, def_zone, skip_attack_anim = FALSE)
	if(!is_open_container())
		return ..()

	. = ATTACK_CHAIN_PROCEED

	if(!reagents || !reagents.total_volume)
		balloon_alert(user, "пусто!")
		return .

	var/list/transferred = list()
	for(var/datum/reagent/reagent as anything in reagents.reagent_list)
		transferred += reagent.name

	var/contained = english_list(transferred)

	if(user.a_intent == INTENT_HARM)
		target.visible_message(
			span_danger("[user] вылива[pluralize_ru(user.gender, "ет", "ют")] содержимое [declent_ru(GENITIVE)] на [target]!"),
			span_userdanger("[user] вылива[pluralize_ru(user.gender, "ет", "ют")] содержимое [declent_ru(GENITIVE)] на вас!")
		)
		add_attack_logs(user, target, "Splashed with [name] containing [contained]")
		reagents.reaction(target, REAGENT_TOUCH)
		reagents.clear_reagents()
		return .|ATTACK_CHAIN_SUCCESS

	if(!iscarbon(target)) // Non-carbons can't process reagents
		balloon_alert(user, "невозможно!")
		return .

	if(!get_location_accessible(target, BODY_ZONE_PRECISE_MOUTH))
		if(target == user)
			balloon_alert(user, "ваш рот закрыт!")
		else
			balloon_alert(user, "рот цели закрыт!")
		return .

	if(target != user)
		target.visible_message(
			span_danger("[user] пыта[pluralize_ru(user.gender, "ет", "ют")]ся напоить содержимым [declent_ru(GENITIVE)] [target]!"),
			span_userdanger("[user] пыта[pluralize_ru(user.gender, "ет", "ют")]ся напоить вас содержимым [declent_ru(GENITIVE)]!"),
		)
		if(!do_after(user, 3 SECONDS, target, NONE) || !reagents || !reagents.total_volume)
			return .
		target.visible_message(
			span_danger("[user] напоил[genderize_ru(user.gender, "", "а", "о", "и")] [target] содержимым [declent_ru(GENITIVE)]!"),
			span_userdanger("[user] напоил[genderize_ru(user.gender, "", "а", "о", "и")] вас содержимым [declent_ru(GENITIVE)]!"),
		)
		add_attack_logs(user, target, "Fed with [name] containing [contained]")
	else
		to_chat(user, span_notice("Вы делаете глоток из [declent_ru(GENITIVE)]."))

	. |= ATTACK_CHAIN_SUCCESS
	var/fraction = min(5 / reagents.total_volume, 1)
	reagents.reaction(target, REAGENT_INGEST, fraction)
	addtimer(CALLBACK(reagents, TYPE_PROC_REF(/datum/reagents, trans_to), target, 5), 5)
	playsound(target.loc,'sound/items/drink.ogg', rand(10,50), TRUE)


/obj/item/reagent_containers/glass/afterattack(obj/target, mob/user, proximity, params)
	if((!proximity) ||  !check_allowed_items(target,target_self = TRUE))
		return

	if(!is_open_container())
		return

	if(target.is_refillable()) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			balloon_alert(usr, "пусто!")
			return

		if(target.reagents.holder_full())
			balloon_alert(usr, "нет места!")
			return

		var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, span_notice("Вы переливаете <b>[trans]</b> единиц[declension_ru(trans, "у", "ы", "")] вещества из [declent_ru(GENITIVE)] в [target.declent_ru(ACCUSATIVE)]."))

	else if(target.is_drainable()) //A dispenser. Transfer FROM it TO us.
		if(!target.reagents.total_volume)
			balloon_alert(user, "пусто!")
			return

		if(reagents.holder_full())
			balloon_alert(user, "нет места!")
			return

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this)
		to_chat(user, "Вы наполняете [declent_ru(ACCUSATIVE)] <b>[trans]</b> единиц[declension_ru(trans, "ей", "ами", "ами")] вещества из содержимого [target.declent_ru(ACCUSATIVE)].")

	else if(reagents.total_volume)
		if(user.a_intent == INTENT_HARM)
			user.visible_message(span_danger("[user] облива[pluralize_ru(user, "ет", "ют")] [target.declent_ru(ACCUSATIVE)] содержимым [declent_ru(GENITIVE)]!"), \
								("Вы обливаете [target.declent_ru(ACCUSATIVE)] содержимым [declent_ru(GENITIVE)]!"))
			reagents.reaction(target, REAGENT_TOUCH)
			reagents.clear_reagents()


/obj/item/reagent_containers/glass/attackby(obj/item/I, mob/user, params)
	if(is_pen(I) || istype(I, /obj/item/flashlight/pen))
		var/rename = rename_interactive(user, I)
		if(!isnull(rename))
			label_text = rename
		return ATTACK_CHAIN_PROCEED_SUCCESS
	return ..()


/obj/item/reagent_containers/glass/beaker
	name = "beaker"
	desc = "Простой стеклянный стакан. На его стенках обозначены деления для измерения объёма содержимого."
	ru_names = list(
		NOMINATIVE = "мерный стакан",
		GENITIVE = "мерного стакана",
		DATIVE = "мерному стакану",
		ACCUSATIVE = "мерный стакан",
		INSTRUMENTAL = "мерным стаканом",
		PREPOSITIONAL = "мерном стакане"
 	)
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beaker"
	item_state = "beaker"
	belt_icon = "beaker"
	materials = list(MAT_GLASS=500)
	var/obj/item/assembly_holder/assembly = null
	var/can_assembly = TRUE


/obj/item/reagent_containers/glass/beaker/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)


/obj/item/reagent_containers/glass/beaker/examine(mob/user)
	. = ..()
	if(assembly)
		. += span_notice("К нему прикрепл[genderize_ru(assembly.gender, "ён", "ена", "ено", "ены")] [assembly]. Открутите [genderize_ru(assembly.gender, "его", "её", "его", "их")] чем-нибудь, чтобы отсоединить.")


/obj/item/reagent_containers/glass/beaker/on_reagent_change()
	update_icon(UPDATE_OVERLAYS)


/obj/item/reagent_containers/glass/beaker/update_overlays()
	. = ..()
	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)
				filling.icon_state = "[icon_state]-10"
			if(10 to 24)
				filling.icon_state = "[icon_state]10"
			if(25 to 49)
				filling.icon_state = "[icon_state]25"
			if(50 to 74)
				filling.icon_state = "[icon_state]50"
			if(75 to 79)
				filling.icon_state = "[icon_state]75"
			if(80 to 90)
				filling.icon_state = "[icon_state]80"
			if(91 to INFINITY)
				filling.icon_state = "[icon_state]100"

		filling.icon += mix_color_from_reagents(reagents.reagent_list)
		. += filling

	if(!is_open_container())
		. += "lid_[initial(icon_state)]"
		if(blocks_emissive == FALSE)
			. += emissive_blocker(icon, "lid_[initial(icon_state)]", src)

	if(assembly)
		. += "assembly"


/obj/item/reagent_containers/glass/beaker/verb/remove_assembly()
	set name = "Отсоединить"
	set category = "Object"
	set src in usr
	if(usr.incapacitated() || HAS_TRAIT(usr, TRAIT_HANDS_BLOCKED))
		return
	if(assembly)
		balloon_alert(usr, "заготовка отсоединена")
		assembly.forceMove_turf()
		usr.put_in_hands(assembly, ignore_anim = FALSE)
		assembly = null
		qdel(GetComponent(/datum/component/proximity_monitor))
		update_icon(UPDATE_OVERLAYS)
	else
		balloon_alert(usr, "нечего отсоединять!")


/obj/item/reagent_containers/glass/beaker/proc/heat_beaker()
	if(reagents)
		reagents.temperature_reagents(4000)


/obj/item/reagent_containers/glass/beaker/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/assembly_holder))
		add_fingerprint(user)
		if(!can_assembly)
			balloon_alert(user, "несовместимо!")
			return ATTACK_CHAIN_PROCEED
		if(assembly)
			balloon_alert(user, "заготовка уже прикреплена!")
			return ATTACK_CHAIN_PROCEED
		if(!user.drop_transfer_item_to_loc(I, src))
			return ..()
		balloon_alert(user, "заготовка прикреплена")
		if(assembly.has_prox_sensors())
			AddComponent(/datum/component/proximity_monitor)
		assembly = I
		update_icon(UPDATE_OVERLAYS)
		return ATTACK_CHAIN_BLOCKED_ALL

	return ..()


/obj/item/reagent_containers/glass/beaker/HasProximity(atom/movable/AM)
	if(assembly)
		assembly.HasProximity(AM)


/obj/item/reagent_containers/glass/beaker/proc/on_entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER

	if(assembly)
		assembly.assembly_crossed(arrived, old_loc)


/obj/item/reagent_containers/glass/beaker/on_found(mob/finder) //for mousetraps
	if(assembly)
		assembly.on_found(finder)

/obj/item/reagent_containers/glass/beaker/hear_talk(mob/living/M, list/message_pieces)
	if(assembly)
		assembly.hear_talk(M, message_pieces)

/obj/item/reagent_containers/glass/beaker/hear_message(mob/living/M, msg)
	if(assembly)
		assembly.hear_message(M, msg)

/obj/item/reagent_containers/glass/beaker/large
	name = "large beaker"
	desc = "Как обычный мерный стакан, только в два раза больше объёмом."
	ru_names = list(
		NOMINATIVE = "большой мерный стакан",
		GENITIVE = "большого мерного стакана",
		DATIVE = "большому мерному стакану",
		ACCUSATIVE = "большой мерный стакан",
		INSTRUMENTAL = "большим мерным стаканом",
		PREPOSITIONAL = "большом мерном стакане"
 	)
	icon_state = "beakerlarge"
	belt_icon = "large_beaker"
	materials = list(MAT_GLASS=2500)
	volume = 100
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,50,100)
	container_type = OPENCONTAINER

/obj/item/reagent_containers/glass/beaker/vial
	name = "vial"
	desc = "Небольшая стеклянная колбочка, часто используемая вирусологами в работе."
	ru_names = list(
		NOMINATIVE = "пробирка",
		GENITIVE = "пробирки",
		DATIVE = "пробирке",
		ACCUSATIVE = "пробирку",
		INSTRUMENTAL = "пробиркой",
		PREPOSITIONAL = "пробирке"
 	)
	icon_state = "vial"
	belt_icon = "vial"
	materials = list(MAT_GLASS=250)
	volume = 25
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25)
	container_type = OPENCONTAINER
	can_assembly = 0

/obj/item/reagent_containers/glass/beaker/drugs
	name = "baggie"
	desc = "Небольшой пластиковый пакет, часто используемый фармацевтическими \"предпринимателями\"."
	ru_names = list(
		NOMINATIVE = "пластиковый пакетик",
		GENITIVE = "пластикового пакетика",
		DATIVE = "пластиковому пакетику",
		ACCUSATIVE = "пластиковый пакетик",
		INSTRUMENTAL = "пластиковым пакетиком",
		PREPOSITIONAL = "пластиковом пакетике"
 	)
	icon_state = "baggie"
	amount_per_transfer_from_this = 2
	possible_transfer_amounts = null
	volume = 10
	container_type = OPENCONTAINER
	can_assembly = 0

/obj/item/reagent_containers/glass/beaker/thermite
	name = "Thermite load"
	desc = "Пластиковый пакетик, надпись на этикетке - \"Термит\"."
	ru_names = list(
		NOMINATIVE = "пластиковый пакетик (Термит)",
		GENITIVE = "пластикового пакетика (Термит)",
		DATIVE = "пластиковому пакетику (Термит)",
		ACCUSATIVE = "пластиковый пакетик (Термит)",
		INSTRUMENTAL = "пластиковым пакетиком (Термит)",
		PREPOSITIONAL = "пластиковом пакетике (Термит)"
 	)
	icon_state = "baggie"
	amount_per_transfer_from_this = 25
	possible_transfer_amounts = null
	volume = 25
	container_type = OPENCONTAINER
	can_assembly = 0
	list_reagents = list("thermite" = 25)

/obj/item/reagent_containers/glass/beaker/noreact
	name = "cryostasis beaker"
	desc = "Криостазисная мензурка, позволяющий хранить химические вещества в таком состоянии, при котором они не вступают в реакцию друг с другом."
	ru_names = list(
		NOMINATIVE = "криостазиный мерный стакан",
		GENITIVE = "криостазиного мерного стакана",
		DATIVE = "криостазиному мерному стакану",
		ACCUSATIVE = "криостазиный мерный стакан",
		INSTRUMENTAL = "криостазиным мерным стаканом",
		PREPOSITIONAL = "криостазином мерном стакане"
 	)
	icon_state = "beakernoreact"
	materials = list(MAT_METAL=3000)
	volume = 50
	amount_per_transfer_from_this = 10
	origin_tech = "materials=2;engineering=3;plasmatech=3"
	container_type = OPENCONTAINER
	blocks_emissive = EMISSIVE_BLOCK_GENERIC

/obj/item/reagent_containers/glass/beaker/noreact/New()
	..()
	reagents.set_reacting(FALSE)

/obj/item/reagent_containers/glass/beaker/bluespace
	name = "bluespace beaker"
	desc = "Мензурка, работающая на экспериментальной блюспейс технологии и элементе \"Кубаний\" в сочетании с соединением \"Питий\"."
	ru_names = list(
		NOMINATIVE = "блюспейс мерный стакан",
		GENITIVE = "блюспейс мерного стакана",
		DATIVE = "блюспейс мерному стакану",
		ACCUSATIVE = "блюспейс мерный стакан",
		INSTRUMENTAL = "блюспейс мерным стаканом",
		PREPOSITIONAL = "блюспейс мерном стакане"
 	)
	icon_state = "beakerbluespace"
	materials = list(MAT_GLASS=3000)
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,50,100,300)
	container_type = OPENCONTAINER
	blocks_emissive = EMISSIVE_BLOCK_GENERIC
	origin_tech = "bluespace=5;materials=4;plasmatech=4"

/obj/item/reagent_containers/glass/beaker/cryoxadone
	list_reagents = list("cryoxadone" = 30)

/obj/item/reagent_containers/glass/beaker/sacid
	list_reagents = list("sacid" = 50)

/obj/item/reagent_containers/glass/beaker/slimejelly
	list_reagents = list("slimejelly" = 50)

/obj/item/reagent_containers/glass/beaker/drugs/meth
	list_reagents = list("methamphetamine" = 10)

/obj/item/reagent_containers/glass/beaker/laughter
	list_reagents = list("laughter" = 50)

/obj/item/reagent_containers/glass/bucket
	name = "bucket"
	desc = "Металлическое ведро. Можете налить туда что-то или надеть себе на голову, никто не запрещает."
	ru_names = list(
		NOMINATIVE = "металлическое ведро",
		GENITIVE = "металлического ведра",
		DATIVE = "металлическому ведру",
		ACCUSATIVE = "металлическое ведро",
		INSTRUMENTAL = "металлическим ведром",
		PREPOSITIONAL = "металлическом ведре"
 	)
	gender = NEUTER
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	materials = list(MAT_METAL=200)
	w_class = WEIGHT_CLASS_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(5,10,15,20,25,30,50,80,100,120)
	volume = 120
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 75, "acid" = 50) //Weak melee protection, because you can wear it on your head
	slot_flags = ITEM_SLOT_HEAD
	resistance_flags = NONE
	blocks_emissive = EMISSIVE_BLOCK_GENERIC
	container_type = OPENCONTAINER
	var/paintable = TRUE


/obj/item/reagent_containers/glass/bucket/Initialize(mapload)
	. = ..()
	if(!color && paintable)
		color = "#0085E5"
	update_icon(UPDATE_OVERLAYS) //in case bucket's color has been changed in editor or by some deriving buckets


/obj/item/reagent_containers/glass/bucket/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/toy/crayon/spraycan))
		add_fingerprint(user)
		var/obj/item/toy/crayon/spraycan/can = I
		if(!paintable)
			balloon_alert(user, "нельзя покрасить!")
			return ATTACK_CHAIN_PROCEED|ATTACK_CHAIN_NO_AFTERATTACK
		if(can.capped)
			balloon_alert(user, "закрыто крышкой!")
			return ATTACK_CHAIN_PROCEED|ATTACK_CHAIN_NO_AFTERATTACK
		balloon_alert(user, "перекрашено!")
		playsound(user.loc, 'sound/effects/spray.ogg', 20, TRUE)
		color = can.colour
		update_icon(UPDATE_OVERLAYS)
		return ATTACK_CHAIN_PROCEED_SUCCESS|ATTACK_CHAIN_NO_AFTERATTACK

	if(istype(I, /obj/item/mop))
		add_fingerprint(user)
		var/obj/item/mop/mop = I
		mop.wet_mop(src, user)
		return ATTACK_CHAIN_PROCEED_SUCCESS

	if(isprox(I))
		if(!user.drop_transfer_item_to_loc(I, src))
			return ..()
		add_fingerprint(user)
		balloon_alert(user, "прикреплено")
		to_chat(user, span_notice("Вы прикрепили [I.declent_ru(ACCUSATIVE)] к [declent_ru(DATIVE)]."))
		var/obj/item/bucket_sensor/bucket_sensor = new(drop_location())
		transfer_fingerprints_to(bucket_sensor)
		I.transfer_fingerprints_to(bucket_sensor)
		bucket_sensor.add_fingerprint(user)
		if(loc == user)
			user.temporarily_remove_item_from_inventory(src, force = TRUE)
			user.put_in_hands(bucket_sensor)
		qdel(I)
		qdel(src)
		return ATTACK_CHAIN_BLOCKED_ALL

	return ..()


/obj/item/reagent_containers/glass/bucket/update_overlays()
	. = ..()
	if(color)
		var/mutable_appearance/bucket_mask = mutable_appearance(icon='icons/obj/janitor.dmi', icon_state = "bucket_mask")
		. += bucket_mask

		var/mutable_appearance/bucket_hand = mutable_appearance(icon='icons/obj/janitor.dmi', icon_state = "bucket_hand", appearance_flags = RESET_COLOR)
		. += bucket_hand


/obj/item/reagent_containers/glass/bucket/equipped(mob/user, slot, initial)
	. = ..()

	if(slot == ITEM_SLOT_HEAD && reagents.total_volume)
		to_chat(user, span_userdanger("Вы надеваете [declent_ru(ACCUSATIVE)] себе на голову и его содержимое выливается прямо на вас!"))
		reagents.reaction(user, REAGENT_TOUCH)
		reagents.clear_reagents()



/obj/item/reagent_containers/glass/bucket/wooden
	name = "wooden bucket"
	desc = "Деревянное ведро. Можете налить туда что-то или надеть себе на голову, никто не запрещает."
	ru_names = list(
		NOMINATIVE = "деревянное ведро",
		GENITIVE = "деревянного ведра",
		DATIVE = "деревянному ведру",
		ACCUSATIVE = "деревянное ведро",
		INSTRUMENTAL = "деревянным ведром",
		PREPOSITIONAL = "деревянном ведре"
 	)
	icon_state = "woodbucket"
	item_state = "woodbucket"
	materials = null
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 50)
	resistance_flags = FLAMMABLE
	paintable = FALSE


/obj/item/reagent_containers/glass/bucket/wooden/update_overlays()
	. = list()


/obj/item/reagent_containers/glass/beaker/waterbottle
	name = "bottle of water"
	desc = "Бутылка воды, наполненная на старом земном заводе по разливу воды."
	ru_names = list(
		NOMINATIVE = "бутылка воды",
		GENITIVE = "бутылки воды",
		DATIVE = "бутылке воды",
		ACCUSATIVE = "бутылку воды",
		INSTRUMENTAL = "бутылкой воды",
		PREPOSITIONAL = "бутылке воды"
 	)
	gender = FEMALE
	icon = 'icons/obj/drinks.dmi'
	icon_state = "smallbottle"
	item_state = "bottle"
	list_reagents = list("water" = 49.5, "fluorine" = 0.5) //see desc, don't think about it too hard
	materials = list(MAT_GLASS = 0)
	volume = 50
	amount_per_transfer_from_this = 10

/obj/item/reagent_containers/glass/beaker/waterbottle/empty
	list_reagents = list()

/obj/item/reagent_containers/glass/beaker/waterbottle/large
	desc = "Свежая бутылка воды коммерческого размера."
	ru_names = list(
		NOMINATIVE = "большая бутылка воды",
		GENITIVE = "большой бутылки воды",
		DATIVE = "большой бутылке воды",
		ACCUSATIVE = "большую бутылку воды",
		INSTRUMENTAL = "большой бутылкой воды",
		PREPOSITIONAL = "большой бутылке воды"
 	)
	icon_state = "largebottle"
	materials = list(MAT_GLASS = 0)
	list_reagents = list("water" = 100)
	volume = 100
	amount_per_transfer_from_this = 20

/obj/item/reagent_containers/glass/beaker/waterbottle/large/empty
	list_reagents = list()

/obj/item/reagent_containers/glass/pet_bowl
	name = "pet bowl"
	desc = "Миска под еду для любимых домашних животных!"
	ru_names = list(
		NOMINATIVE = "миска для животных",
		GENITIVE = "миски для животных",
		DATIVE = "миске для животных",
		ACCUSATIVE = "миску для животных",
		INSTRUMENTAL = "миской для животных",
		PREPOSITIONAL = "миске для животных"
 	)
	gender = FEMALE
	icon = 'icons/obj/pet_bowl.dmi'
	icon_state = "petbowl"
	item_state = "petbowl"
	materials = list(MAT_METAL = 100, MAT_GLASS = 100)
	w_class = WEIGHT_CLASS_NORMAL
	amount_per_transfer_from_this = 15
	possible_transfer_amounts = null
	volume = 15
	resistance_flags = FLAMMABLE
	blocks_emissive = EMISSIVE_BLOCK_GENERIC
	color = "#0085E5"


/obj/item/reagent_containers/glass/pet_bowl/Initialize(mapload)
	. = ..()
	update_icon(UPDATE_OVERLAYS)


/obj/item/reagent_containers/glass/pet_bowl/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/toy/crayon/spraycan))
		add_fingerprint(user)
		var/obj/item/toy/crayon/spraycan/can = I
		if(can.capped)
			balloon_alert(user, "закрыто крышкой!")
			return ATTACK_CHAIN_PROCEED|ATTACK_CHAIN_NO_AFTERATTACK
		balloon_alert(user, "перекрашено")
		playsound(user.loc, 'sound/effects/spray.ogg', 20, TRUE)
		color = can.colour
		update_icon(UPDATE_OVERLAYS)
		return ATTACK_CHAIN_PROCEED_SUCCESS|ATTACK_CHAIN_NO_AFTERATTACK

	return ..()


/obj/item/reagent_containers/glass/pet_bowl/on_reagent_change()
	update_icon(UPDATE_OVERLAYS)


/obj/item/reagent_containers/glass/pet_bowl/update_overlays()
	. = ..()
	var/mutable_appearance/bowl_mask = mutable_appearance(icon = 'icons/obj/pet_bowl.dmi', icon_state = "colorable_overlay")
	. += bowl_mask
	var/mutable_appearance/bowl_nc_mask = mutable_appearance(icon = 'icons/obj/pet_bowl.dmi', icon_state = "nc_petbowl", appearance_flags = RESET_COLOR)
	. += bowl_nc_mask
	if(reagents.total_volume)
		var/datum/reagent/feed = reagents.has_reagent("afeed")
		if(feed && (feed.volume >= (reagents.total_volume - feed.volume)))
			var/image/feed_overlay = image(icon = 'icons/obj/pet_bowl.dmi', icon_state = "petfood_5", layer = FLOAT_LAYER)
			feed_overlay.appearance_flags = RESET_COLOR
			switch(feed.volume)
				if(6 to 10)
					feed_overlay.icon_state = "petfood_10"
				if(11 to 15)
					feed_overlay.icon_state = "petfood_15"
			. += feed_overlay
		else
			. += mutable_appearance(icon, "liquid_overlay", color = mix_color_from_reagents(reagents.reagent_list), appearance_flags = RESET_COLOR)


/obj/item/reagent_containers/glass/pet_bowl/attack_animal(mob/living/simple_animal/pet)
	if(!pet.client || !pet.safe_respawn(pet, check_station_level = FALSE) || !reagents.total_volume)
		return ..()
	if(reagents.has_reagent("afeed", 1))
		pet.heal_organ_damage(5, 5)
		reagents.remove_reagent("afeed", 1)
		playsound(pet.loc, 'sound/items/eatfood.ogg', rand(10, 30), TRUE)
	else
		reagents.remove_any(1)
		playsound(pet.loc, 'sound/items/drink.ogg', rand(10, 30), TRUE)
