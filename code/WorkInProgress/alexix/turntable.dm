/obj/machinery/party/mixer
	name = "mixer"
	desc = "A mixing board for mixing music"
	icon = 'code/WorkInProgress/alexix/turntable.dmi'
	icon_state = "mixer"
	anchored = 1
	var/playing = 0

/mob/var/music = 0

/obj/machinery/party/mixer/New()
	..()
	sleep(2)
	new /sound/turntable/test(src)
	return

/obj/machinery/party/mixer/attack_hand(mob/user as mob)

	var/t = "<B>Turntable Interface</B><br><br>"
	//t += "<A href='?src=\ref[src];on=1'>On</A><br>"
	t += "<A href='?src=\ref[src];off=1'>Off</A><br><br>"
	t += "<A href='?src=\ref[src];on=remove_kebab'>Remove Llego</A><br>"
	//t += "<A href='?src=\ref[src];on2=Testloop2'>TestLoop2</A><br>"
	//t += "<A href='?src=\ref[src];on3=Testloop3'>TestLoop3</A><br>"
	user << browse(t, "window=turntable;size=420x300")

/obj/machinery/party/mixer/Topic(href, href_list)
	..()
	if( href_list["on"] )
		if(src.playing == 0)
			//world << "Should be working..."
			var/sound/S = sound('sound/music/remove_kebab.ogg')
			S.repeat = 1
			S.channel = 10
			S.falloff = 2
			S.wait = 1
			S.environment = 0
			//for(var/mob/M in world)
			//	if(M.loc.loc == src.loc.loc && M.music == 0)
			//		world << "Found the song..."
			//		M << S
			//		M.music = 1
			var/area/A = src.loc.loc
//			for(var/area/RA in A.related)
//				for(var/obj/machinery/party/lasermachine/L in RA)
//					L.turnon()
			playing = 1
			while(playing == 1)
				for(var/mob/M in world)
					if((M.loc.loc in A.related) && M.music == 0)
						//world << "Found the song..."
						M << S
						M.music = 1
					else if(!(M.loc.loc in A.related) && M.music == 1)
						var/sound/Soff = sound(null)
						Soff.channel = 10
						M << Soff
						M.music = 0
				sleep(10)
			return
	if( href_list["off"] )
		if(src.playing == 1)
			var/sound/S = sound(null)
			S.channel = 10
			S.wait = 1
			for(var/mob/M in world)
				M << S
				M.music = 0
			playing = 0
//			var/area/A = src.loc.loc
//			for(var/area/RA in A.related)
//				for(var/obj/machinery/party/lasermachine/L in RA)
//					L.turnoff()

/sound/turntable/test
	file = 'sound/music/remove_kebab.ogg'
	falloff = 2
	repeat = 1