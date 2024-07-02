extends Area2D

class_name Player

var targetPosition: Vector2

var moving = false

func _ready():
    targetPosition = position

func _process(_dt):
    if !moving:
        var move = true
        if Input.is_action_pressed("Up"):
            targetPosition = Vector2(position.x, position.y - 20)
        elif Input.is_action_pressed("Down"):
            targetPosition = Vector2(position.x, position.y + 20)
        elif Input.is_action_pressed("LUp"):
            targetPosition = Vector2(position.x - 17, position.y - 10)
        elif Input.is_action_pressed("RUp"):
            targetPosition = Vector2(position.x + 17, position.y - 10)
        elif Input.is_action_pressed("LDown"):
            targetPosition = Vector2(position.x - 17, position.y + 10)
        elif Input.is_action_pressed("RDown"):
            targetPosition = Vector2(position.x + 17, position.y + 10)
        else:
            move = false
        if move and !CheckForCollision():
            moving = true
            var tween: Tween = create_tween()
            tween.tween_property(self, "position", targetPosition, 0.45).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
            tween.tween_callback(func(): moving = false)

func CheckForCollision():
    var space_state = get_world_2d().direct_space_state
    var query = PhysicsPointQueryParameters2D.new()
    query.position = targetPosition
    var result = space_state.intersect_point(query)
    return !result.size() == 2