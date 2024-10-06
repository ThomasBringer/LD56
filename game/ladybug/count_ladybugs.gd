extends Label

var count: int = 0
var total: int

func _ready() -> void:
	var ladybugs = get_tree().get_nodes_in_group("ladybug")
	total = ladybugs.size()
	update_text()
	for ladybug in ladybugs:
		ladybug.getbug.connect(on_collect_ladybug)

func on_collect_ladybug() -> void:
	count += 1
	update_text()

func update_text():
	text = str(count)+"/"+str(total)
