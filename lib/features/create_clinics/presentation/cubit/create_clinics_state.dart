import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'create_clinics_state.freezed.dart';

@freezed
class CreateClinicsState with _$CreateClinicsState {
  const factory CreateClinicsState.initial() = _Initial;
  const factory CreateClinicsState.loading() = Loading;
  const factory CreateClinicsState.created() = Created;
  const factory CreateClinicsState.loaded(
    List<Map<String, dynamic>> data,
  ) = Loaded;
  const factory CreateClinicsState.error() = Error;
}
