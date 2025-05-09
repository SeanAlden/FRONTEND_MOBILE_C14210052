  class Category {
    final int id;
    final String name;
    final String code;
    final String? description;

    Category({
      required this.id, 
      required this.name, 
      required this.code, 
      this.description
    });

    factory Category.fromJson(Map<String, dynamic> json) {
      return Category(
        id: json['id'],
        name: json['name'],
        code: json['code'],
        description: json['description'],
      );
    }
  }