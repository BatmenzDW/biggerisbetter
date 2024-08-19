extends Resource
class_name BuildingUpgradeCostResource

@export var name: String

@export var level : int = 2

@export var new_texture : Texture

@export_category("UpgradeCost")

@export var oil := 0
@export var metal := 0
@export var crystal := 0
@export var funds := 0

@export_category("Production")

@export var prodCost : ProdCostResource

@export_category("Defenses")

@export var damage: int

@export_category("Rockets")

@export var load_percent : float
@export var load_speed : float
@export var max_load : float
