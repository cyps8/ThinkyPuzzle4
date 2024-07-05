extends Area2D

class_name Player

static var ins: Player

var targetPosition: Vector2

var moving = false

var goingDown = false

var falling = false

var fallDistance = 0

var resetPos: Vector2

func _init():
	ins = self

func _ready():
	targetPosition = position
	resetPos = position

signal Reset

func _process(_dt):
	if moving:
		if fallingAnim:
			$Sprite.rotation -= 15 * _dt
		return
	else:
		$Sprite.rotation = 0
	if falling:
		Fall()
		return

	var move = WASDMove()
	if !move:
		move = ArrowMove()
	if !move && Input.is_action_just_pressed("Interact"):
		Interact()
	if !move && Input.is_action_just_pressed("Reset"):
		ResetRN()
	if move and !CheckForCollision():
		moving = true
		var tween: Tween = create_tween()
		tween.tween_property(self, "position", targetPosition, 0.45).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_callback(func(): moving = false)

func ResetRN():
	position = resetPos
	emit_signal("Reset")

	if fallTween:
		fallTween.kill()
		moving = false
		falling = false
		fallingAnim = false

	get_tree().get_first_node_in_group("Fell").visible = false

var fallingAnim = false
var fallTween: Tween

func Fall():
	fallingAnim = true
	moving = true
	falling = false
	fallTween = create_tween()
	FindFallTarget()
	fallTween.tween_property(self, "position", targetPosition, 0.2 * fallDistance)
	fallTween.tween_callback(func(): moving = false)
	fallTween.tween_callback(func(): fallingAnim = false)

func FindFallTarget():
	var space_state = get_world_2d().direct_space_state
	var targetFound = false
	var currentCheck = position
	fallDistance = 0
	while !targetFound:
		currentCheck.y += 20
		fallDistance += 1
		var query = PhysicsPointQueryParameters2D.new()
		query.position = currentCheck
		var result = space_state.intersect_point(query)
		if result.size() == 2:
			targetFound = true
		if fallDistance > 100 || result.size() > 2:
			targetFound = true
			targetPosition = currentCheck
			var tween: Tween = create_tween()
			get_tree().get_first_node_in_group("Fell").visible = true
			tween.tween_interval(1.5)
			tween.tween_callback(func(): ResetRN())
	targetPosition = currentCheck

func CheckForCollision():
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = targetPosition
	var result = space_state.intersect_point(query)
	if result.size() <= 1:
		falling = true
		return false
	return !result.size() == 2

func WASDMove() -> bool:
	if Input.is_action_pressed("Up"):
		targetPosition = Vector2(position.x, position.y - 20)
		goingDown = false
	elif Input.is_action_pressed("Down"):
		targetPosition = Vector2(position.x, position.y + 20)
		goingDown = true
	elif Input.is_action_pressed("LUp"):
		targetPosition = Vector2(position.x - 17, position.y - 10)
		goingDown = false
		$Sprite.flip_h = true
		$Sprite.rotation = 0.5
	elif Input.is_action_pressed("RUp"):
		targetPosition = Vector2(position.x + 17, position.y - 10)
		goingDown = false
		$Sprite.flip_h = false
		$Sprite.rotation = -0.5
	elif Input.is_action_pressed("LDown"):
		targetPosition = Vector2(position.x - 17, position.y + 10)
		goingDown = true
		$Sprite.flip_h = true
		$Sprite.rotation = -0.5
	elif Input.is_action_pressed("RDown"):
		targetPosition = Vector2(position.x + 17, position.y + 10)
		goingDown = true
		$Sprite.flip_h = false
		$Sprite.rotation = 0.5
	else:
		return false
	return true

func ArrowMove() -> bool:
	if Input.is_action_pressed("ArrowUp"):
		goingDown = false
		if Input.is_action_pressed("ArrowLeft"):
			targetPosition = Vector2(position.x - 17, position.y - 10)
			$Sprite.flip_h = true
		elif Input.is_action_pressed("ArrowRight"):
			targetPosition = Vector2(position.x + 17, position.y - 10)
			$Sprite.flip_h = false
		else:
			targetPosition = Vector2(position.x, position.y - 20)
	elif Input.is_action_pressed("ArrowDown"):
		goingDown = true
		if Input.is_action_pressed("ArrowLeft"):
			targetPosition = Vector2(position.x - 17, position.y + 10)
			$Sprite.flip_h = true
		elif Input.is_action_pressed("ArrowRight"):
			targetPosition = Vector2(position.x + 17, position.y + 10)
			$Sprite.flip_h = false
		else:
			targetPosition = Vector2(position.x, position.y + 20)
	else:
		return false
	return true

var areas: Array

func AddArea(area: Area2D):
	areas.append(area)
	if area.is_in_group("Save"):
		if resetPos != area.position:
			get_tree().get_first_node_in_group("Checkpoint").visible = true
			var tween:Tween = create_tween()
			tween.tween_interval(1.5)
			tween.tween_callback(func(): get_tree().get_first_node_in_group("Checkpoint").visible = false)
		resetPos = area.position
	else:
		get_tree().get_first_node_in_group("Interact").visible = true

func RemoveArea(area: Area2D):
	areas.erase(area)
	get_tree().get_first_node_in_group("Interact").visible = false

func Interact():
	if areas.size() == 0:
		return

	if areas[0] is ZiplineEnd:
		targetPosition = areas[0].zipline.ZipFromEnd(areas[0])
		if targetPosition != position:
			moving = true
			var tween: Tween = create_tween()
			tween.tween_property(self, "position", targetPosition, position.distance_to(targetPosition) * 0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
			tween.tween_callback(func(): moving = false)
			var rotationTween: Tween = create_tween()
			rotationTween.tween_property($Sprite, "rotation", 0.3, position.distance_to(targetPosition) * 0.005).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			rotationTween.tween_property($Sprite, "rotation", 0.0, position.distance_to(targetPosition) * 0.005).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			rotationTween.tween_callback(func(): $Sprite.rotation = 0)

	elif areas[0] is Lever:
		print("Pressed")
		areas[0].Pressed()
		moving = true
		var tween: Tween = create_tween()
		tween.tween_interval(1)
		tween.tween_callback(func(): moving = false)
