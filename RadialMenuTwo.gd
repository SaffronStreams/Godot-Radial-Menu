extends Node2D


var circleCenter = Vector2(300,300)
var outerCircleRadius = 250
var innerCircleRadius = 50
var circleColor = Color(.5,.5,.5,1)
var arcColor = Color(.12, .12, .12, 1)
var selectedColor = Color(.36, .36, .36, 1)

var sections = 5

var xAxisR = 0
var yAxisR = 0
var deadZone = 0.2

var selectedAngle = 0
var selectedSection : int

#var readoutTimer = 0


func _process(delta):
	#For testing, allows you to adjust number of sections
	if Input.is_action_just_pressed("ui_right"):
		if sections < 12:
			sections +=1
	if Input.is_action_just_pressed("ui_left"):
		if sections > 1:
			sections -= 1
			
	#If controller is connected, read out position of R Stick (2 and 3 are its x and y axis)
	if Input.get_connected_joypads().size()>0:
		xAxisR = Input.get_joy_axis(0,JOY_AXIS_2)
		yAxisR = Input.get_joy_axis(0, JOY_AXIS_3)
#		readoutTimer += delta
#		if readoutTimer > 1:
#			readoutTimer = 0
#			print("Sticks: (" + str(xAxisR) + ", " + str(yAxisR) +")")
		if abs(xAxisR) > deadZone|| abs(yAxisR) > deadZone:
			selectedAngle = rad2deg(Vector2(xAxisR, yAxisR).angle_to(Vector2(0,-1)))
#			print(selectedAngle)
			if selectedAngle < 0:
				selectedAngle =  - selectedAngle
			else:
				selectedAngle = 360 - selectedAngle
		
			selectedSection = selectedAngle /(360/sections)
	update()
	pass
	
func _draw():
	draw_circle(circleCenter,outerCircleRadius, circleColor)
	for i in sections:
		if i == selectedSection:
			draw_circle_arc_poly(circleCenter,outerCircleRadius-5, i* (360.0 \
			/sections) , (i+1) * (360.0  /sections),  selectedColor )
		else:
			draw_circle_arc_poly(circleCenter,outerCircleRadius-5, i* (360.0 \
			/sections) , (i+1) * (360.0  /sections),  arcColor )
	draw_circle(circleCenter,innerCircleRadius, circleColor)
	draw_lines()
	
func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points =32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])
	
	for i in range(nb_points +1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
			
	draw_polygon(points_arc, colors)
	
func draw_lines() -> void:
	for i in sections:
		draw_line(circleCenter,Vector2(0, -outerCircleRadius).rotated(deg2rad(360.0/sections *i))+ \
		circleCenter,circleColor,2.0,false)
