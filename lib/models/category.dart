class Category {
  Category({
    this.isActive,
    this.subCategories,
    this.name,
    this.displayOrder,
    this.id,
  });

  bool? isActive;
  List<dynamic>? subCategories;
  String? name;
  int? displayOrder;
  int? id;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        isActive: json["isActive"],
        subCategories: List<dynamic>.from(json["subCategories"].map((x) => x)),
        name: json["name"],
        displayOrder: json["displayOrder"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "isActive": isActive,
        "subCategories": List<dynamic>.from(subCategories!.map((x) => x)),
        "name": name,
        "displayOrder": displayOrder,
        "id": id,
      };
}
