//********** Acid Bladder **********//
/obj/item/acid_bladder
	name = "acid bladder"
	desc = "Небольшой кислотный мешочек, добытый с тела сернистого странника. Оболочка данного пузыря достаточно слабая и вероятнее всего разорвется при броске во что-то. Или в кого-то."
	icon = 'icons/obj/lavaland/lava_fishing.dmi'
	icon_state = "acid_bladder"
	w_class = WEIGHT_CLASS_TINY

/obj/item/acid_bladder/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(isliving(hit_atom))
		var/mob/living/living = hit_atom
		var/datum/reagents/reagents_list = new (50)
		reagents_list.add_reagent("facid", 40)
		living.visible_message(span_danger("Кислотный пузырек разрывается при попадании на [living], разбрызгивая кислоту по [genderize_ru(living.gender, "его", "её", "его", "их")] телу!"))
		reagents_list.reaction(living, REAGENT_TOUCH)
		reagents_list.clear_reagents()
	else if(iswallturf(hit_atom))
		var/turf/simulated/wall/wall_target = hit_atom
		hit_atom.visible_message(span_danger("Кислотный пузырек разрывается при попадании на стену, медленно её расплавляя!"))
		wall_target.rot()
	else
		var/datum/reagents/reagents_list = new (100)
		reagents_list.add_reagent("facid", 80)
		reagents_list.reaction(hit_atom, REAGENT_TOUCH)
	qdel(src)

//********** Saw Blade **********//
/obj/item/circular_saw_blade
	name = "circular saw blade"
	desc = "Костный нарост в виде циркулярной пилы, вырванный из черепа ослеплённого жнеца. Используется для улучшения костяного топора."
	icon = 'icons/obj/lavaland/lava_fishing.dmi'
	icon_state = "circular_saw_blade"
	w_class = WEIGHT_CLASS_TINY

//**********Grace of Lazis **********//
/obj/structure/grace_of_lazis
	name = "grace of lazis"
	icon = 'icons/obj/lavaland/grace_of_lazis.dmi'
	icon_state = "grace_of_lazis4"
	desc = "Огромное количество мяса, насаженного на костяное копье. Символ невероятно удачного сезона охоты."
	anchored = TRUE
	density = TRUE
	max_integrity = 1000
	var/meat_parts = 40

/obj/structure/grace_of_lazis/attackby(obj/item/I, mob/user, params)
	if(!istype(I, /obj/item/kitchen/knife))
		return ..()

	to_chat(user, span_notice("Вы начали отрезать порцию мяса от постамента."))

	if(!do_after(user, 3 SECONDS, src, max_interact_count = 1))
		return ..()

	meat_parts--
	update_icon(UPDATE_ICON_STATE)
	to_chat(user, span_notice("Вы отрезали порцию мяса с постамента."))
	var/obj/item/reagent_containers/food/snacks/lavaland_food/grace_of_lazis/food = new()
	user.put_in_hands(food)
	if(meat_parts == 0)
		visible_message(span_warning("от постамента остается лишь одно копье!"))
		var/obj/item/twohanded/spear/bonespear/spear
		spear = new(loc)
		qdel(src)
		return ATTACK_CHAIN_PROCEED
	return ATTACK_CHAIN_SUCCESS

/obj/structure/grace_of_lazis/update_icon_state()
	switch(meat_parts)
		if(1 to 10)
			icon_state = "grace_of_lazis1"
		if(11 to 20)
			icon_state = "grace_of_lazis2"
		if(21 to 30)
			icon_state = "grace_of_lazis3"
		if(31 to INFINITY)
			icon_state = "grace_of_lazis4"
