class ObjectData {
  late final String? file;
  late final List<String>? objects;

  ObjectData({this.file, this.objects});

  factory ObjectData.fromJson(Map<String, dynamic> json) {
    return ObjectData(
      file: json['file'],
      objects: List<String>.from(json['objects'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file': file,
      'labels': objects,
    };
  }
}
