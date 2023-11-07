class DataModel {
  DataModel({
    this.file,
    this.text,
  });

  late final String? file;
  late final String? text;

  DataModel.fromJson(Map<String, dynamic> json) {
    file = json['file'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': file,
      'text': text,
    };
  }
}
