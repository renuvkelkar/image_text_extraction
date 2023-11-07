import 'package:cloud_firestore/cloud_firestore.dart';

class SumDataModel {
  SumDataModel({
    this.text,
    this.summary,
    this.updateTime,
  });

  late final String? text;
  late final String? summary;
  late final Timestamp? updateTime;

  SumDataModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    summary = json['summary'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'summary': summary,
      'updateTime': updateTime,
    };
  }
}
