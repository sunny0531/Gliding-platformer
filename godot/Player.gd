extends CharacterBody2D


@export var max_speed = 330.0
@export var acceleration=100
@export var jump_strength = -220.0
@export var boost_strength=-300
@export var terminal_velocity=500
var default_ground_deceleration:float=100
var ground_deceleration:=default_ground_deceleration
var gliding_deceleration:=70
var jumped=false
var boosted=false
var boosting=false
var gliding=false
var gravity:float
var gliding_gravity:float

func _ready():
	gravity=get_node("../Environment").get("gravity")
	gliding_gravity=get_node("../Environment").get("gliding_gravity")	
func _physics_process(delta):
	apply_gravity(delta)
	jump_and_glide(delta)
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x,max_speed*direction, acceleration)
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, ground_deceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, gliding_deceleration)
	move_and_slide()
func jump_and_glide(delta):
	var on_floor:bool=is_on_floor()
	if on_floor:
		boosted=false
		jumped=false
		gliding=false
		boosting=false
	if gliding and Input.is_action_just_pressed("ui_accept"):
		gliding=false
		boosting=false
	elif Input.is_action_just_pressed("ui_accept") and on_floor and not jumped and not gliding:
		velocity.y=jump_strength
		self.jumped=true
	elif Input.is_action_just_pressed("ui_accept") and not on_floor and jumped:
		if not boosted or boosting:
			velocity.y=move_toward(velocity.y,velocity.y+boost_strength,170)
			boosted=true
			boosting=true
		gliding=true
	
	elif Input.is_action_just_pressed("ui_accept") and not on_floor and not jumped and not gliding:
		velocity.y=0
		gliding=true


func apply_gravity(delta):
	var on_floor:bool=is_on_floor()
	if not on_floor and not gliding:
		velocity.y = move_toward(velocity.y,terminal_velocity,gravity)
	elif not on_floor and gliding:
		velocity.y = move_toward(velocity.y,terminal_velocity,gliding_gravity)
	



func _reset(body):
	if body==self:
		await get_tree().create_timer(0.5).timeout
		self.position=Vector2(64,568)


func _on_area_2d_body_entered(body):
	
	var d=body.get("deceleration")
	if d != null:
		ground_deceleration=d
	else:
		ground_deceleration=default_ground_deceleration
