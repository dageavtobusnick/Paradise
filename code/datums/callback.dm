/*
	USAGE:

		var/datum/callback/C = new(object|null, /proc/type/path|"procstring", arg1, arg2, ... argn)
		var/timerid = addtimer(C, time, timertype)
		OR
		var/timerid = addtimer(CALLBACK(object|null, PREC_REF(/proc/type/path)|procstring, arg1, arg2, ... argn), time, timertype)

		Note: proc strings can only be given for datum proc calls, global procs must be proc paths
		Also proc strings are strongly advised against because they don't compile error if the proc stops existing
		See the note on proc typepath shortcuts

	INVOKING THE CALLBACK:
		var/result = C.Invoke(args, to, add) //additional args are added after the ones given when the callback was created
		OR
		var/result = C.InvokeAsync(args, to, add) //Sleeps will not block, returns . on the first sleep (then continues on in the "background" after the sleep/block ends), otherwise operates normally.
		OR
		INVOKE_ASYNC(<CALLBACK args>) to immediately create and call InvokeAsync

	PROC TYPEPATH SHORTCUTS (these operate on paths, not types, so to these shortcuts, datum is NOT a parent of atom, etc...)

		global proc while in another global proc:
			.some_proc_here
			Example:
				CALLBACK(GLOBAL_PROC, /proc/some_proc_here)

		proc defined on current(src) object (when in a /proc/ and not an override) OR overridden at src or any of it's parents:
			.some_proc_here
			Example:
				CALLBACK(src, PROC_REF(some_proc_here))

		proc defined on a parent of a some type:
			/some/type/proc/some_proc_here
			Example:
				CALLBACK(src, TYPE_PROC_REF(/some/type, some_proc_here))


		Other wise you will have to do the full typepath of the proc (/type/of/thing/proc/procname)

*/

/datum/callback
	var/datum/object = GLOBAL_PROC
	var/delegate
	var/list/arguments
	var/usr_uid

/datum/callback/New(thingtocall, proctocall, ...)
	if(thingtocall)
		object = thingtocall
	delegate = proctocall
	if(length(args) > 2)
		arguments = args.Copy(3)
	if(usr)
		usr_uid = usr.UID()

/datum/callback/proc/Invoke(...)
	if(!usr && usr_uid)
		var/mob/M = locateUID(usr_uid)
		if(M)
			if(length(args))
				return world.invoke_callback_with_usr(arglist(list(M, src) + args))
			return world.invoke_callback_with_usr(M, src)
	if(!object)
		return
	var/list/calling_arguments = arguments
	if(length(args))
		if(length(arguments))
			calling_arguments = calling_arguments + args //not += so that it creates a new list so the arguments list stays clean
		else
			calling_arguments = args
	if(object == GLOBAL_PROC)
		return call(delegate)(arglist(calling_arguments))
	return call(object, delegate)(arglist(calling_arguments))

//copy and pasted because fuck proc overhead
/datum/callback/proc/InvokeAsync(...)
	set waitfor = FALSE

	if(!usr && usr_uid)
		var/mob/M = locateUID(usr_uid)
		if(M)
			if(length(args))
				return world.invoke_callback_with_usr(arglist(list(M, src) + args))
			return world.invoke_callback_with_usr(M, src)

	if(!object)
		return
	var/list/calling_arguments = arguments
	if(length(args))
		if(length(arguments))
			calling_arguments = calling_arguments + args //not += so that it creates a new list so the arguments list stays clean
		else
			calling_arguments = args
	if(object == GLOBAL_PROC)
		return call(delegate)(arglist(calling_arguments))
	return call(object, delegate)(arglist(calling_arguments))
