extends Node3D


const FLOOR = preload("res://scenes/assets/floors/floor_tile_extralarge_grates.tscn")
const WALL = preload("res://scenes/assets/walls/wall.tscn")
const CHEST = preload("res://scenes/assets/level_complition/chest_gold.tscn")

enum CellTypes {
	VISITED,
	UNVISITED
}

enum QueueStatus {
	FULL,
	NORMAL,
	EMPTY
}


class Queue:
	var array: Array
	var head: int
	var tail: int
	var size: int
	var status: QueueStatus
	
	func _init(_size: int) -> void:
		self.head = 0
		self.tail = 0
		self.size = _size
		self.status = QueueStatus.EMPTY

	func isFull() -> bool:
		if self.status == QueueStatus.FULL:
			return true
		elif self.size == len(self.array) and (self.tail == self.head - 1 or self.head == 0):
			self.status = QueueStatus.FULL
			return true
		else:
			return false

	func push(obj) -> void:
		if self.isEmpty():
			self.status = QueueStatus.NORMAL
		elif self.isFull():
			print("Очередь переполнена.")
			return
		
		self.array.append(obj)
		self.tail = (self.tail + 1) % self.size
		
		self.isFull()

	func push_array(arr: Array) -> void:
		if arr.is_empty():
			return
		
		for elm in arr:
			self.push(elm)

	func pop() -> Object:
		if self.isFull():
			self.status = QueueStatus.NORMAL
		elif self.isEmpty():
			print("Очередь пуста.")
			return null
		
		var temp = array[self.head]
		self.head = (self.head + 1) % self.size
		
		self.isEmpty()
		
		return temp


	func isEmpty() -> bool:
		if self.status == QueueStatus.EMPTY:
			return true
		elif array.is_empty() or self.tail == self.head:
			self.status = QueueStatus.EMPTY
			return true
		else:
			return false

class Cell:
	var borders: int
	var coords: Vector2i
	
	var mark: CellTypes
	
	func _init(_coords: Vector2i) -> void:
		self.borders = 0b1111
		self.coords = _coords
		self.mark = CellTypes.UNVISITED
		
	func mark_as_visited() -> void:
		self.mark = CellTypes.VISITED
		
	func is_visited() -> bool:
		return mark == CellTypes.VISITED
		
	func border_exist(number: int) -> bool:
		return self.borders & [0b1, 0b10, 0b100, 0b1000][number]
		
	func remove_borders(bit_num: int) -> void:
		self.borders &= ~bit_num


class Field:
	var size: Vector2i
	var array: Array[Cell]
	
	func _init(_size: Vector2i) -> void:
		self.size = _size
		
		for i in range(_size.x):
			for j in range(_size.y):
				self.array.append(Cell.new(Vector2i(i, j)))
				
	func get_cell(coords: Vector2i) -> Cell:
		return array[coords.y * size.y + coords.x]
		
	func cell_exist(coords: Vector2i) -> bool:
		return 0 <= coords.x and coords.x < size.x and 0 <= coords.y and coords.y < size.y
		
	func get_childs(parent: Cell) -> Array:
		var result = []
		var child_coords: Vector2i
		
		for k in range(4):
			child_coords = [Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, -1), Vector2i(-1, 0)][k] + parent.coords
			
			if not parent.border_exist(k) and self.cell_exist(child_coords):
				result.append(self.get_cell(child_coords))
				
		return result
		
	func get_unvisited_childs(parent: Cell) -> Array:
		var arr = get_childs(parent)

		return arr.filter(func(elm: Cell): return not elm.is_visited())


class Maze extends Field:
	var start: Vector2i
	var finish: Vector2i
	
	func _init(_size: Vector2i, _start: Vector2i) -> void:
		super(_size)
		self.start = _start
		self._make_maze()
		
	func _rand_remove_borders_bit_num() -> int:
		return randi_range(0b0, 0b1111)
		
	func _make_maze() -> void:
		var childs: Array
		var this: Cell
		var queue: Queue = Queue.new(self.size.x * self.size.y)
		queue.push(self.get_cell(self.start))
		
		while not queue.isEmpty():
			this = queue.pop()
			
			this.mark_as_visited()
			this.remove_borders(_rand_remove_borders_bit_num())
			
			childs = self.get_unvisited_childs(this)
			print(childs)
			queue.push_array(childs)
			
		self.finish = this.coords


func generate_maze(position: Vector3) -> void:
	var size: Vector2i = Vector2i(10, 10)
	var maze: Maze = Maze.new(size, Vector2i(1, 1))
	var floor: Node3D
	
	for i in range(size.x):
		for j in range(size.y):
			floor = FLOOR.instantiate()
			add_child(floor)
			floor.global_position = Vector3(i, 0, j) * 8 + Vector3(4, 0, 4)
	
	var offset: Vector3
	var rotation: float
	var wall: Node3D
	
	for k in range(4):
		offset = [Vector3(1, 0, 4), Vector3(4, 0, 1), Vector3(7, 0, 4), Vector3(4, 0, 7)][k]
		rotation = [PI / 2, 0, PI / 2, 0][k]
		
		for cell in maze.array:
			print(cell.borders)
			if cell.border_exist(k):
				wall = WALL.instantiate()
				add_child(wall)
				
				wall.global_position = Vector3(cell.coords.x, 0, cell.coords.y) * 8 + offset
				wall.rotate_y(rotation)
	
	var finish = maze.finish
	var chest = CHEST.instantiate()
	add_child(chest)
	chest.global_position = Vector3(finish.x, 0, finish.y) * 8 + Vector3(4, 0, 4)


func _init() -> void:
	generate_maze(Vector3(0, 0, 0,))
