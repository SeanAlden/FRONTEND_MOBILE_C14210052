  class Category {
    final int id; // id kategori
    final String name; // nama kategori
    final String code; // kode kategori
    final String? description; // deskripsi kategori

    Category({
      required this.id, 
      required this.name, 
      required this.code, 
      this.description
    });

    // mengambil data dengan API call
    factory Category.fromJson(Map<String, dynamic> json) {
      return Category(
        id: json['id'], 
        name: json['name'], 
        code: json['code'], 
        description: json['description'], 
      );
    }
  }