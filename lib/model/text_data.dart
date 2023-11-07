class TextDataModel {
  TextDataModel({
    this.file,
    this.text,
  });

  late final String? file;
  late final String? text;

  TextDataModel.fromJson(Map<String, dynamic> json) {
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
