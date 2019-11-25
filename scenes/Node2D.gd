extends Node2D

func _draw():
    var cen = Vector2(25, 25)
    var rad = 20
    var col = Color(0, 0, 1)
    draw_circle (cen, rad, col)
    col = Color(1, 0, 0)
    var rect = Rect2(Vector2(50, 50),Vector2(50, 50))
    draw_rect(rect, col)