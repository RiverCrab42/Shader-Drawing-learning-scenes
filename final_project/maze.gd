extends Node3D

class QueueNode:
	var ptr: int
	var object
	
	func _init(ptr: int, obj) -> void:
		ptr = ptr
		object = obj


class Queue:
	var array: Array[QueueNode]
	var top
	var min_index
	
	func _init() -> void:
		top = 0
		min_index = 0
	
	func push(obj) -> void:
		var node = array.back()
		node.ptr = min_index
		
		if min_index == len(array):
			array.append(QueueNode.new(0, obj))
			min_index += 1
		else:
			array[min_index] = QueueNode.new(0, obj)
			
			if min_index + 1 == top:
				min_index += 1
			else:
				min_index = len(array)
		
	func pop() -> Object:
		var temp = array[top].object
		
		array[top] = null
		min_index = top
		
		top += 1
		
		return temp
		
	func isEmpty() -> bool:
		return array[top] == null
	

class Cell:
	static var number_in_row: int
	
	var index: int
	var borders: Array
	var coords: Vector2i
	
	func _init(coords: Vector2i) -> void:
		borders = [true, true, true, true]
		coords = coords
		index = from_coords_to_index(coords)
		
	static func from_coords_to_index(coords: Vector2i) -> int:
		return coords.x * number_in_row + coords.y
		
func create_maze_map(size: Vector2i) -> Array[Cell]:
	Cell.number_in_row = size.x
	
	var array: Array[Cell] = []
	var elm: Cell
	
	for i in range(size.x):
		for j in range(size.y):
			elm = Cell.new(Vector2i(i, j))
			array[elm.index] = elm
			
	return array
	
func make_tree(array: Array[Cell], start: int):
	var queue: Queue
	var tree_root: GraphNode
	
	queue.push(array[start])
	
	# TODO
	

func generate_maze() -> Array[Cell]:
	return create_maze_map(Vector2i(10, 10))
			
