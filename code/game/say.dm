/*
 	Miauw's big Say() rewrite.
	This file has the basic atom/movable level speech procs.
	And the base of the send_speech() proc, which is the core of saycode.
*/
var/list/freqtospan = list(
	"1351" = "sciradio",
	"1355" = "medradio",
	"1357" = "engradio",
	"1347" = "suppradio",
	"1349" = "servradio",
	"1359" = "secradio",
	"1353" = "comradio",
	"1447" = "aiprivradio",
	"1213" = "syndradio",
	"1441" = "dsquadradio"
	)

var/list/freqtoname = list(
	"1351" = "Science",
	"1353" = "Command",
	"1355" = "Medical",
	"1357" = "Engineering",
	"1359" = "Security",
	"1441" = "Deathsquad",
	"1213" = "Syndicate",
	"1347" = "Supply",
	"1349" = "Service",
	"1447" = "AI Private"
)

/atom/movable/proc/say(message)
	if(!can_speak())
		return
	if(message == "" || !message)
		return
	send_speech(message)

/atom/movable/proc/Hear(message, atom/movable/speaker, datum/language/message_langs, raw_message, radio_freq, need_to_render = 1)
	return

/atom/movable/proc/can_speak()
	return 1

/atom/movable/proc/send_speech(message, range, datum/language/lang = all_languages["Galactic Common"])
	//var/rendered = compose_message(src, lang, message)
	for(var/atom/movable/AM in get_hearers_in_view(range, src))
		AM.Hear(message, src, lang, message)

/atom/movable/proc/compose_message(atom/movable/speaker, datum/language/message_langs, raw_message, radio_freq)
	//This proc uses text() because it is faster than appending strings. Thanks BYOND.
	//Basic span
	var/spanpart1 = "<span class='[radio_freq ? get_radio_span(radio_freq) : "game say"]'>"
	//Start name span.
	var/spanpart2 = "<span class='name'>"
	//Radio freq/name display
	var/freqpart = radio_freq ? "\[[get_radio_name(radio_freq)]\] " : ""
	//Speaker name
	var/namepart =  "[speaker.GetVoice()][speaker.get_alt_name()]"
	//End name span.
	var/endspanpart = "</span>"
	//Message
	var/messagepart = "<span class='message'>[lang_treat(speaker, message_langs, raw_message)]</span></span>"

	return "[spanpart1][spanpart2][compose_track_href(speaker, message_langs, raw_message, radio_freq)][namepart]\icon[speaker.GetRadio()][freqpart][compose_job(speaker, message_langs, raw_message, radio_freq)][endspanpart][messagepart]"

/atom/movable/proc/compose_track_href(atom/movable/speaker, message_langs, raw_message, radio_freq)
	return ""

/atom/movable/proc/compose_job(atom/movable/speaker, message_langs, raw_message, radio_freq)
	return ""

/atom/movable/proc/say_quote(var/text)
	if(!text)
		return "says, \"...\""	//not the best solution, but it will stop a large number of runtimes. The cause is somewhere in the Tcomms code
	var/ending = copytext(text, length(text))
	if (ending == "?")
		return "asks, \"[text]\""
	if (ending == "!")
		return "exclaims, \"[text]\""

	return "says, \"[text]\""
/////////В этой функции мы проверяем язык и уродуем сообщение, если не говорим на этом языке. Если язык = null, то это значит, что говорит какой-либо автомат или еще какая хуйня.
/atom/movable/proc/lang_treat(atom/movable/speaker, datum/language/message_langs, raw_message, verb_need = 1)
	if(!message_langs || !istype(message_langs))
		message_langs = all_languages["Galactic Common"]
	var/message = raw_message
	if(!can_speak_lang(message_langs))
		message = stars(raw_message)
	return "[verb_need ? (message_langs.get_spoken_verb(speaker, copytext(raw_message, length(raw_message))) + ", ") : ""]\"<span class='[message_langs.colour]'>[message]</span>\""
/proc/get_radio_span(freq)
	var/returntext = freqtospan["[freq]"]
	if(returntext)
		return returntext
	return "radio"

/proc/get_radio_name(freq)
	var/returntext = radiochannelsreverse["[freq]"]
	if(returntext)
		return returntext
	return "[copytext("[freq]", 1, 4)].[copytext("[freq]", 4, 5)]"

/atom/movable/proc/GetVoice()
	return name

/atom/movable/proc/IsVocal()
	return 1

/atom/movable/proc/get_alt_name()
	return

//these exist mostly to deal with the AIs hrefs and job stuff.
/atom/movable/proc/GetJob()
	return

/atom/movable/proc/GetTrack()
	return

/atom/movable/proc/GetSource()
	return

/atom/movable/proc/GetRadio()

/atom/movable/virtualspeaker
	var/job
	var/faketrack
	var/atom/movable/source
	var/obj/item/device/radio/radio

/atom/movable/virtualspeaker/GetJob()
	return job

/atom/movable/virtualspeaker/GetTrack()
	return faketrack

/atom/movable/virtualspeaker/GetSource()
	return source

/atom/movable/virtualspeaker/GetRadio()
	return radio
