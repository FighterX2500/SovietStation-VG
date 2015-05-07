/*
	Datum based languages. Easily editable and modular.
*/

/datum/language
	var/name = "an unknown language" // Fluff name of language if any.
	var/desc = "A language."         // Short description for 'Check Languages'.
	var/speech_verb = "says"         // 'says', 'hisses', 'farts'.
	var/ask_verb = "asks"            // Used when sentence ends in a ?
	var/exclaim_verb = "exclaims"    // Used when sentence ends in a !
	var/signlang_verb = list()       // list of emotes that might be displayed if this language has NONVERBAL or SIGNLANG flags
	var/colour = "body"         // CSS style to use for strings in this language.
	var/list/key = "x"                    // Character used to speak in language eg. :o for Unathi.
	var/flags = 0                    // Various language flags.
//	var/native                       // If set, non-native speakers will have trouble speaking.

/datum/language/proc/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)

	log_say("[key_name(speaker)] : ([name]) [message]")

	for(var/mob/player in player_list)

		var/understood = 0

		if(istype(player,/mob/dead))
			understood = 1
		else if((player.can_speak_lang(src) && check_special_condition(player)) || player.universal_speak)
			understood = 1

		if(istype(player, /mob/living/simple_animal/jirachi))
			understood = 0

		if(understood)
			if(!speaker_mask) speaker_mask = speaker.name
			var/msg = "<i><span class='[colour]'>[name], <span class='name'>[speaker_mask]</span> [src.get_spoken_verb(copytext(message, length(message)))], \"[message]\"</span></i>"
			player << "[msg]"

/datum/language/proc/check_special_condition(var/mob/other)
	return 1

/datum/language/proc/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return exclaim_verb
		if("?")
			return ask_verb
	return speech_verb
/datum/language/common
	name = "Galactic Common"
	desc = "The common galactic tongue."
	speech_verb = "says"
	exclaim_verb = "exclaims"
	key = list("0")
	flags = RESTRICTED
/datum/language/jirachispeak
	name = "Jirachispeak"
	desc = "Telepathy projected voice"
	speech_verb = "telepatically says"
	exclaim_verb = "telepatically cries"
	ask_verb = "telepatically asks"
/datum/language/clatter
	name = "Clatter"
	speech_verb = "says"
	ask_verb = "asks"
	exclaim_verb = "exclaims"
	colour = "white"
	key = list("ù","o")
	flags = WHITELISTED
/datum/language/unathi
	name = "Sinta'unathi"
	desc = "The common language of Moghes, composed of sibilant hisses and rattles. Spoken natively by Unathi."
	speech_verb = "hisses"
	ask_verb = "hisses"
	exclaim_verb = "roars"
	colour = "soghun"
	key = list("à","f")
	flags = WHITELISTED

/datum/language/tajaran
	name = "Siik'tajr"
	desc = "The traditionally employed tongue of Ahdomai, composed of expressive yowls and chirps. Native to the Tajaran."
	speech_verb = "mrowls"
	ask_verb = "mrowls"
	exclaim_verb = "yowls"
	colour = "tajaran"
	key = list("í","y")
	flags = WHITELISTED

/datum/language/skrell
	name = "Skrellian"
	desc = "A melodic and complex language spoken by the Skrell of Qerrbalak. Some of the notes are inaudible to humans."
	speech_verb = "warbles"
	ask_verb = "warbles"
	exclaim_verb = "warbles"
	colour = "skrell"
	key = list("ê","r")
	flags = WHITELISTED

/datum/language/vox
	name = "Vox-pidgin"
	desc = "The common tongue of the various Vox ships making up the Shoal. It sounds like chaotic shrieking to everyone else."
	speech_verb = "shrieks"
	ask_verb = "creels"
	exclaim_verb = "SHRIEKS"
	colour = "vox"
	key = list("ì","v")
	flags = RESTRICTED

/datum/language/diona
	name = "Rootspeak"
	desc = "A creaking, subvocal language spoken instinctively by the Dionaea. Due to the unique makeup of the average Diona, a phrase of Rootspeak can be a combination of anywhere from one to twelve individual voices and notes."
	speech_verb = "creaks and rustles"
	ask_verb = "creaks"
	exclaim_verb = "rustles"
	colour = "soghun"
	key = list("î","j")
	flags = RESTRICTED

/datum/language/common/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return pick("exclaims","shouts","yells") //TODO: make the basic proc handle lists of verbs.
		if("?")
			return ask_verb
	return speech_verb

/datum/language/human
	name = "Sol Common"
	desc = "A bastardized hybrid of informal English and elements of Mandarin Chinese; the common language of the Sol system."
	colour = "rough"
	key = list("1")
	flags = RESTRICTED

// Galactic common languages (systemwide accepted standards).
/datum/language/trader
	name = "Tradeband"
	desc = "Maintained by the various trading cartels in major systems, this elegant, structured language is used for bartering and bargaining."
	speech_verb = "enunciates"
	colour = "say_quote"
	key = list("2")

/datum/language/gutter
	name = "Gutter"
	desc = "Much like Standard, this crude pidgin tongue descended from numerous languages and serves as Tradeband for criminal elements."
	speech_verb = "growls"
	colour = "rough"
	key = list("3")


/datum/language/xenocommon
	name = "Xenomorph"
	colour = "alien"
	desc = "The common tongue of the xenomorphs."
	speech_verb = "hisses"
	ask_verb = "hisses"
	exclaim_verb = "hisses"
	key = list("4")
	flags = RESTRICTED

/datum/language/xenos
	name = "Hivemind"
	desc = "Xenomorphs have the strange ability to commune over a psychic hivemind."
	speech_verb = "hisses"
	ask_verb = "hisses"
	exclaim_verb = "hisses"
	colour = "alien"
	key = list("ô","a")
	flags = RESTRICTED | HIVEMIND

/datum/language/xenos/check_special_condition(var/mob/other)
	var/mob/living/carbon/M = other
	if(!istype(M))
		return 1
	if(istype(M,/mob/living/carbon/alien))
		return 1

	return 0

/datum/language/ling
	name = "Changeling"
	desc = "Although they are normally wary and suspicious of each other, changelings can commune over a distance."
	speech_verb = "says"
	colour = "changeling"
	key = list("ï","g")
	flags = RESTRICTED | HIVEMIND

/datum/language/ling/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)
	if(speaker.mind && speaker.mind.changeling)
		..(speaker,message,speaker.mind.changeling.changelingID)
	else
		..(speaker,message)

/datum/language/corticalborer
	name = "Cortical Link"
	desc = "Cortical borers possess a strange link between their tiny minds."
	speech_verb = "sings"
	ask_verb = "sings"
	exclaim_verb = "sings"
	colour = "alien"
	key = list("÷","x")
	flags = RESTRICTED | HIVEMIND

/datum/language/animal
	name = "Animalspeak"
	desc = "Animals talking on this"
	speech_verb = "speaks"
	ask_verb = "speaks"
	exclaim_verb = "speaks"
	colour = "animal"
	key = list("ë","k")
	flags = RESTRICTED
/datum/language/slime
	name = "Slimespeak"
	desc = "Slimes talking on this"
	speech_verb = "chirps"
	ask_verb = "chirps"
	exclaim_verb = "chirps"
	colour = "slime"
	key = list("æ",";")
	flags = RESTRICTED | HIVEMIND
/datum/language/corticalborer/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)

	var/mob/living/simple_animal/borer/B
	if(istype(speaker,/mob/living/carbon))
		var/mob/living/carbon/M = speaker
		B = M.has_brain_worms()
	else if(istype(speaker,/mob/living/simple_animal/borer))
		B = speaker

	if(B)
		speaker_mask = B.truename
	..(speaker,message,speaker_mask)

/datum/language/binary
	name = "Robot Talk"
	desc = "Most human stations support free-use communications protocols and routing hubs for synthetic use."
	colour = "robot_talk"
	speech_verb = "states"
	ask_verb = "queries"
	exclaim_verb = "declares"
	key = list("è","b")
	flags = RESTRICTED | HIVEMIND
	var/drone_only

/datum/language/binary/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)
	if (!message)
		return

	var/message_start = "<i><span class='[colour]'>[name], <span class='name'>[speaker.name]</span>"
	var/message_body = "<span class='message'>[src.get_spoken_verb(copytext(message, length(message)))], \"[message]\"</span></span></i>"

	for (var/mob/M in dead_mob_list)
		if(!istype(M,/mob/new_player)) //No meta-evesdropping
			M.show_message("[message_start] [message_body]", 2)

	for (var/mob/living/S in living_mob_list)
		//if(drone_only && !istype(S,/mob/living/silicon/robot/drone))
		//	continue
		if(istype(S , /mob/living/silicon/ai))
			message_start = "<i><span class='[colour]'>[name], <a href='byond://?src=\ref[S];track2=\ref[S];track=\ref[speaker];trackname=[html_encode(speaker.name)]'><span class='name'>[speaker.name]</span></a>"
		if (!S.can_speak_lang(src))
			continue

		S.show_message("[message_start] [message_body]", 2)

	var/list/listening = hearers(1, src)
	listening -= src

	for (var/mob/living/M in listening)
		if(istype(M, /mob/living/silicon) || M.binarycheck())
			continue
		M.show_message("<i><span class='game say'><span class='name'>synthesised voice</span> <span class='message'>beeps, \"beep beep beep\"</span></span></i>",2)

	//Òðàòèì çàðÿä áàòàðåè íà áîëòîâíþ
	if (isrobot(speaker))
		var/mob/living/silicon/robot/R = speaker
		if(R.cell)
			R.cell.charge -= 100
// Language handling.
/atom/movable/proc/add_language(var/language)
	if(language == null)
		return
	if(!languages)
		languages = list()
	if(!istype(language,/list))
		var/datum/language/new_language
		if(!istype(language,/datum/language))
			new_language = all_languages[language]
		else
			new_language = language
		if(!istype(new_language) || (new_language in languages))
			return 0

		languages.Add(new_language)
		return 1
	else
		var/list/L = language
		for(var/lang in L)
			var/datum/language/new_language
			if(!istype(lang,/datum/language))
				new_language = all_languages[lang]
			else
				new_language = lang
			if(!istype(new_language) || (new_language in languages))
				continue
			languages.Add(new_language)
		return 1
/atom/movable/proc/remove_language(var/rem_language)
	if(!istype(rem_language,/list))
		languages.Remove(all_languages[rem_language])
	else
		var/list/L = rem_language
		for(var/datum/language/lang in L)
			languages.Remove(L)

	return 0
/mob/living/add_language(var/language)
	if(..() && !current_language_speak && (languages.len > 0))
		current_language_speak = languages[1]

// Can we speak this language, as opposed to just understanding it?
/atom/movable/proc/can_speak_lang(datum/language/speaking)
	if(src.universal_speak)
		return 1
	if(istype(speaking, /datum/language/jirachispeak))
		return 1
	return (speaking in src.languages)
/mob/living/carbon/human/can_speak_lang(datum/language/speaking)
	if(..())
		return 1
	if(ears)
		var/obj/item/device/radio/headset/H = ears
		if(istype(H))
			if(speaking.name in H.translate)
				return 1

	return 0
//TBD
/mob/verb/check_languages()
	set name = "Language"
	set category = "IC"
	set src = usr

	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"
	if(istype(src,/mob/living))
		var/mob/living/S = src
		var/keytostring
		if(!universal_speak)
			for(var/datum/language/L in languages)
				for(var/k in L.key)
					keytostring += ":[k] "
				if(S.current_language_speak == L)
					dat += "<b><span class='[L.colour]'>[L.name]</span> ([keytostring]) - Default language speaking</b><br/>[L.desc]<br/><br/>"
				else
					dat += "<b><span class='[L.colour]'>[L.name]</span> ([keytostring]) - <a href='byond://?src=\ref[src];setlang=[L.key[1]]'>Set default </a></b><br/>[L.desc]<br/><br/>"
				keytostring = ""
		else
			for(var/W in all_languages)
				var/datum/language/L = all_languages[W]
				for(var/k in L.key)
					keytostring += ":[k] "
				if(S.current_language_speak == L)
					dat += "<b><span class='[L.colour]'>[L.name]</span> ([keytostring]) - Default language speaking</b><br/>[L.desc]<br/><br/>"
				else
					dat += "<b><span class='[L.colour]'>[L.name]</span> ([keytostring]) - <a href='byond://?src=\ref[src];setlang=[L.key[1]]'>Set default </a></b><br/>[L.desc]<br/><br/>"
				keytostring = ""
	else
		for(var/datum/language/L in languages)
			dat += "<b>[L.name] (:[L.key])</b><br/>[L.desc]<br/><br/>"
	src << browse(dat, "window=checklanguage")
	return
/mob/living/carbon/human/check_languages()
	set name = "Language"
	set category = "IC"
	set src = usr
	var/keytostring
	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"
	if(istype(src,/mob/living))
		var/mob/living/S = src
		if(!universal_speak)
			for(var/datum/language/L in languages)
				for(var/k in L.key)
					keytostring += ":[k] "
				if(S.current_language_speak == L)
					dat += "<b><span class='[L.colour]'>[L.name]</span> ([keytostring]) - Default language speaking</b><br/>[L.desc]<br/><br/>"
				else
					dat += "<b><span class='[L.colour]'>[L.name]</span> ([keytostring]) - <a href='byond://?src=\ref[src];setlang=[L.key[1]]'>Set default</a></b><br/>[L.desc]<br/><br/>"
				keytostring = ""
			if(ears)
				var/obj/item/device/radio/headset/H = ears
				if(istype(H) && H.translate.len > 0)
					dat += "<b><span class='confirm'>Your headset can translate:</span></b><br>"
					for(var/L in H.translate)
						var/datum/language/lang = all_languages[L]
						for(var/k in lang.key)
							keytostring += ":[k] "
						if(istype(lang))
							dat += "<b><span class='[lang.colour]'>[lang.name]</span> ([keytostring])</b><br/>[lang.desc]<br/><br/>"
						keytostring = ""
		else
			for(var/W in all_languages)
				var/datum/language/L = all_languages[W]
				for(var/k in L.key)
					keytostring += ":[k] "
				if(S.current_language_speak == L)
					dat += "<b><span class='[L.colour]'>[L.name]</span> ([keytostring]) - Default language speaking</b><br/>[L.desc]<br/><br/>"
				else
					dat += "<b><span class='[L.colour]'>[L.name]</span> ([keytostring]) - <a href='byond://?src=\ref[src];setlang=[L.key[1]]'>Set default</a></b><br/>[L.desc]<br/><br/>"
				keytostring = ""
	else
		for(var/datum/language/L in languages)
			for(var/k in L.key)
				keytostring += ":[k] "
			dat += "<b><span class='[L.colour]'>[L.name]</span> ([keytostring])</b><br/>[L.desc]<br/><br/>"
			keytostring = ""
	src << browse(dat, "window=checklanguage")
	return
