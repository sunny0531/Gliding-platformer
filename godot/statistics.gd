extends RichTextLabel

@onready var player=self.get_node("../Player")
var _time:float = 0.0
var best_time:=0

var formatting="""Timer: {timer}
Best time: {best}
x: {x}
y: {y}
jumped: {jumped}
boosted: {boosted}
boosting: {boosting}
gliding: {gliding}
ground deceleration: {ground_deceleration}
"""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_time += delta as float
	
	var velocity=player.get("velocity")
	self.text=formatting.format({"ground_deceleration":player.get("ground_deceleration"),"timer":format_time(_time),"best":format_time(best_time),"x":velocity.x,"y":velocity.y,"jumped": player.get("jumped"),"boosted": player.get("boosted"),"boosting":player.get("boosting"),"gliding": player.get("gliding")})


func format_time(ptime:float):
	var minutes := ptime / 60
	var seconds := fmod(ptime, 60)
	var time="%02d:%02d"%[minutes,seconds]
	return time


func _on_portal_body_entered(body):
	if _time<best_time or best_time==0:
		best_time=_time
	_time=0
	await get_tree().create_timer(0.5).timeout
	_time=0
