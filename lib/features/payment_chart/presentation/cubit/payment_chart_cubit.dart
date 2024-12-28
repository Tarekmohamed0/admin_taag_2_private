import 'package:admin_taag/features/payment_chart/presentation/cubit/payment_chart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  // قائمة العمليات
  List<Map<String, dynamic>> paymentsList = [];

  // جلب البيانات من Firebase
  Future<void> fetchPayments() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('payments').get();
      paymentsList = snapshot.docs.map((doc) => doc.data()).toList();
      emit(PaymentSuccess());
    } catch (e) {
      emit(PaymentFailure("Error fetching payments: $e"));
      log("Error fetching payments: $e");
    }
  }

  @override
  void onChange(Change<PaymentState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
