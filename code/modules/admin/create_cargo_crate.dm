GLOBAL_VAR(create_crate_html)
GLOBAL_LIST_INIT(create_crate_forms, list(/datum/supply_packs, /datum/syndie_supply_packs))

/datum/admins/proc/create_crate(mob/user)
	if(!GLOB.create_object_html)
		var/objectjs = null
		objectjs = jointext(typecacheof(/datum/supply_packs) + typecacheof(/datum/syndie_supply_packs), ";")
		GLOB.create_object_html = file2text('html/create_object.html')
		GLOB.create_object_html = replacetext(GLOB.create_object_html, "null /* object types */", "\"[objectjs]\"")
		GLOB.create_mob_html = replacetext(GLOB.create_mob_html, "Create Object", "Create Crate")

	var/datum/browser/popup = new(user, "create_crate", "<div align='center'>Create Crate</div>", 550, 600)
	var/unique_content = GLOB.create_object_html
	unique_content = replacetext(unique_content, "/* ref src */", UID())
	popup.set_content(unique_content)
	popup.set_window_options("can_close=1;can_minimize=0;can_maximize=1;can_resize=1")
	popup.add_stylesheet("dark_inputs", "html/dark_inputs.css")
	popup.open()
	onclose(user, "create_crate")
