class Interest {
  Interest({
    this.name,
    this.displayOrder,
    this.id,
    this.isSelected = false,
  });

  String? name;
  int? displayOrder;
  int? id;

  bool isSelected;

  factory Interest.fromJson(Map<String, dynamic> json) => Interest(
        name: json["name"],
        displayOrder: json["displayOrder"],
        id: json["id"],
      );
}
