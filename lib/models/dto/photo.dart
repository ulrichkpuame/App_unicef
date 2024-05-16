class Photo {
  String? id;
  String? photoName;

  Photo({
    required this.id,
    required this.photoName,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      photoName: json['photoName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['photoName'] = photoName;
    return data;
  }
}
