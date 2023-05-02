class Blog {
  final int? id;
  final String title;
  final String description;
  //final String image;

  const Blog(
      {required this.title,
      required this.description,
      //required this.image,
      this.id});

  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        //image: json['image'],
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        //'image': image,
      };
}
