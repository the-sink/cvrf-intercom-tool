extends Control

onready var input_box = $TextEdit
onready var player = $IntercomPlayer

var intercom_words = []
var effect
var record
var playing = false

var root = OS.get_executable_path() + "\\..\\"
var directory = Directory.new()

var loginDelay = 0.5
var separatorDelay = 0.2

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and not ".import" in file:
			files.append(file)

	dir.list_dir_end()

	return files

func _ready():
	effect = AudioServer.get_bus_effect(AudioServer.get_bus_index("Record"), 0)
	var word_array = list_files_in_directory(OS.get_executable_path() + "/../IntercomAssets/")
	for word in word_array:
		var word_processed = word.replace(".wav","")
		print(word_processed)
		intercom_words.append(word_processed)
		input_box.add_keyword_color(word_processed, Color(0,1,0))
	input_box.add_color_region(":"," ",Color(1,0,1))

func play_sound(path):
	player.set_stream(load(path))
	player.play()
	return player.get_stream().get_length()

func set_status():
	$PreviewButton.disabled = true
	$RecordButton.disabled = true
	if effect.is_recording_active():
		$Status.text = "Recording..."
	else:
		$Status.text = "Playing..."

func execute_announcement():
	playing = true
	set_status()
	var Folder = OS.get_executable_path() + "\\..\\IntercomAssets\\"
	var words_for_broadcast = input_box.text.split(" ", false)
	for word in words_for_broadcast:
		var find = intercom_words.find(word)
		if find == -1:
			words_for_broadcast.remove(find)
	if $CheckBox.pressed == true:
		var length = play_sound(Folder + "_login_emergency.wav")
		yield(get_tree().create_timer(length + loginDelay), "timeout")
	else:
		var length = play_sound(Folder + "_login_normal.wav")
		yield(get_tree().create_timer(length + loginDelay), "timeout")
	for word in words_for_broadcast:
		var extraDelay = false
		var play = true
		if not word.find(":") == -1:
			word = word.replace(":","")
			extraDelay = true
		if word == "":
			play = false
		if play == true: 
			var length = play_sound(Folder+word+".wav")
			if extraDelay == true:
				length += separatorDelay
			yield(get_tree().create_timer(length), "timeout")
		else:
			yield(get_tree().create_timer(separatorDelay), "timeout")
	playing = false

func _on_PreviewButton_pressed():
	if not playing:
		yield(execute_announcement(), "completed")
		$RecordButton.disabled = false
		$PreviewButton.disabled = false
		$Status.text = "Ready"


func _on_RecordButton_pressed():
	if not effect.is_recording_active() and not playing:
		effect.set_recording_active(true)
		yield(execute_announcement(), "completed")
		effect.set_recording_active(false)
		record = effect.get_recording()
		var data = record.get_data()
		var saveName = ""
		if $FileName.text == "File Name":
			saveName = str(OS.get_unix_time()) + ".wav"
		else:
			saveName = $FileName.text.substr(0, 60) + ".wav"
		directory.open(root)
		directory.make_dir("Recordings")
		record.save_to_wav(root + "Recordings\\" + saveName)
		$Status.text = "Saved: Recordings\\" + saveName
		yield(get_tree().create_timer(2), "timeout")
		$RecordButton.disabled = false
		$PreviewButton.disabled = false
		$Status.text = "Ready"
		$RecordButton.text = "Record To File"
		$IntercomPlayer.stream = record

# logic for audio and recording settings

func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_FileName_focus_entered():
	if $FileName.text == "File Name":
		$FileName.text = ""


func _on_FileName_focus_exited():
	if $FileName.text == "":
		$FileName.text = "File Name"


func _on_LoginDelay_focus_exited():
	if $LoginDelay.text == "":
		$LoginDelay.text = str(loginDelay)
	loginDelay = float($LoginDelay.text)


func _on_SeparatorDelay_focus_exited():
	if $SeparatorDelay.text == "":
		$SeparatorDelay.text = str(separatorDelay)
	separatorDelay = float($SeparatorDelay.text)
