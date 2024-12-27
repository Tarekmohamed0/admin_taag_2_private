import 'package:freezed_annotation/freezed_annotation.dart';
part 'payment_chart_state.freezed.dart';

@freezed
class PaymentChartState with _$PaymentChartState {
  const factory PaymentChartState.initial() = _Initial;
  const factory PaymentChartState.loading() = _Loading;
  const factory PaymentChartState.loaded() = _Loaded;
  const factory PaymentChartState.error() = _Error;
}
