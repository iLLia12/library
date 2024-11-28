extends Node2D

var is_dragging = false
var start_position: Vector2
var end_position: Vector2

var collision_results = []

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Start dragging
				start_position = get_global_mouse_position()
				is_dragging = true
			else:
				# Stop dragging
				is_dragging = false
				check_collisions_in_rectangle()
				queue_redraw()  # Trigger a redraw to clear the rectangle
	elif event is InputEventMouseMotion and is_dragging:
		# Update the end position as the mouse moves
		end_position = get_global_mouse_position()
		queue_redraw()  # Redraw the rectangle

func _draw():
	if is_dragging:
		# Ensure the rectangle is drawn in any drag direction
		var rect_position = Vector2(
			min(start_position.x, end_position.x),
			min(start_position.y, end_position.y)
		)
		var rect_size = Vector2(
			abs(end_position.x - start_position.x),
			abs(end_position.y - start_position.y)
		)
		var rect = Rect2(rect_position, rect_size)
		draw_rect(rect, Color(0, 0, 1, 0.3), true)  # Semi-transparent blue rectangle
		draw_rect(rect, Color(0, 0, 1), false)     # Blue outline

func check_collisions_in_rectangle():
	collision_results.clear()  # Reset previous results

	# Calculate rectangle properties
	var rect_position = Vector2(
		min(start_position.x, end_position.x),
		min(start_position.y, end_position.y)
	)
	var rect_size = Vector2(
		abs(end_position.x - start_position.x),
		abs(end_position.y - start_position.y)
	)
	var rect_center = rect_position + rect_size / 2

	# Create a rectangle shape for the query
	var shape = RectangleShape2D.new()
	shape.extents = rect_size / 2  # RectangleShape2D uses half-extents

	# Configure the physics query
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = Transform2D(0, rect_center)

	# Perform the query
	var space_state = get_world_2d().direct_space_state
	collision_results = space_state.intersect_shape(query, 32)  # Limit to 32 results
	print("Collisions detected:", collision_results.size())
	print("Collisions detected:", collision_results)

