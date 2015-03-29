/obj/machinery/power/solar/control
	name = "solar panel control"
	desc = "A controller for solar panel arrays."
	icon = 'icons/obj/computer.dmi'
	icon_state = "solar"
	use_power = 1
	idle_power_usage = 50
	active_power_usage = 300
	var/id_tag = 0
	var/cdir = 0
	var/gen = 0
	var/lastgen = 0
	var/track = 0			//0 = off  1 = manual  2 = automatic
	var/trackrate = 60		//Measured in tenths of degree per minute (i.e. defaults to 6.0 deg/min)
	var/trackdir = 1		//-1 = CCW, 1 = CW
	var/nexttime = 0		//Next clock time that manual tracking will move the array
	var/obj/machinery/power/solar/tracker/connected_tracker = null
	var/list/connected_panels = list()

	l_color = "#FF9933"

/obj/machinery/power/solar/control/initialize()
	..()

	if(powernet)
		set_panels(cdir)

/obj/machinery/power/solar/control/Destroy()
	for(var/obj/machinery/power/solar/panel/P in getPowernetNodes())
		if(P.control == src)
			P.control = null

	..()

/obj/machinery/power/solar/control/update_icon()
	overlays.len = 0

	if(stat & BROKEN)
		icon_state = "broken"
		return

	if(stat & NOPOWER)
		icon_state = "c_unpowered"
		return

	icon_state = "solar"

	if(cdir > 0)
		overlays += image('icons/obj/computer.dmi', "solcon-o", FLY_LAYER, angle2dir(cdir))

/obj/machinery/power/solar/control/attack_ai(mob/user)
	if(!..())
		add_hiddenprint(user)
		interact(user)

/obj/machinery/power/solar/control/attack_hand(mob/user)
	if(!..())
		add_fingerprint(user)
		interact(user)

/obj/machinery/power/solar/control/disconnect_from_network()
	..()
	solars_list.Remove(src)
	// Забываем про подсоединенные панели и тракер
	for(var/obj/machinery/power/solar/panel/M in connected_panels)
		M.control = null
	if(connected_tracker)
		connected_tracker.control = null
	connected_panels = list()
	connected_tracker = null


/obj/machinery/power/solar/control/connect_to_network()
	var/to_return = ..()
	if(powernet) //if connected and not already in solar_list...
		solars_list |= src //... add it
	return to_return

/obj/machinery/power/solar/control/process()
	..()
	lastgen = gen
	gen = 0

	if(stat & (NOPOWER | BROKEN))
		return

	if(track == 1 && nexttime < world.time && trackdir * trackrate)
		// Increments nexttime using itself and not world.time to prevent drift
		nexttime = nexttime + 6000 / trackrate
		// Nudges array 1 degree in desired direction
		cdir = (cdir + trackdir + 360) % 360
		set_panels(cdir)
		update_icon()
	if(track == 2)
		if(connected_tracker.sun_angle != sun.angle)
			connected_tracker.set_angle(sun.angle)
			update_icon()
	updateDialog()

/obj/machinery/power/solar/control/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		playsound(get_turf(src), 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if(src.stat & BROKEN)
				visible_message("<span class='notice'>[user] clears the broken monitor off of [src].</span>", \
				"You clear the broken monitor off of [src]")
				var/obj/structure/computerframe/A = new /obj/structure/computerframe(src.loc)
				getFromPool(/obj/item/weapon/shard, loc)
				var/obj/item/weapon/circuitboard/solar_control/M = new /obj/item/weapon/circuitboard/solar_control(A)
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				qdel(src)
			else
				visible_message("<span class='notice'>[user] disconnects [src]'s monitor.</span>", \
				"<span class='notice'>You disconnect [src]'s monitor.</span>")
				var/obj/structure/computerframe/A = new /obj/structure/computerframe(src.loc)
				var/obj/item/weapon/circuitboard/solar_control/M = new /obj/item/weapon/circuitboard/solar_control(A)
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				qdel(src)
	else
		src.attack_hand(user)

// called by solar tracker when sun position changes (somehow, that's not supposed to be in process)
/obj/machinery/power/solar/control/proc/tracker_update(angle)
	if(track != 2 || stat & (NOPOWER | BROKEN))
		return

	cdir = angle
	set_panels(cdir)
	update_icon()
	updateDialog()

/obj/machinery/power/solar/control/interact(mob/user)
	if(stat & (BROKEN | NOPOWER))
		return

	if ((get_dist(src, user) > 1))
		if (!istype(user, /mob/living/silicon/ai))
			usr.set_machine(null)
			user << browse(null, "window=solcon")
			return

	user.set_machine(src)
	var/t = "<B><span class='highlight'>Generated power</span></B> : [round(lastgen)] W<BR>"
	t += "<B><span class='highlight'>Star Orientation</span></B>: [sun.angle]&deg ([angle2text(sun.angle)])<BR>"
	t += "<B><span class='highlight'>Array Orientation</span></B>: [rate_control(src,"cdir","[cdir]&deg",1,15)] ([angle2text(cdir)])<BR>"
	t += "<B><span class='highlight'>Tracking:</B><div class='statusDisplay'>"
	switch(track)
		if(0)
			t += "<span class='linkOn'>Off</span> <A href='?src=\ref[src];track=1'>Timed</A> <A href='?src=\ref[src];track=2'>Auto</A><BR>"
		if(1)
			t += "<A href='?src=\ref[src];track=0'>Off</A> <span class='linkOn'>Timed</span> <A href='?src=\ref[src];track=2'>Auto</A><BR>"
		if(2)
			t += "<A href='?src=\ref[src];track=0'>Off</A> <A href='?src=\ref[src];track=1'>Timed</A> <span class='linkOn'>Auto</span><BR>"

	t += "Tracking Rate: [rate_control(src,"tdir","[trackrate] deg/h ([trackrate<0 ? "CCW" : "CW"])",1,30,180)]</div><BR>"

	t += "<B><span class='highlight'>Connected devices:</span></B><div class='statusDisplay'>"

	t += "<A href='?src=\ref[src];search_connected=1'>Search for devices</A><BR>"
	t += "Solar panels : [connected_panels.len] connected<BR>"
	t += "Solar tracker : [(connected_tracker != null) ? "<span class='good'>Found</span>" : "<span class='bad'>Not found</span>"]</div><BR>"

	t += "<A href='?src=\ref[src];close=1'>Close</A>"

	var/datum/browser/popup = new(user, "solcon", name)
	popup.set_content(t)
	popup.open()

	return

/obj/machinery/power/solar/control/Topic(href, href_list)
	if(..())
		usr << browse(null, "window=solcon")
		usr.set_machine(null)
		return 0
	if(href_list["close"] )
		usr << browse(null, "window=solcon")
		usr.set_machine(null)
		return 0

	if(href_list["rate control"])
		if(href_list["cdir"])
			src.cdir = dd_range(0,359,(360+src.cdir+text2num(href_list["cdir"]))%360)
			if(track == 2) //manual update, so losing auto-tracking
				track = 0
			spawn(1)
				set_panels(cdir)
		if(href_list["tdir"])
			src.trackrate = dd_range(-7200,7200,src.trackrate+text2num(href_list["tdir"]))
			if(src.trackrate) nexttime = world.time + 36000/abs(trackrate)

	if(href_list["track"])
		track = text2num(href_list["track"])
		if(track == 2)
			if(connected_tracker != null)
				connected_tracker.set_angle(sun.angle)
				set_panels(cdir)
		else if (track == 1) //begin manual tracking
			if(src.trackrate) nexttime = world.time + 36000/abs(trackrate)
			set_panels(cdir)

	if(href_list["search_connected"])
		src.search_for_connected()
		if(connected_tracker && track == 2)
			connected_tracker.set_angle(sun.angle)
		src.set_panels(cdir)

	interact(usr)
	return 1

/obj/machinery/power/solar/control/proc/search_for_connected()
	if(powernet)
		for(var/obj/machinery/power/M in powernet.nodes)
			if(istype(M, /obj/machinery/power/solar/panel))
				var/obj/machinery/power/solar/panel/S = M
				if(!S.control) //i.e unconnected
					S.control = src
					connected_panels |= S
			else if(istype(M, /obj/machinery/power/solar/tracker))
				if(!connected_tracker) //if there's already a tracker connected to the computer don't add another
					var/obj/machinery/power/solar/tracker/T = M
					if(!T.control) //i.e unconnected
						connected_tracker = T
						T.control = src


/obj/machinery/power/solar/control/proc/set_panels(var/cdir)
	for(var/obj/machinery/power/solar/panel/P in getPowernetNodes())
		if(get_dist(P, src) < SOLAR_MAX_DIST)
			if(!P.control)
				P.control = src

			P.ndir = cdir

/obj/machinery/power/solar/control/power_change()
	if(powered())
		stat &= ~NOPOWER
		update_icon()
	else
		spawn(rand(0, 15))
			stat |= NOPOWER
			update_icon()

/obj/machinery/power/solar/control/proc/broken()
	stat |= BROKEN
	update_icon()

/obj/machinery/power/solar/control/meteorhit()
	broken()
	return

/obj/machinery/power/solar/control/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if (prob(50))
				broken()
		if(3.0)
			if (prob(25))
				broken()

/obj/machinery/power/solar/control/blob_act()
	if(prob(75))
		broken()
		density = 0

