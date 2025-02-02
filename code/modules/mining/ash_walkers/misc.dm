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
		new /obj/item/twohanded/spear/bonespear(src.loc)
		qdel(src)
		return ATTACK_CHAIN_PROCEED
	return ATTACK_CHAIN_BLOCKED

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

//**********Food Scroll**********//
/obj/item/paper/food_scroll
	name = "cooking scroll"
	icon = 'icons/obj/library.dmi'
	icon_state = "food_scroll"
	item_state = "food_scroll"
	desc = "Пергамент, изготовленный из человеческой кожи. На нем нанесена информация о том, как прокормить голодное племя."
	language = LANGUAGE_UNATHI
	info = "<BR> КАК ГОТОВИТЬ МЯСО \
			<BR> Надо: \
			<BR> 1 Огонь чтобы готовить \
			<BR> Много мяса \
			<BR> ГОТОВКА: \
			<BR> Шаг 1: Сунь мясо в огонь \
			<BR> Шаг два: Вынь мясо из огня \
			<BR> 3: Ешь мясо \
			<BR> Советы: не ешь других пеплоходцев, пока они живы. \
			<BR> Если мясо не кричит, готовить проще"

/obj/item/paper/food_scroll/update_icon_state()
	return

/obj/structure/fluff/ash_statue //used to mark point of interest
	name = "ash totem"
	desc = "Массивный каменный столб с прикрепленным к нему черепом убитого зверя. Кажется вы зашли в охотничьи угодья пеплоходцев."
	icon = 'icons/obj/lavaland/grace_of_lazis.dmi'
	icon_state = "totem_stone"
	anchored = TRUE
	density = TRUE
	deconstructible = FALSE

/obj/structure/ash_totem
	name = "totem"
	icon = 'icons/obj/lavaland/grace_of_lazis.dmi'
	icon_state = "totem_wooden"
	desc = "совершенно обычный тотем! Выглядит прикольно. Вы не должны видеть это."
	max_integrity = 1000
	anchored = TRUE
	density = TRUE
	var/applied_dye = null
	var/applied_dye_fluff_name = null

/obj/structure/ash_totem/examine(mob/user)
	. = ..()
	. += span_notice("Эта статуя может использоваться вместо полноценного пеплоходца, если будет построена у ритуальной руны.")

	if(applied_dye && applied_dye_fluff_name) //jeez this is so hard to make it in russian holy fuck
		. += span_notice("На эту статую нанесена [applied_dye_fluff_name] краска.")

/obj/structure/ash_totem/update_overlays()
	. = ..()
	if(applied_dye)
		. += "[icon_state]_[applied_dye]"


/obj/structure/ash_totem/wooden
	name = "wooden totem"
	icon_state = "totem_wooden"
	desc = "Массивная статуя, сделанная из цельного куска древесины. Рисунок на статуе отдаленно напоминает человеческое лицо, искаженное в гримасе ужаса."

/obj/structure/ash_totem/stone
	name = "stone totem"
	icon_state = "totem_stone"
	desc = "Массивная каменная статуя с прикрепленным к ней черепом убитого животного. Сухожилия, держащие череп на месте, медленно покачиваются на ветру."

/obj/structure/ash_totem/bone
	name = "bone totem"
	icon_state = "totem_bone"
	desc = "Массивная статуя, сделанная из огромной кости. Вы не знаете, какому именно животному принадлежит эта кость, и вы явно не хотите это узнавать."

/obj/structure/chair/stool/wooden
	name = "wooden stool"
	ru_names = list(
		NOMINATIVE = "деревянная табуретка",
		GENITIVE = "деревянной табуретки",
		DATIVE = "деревянной табуретке",
		ACCUSATIVE = "деревянную табуретку",
		INSTRUMENTAL = "деревянной табуреткой",
		PREPOSITIONAL = "деревянной табуретке"
	)
	desc = "Деревянная табуретка. Достаточно удобная, чтобы на ней сидеть."
	icon_state = "wooden_stool"
	item_chair = /obj/item/chair/stool/wooden

/obj/item/chair/stool/wooden
	name = "wooden stool"
	ru_names = list(
		NOMINATIVE = "деревянная табуретка",
		GENITIVE = "деревянной табуретки",
		DATIVE = "деревянной табуретке",
		ACCUSATIVE = "деревянную табуретку",
		INSTRUMENTAL = "деревянной табуреткой",
		PREPOSITIONAL = "деревянной табуретке"
	)
	desc = "Деревянная табуретка. Достаточно удобная, чтобы держать ее в руках."
	icon = 'icons/obj/chairs.dmi'
	icon_state = "wooden_stool_toppled"
	item_state = "stool"
	force = 8
	origin_type = /obj/structure/chair/stool/wooden
	break_chance = 10 //It's too sturdy.
