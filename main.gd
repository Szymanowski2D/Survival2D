extends Node

@export var mob_scene: PackedScene
@export var bullet_scene: PackedScene
var score
var life

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hit() -> void:
	$HUD.update_life($Player.life)

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$BulletTimer.stop()
	$HUD.show_game_over()
	$HUD.update_life($Player.life)
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	score = 0;
	life = 3;
	$Player.start($StartPosition.position, life)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.update_life(life)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	var direction = mob_spawn_location.rotation + PI / 2
	
	mob.position = mob_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
	
func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$BulletTimer.start()
	$ScoreTimer.start()

func _on_bullet_timer_timeout() -> void:
	var position = $Player.position
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	
	var mouse = get_viewport().get_mouse_position();
	
	var velocity = (mouse - position).normalized()
	bullet.linear_velocity = velocity * 1000
	
	add_child(bullet)
