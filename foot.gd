extends Node2D

class_name Foot


@export var skeleton: Skeleton2D
@export var rest_target: Node2D

@export var bone1: Bone2D
@export var bone2: Bone2D

@export var flip_direction: bool = false

@export var move_speed: float = 1000.0
@export_range(0.1, 40.0) var move_want_threshold = 30.0
@export_range(30.0, 60.0) var move_need_threshold = 35.0
@export_range(0.0, 0.99) var move_step_overshoot = 0.9

var target: Node2D

func _ready() -> void:
	target = Node2D.new()
	target.top_level = true
	target.global_transform = rest_target.global_transform
	add_child(target)

	var sms := skeleton.get_modification_stack()
	if sms == null:
		sms = SkeletonModificationStack2D.new()
	var ik_mod := SkeletonModification2DTwoBoneIK.new()
	ik_mod.target_nodepath = target.get_path()
	ik_mod.set_joint_one_bone_idx(bone1.get_index_in_skeleton())
	ik_mod.set_joint_two_bone_idx(bone2.get_index_in_skeleton())
	ik_mod.flip_bend_direction = flip_direction
	ik_mod.enabled = true
	sms.add_modification(ik_mod)
	sms.enabled = true
	skeleton.set_modification_stack(sms)

var tween: Tween


func _get_rest_distance() -> float:
	return target.global_position.distance_to(rest_target.global_position)

func do_move():
	var dst := _get_rest_distance()
	var speed := move_speed
	speed *= min(1.0, dst / move_want_threshold)
	var target_pos := rest_target.global_position
	target_pos += (target_pos - target.global_position).normalized() * move_want_threshold * move_step_overshoot
	tween = get_tree().create_tween()
	tween \
		.tween_property(
			target,
			"global_position",
			target_pos,
			dst / move_speed
		) \
		.set_ease(Tween.EASE_IN_OUT)

func is_moving() -> bool:
	return tween != null and tween.is_running()

func wants_move() -> bool:
	return _get_rest_distance() > move_want_threshold

func needs_move() -> bool:
	return _get_rest_distance() > move_need_threshold

func _draw() -> void:
	draw_circle(to_local(rest_target.global_position), 5, Color.RED)
	draw_line(to_local(rest_target.global_position), to_local(target.global_position), Color.RED, 2.0)
	queue_redraw()
