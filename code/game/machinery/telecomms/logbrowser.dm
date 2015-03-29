//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
/obj/machinery/computer/telecomms

	l_color = "#50AB00"

/obj/machinery/computer/telecomms/server
	name = "Telecommunications Server Monitor"
	icon_state = "comm_logs"


	var/screen = 0				// the screen number:
	var/list/servers = list()	// the servers located by the computer
	var/obj/machinery/telecomms/server/SelectedServer

	var/network = "NULL"		// the network to probe
	var/temp = ""				// temporary feedback messages

	var/universal_translate = 0 // set to 1 if it can translate nonhuman speech

	req_access = list(access_tcomsat)


	attack_hand(mob/user as mob)
		if(stat & (BROKEN|NOPOWER))
			return
		user.set_machine(src)
		var/dat = "<TITLE>Telecommunication Server Monitor</TITLE><center><b>Telecommunications Server Monitor</b></center>"

		switch(screen)


		  // --- Main Menu ---

			if(0)

				// AUTOFIXED BY fix_string_idiocy.py
				// C:\Users\Rob\Documents\Projects\vgstation13\code\game\machinery\telecomms\logbrowser.dm:30: dat += "<br>[temp]<br>"
				dat += {"<br>[temp]<br>
					<br>Current Network: <a href='?src=\ref[src];network=1'>[network]</a><br>"}
				// END AUTOFIX
				if(servers.len)
					dat += "<br>Detected Telecommunication Servers:<ul>"
					for(var/obj/machinery/telecomms/T in servers)
						dat += "<li><a href='?src=\ref[src];viewserver=[T.id]'>\ref[T] [T.name]</a> ([T.id])</li>"

					// AUTOFIXED BY fix_string_idiocy.py
					// C:\Users\Rob\Documents\Projects\vgstation13\code\game\machinery\telecomms\logbrowser.dm:36: dat += "</ul>"
					dat += {"</ul>
						<br><a href='?src=\ref[src];operation=release'>\[Flush Buffer\]</a>"}
					// END AUTOFIX
				else
					dat += "<br>No servers detected. Scan for servers: <a href='?src=\ref[src];operation=scan'>\[Scan\]</a>"


		  // --- Viewing Server ---

			if(1)

				// AUTOFIXED BY fix_string_idiocy.py
				// C:\Users\Rob\Documents\Projects\vgstation13\code\game\machinery\telecomms\logbrowser.dm:46: dat += "<br>[temp]<br>"
				dat += {"<br>[temp]<br>
					<center><a href='?src=\ref[src];operation=mainmenu'>\[Main Menu\]</a>     <a href='?src=\ref[src];operation=refresh'>\[Refresh\]</a></center>
					<br>Current Network: [network]
					<br>Selected Server: [SelectedServer.id]"}
				// END AUTOFIX
				if(SelectedServer.totaltraffic >= 1024)
					dat += "<br>Total recorded traffic: [round(SelectedServer.totaltraffic / 1024)] Terrabytes<br><br>"
				else
					dat += "<br>Total recorded traffic: [SelectedServer.totaltraffic] Gigabytes<br><br>"

				dat += "Stored Logs: <ol>"

				var/i = 0
				for(var/datum/comm_log_entry/C in SelectedServer.log_entries)
					i++


					// If the log is a speech file
					if(C.input_type == "Speech File")

						dat += "<li><font color = #008F00>[C.name]</font color>  <font color = #FF0000><a href='?src=\ref[src];delete=[i]'>\[X\]</a></font color><br>"

						// -- Determine race of orator --

						var/datum/language/language = C.parameters["languages"] // MMIs, pAIs, Cyborgs and humans all speak Human
						// -- If the orator is a human, or universal translate is active, OR mob has universal speech on --
							// AUTOFIXED BY fix_string_idiocy.py
							// C:\Users\Rob\Documents\Projects\vgstation13\code\game\machinery\telecomms\logbrowser.dm:102: dat += "<u><font color = #18743E>Data type</font color></u>: [C.input_type]<br>"
						dat += {"<u><font color = #18743E>Data type</font color></u>: [C.input_type]<br>
							<u><font color = #18743E>Source</font color></u>: [C.parameters["name"]] (Job: [C.parameters["job"]])<br>
							<u><font color = #18743E>Language</font color></u>: [language.name]<br>
							<u><font color = #18743E>Contents</font color></u>: \"[user.can_speak_lang(language) ? C.parameters["message"] : C.parameters["badmessage"]]\"<br>"}
						dat += "</li><br>"

					else if(C.input_type == "Execution Error")


						// AUTOFIXED BY fix_string_idiocy.py
						// C:\Users\Rob\Documents\Projects\vgstation13\code\game\machinery\telecomms\logbrowser.dm:120: dat += "<li><font color = #990000>[C.name]</font color>  <font color = #FF0000><a href='?src=\ref[src];delete=[i]'>\[X\]</a></font color><br>"
						dat += {"<li><font color = #990000>[C.name]</font color>  <font color = #FF0000><a href='?src=\ref[src];delete=[i]'>\[X\]</a></font color><br>
							<u><font color = #787700>Output</font color></u>: \"[C.parameters["message"]]\"<br>
							</li><br>"}
						// END AUTOFIX


				dat += "</ol>"



		user << browse(dat, "window=comm_monitor;size=575x400")
		onclose(user, "server_control")

		temp = ""
		return


	Topic(href, href_list)
		if(..())
			return


		add_fingerprint(usr)
		usr.set_machine(src)

		if(href_list["viewserver"])
			screen = 1
			for(var/obj/machinery/telecomms/T in servers)
				if(T.id == href_list["viewserver"])
					SelectedServer = T
					break

		if(href_list["operation"])
			switch(href_list["operation"])

				if("release")
					servers = list()
					screen = 0

				if("mainmenu")
					screen = 0

				if("scan")
					if(servers.len > 0)
						temp = "<font color = #D70B00>- FAILED: CANNOT PROBE WHEN BUFFER FULL -</font color>"

					else
						for(var/obj/machinery/telecomms/server/T in range(25, src))
							if(T.network == network)
								servers.Add(T)

						if(!servers.len)
							temp = "<font color = #D70B00>- FAILED: UNABLE TO LOCATE SERVERS IN \[[network]\] -</font color>"
						else
							temp = "<font color = #336699>- [servers.len] SERVERS PROBED & BUFFERED -</font color>"

						screen = 0

		if(href_list["delete"])

			if(!src.allowed(usr) && !emagged)
				usr << "\red ACCESS DENIED."
				return

			if(SelectedServer)

				var/datum/comm_log_entry/D = SelectedServer.log_entries[text2num(href_list["delete"])]

				temp = "<font color = #336699>- DELETED ENTRY: [D.name] -</font color>"

				SelectedServer.log_entries.Remove(D)
				del(D)

			else
				temp = "<font color = #D70B00>- FAILED: NO SELECTED MACHINE -</font color>"

		if(href_list["network"])
			var/newnet = input(usr, "Which network do you want to view?", "Comm Monitor", network) as null|text
			if(newnet && (usr in range(1, src) || issilicon(usr)))
				if(length(newnet) > 15)
					temp = "<font color = #D70B00>- FAILED: NETWORK TAG STRING TOO LENGHTLY -</font color>"

				else

					network = newnet
					screen = 0
					servers = list()
					temp = "<font color = #336699>- NEW NETWORK TAG SET IN ADDRESS \[[network]\] -</font color>"

		updateUsrDialog()
		return

	attackby(var/obj/item/weapon/D as obj, var/mob/user as mob)
		..()
		src.updateUsrDialog()
		return

	emag(mob/user)
		if(!emagged)
			playsound(get_turf(src), 'sound/effects/sparks4.ogg', 75, 1)
			emagged = 1
			user << "\blue You you disable the security protocols"
			return 1