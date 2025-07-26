extends AudioStreamPlayer2D

var wanderingKnight = preload("res://assets/music/The Wandering Knights Ballad.mp3")
var dancingNymph = preload("res://assets/music/The Dancing Nymph.mp3")
var fondMemories = preload("res://assets/music/Fond Memories.mp3")
var brokenTankard = preload("res://assets/music/Broken Tankard.mp3")
var walkThroughTheSquare = preload("res://assets/music/Walk Through The Square.mp3")


func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	stream = music
	volume_db = volume
	play()

func _play_main_music(song):
	if song == "wanderingKnight":
		_play_music(wanderingKnight)
	elif song == "dancingNymph":
		_play_music(dancingNymph)
	elif song == "fondMemories":
		_play_music(fondMemories)
	elif song == "brokenTankard":
		_play_music(brokenTankard)
	elif song == "walkThroughTheSquare":
		_play_music(walkThroughTheSquare)
