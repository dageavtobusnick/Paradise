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
