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
        return
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

func Fall():
    moving = true
    falling = false
    var tween: Tween = create_tween()
    FindFallTarget()
    tween.tween_property(self, "position", targetPosition, 0.2 * fallDistance)
    tween.tween_callback(func(): moving = false)

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
        if fallDistance > 100:
            targetFound = true
            currentCheck = position
    targetPosition = currentCheck

func CheckForCollision():
    var space_state = get_world_2d().direct_space_state
    var query = PhysicsPointQueryParameters2D.new()
    query.position = targetPosition
    var result = space_state.intersect_point(query)
    if result.size() <= 1 && goingDown:
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
    elif Input.is_action_pressed("RUp"):
        targetPosition = Vector2(position.x + 17, position.y - 10)
        goingDown = false
        $Sprite.flip_h = false
    elif Input.is_action_pressed("LDown"):
        targetPosition = Vector2(position.x - 17, position.y + 10)
        goingDown = true
        $Sprite.flip_h = true
    elif Input.is_action_pressed("RDown"):
        targetPosition = Vector2(position.x + 17, position.y + 10)
        goingDown = true
        $Sprite.flip_h = false
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
        resetPos = area.position

func RemoveArea(area: Area2D):
    areas.erase(area)

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
    elif areas[0] is Lever:
        print("Pressed")
        areas[0].Pressed()
        moving = true
        var tween: Tween = create_tween()
        tween.tween_interval(1)
        tween.tween_callback(func(): moving = false)
