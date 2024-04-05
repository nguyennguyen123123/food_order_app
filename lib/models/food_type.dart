class FoodType {
  final String typeId;
  final String? name;
  final String? description;
  final String? image;
  final String? createdAt;

  FoodType({
    required this.typeId,
    this.name,
    this.description,
    this.image,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'typeId': typeId,
      'name': name,
      'description': description,
      'image': image,
      'created_at': createdAt,
    };
  }

  Map toMap(FoodType food) {
    var data = Map<String, dynamic>();
    data['typeId'] = food.typeId;
    data['name'] = food.name;
    data['description'] = food.description;
    data['image'] = food.image;
    data['created_at'] = food.createdAt;
    return data;
  }

  factory FoodType.fromMap(
    Map<dynamic, dynamic> mapData,
  ) {
    return FoodType(
      typeId: mapData['typeId'],
      name: mapData['name'],
      description: mapData['description'],
      image: mapData['image'],
      createdAt: mapData['created_at'],
    );
  }
}
