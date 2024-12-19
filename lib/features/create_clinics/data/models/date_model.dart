import 'package:freezed_annotation/freezed_annotation.dart';
part 'date_model.g.dart';

@JsonSerializable()
class DateModel {
  final String day;
  final String startTime;
  final String endTime;
  DateModel({
    required this.day,
    required this.startTime,
    required this.endTime,
  });
  factory DateModel.fromJson(Map<String, dynamic> json) =>
      _$DateModelFromJson(json);
  Map<String, dynamic> DateModeltoJson() => _$DateModelToJson(this);
}
