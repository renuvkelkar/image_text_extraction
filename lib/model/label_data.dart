// class LabelDataModel {
//   LabelDataModel({
//     this.file,
//     this.labels,
//   });

//   late final String? file;
//   late final List<String>? labels;

//   LabelDataModel.fromJson(Map<String, dynamic> json) {
//     file = json['file'];
//     labels = json['labels'];
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'name': file,
//       'labels': labels,
//     };
//   }
// }

class LabeledImage {
  late final String? file;
  late final List<String>? labels;

  LabeledImage({this.file, this.labels});

  factory LabeledImage.fromJson(Map<String, dynamic> json) {
    return LabeledImage(
      file: json['file'],
      labels: List<String>.from(json['labels'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file': file,
      'labels': labels,
    };
  }
}
