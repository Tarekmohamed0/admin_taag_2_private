import 'package:admin_taag/features/payment_chart/presentation/cubit/payment_chart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentChartCubit extends Cubit<PaymentChartState> {
  PaymentChartCubit() : super(const PaymentChartState.initial());
}
