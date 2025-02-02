//special torch lamps

#define TORCH_OK 0
#define TORCH_EMPTY 1
#define TORCH_OFF 2
#define TORCH_BURNED 3

/obj/item/mounted/frame/torch_holder
	name = "torch holder"
	ru_names = list(
		NOMINATIVE = "крепление для факела",
		GENITIVE = "крепления для факела",
		DATIVE = "креплению для факела",
		ACCUSATIVE = "крепление для факела",
		INSTRUMENTAL = "креплением для факела",
		PREPOSITIONAL = "креплении для факела",
	)
	desc = "Один из самых популярных способов осветить пространство в средневековых замках."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "torch_holder_item"
	mount_reqs = list("simfloor", "nospace")

/obj/item/mounted/frame/torch_holder/do_build(turf/on_wall, mob/user)
	to_chat(user, span_notice("Вы начали устанавливать [declent_ru(ACCUSATIVE)] на [on_wall.declent_ru(ACCUSATIVE)]."))
	playsound(get_turf(src), 'sound/machines/click.ogg', 75, 1)

	var/constrdir = user.dir
	var/constrloc = get_turf(user)
	if(!do_after(user, 4 SECONDS, on_wall, max_interact_count = 1, cancel_on_max = TRUE, cancel_message = span_notice("Вы прекратили устанавливать [declent_ru(ACCUSATIVE)].")))
		return

	var/obj/machinery/torch_holder/built/torch = new(constrloc)
	torch.dir = constrdir
	torch.fingerprints = src.fingerprints
	torch.fingerprintshidden = src.fingerprintshidden
	torch.fingerprintslast = src.fingerprintslast
	user.visible_message(span_notice("[user] устанавливает [declent_ru(ACCUSATIVE)] на [on_wall.declent_ru(ACCUSATIVE)]"), \
		span_notice("вы установили [declent_ru(ACCUSATIVE)] на [on_wall.declent_ru(ACCUSATIVE)]."))
	qdel(src)

/obj/machinery/torch_holder
	name = "torch holder"
	ru_names = list(
		NOMINATIVE = "крепление для факела",
		GENITIVE = "крепления для факела",
		DATIVE = "креплению для факела",
		ACCUSATIVE = "крепление для факела",
		INSTRUMENTAL = "креплением для факела",
		PREPOSITIONAL = "креплении для факела",
	)
	desc = "Красиво выглядящее крепление для факела."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "torch_holder"
	/// Our torch, that stored in holder
	var/obj/item/flashlight/flare/torch/fakel
	/// For mapping. Ancient torches can't be taken away and they are infinite
	var/ancient = FALSE
	/// Light range when on. Standart torch is brighter, this is for mapping reason.
	var/brightness_range = 5
	/// Light colour when on
	var/brightness_color = "#dc8a38"
	/// Light power when on
	var/brightness_power = 1
	/// Torch holder status (TORCH_OK | TORCH_EMPTY | TORCH_OFF | TORCH_BURNED)
	var/status = TORCH_OK
	///Fuel consumption
	var/fuel = 0
	///New torch related stuff
	var/fuel_lower = 0
	var/fuel_upp = 0

/obj/machinery/torch_holder/Initialize(mapload) //mapping version, preloaded with torch
	. = ..()
	fakel = new(src)
	fuel = fakel.fuel
	update_icon(UPDATE_OVERLAYS)
	update_light_state()
	START_PROCESSING(SSobj, src)

/obj/machinery/torch_holder/Destroy()
	. = ..()
	QDEL_NULL(fakel)
	STOP_PROCESSING(SSobj, src)

/obj/machinery/torch_holder/examine(mob/user)
	. = ..()
	if(in_range(user, src))
		switch(status)
			if(TORCH_OK)
				. += span_notice("[fakel.declent_ru(NOMINATIVE)] ярко горит.")
			if(TORCH_EMPTY)
				. += span_notice("внутри нет факела.")
			if(TORCH_OFF)
				. += span_notice("[fakel.declent_ru(NOMINATIVE)] не подожжен.")
			if(TORCH_BURNED)
				. += span_notice("[fakel.declent_ru(NOMINATIVE)] выгорел.")

/obj/machinery/torch_holder/process()
	if(ancient)
		return
	if(status != TORCH_OK)
		return
	fuel = max(fuel - 1, 0)
	if(!fuel)
		burnout()
		STOP_PROCESSING(SSobj, src)

/obj/machinery/torch_holder/proc/update_light_state() //I can't make it better..
	switch(status)
		if(TORCH_OFF, TORCH_BURNED, TORCH_EMPTY)
			set_light(0)
			return
		else
			light_range = brightness_range
			light_power = brightness_power
			light_color = brightness_color
			update_light()

/obj/machinery/torch_holder/proc/burnout()
	if(ancient)
		return
	if(!fuel) //double check
		status = TORCH_BURNED
		update_light_state()
		update_icon(UPDATE_OVERLAYS)
	else
		return

/obj/machinery/torch_holder/update_overlays()
	. = ..()
	if(ancient)
		return
	overlays.Cut()
	switch(status)		// set overlays
		if(TORCH_OK)
			overlays += "torch_overlay"
		if(TORCH_OFF, TORCH_BURNED)
			overlays += "torch_overlay_not_light"
		if(TORCH_EMPTY)
			overlays += ""

/obj/machinery/torch_holder/attackby(obj/item/item, mob/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(ancient)
		return ..()

	if(istype(item, /obj/item/flashlight/flare/torch))
		var/obj/item/flashlight/flare/torch/torch = item

		if(status != TORCH_EMPTY)
			if(status == TORCH_OFF && torch.on)
				balloon_alert(user, "факел подожжён!")
				status = TORCH_OK
				update_icon(UPDATE_OVERLAYS)

				brightness_range = torch.light_range
				brightness_power = torch.light_power
				brightness_color = torch.light_color

				update_light_state()
				START_PROCESSING(SSobj, src)
				return ATTACK_CHAIN_BLOCKED_ALL
			else
				balloon_alert(user, "уже есть!")
				return ATTACK_CHAIN_PROCEED
		else
			add_fingerprint(user)

			if(!torch.fuel)
				balloon_alert(user, "ваш факел выгорел!")
				return ATTACK_CHAIN_PROCEED
			balloon_alert(user, "факел установлен")
			if(!torch.on)
				status = TORCH_OFF
			else
				status = TORCH_OK
				START_PROCESSING(SSobj, src)

		set_light_range_power_color(torch.light_range, torch.light_power, torch.light_color)

		fuel = torch.fuel
		fuel_lower = torch.fuel_lower
		fuel_upp = torch.fuel_upp
		update_icon(UPDATE_OVERLAYS)
		update_light_state()

		user.drop_transfer_item_to_loc(torch, src)	//drop the item to update overlays and such
		qdel(torch)
		return ATTACK_CHAIN_BLOCKED_ALL

/obj/machinery/torch_holder/attack_hand(mob/user)
	if(ancient)
		balloon_alert(user, "невозможно вынуть!")
		return FALSE

	user.changeNext_move(CLICK_CD_MELEE)
	add_fingerprint(user)

	if(status == TORCH_EMPTY)
		balloon_alert(user, "внутри пусто!")
		return FALSE

	// make it burn hands if not wearing fire-insulated gloves
	if(status == TORCH_OK)
		var/prot = 0
		var/mob/living/carbon/human/H = user
		if(istype(H))
			if(H.gloves)
				var/obj/item/clothing/gloves/G = H.gloves
				if(G.max_heat_protection_temperature)
					prot = (G.max_heat_protection_temperature > 360)
		else
			prot = 1

		if(prot > 0 || HAS_TRAIT(user, TRAIT_RESIST_HEAT))
			to_chat(user, span_notice("Вы вытаскиваете [fakel.declent_ru(ACCUSATIVE)]."))
		else if(HAS_TRAIT(user, TRAIT_TELEKINESIS))
			to_chat(user, span_notice("Вы вытаскиваете [fakel.declent_ru(ACCUSATIVE)] с помощью телекинеза."))
		else
			if(user.a_intent == INTENT_DISARM || user.a_intent == INTENT_GRAB)
				to_chat(user, span_warning("Вы пытаетесь вытащить [fakel.declent_ru(ACCUSATIVE)], но обжигаетесь в процессе!"))
				H.apply_damage(5, BURN, def_zone = H.hand ? BODY_ZONE_PRECISE_L_HAND : BODY_ZONE_PRECISE_R_HAND)
				return FALSE
			else
				to_chat(user, span_warning("Вы пытаетесь вытащить [fakel.declent_ru(ACCUSATIVE)], но он слишком горячий!"))
				return FALSE
	else
		balloon_alert(user, "факел вынут")

	drop_fakel(user)

/obj/machinery/torch_holder/proc/drop_fakel(mob/user)
	var/obj/item/flashlight/flare/torch/torch = new(src)
	if(status == TORCH_OK)
		torch.attack_self(user)//forcing it to light up and start processing
	torch.fuel = fuel

	torch.set_light_range_power_color(brightness_range, brightness_power, brightness_color)

	torch.update_brightness()

	torch.forceMove(loc)
	if(user) //puts it in our active hand
		torch.add_fingerprint(user)
		user.put_in_active_hand(torch, ignore_anim = FALSE)

	status = TORCH_EMPTY
	update_icon(UPDATE_OVERLAYS)
	update_light_state()
	return torch

/obj/machinery/torch_holder/mapping
	name = "ancient torch holder"
	ru_names = list(
		NOMINATIVE = "древнее крепление для факела",
		GENITIVE = "древнего крепления для факела",
		DATIVE = "древнему креплению для факела",
		ACCUSATIVE = "древнее крепление для факела",
		INSTRUMENTAL = "древним креплением для факела",
		PREPOSITIONAL = "древнем креплении для факела",
	)
	desc = "Красиво выглядящее крепление для факела. Поверхность прожравела от времени, а сам факел практически прирос к креплению."
	icon_state = "torch_holder_complete"
	ancient = TRUE

/obj/machinery/torch_holder/mapping/Initialize(mapload)
	. = ..()
	fuel = INFINITY

/obj/machinery/torch_holder/built/Initialize(mapload)
	status = TORCH_EMPTY
	STOP_PROCESSING(SSobj, src)
	..()

/obj/machinery/torch_holder/extinguish_light(force = FALSE)
	if(force)
		fuel = 0
		visible_message(span_danger("[fakel.declent_ru(NOMINATIVE)] быстро выгорает!"))
	else
		visible_message(span_notice("[fakel.declent_ru(NOMINATIVE)] ненадолго меркнет, после чего снова начинает освещать пространство вокруг."))

#undef TORCH_OK
#undef TORCH_EMPTY
#undef TORCH_OFF
#undef TORCH_BURNED
